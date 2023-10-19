import 'dart:developer';

import 'package:eds_beta/api/user_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/address_model.dart';

final addressAPIProvider =
    StateNotifierProvider<AddressAPI, List<AddressModel>?>((ref) {
  final userAPI = ref.watch(userAPIProvider.notifier);
  return AddressAPI(userAPI: userAPI);
});

class AddressAPI extends StateNotifier<List<AddressModel>?> {
  late UserAPI _userAPI;

  AddressAPI({
    required UserAPI userAPI,
  }) : super([]) {
    _userAPI = userAPI;
    state = _userAPI.user?.addresses;
  }

  List<AddressModel>? get addresses {
    state = _userAPI.user?.addresses;
    log("$state from address_api.dart");
    return state;
  }

  Future<void> addAddress({required AddressModel address}) async {
    await _userAPI.addAddress(address: address);

    state = _userAPI.user?.addresses;
  }

  Future<void> deleteAddress({required AddressModel address}) async {
    await _userAPI.deleteAddress(address: address);

    state = _userAPI.user?.addresses;
  }

  Future<void> updateAddress({required AddressModel address}) async {
    state = state!.map((e) => e.id == address.id ? address : e).toList();
    await _userAPI.updateAddress(addresses: state!);
    state = _userAPI.user?.addresses;
  }

  Future<void> setDefaultAddress({required AddressModel address}) async {
    state = state!
        .map((e) => e.id == address.id ? address : e.copyWith(isDefault: false))
        .toList();
    await _userAPI.updateAddress(addresses: state!);
    state = _userAPI.user?.addresses;
  }
}

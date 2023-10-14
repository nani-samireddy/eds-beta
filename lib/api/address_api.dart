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
}

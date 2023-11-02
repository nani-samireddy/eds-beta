import 'dart:developer';
import 'package:eds_beta/api/address_api.dart';
import 'package:eds_beta/common/common.dart';
import 'package:eds_beta/common/components/title_app_bar.dart';
import 'package:eds_beta/features/main_layout/cart/view/address_editing_page.dart';
import 'package:eds_beta/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddressSelectionPage extends ConsumerStatefulWidget {
  const AddressSelectionPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddressSelectionPageState();
}

class _AddressSelectionPageState extends ConsumerState<AddressSelectionPage> {
  @override
  Widget build(BuildContext context) {
    final addresses = ref.watch(addressAPIProvider) ?? [];

    log(addresses.toString());
    return Scaffold(
      appBar: titleAppBar(title: "Shipping Address"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              OptionListTile(
                title: "Add new address",
                icon: Icons.add,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddressEditingPage(
                          title: "Add New Address",
                          onSave: () {
                            log("Save new address");
                          }),
                    ),
                  );
                },
              ),
              const CustomDivider(),
              addresses.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: addresses.length,
                      itemBuilder: (context, index) {
                        return OptionListTile(
                          leading: addresses[index].isDefault
                              ? const Icon(
                                  Icons.check_circle,
                                  color: Pallete.black,
                                )
                              : const SizedBox(),
                          title: addresses[index].title,
                          subtitle: addresses[index].address,
                          onTap: () {
                            log("Select address");

                            ref
                                .read(addressAPIProvider.notifier)
                                .setDefaultAddress(
                                    address: addresses[index]
                                        .copyWith(isDefault: true));
                          },
                          icon: Icons.edit,
                          onTrailTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => AddressEditingPage(
                                    address: addresses[index],
                                    title: "Edit Address",
                                    onSave: () {
                                      log("Save edited address");
                                    }),
                              ),
                            );
                          },
                        );
                      },
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

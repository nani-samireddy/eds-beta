import 'dart:developer';

import 'package:eds_beta/api/address_api.dart';
import 'package:eds_beta/common/custom_text_input.dart';
import 'package:eds_beta/common/primary_button.dart';

import 'package:eds_beta/core/core.dart';
import 'package:eds_beta/core/styles.dart';
import 'package:eds_beta/models/address_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddressEditingPage extends ConsumerStatefulWidget {
  const AddressEditingPage(
      {super.key, required this.title, required this.onSave, this.address});
  final String title;
  final AddressModel? address;
  final void Function() onSave;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddressEditingPageState();
}

class _AddressEditingPageState extends ConsumerState<AddressEditingPage> {
  @override
  void didChangeDependencies() {
    if (widget.address != null) {
      _addressTitleController.text = widget.address!.title;
      _fullNameController.text = widget.address!.fullName;
      _addressLineController.text = widget.address!.address;
      _landMarkController.text = widget.address!.landMark;
      _cityController.text = widget.address!.city;
      _stateController.text = widget.address!.state;
      _zipController.text = widget.address!.zipCode;
      _phoneController.text = widget.address!.phone;
      _emailController.text = widget.address!.email;
      _isDefault = widget.address!.isDefault;
    }
    super.didChangeDependencies();
  }

  final TextEditingController _addressTitleController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _addressLineController = TextEditingController();
  final TextEditingController _landMarkController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isDefault = false;

  void _onSave() async {
    final address = AddressModel(
        id: DateTime.now().toString(),
        title: _addressTitleController.text,
        fullName: _fullNameController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        address: _addressLineController.text,
        landMark: _landMarkController.text,
        city: _cityController.text,
        state: _stateController.text,
        country: "India",
        zipCode: _zipController.text,
        isDefault: _isDefault);
    final addressAPI = ref.read(addressAPIProvider.notifier);
    await addressAPI.addAddress(address: address).then((value) {
      showSnackBar(content: "Address added successfully", context: context);
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  "Address Title",
                  style: AppStyles.sectionHeading,
                ),
                CustomTextInput(
                  hintText: "Address Title*",
                  labelText: "Address Title*",
                  controller: _addressTitleController,
                  type: TextInputType.text,
                  validator: validateName,
                  onChange: (value) {
                    log(_addressTitleController.text);
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Shipping Address",
                  style: AppStyles.sectionHeading,
                ),
                CustomTextInput(
                  hintText: "Full Name",
                  labelText: "Full Name",
                  controller: _fullNameController,
                  type: TextInputType.text,
                  validator: validateName,
                ),
                CustomTextInput(
                  hintText: "Address",
                  labelText: "Address",
                  controller: _addressLineController,
                  type: TextInputType.text,
                  validator: validateAddress,
                ),
                CustomTextInput(
                  hintText: "Landmark",
                  labelText: "Landmark",
                  controller: _landMarkController,
                  type: TextInputType.text,
                  validator: validateAddress,
                ),
                CustomTextInput(
                  hintText: "City",
                  labelText: "City",
                  controller: _cityController,
                  type: TextInputType.text,
                  validator: validateAddress,
                ),
                CustomTextInput(
                  hintText: "State",
                  labelText: "State",
                  controller: _stateController,
                  type: TextInputType.text,
                  validator: validateAddress,
                ),
                CustomTextInput(
                  hintText: "Pincode",
                  labelText: "Pincode",
                  controller: _zipController,
                  type: TextInputType.number,
                  validator: validatePincode,
                ),
                Text(
                  "Contact Details",
                  style: AppStyles.sectionHeading,
                ),
                CustomTextInput(
                  hintText: "Phone number",
                  labelText: "Phone number",
                  controller: _phoneController,
                  type: TextInputType.number,
                  validator: validatephoneNumber,
                ),
                CustomTextInput(
                  hintText: "Email address",
                  labelText: "Email address",
                  controller: _emailController,
                  type: TextInputType.emailAddress,
                  validator: validateEmailAddress,
                ),
                const SizedBox(
                  height: 10,
                ),
                CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(
                      "Set as default address",
                      style: AppStyles.sectionSubheading,
                    ),
                    value: _isDefault,
                    onChanged: (value) {
                      setState(() {
                        _isDefault = value!;
                      });
                    }),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PrimaryButton(text: "SAVE", onPressed: _onSave),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

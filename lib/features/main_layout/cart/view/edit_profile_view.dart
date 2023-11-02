import 'package:eds_beta/api/user_api.dart';
import 'package:eds_beta/common/common.dart';
import 'package:eds_beta/common/components/title_app_bar.dart';
import 'package:eds_beta/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class EditProfileView extends ConsumerStatefulWidget {
  const EditProfileView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  String _phoneNumber = "9123456780";
  String _email = "name@example.com";
  bool _validDetails = false;

  bool _isDateOfBirthValid = false;
  void _validate() {
    setState(() {
      _validDetails = validateName(_nameController.text) == null &&
          validateDateOfBirth(_dateOfBirthController.text) == null;
    });
  }

  @override
  void didChangeDependencies() {
    final user = ref.watch(userAPIProvider);
    _nameController.text = user == null ? "" : user.name;
    _dateOfBirthController.text =
        user == null ? "" : user.dateOfBirth.toString();
    _phoneNumber = user == null ? "" : user.phone;
    _email = user == null ? "" : user.email;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: titleAppBar(title: "Edit Profile"),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Center(
              child: Column(
                children: [
                  CustomTextInput(
                      hintText: "Full name",
                      labelText: "Full name",
                      controller: _nameController,
                      type: TextInputType.name,
                      onChange: (value) {
                        _validate();
                      },
                      validator: validateName),
                  CustomTextInput(
                    isValid: _isDateOfBirthValid,
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime(2000),
                          firstDate: DateTime(1800),
                          lastDate: DateTime.now());
                      if (pickedDate != null) {
                        _dateOfBirthController.text =
                            DateFormat('dd/MM/yyyy').format(pickedDate);
                        setState(() {
                          _isDateOfBirthValid = true;
                        });
                        _validate();
                      }
                    },
                    readOnly: false,
                    hintText: "Date of birth (DD/MM/YYYY)",
                    labelText: "Date of birth (DD/MM/YYYY)",
                    controller: _dateOfBirthController,
                    type: TextInputType.datetime,
                    validator: validateDateOfBirth,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  OptionListTile(
                      title: "Change phone number",
                      subtitle: _phoneNumber,
                      icon: Icons.edit,
                      onTrailTap: () {}),
                  OptionListTile(
                      title: "Change email",
                      subtitle: _email,
                      icon: Icons.edit,
                      onTrailTap: () {}),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PrimaryButton(
                      enable: _validDetails,
                        text: 'SAVE',
                        onPressed: () {
                          Map<String, dynamic> data = {
                            "name": _nameController.text,
                            "dateOfBirth": _dateOfBirthController.text,
                          };
                          ref
                              .read(userAPIProvider.notifier)
                              .updateUserDetails(data: data)
                              .then((value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Profile updated"),
                              ),
                            );
                            Navigator.of(context).pop();
                          });
                        }),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

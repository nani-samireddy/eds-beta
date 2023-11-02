import 'package:eds_beta/features/authentication/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:eds_beta/api/user_api.dart';
import 'package:eds_beta/common/common.dart';
import 'package:eds_beta/constants/images_urls.dart';
import 'package:eds_beta/core/core.dart';
import 'package:eds_beta/core/styles.dart';
import 'package:eds_beta/theme/pallete.dart';

class BasicDetailsView extends ConsumerStatefulWidget {
  const BasicDetailsView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BasicDetailsViewState();
}

class _BasicDetailsViewState extends ConsumerState<BasicDetailsView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _validDetails = false;

  bool _isDateOfBirthValid = false;
  void _validate() {
    setState(() {
      _validDetails = validateName(_nameController.text) == null &&
          validateDateOfBirth(_dateOfBirthController.text) == null &&
          validateEmailAddress(_emailController.text) == null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        body: SizedBox(
          height: double.maxFinite,
          child: Stack(
            children: [
              // Background image
              Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(ImagesUrl.authBg),
                        fit: BoxFit.cover)),
              ),

              Positioned(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Pallete.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    padding: const EdgeInsets.only(
                        left: 40, right: 40, bottom: 40, top: 10),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              height: 4,
                              width: 60,
                              margin: const EdgeInsets.only(bottom: 30),
                              decoration: BoxDecoration(
                                color: Pallete.fadedIconColor.withOpacity(0.5),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            "Little about you 📜",
                            style: AppStyles.heading1,
                          ),
                          const Text(
                            "Enter your name and Date of Birth to continue",
                            style: TextStyle(
                                color: Pallete.grey,
                                fontSize: 20,
                                fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
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
                          CustomTextInput(
                            hintText: "Email address",
                            labelText: "Email address",
                            controller: _emailController,
                            type: TextInputType.emailAddress,
                            onChange: (value) {
                              _validate();
                            },
                            validator: validateEmailAddress,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          PrimaryButton(
                            enable: _validDetails,
                            text: "Continue",
                            onPressed: () async {
                              Map<String, dynamic> data = {
                                "name": _nameController.text,
                                "dateOfBirth": _dateOfBirthController.text,
                                "email": _emailController.text,
                              };
                              await ref
                                  .read(userAPIProvider.notifier)
                                  .updateUserDetails(data: data)
                                  .then((value) {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (_) => const AuthWrapper()),
                                    (route) => false);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

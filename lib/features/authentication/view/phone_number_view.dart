import 'package:eds_beta/common/common.dart';
import 'package:eds_beta/constants/images_urls.dart';
import 'package:eds_beta/core/core.dart';
import 'package:eds_beta/features/authentication/controller/auth_controller.dart';
import 'package:eds_beta/features/authentication/view/otp_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PhoneNumberView extends ConsumerStatefulWidget {
  const PhoneNumberView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PhoneNumberViewState();
}

class _PhoneNumberViewState extends ConsumerState<PhoneNumberView> {
  bool _isLoading = false;
  bool _isValid = false;
  final TextEditingController phoneNumberController = TextEditingController();

  void _requestOTP() async {
    setState(() {
      _isLoading = true;
    });
    await ref
        .read(authControllerProvider.notifier)
        .sendOTP(phoneNumber: phoneNumberController.text, context: context)
        .then((res) {
      setState(() {
        _isLoading = false;
      });
      if (res) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                OTPValidationView(phoneNumber: phoneNumberController.text),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      ImagesUrl.welcomePng,
                      height: 400,
                    ),
                  ),
                  const Text(
                    "Find the Perfect Gift",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Text(
                    "Get access to your orders, wishlist, recommandations, and highly customizable products...",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w100),
                  ),
                  Center(
                    child: CustomTextInput(
                        validator: validatephoneNumber,
                        type: TextInputType.number,
                        hintText: "Enter 10 digit phone number ",
                        labelText: "Phone number*",
                        controller: phoneNumberController,
                        onChange: (val) {
                          setState(() {
                            if (validateOTP(val) == null) {
                              _isValid = true;
                            } else {
                              _isValid = false;
                            }
                          });
                        }),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: PrimaryButton(
                      text: "Request OTP",
                      onPressed: _requestOTP,
                      enable: _isValid,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _isLoading ? const CircularLoaderPage() : const SizedBox.shrink(),
        ],
      ),
    );
  }
}

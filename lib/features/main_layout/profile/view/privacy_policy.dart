import 'package:eds_beta/common/components/title_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  final String _privacyPolicy = '''
# Privacy Policy

This Privacy Policy describes how your personal information is collected, used, and shared when you visit or make a purchase from [Store URL](insert-your-store-url-here).

## Personal Information we collect

When you visit the Site, we automatically collect certain information about your device, including information about your web browser, IP address, time zone, and some of the cookies that are installed on your device.

When you make a purchase or attempt to make a purchase through the Site, we collect certain information from you, including your name, billing address, shipping address, payment information, email address, and phone number.

We use the information we collect when you make a purchase to fulfill the purchase order, including processing your payment information, arranging for shipping, and providing you with invoices and/or order confirmations.

## How we use your personal information

We use the information we collect from you in a variety of ways, including to:

- Process your orders and fulfill your purchase requests
- Provide customer support
- Send you marketing communications
- Improve our website and products
- Comply with applicable laws and regulations

## How we share your personal information

We share your personal information with third parties to help us provide you with our products and services, to process your payments, and to improve our marketing efforts.

These third parties may have access to your personal information only to the extent necessary to perform their tasks and are prohibited from using it for any other purpose.

## How we protect your personal information

We take security measures to protect your personal information. We use encryption to protect sensitive information transmitted online, and we implement physical, electronic, and procedural safeguards to protect your information off-line.

## Your rights

You have the right to access, correct, delete, and port your personal information. You also have the right to object to the processing of your personal information and to withdraw your consent at any time.

To exercise these rights, please contact us at (email address).

## Changes to our privacy policy

We may update our privacy policy from time to time. We will notify you of any changes by posting the new privacy policy on the Site.

## Contact us

If you have any questions about our privacy policy, please contact us at [endlessstore.in.co@gmail.com](mailto:endlessstore.in.co@gmail.com).

''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: titleAppBar(title: "Privacy Policy"),
      body: Markdown(
        data: _privacyPolicy,
      ),
    );
  }
}

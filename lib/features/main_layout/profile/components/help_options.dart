import 'package:eds_beta/common/common.dart';
import 'package:eds_beta/features/main_layout/profile/view/faqs_view.dart';
import 'package:eds_beta/features/main_layout/profile/view/privacy_policy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HelpOptions extends ConsumerStatefulWidget {
  const HelpOptions({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HelpOptionsState();
}

class _HelpOptionsState extends ConsumerState<HelpOptions> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OptionListTile(
          title: "Privacy Policy",
          icon: Icons.privacy_tip,
          subtitle: "Read our privacy policy",
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const PrivacyPolicy()));
          },
        ),
        OptionListTile(
          title: "FAQs",
          icon: Icons.info,
          subtitle: "Read frequently asked questions",
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const FAQsView()));
          },
        ),
      ],
    );
  }
}

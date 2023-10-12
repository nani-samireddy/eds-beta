import 'package:eds_beta/core/styles.dart';
import 'package:flutter/material.dart';

class OptionListTile extends StatelessWidget {
  const OptionListTile(
      {super.key,
      required this.title,
      this.subtitle,
      required this.icon,
      this.leading,
      this.onTap});
  final String title;
  final String? subtitle;
  final IconData icon;
  final Widget? leading;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: Text(
        title,
        style: AppStyles.sectionHeading,
      ),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: Icon(icon),
      onTap: onTap,
    );
  }
}

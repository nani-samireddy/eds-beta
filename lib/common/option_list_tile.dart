import 'package:eds_beta/core/styles.dart';
import 'package:flutter/material.dart';

class OptionListTile extends StatelessWidget {
  const OptionListTile(
      {super.key,
      required this.title,
      this.subtitle,
      required this.icon,
      this.leading,
      this.onTap,
      this.onTrailTap});
  final String title;
  final String? subtitle;
  final IconData icon;
  final Widget? leading;
  final void Function()? onTap;
  final void Function()? onTrailTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: Text(
        title,
        style: AppStyles.sectionHeading,
      ),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: IconButton(icon: Icon(icon), onPressed: onTrailTap),
      onTap: onTap,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsOptions extends ConsumerStatefulWidget {
  const SettingsOptions({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SettingsOptionsState();
}

class _SettingsOptionsState extends ConsumerState<SettingsOptions> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [Text("Settings")],
    );
  }
}

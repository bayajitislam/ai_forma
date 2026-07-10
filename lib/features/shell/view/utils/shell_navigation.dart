import 'package:flutter/material.dart';
import 'package:ai_forma/features/shell/view/pages/app_shell_view.dart';

void navigateToAppShell(BuildContext context) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute<void>(builder: (_) => const AppShellView()),
    (route) => false,
  );
}

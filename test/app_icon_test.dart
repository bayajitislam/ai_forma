import 'package:ai_forma/core/icons/app_icons.dart';
import 'package:ai_forma/core/widgets/app_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders an Icon for IconData and SvgPicture for asset path', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              AppIcon(icon: Icons.home),
              const AppIcon(icon: AppIcons.insightSvg),
            ],
          ),
        ),
      ),
    );

    expect(find.byType(Icon), findsOneWidget);
    expect(find.byType(SvgPicture), findsOneWidget);
  });
}

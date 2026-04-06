import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:personal_finance_app/core/widgets/app_primary_button.dart';

import '../helpers/golden_test_helpers.dart';

void main() {
  group('AppPrimaryButton golden', () {
    testWidgets('light — enabled with icon', (tester) async {
      await pumpGoldenWidget(
        tester,
        const SizedBox(
          width: 280,
          child: AppPrimaryButton(
            label: 'Add Transaction',
            icon: Icons.add_rounded,
          ),
        ),
      );
      await expectLater(
        find.byType(AppPrimaryButton),
        matchesGoldenFile('goldens/primary_button_light_enabled.png'),
      );
    });

    testWidgets('light — disabled (null onPressed)', (tester) async {
      await pumpGoldenWidget(
        tester,
        const SizedBox(
          width: 280,
          child: AppPrimaryButton(label: 'Add Transaction'),
        ),
      );
      await expectLater(
        find.byType(AppPrimaryButton),
        matchesGoldenFile('goldens/primary_button_light_disabled.png'),
      );
    });

    testWidgets('dark — enabled with icon', (tester) async {
      await pumpDarkGoldenWidget(
        tester,
        const SizedBox(
          width: 280,
          child: AppPrimaryButton(
            label: 'Add Transaction',
            icon: Icons.add_rounded,
          ),
        ),
      );
      await expectLater(
        find.byType(AppPrimaryButton),
        matchesGoldenFile('goldens/primary_button_dark_enabled.png'),
      );
    });

    testWidgets('dark — disabled (null onPressed)', (tester) async {
      await pumpDarkGoldenWidget(
        tester,
        const SizedBox(
          width: 280,
          child: AppPrimaryButton(label: 'Add Transaction'),
        ),
      );
      await expectLater(
        find.byType(AppPrimaryButton),
        matchesGoldenFile('goldens/primary_button_dark_disabled.png'),
      );
    });
  });
}

import 'package:flutter_test/flutter_test.dart';

import 'package:personal_finance_app/core/widgets/app_bottom_nav_bar.dart';

import '../helpers/golden_test_helpers.dart';

void main() {
  group('AppBottomNavBar golden', () {
    testWidgets('light — tab 0 (Home) selected', (tester) async {
      await pumpGoldenWidget(
        tester,
        AppBottomNavBar(currentIndex: 0, onTap: (_) {}),
      );
      await expectLater(
        find.byType(AppBottomNavBar),
        matchesGoldenFile('goldens/bottom_nav_light_home.png'),
      );
    });

    testWidgets('light — tab 2 (Goals) selected', (tester) async {
      await pumpGoldenWidget(
        tester,
        AppBottomNavBar(currentIndex: 2, onTap: (_) {}),
      );
      await expectLater(
        find.byType(AppBottomNavBar),
        matchesGoldenFile('goldens/bottom_nav_light_goals.png'),
      );
    });

    testWidgets('dark — tab 0 (Home) selected', (tester) async {
      await pumpDarkGoldenWidget(
        tester,
        AppBottomNavBar(currentIndex: 0, onTap: (_) {}),
      );
      await expectLater(
        find.byType(AppBottomNavBar),
        matchesGoldenFile('goldens/bottom_nav_dark_home.png'),
      );
    });

    testWidgets('dark — tab 3 (Insights) selected', (tester) async {
      await pumpDarkGoldenWidget(
        tester,
        AppBottomNavBar(currentIndex: 3, onTap: (_) {}),
      );
      await expectLater(
        find.byType(AppBottomNavBar),
        matchesGoldenFile('goldens/bottom_nav_dark_insights.png'),
      );
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:personal_finance_app/features/transactions/presentation/transaction_view_data.dart';
import 'package:personal_finance_app/features/transactions/widgets/transaction_tile.dart';

import '../helpers/golden_test_helpers.dart';

void main() {
  final incomeTransaction = const TransactionViewData(
    id: 1,
    title: 'Monthly Salary',
    subtitle: 'Today - 9:00 AM',
    amount: 5000,
    isIncome: true,
    tone: TransactionVisualTone.income,
    icon: Icons.account_balance_wallet_rounded,
    dateGroup: 'Today',
  );

  final expenseFood = const TransactionViewData(
    id: 2,
    title: 'Vegetarian Groceries',
    subtitle: 'Yesterday - 3:00 PM',
    amount: 45,
    isIncome: false,
    tone: TransactionVisualTone.food,
    icon: Icons.restaurant_rounded,
    dateGroup: 'Yesterday',
  );

  final expenseHousing = const TransactionViewData(
    id: 3,
    title: 'Monthly Rent',
    subtitle: 'Yesterday - 9:00 AM',
    amount: 1200,
    isIncome: false,
    tone: TransactionVisualTone.housing,
    icon: Icons.home_work_rounded,
    dateGroup: 'Yesterday',
  );

  group('TransactionTile golden', () {
    testWidgets('light — income tile', (tester) async {
      await pumpGoldenWidget(
        tester,
        SizedBox(
          width: 350,
          child: TransactionTile(
            transaction: incomeTransaction,
            currencySymbol: r'$',
          ),
        ),
      );
      await expectLater(
        find.byType(TransactionTile).first,
        matchesGoldenFile('goldens/transaction_tile_light_income.png'),
      );
    });

    testWidgets('light — expense food tile', (tester) async {
      await pumpGoldenWidget(
        tester,
        SizedBox(
          width: 350,
          child: TransactionTile(
            transaction: expenseFood,
            currencySymbol: r'$',
          ),
        ),
      );
      await expectLater(
        find.byType(TransactionTile).first,
        matchesGoldenFile('goldens/transaction_tile_light_food.png'),
      );
    });

    testWidgets('light — expense housing tile compact', (tester) async {
      await pumpGoldenWidget(
        tester,
        SizedBox(
          width: 350,
          child: TransactionTile(
            transaction: expenseHousing,
            currencySymbol: r'$',
            compact: true,
          ),
        ),
      );
      await expectLater(
        find.byType(TransactionTile).first,
        matchesGoldenFile('goldens/transaction_tile_light_housing_compact.png'),
      );
    });

    testWidgets('dark — income tile', (tester) async {
      await pumpDarkGoldenWidget(
        tester,
        SizedBox(
          width: 350,
          child: TransactionTile(
            transaction: incomeTransaction,
            currencySymbol: r'$',
          ),
        ),
      );
      await expectLater(
        find.byType(TransactionTile).first,
        matchesGoldenFile('goldens/transaction_tile_dark_income.png'),
      );
    });

    testWidgets('dark — expense food tile', (tester) async {
      await pumpDarkGoldenWidget(
        tester,
        SizedBox(
          width: 350,
          child: TransactionTile(
            transaction: expenseFood,
            currencySymbol: r'$',
          ),
        ),
      );
      await expectLater(
        find.byType(TransactionTile).first,
        matchesGoldenFile('goldens/transaction_tile_dark_food.png'),
      );
    });
  });
}

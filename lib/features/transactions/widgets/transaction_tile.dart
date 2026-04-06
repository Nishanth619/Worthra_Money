import 'package:flutter/material.dart';

import '../../../core/theme/app_palette.dart';
import '../../../core/theme/theme_extensions.dart';
import '../../../core/utils/currency_format.dart';
import '../presentation/transaction_view_data.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({
    required this.transaction,
    required this.currencySymbol,
    this.compact = false,
    super.key,
  });

  final TransactionViewData transaction;
  final String currencySymbol;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = context.appPalette;
    final amountColor = transaction.isIncome
        ? colors.primaryContainer
        : colors.textPrimary;
    final amountPrefix = transaction.isIncome ? '+' : '-';
    final visualColors = _colorsForTone(transaction.tone, colors);

    return Container(
      padding: EdgeInsets.all(compact ? 16 : 18),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: compact ? 48 : 52,
            height: compact ? 48 : 52,
            decoration: BoxDecoration(
              color: visualColors.$1,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              transaction.icon,
              color: visualColors.$2,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(transaction.subtitle, style: textTheme.bodySmall),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '$amountPrefix${formatCurrency(transaction.amount, symbol: currencySymbol)}',
            style: textTheme.titleMedium?.copyWith(
              color: amountColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

(Color, Color) _colorsForTone(TransactionVisualTone tone, AppPalette colors) {
  return switch (tone) {
    TransactionVisualTone.income => (colors.primarySoft, colors.primary),
    TransactionVisualTone.food => (colors.secondarySoft, colors.secondary),
    TransactionVisualTone.transport => (
      colors.surfaceContainerHighest,
      colors.textPrimary,
    ),
    TransactionVisualTone.housing => (colors.secondarySoft, colors.secondary),
    TransactionVisualTone.gift => (colors.tertiarySoft, colors.tertiary),
    TransactionVisualTone.work => (
      colors.surfaceContainerHigh,
      colors.primary,
    ),
    TransactionVisualTone.neutral => (
      colors.surfaceContainerLow,
      colors.textPrimary,
    ),
  };
}

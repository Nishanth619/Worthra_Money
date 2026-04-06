import 'package:flutter/material.dart';

import '../../../models/transaction.dart';

enum TransactionVisualTone {
  income,
  food,
  transport,
  housing,
  gift,
  work,
  neutral,
}

class TransactionViewData {
  const TransactionViewData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.icon,
    required this.tone,
    required this.dateGroup,
    required this.isIncome,
  });

  final int id;
  final String title;
  final String subtitle;
  final double amount;
  final IconData icon;
  final TransactionVisualTone tone;
  final String dateGroup;
  final bool isIncome;
}

TransactionViewData mapTransactionToViewData(Transaction transaction) {
  final category = transaction.category;
  final visuals = _visualsForCategory(category, transaction.isExpense);
  final title = (transaction.notes?.trim().isNotEmpty ?? false)
      ? transaction.notes!.trim()
      : category;

  return TransactionViewData(
    id: transaction.id,
    title: title,
    subtitle: _formatTimestamp(transaction.date),
    amount: transaction.amount,
    icon: visuals.icon,
    tone: visuals.tone,
    dateGroup: _formatDateGroup(transaction.date),
    isIncome: !transaction.isExpense,
  );
}

({IconData icon, TransactionVisualTone tone}) _visualsForCategory(
  String category,
  bool isExpense,
) {
  final normalized = category.toLowerCase();

  if (!isExpense) {
    if (normalized.contains('salary')) {
      return (
        icon: Icons.account_balance_wallet_rounded,
        tone: TransactionVisualTone.income,
      );
    }
    return (icon: Icons.south_west_rounded, tone: TransactionVisualTone.income);
  }

  if (normalized.contains('food') || normalized.contains('dining')) {
    return (icon: Icons.restaurant_rounded, tone: TransactionVisualTone.food);
  }
  if (normalized.contains('transport')) {
    return (
      icon: Icons.train_rounded,
      tone: TransactionVisualTone.transport,
    );
  }
  if (normalized.contains('housing') || normalized.contains('rent')) {
    return (
      icon: Icons.home_work_rounded,
      tone: TransactionVisualTone.housing,
    );
  }
  if (normalized.contains('gift')) {
    return (icon: Icons.card_giftcard_rounded, tone: TransactionVisualTone.gift);
  }
  if (normalized.contains('tech') || normalized.contains('work')) {
    return (icon: Icons.dns_rounded, tone: TransactionVisualTone.work);
  }
  return (icon: Icons.payments_outlined, tone: TransactionVisualTone.neutral);
}

String _formatDateGroup(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final candidate = DateTime(date.year, date.month, date.day);
  final difference = today.difference(candidate).inDays;

  if (difference == 0) {
    return 'Today';
  }
  if (difference == 1) {
    return 'Yesterday';
  }
  if (difference > 6) {
    return _formatCalendarDate(date);
  }

  const weekdayNames = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  return weekdayNames[date.weekday - 1];
}

String _formatTimestamp(DateTime date) {
  final dayLabel = _formatDateGroup(date);
  final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
  final minute = date.minute.toString().padLeft(2, '0');
  final period = date.hour >= 12 ? 'PM' : 'AM';
  return '$dayLabel - $hour:$minute $period';
}

String _formatCalendarDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${months[date.month - 1]} ${date.day}';
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_settings.dart';
import '../repositories/category_insight.dart';
import 'database_provider.dart';
import 'settings_provider.dart';
import 'transactions_provider.dart';

// ── Period Helper ─────────────────────────────────────────────────────────────

DateTimeRange weekRange() {
  final now = DateTime.now();
  final start = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 6));
  final end = DateTime(now.year, now.month, now.day, 23, 59, 59, 999, 999);
  return DateTimeRange(start: start, end: end);
}

DateTimeRange monthRange() {
  final now = DateTime.now();
  final start = DateTime(now.year, now.month);
  final end = DateTime(now.year, now.month + 1).subtract(const Duration(microseconds: 1));
  return DateTimeRange(start: start, end: end);
}

// Keep old names as aliases for backward compatibility
DateTimeRange currentWeekRange() => weekRange();
DateTimeRange currentMonthRange() => monthRange();

DateTimeRange _rangeFor(InsightsPeriodPreference period) =>
    period == InsightsPeriodPreference.weekly ? weekRange() : monthRange();

// ── Category insight breakdown ────────────────────────────────────────────────

/// Aggregated chart data for the insights screen.
final insightsProvider = FutureProvider<List<CategoryInsight>>((ref) async {
  ref.watch(transactionRefreshProvider);
  final period = ref.watch(insightsPeriodProvider);
  final repository = await ref.watch(transactionRepositoryProvider.future);
  final range = _rangeFor(period);
  return repository.getCategoryInsightsByDateRange(range.start, range.end);
});

// ── Income / Expense for current period ──────────────────────────────────────

final periodIncomeProvider = FutureProvider<double>((ref) async {
  ref.watch(transactionRefreshProvider);
  final period = ref.watch(insightsPeriodProvider);
  final repository = await ref.watch(transactionRepositoryProvider.future);
  final range = _rangeFor(period);
  return repository.getIncomeForDateRange(range.start, range.end);
});

final periodExpenseProvider = FutureProvider<double>((ref) async {
  ref.watch(transactionRefreshProvider);
  final period = ref.watch(insightsPeriodProvider);
  final repository = await ref.watch(transactionRepositoryProvider.future);
  final range = _rangeFor(period);
  return repository.getExpenseForDateRange(range.start, range.end);
});

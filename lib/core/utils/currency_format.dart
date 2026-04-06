String formatCurrency(
  double amount, {
  required String symbol,
  bool withDecimals = true,
  /// When true, abbreviates large amounts: 1500 → ₹1.5K, 1200000 → ₹1.2M
  bool compact = false,
}) {
  if (compact) {
    if (amount >= 1000000) {
      return '$symbol${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '$symbol${(amount / 1000).toStringAsFixed(1)}K';
    }
    return '$symbol${amount.toStringAsFixed(0)}';
  }
  final formatted = withDecimals
      ? amount.toStringAsFixed(2)
      : amount.toStringAsFixed(0);
  return '$symbol$formatted';
}

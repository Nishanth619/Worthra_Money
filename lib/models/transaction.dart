import 'package:isar_community/isar.dart';

part 'transaction.g.dart';

// Generate the schema with:
// dart run build_runner build --delete-conflicting-outputs
@collection
class Transaction {
  Transaction({
    this.id = Isar.autoIncrement,
    required this.amount,
    required this.isExpense,
    required this.category,
    required this.date,
    this.notes,
    this.serverId,
    this.syncedAt,
  });

  Id id;
  double amount;
  bool isExpense;

  @Index(caseSensitive: false)
  String category;

  @Index()
  DateTime date;

  String? notes;

  /// Server-assigned UUID. Null until the record has been pushed to the API.
  /// This is indexed for lookup, but not unique because unsynced local rows
  /// all start with `null` and must coexist safely.
  @Index()
  String? serverId;

  /// Timestamp of the last successful server confirmation. Null = unsynced.
  DateTime? syncedAt;
}

import 'package:isar_community/isar.dart';

part 'goal.g.dart';

// Generate the schema with:
// dart run build_runner build --delete-conflicting-outputs
@collection
class Goal {
  Goal({
    this.id = Isar.autoIncrement,
    required this.title,
    required this.targetAmount,
    required this.currentAmount,
    required this.isStreakChallenge,
    this.iconCodePoint,
    this.deadline,
    this.lastLoggedDate,
    this.serverId,
    this.syncedAt,
  });

  Id id;

  @Index(caseSensitive: false)
  String title;

  double targetAmount;
  double currentAmount;
  bool isStreakChallenge;

  /// Codepoint of the user-selected MaterialIcon. Null = auto-assigned by
  /// keyword matching.
  int? iconCodePoint;

  /// Optional target completion date (savings goals only).
  DateTime? deadline;

  /// For streak challenges: the date the user last pressed "Log Day".
  /// Null = streak has never been started.
  @Index()
  DateTime? lastLoggedDate;

  /// Server-assigned UUID. Null until the record has been pushed to the API.
  @Index()
  String? serverId;

  /// Timestamp of the last successful server confirmation. Null = unsynced.
  DateTime? syncedAt;

  // ── Computed helpers (not persisted) ───────────────────────────────────────

  /// Progress in the range [0.0 – 1.0].
  double get progress =>
      targetAmount == 0 ? 0 : (currentAmount / targetAmount).clamp(0.0, 1.0);

  /// True when the goal has been fully achieved.
  bool get isCompleted => currentAmount >= targetAmount && targetAmount > 0;

  /// True if the streak was active as of today (logged today or yesterday).
  /// A gap of more than 1 calendar day means the streak is broken.
  bool get isStreakAlive {
    if (lastLoggedDate == null) return false;
    final today = _dateOnly(DateTime.now());
    final last = _dateOnly(lastLoggedDate!);
    return today.difference(last).inDays <= 1;
  }

  /// True if the user has already logged a day today.
  bool get loggedToday {
    if (lastLoggedDate == null) return false;
    final today = _dateOnly(DateTime.now());
    final last = _dateOnly(lastLoggedDate!);
    return today == last;
  }
}

DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

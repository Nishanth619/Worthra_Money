import 'dart:ffi';
import 'dart:io';

import 'package:isar_community/isar.dart';
import 'package:personal_finance_app/models/app_settings.dart';
import 'package:personal_finance_app/models/goal.dart';
import 'package:personal_finance_app/models/transaction.dart';

class TestDatabase {
  TestDatabase._({required this.isar, required this.directory});

  final Isar isar;
  final Directory directory;

  static Future<TestDatabase> open({String? name}) async {
    final directory = await Directory.systemTemp.createTemp(
      'personal_finance_app_test_',
    );
    final libraryPath =
        '${directory.path}${Platform.pathSeparator}${_libraryFileName()}';
    await Isar.initializeIsarCore(
      libraries: {Abi.current(): libraryPath},
      download: true,
    );
    final isar = await Isar.open(
      [AppSettingsSchema, TransactionSchema, GoalSchema],
      directory: directory.path,
      name: name ?? 'test_instance',
    );

    return TestDatabase._(isar: isar, directory: directory);
  }

  Future<void> dispose() async {
    if (isar.isOpen) {
      await isar.close(deleteFromDisk: true);
    }
  }
}

String _libraryFileName() {
  switch (Abi.current()) {
    case Abi.linuxX64:
      return 'libisar.so';
    case Abi.macosArm64:
    case Abi.macosX64:
      return 'libisar.dylib';
    case Abi.windowsArm64:
    case Abi.windowsX64:
      return 'libisar.dll';
    default:
      throw UnsupportedError('Unsupported ABI for Isar test initialization.');
  }
}

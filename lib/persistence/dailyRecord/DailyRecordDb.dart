import /*'package:headache_app/persistence/dailyRecord/DailyRecordDb_sqlite.dart'
if (dart.library.html)*/ 'package:headache_app/persistence/dailyRecord/DailyRecordDb_memory.dart' as Impl;

class DailyRecordDb extends Impl.DailyRecordDb {
  static final DailyRecordDb _instance = DailyRecordDb._privateConstructor();

  DailyRecordDb._privateConstructor();

  factory DailyRecordDb() {
    return _instance;
  }
}

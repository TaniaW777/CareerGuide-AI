import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

void initDatabaseFactory() {
  // Use the no-web-worker factory for Flutter web so the app does not
  // require the sqflite_sw.js worker asset to be manually added.
  databaseFactory = databaseFactoryFfiWebNoWebWorker;
}

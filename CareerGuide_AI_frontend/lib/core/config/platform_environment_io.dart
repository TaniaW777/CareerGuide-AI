import 'dart:io';

bool get isFlutterTest {
  final env = Platform.environment['FLUTTER_TEST'];
  return env == 'true' || env == '1' || Platform.environment.containsKey('FLUTTER_TEST');
}

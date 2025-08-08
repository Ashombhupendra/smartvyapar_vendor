String vdLoggerTag = 'Vendor-Logger';
String logs = '[$vdLoggerTag] - Starting at ${DateTime.now()}';

Future<void> vdDebug(dynamic message, {String? tag}) async {
  String log = "\n[$vdLoggerTag] ${tag == null ? '' : '($tag)'}: $message";
  print(log);
  logs += log;
}

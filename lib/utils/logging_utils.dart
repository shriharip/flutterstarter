//Copyright Poul Herbert AuthPass
// wwill have to see how we can just spawn an isolate and push the file

import 'dart:io';
import 'dart:isolate';

import 'package:fl_starter/utils/path_utils.dart';
import 'package:logging/logging.dart';
import 'package:logging_appenders/logging_appenders.dart';
import 'package:path/path.dart' as path;

final _logger = Logger('logging_utils');

class LoggingUtils {
  factory LoggingUtils() => _instance;

  LoggingUtils._();

  static final _instance = LoggingUtils._();

  AsyncInitializingLogHandler<RotatingFileAppender> _rotatingFileLoggerCached;
  AsyncInitializingLogHandler<RotatingFileAppender> get _rotatingFileLogger =>
      _rotatingFileLoggerCached ??=
          AsyncInitializingLogHandler<RotatingFileAppender>(builder: () async {
        Directory dir = await PathUtils().getLogsDirectoryProvider();

        final appLogFile = File(path.join(dir.path, 'app.log.txt'));

        await appLogFile.parent.create(recursive: true);

        _logger.info('Logging into $appLogFile');
        return RotatingFileAppender(
          rotateAtSizeBytes: 10 * 1024 * 1024,
          baseFilePath: appLogFile.path,
        );
      });

  List<File> get rotatingFileLoggerFiles =>
      _rotatingFileLogger.delegatedLogHandler?.getAllLogFiles() ?? [];

  void setupLogging() {
    Logger.root.level = Level.ALL;
    PrintAppender().attachToLogger(Logger.root);

    _rotatingFileLogger.attachToLogger(Logger.root);

    final isolateDebug =
        '${Isolate.current.debugName} (${Isolate.current.hashCode})'; // NON-NLS
    _logger.info(
        'Running in isolate $isolateDebug');

    Isolate.current.addOnExitListener(RawReceivePort((dynamic val) {
      print('exiting isolate $isolateDebug');
    }).sendPort);

    final exitPort = ReceivePort();
    exitPort.listen((dynamic data) {
      _logger.info(
          'Exiting isolate $isolateDebug ${Isolate.current.debugName} (${Isolate.current.hashCode}');
    }, onDone: () {
      _logger.info('Done $isolateDebug');
    });
    Isolate.current.addOnExitListener(exitPort.sendPort, response: 'exit');
  }
}

import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;

class PathUtils {

PathUtils._();

factory PathUtils() => instance;

static PathUtils get instance => PathUtils._();

Map<String, Directory> directoryCache = Map();

Future<Directory>  getTempDirectory() async {
  
  if(directoryCache['temp'] != null){
    return directoryCache['temp'];
  } else {
     Directory dir = await path_provider.getTemporaryDirectory();
    directoryCache['temp'] = dir;
    return directoryCache['temp'];
  }
}

Future<Directory>  getAppDirectoryProvider() async => await path_provider.getApplicationDocumentsDirectory();

Future<Directory>  getLogsDirectoryProvider() async{ 
  Directory dir =  await path_provider.getApplicationDocumentsDirectory();
    return  Directory(path.join( dir.path, 'logs'));
  }

}

import 'package:fl_starter/main.dart';
import 'package:fl_starter/providers/core_providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


final Provider<EnvType> envTypeProvider = Provider<EnvType>((ref) => EnvType.production); 
Future<void> main() async => startApp();
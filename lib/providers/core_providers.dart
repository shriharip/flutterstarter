
import 'package:fl_starter/development.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:logging/logging.dart';
import 'package:device_info/device_info.dart';
import 'package:package_info/package_info.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

part 'core_providers.g.dart';

final _logger = Logger('core providers');

@JsonLiteral('../env_secrets/dev.json')
Map<String, String> get devSecrets => _$devSecretsJsonLiteral;

@JsonLiteral('../env_secrets/prod.json')
Map<String, String> get prodSecrets => _$prodSecretsJsonLiteral;

enum EnvType { production, development }

DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

final secretsProvider = Provider<Map<String, String>>((ref) {
  final Map<String, String> envSecrets =
      ref.read<EnvType>(envTypeProvider) == EnvType.development
          ? devSecrets
          : prodSecrets;
  return envSecrets;
});

final iosDeviceInfoProvider =
    FutureProvider<IosDeviceInfo>((ref) async => await _deviceInfo.iosInfo);
final andDeviceInfoProvider = FutureProvider<AndroidDeviceInfo>(
    (ref) async => await _deviceInfo.androidInfo);
final packageInfoProvider = FutureProvider<PackageInfo>(
    (ref) async => await PackageInfo.fromPlatform());

// Client client = clientViaApiKey('AIzaSyBQ_KodoH-uy45szm52x9EVu2FoBs43g50');

final FutureProvider<Mixpanel> mixpanelProvider =
    FutureProvider<Mixpanel>((ref) async {
  Mixpanel mixpanel =
      await Mixpanel.init('token', optOutTrackingDefault: false);
  mixpanel.setServerURL("https://api-eu.mixpanel.com");

  return mixpanel;
});

  // final gaapiProvider = FutureProvider<AnalyticsApi>((ref) async{
  //  AnalyticsApi api =  AnalyticsApi(client);

  //  ManagementCustomMetricsResource ma = api.management.customMetrics;
  //  List a = (await  ma.list('UA-28928061-3', '')).items;
  
  
  //  _logger.fine( '$a');
  //   return api;

  // }); 



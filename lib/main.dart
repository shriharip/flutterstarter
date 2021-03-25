
import 'dart:async';
import 'dart:io';

import 'package:fl_starter/providers/graph_providers.dart';
import 'package:fl_starter/theme.dart';
import 'package:fl_starter/providers/core_providers.dart';
import 'package:fl_starter/utils/format_utils.dart';
import 'package:fl_starter/utils/logging_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:fl_starter/utils/extension_methods.dart';


final _logger = Logger('main');
void main() => throw Exception('Run either development/production .dart file');


  void startApp() async{
    
    WidgetsFlutterBinding.ensureInitialized();
    LoggingUtils().setupLogging();
    final navigatorKey = GlobalKey<NavigatorState>();
    

    await runZonedGuarded<Future<void>>(() async {
      
    runApp(ProviderScope(child: MyApp()));
  }, (dynamic error, StackTrace stackTrace) {
    _logger.shout('Unhandled error in app.', error, stackTrace);
  
  }, zoneSpecification: ZoneSpecification(
    fork: ( self,  parent,  zone,
         specification,  zoneValues) {
      print('Forking zone.'); 
      return parent.fork(zone, specification, zoneValues);
    },
  ));
    
  }
  


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) { 
     return MaterialApp(
      title: 'Flutter Demo',
      theme: myTheme,
      localizationsDelegates: [
    AppLocalizations.delegate,
   GlobalMaterialLocalizations.delegate,
   GlobalWidgetsLocalizations.delegate,
   GlobalCupertinoLocalizations.delegate,
 ],

 supportedLocales: [
    const Locale('en', ''), // English, no country code
  ],
      routes: {
        '/' : (context) => MyHomePage(title: 'Flutter Demo Home Page'),
        'two': (context) => GraphQLProvider(
              client: client,
              child: SecondPage(),
            )

      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  void initState() { 
    super.initState();
FormatUtils(locale: 'en');
  }

  void _incrementCounter() {
    
    Navigator.of(context).pushNamed('two');
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
         title: Text(widget.title),
      ),
      body: Center(
        
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


class SecondPage extends StatelessWidget {
  const SecondPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Center(
          child: Text('A new Page'),
        ),
      ),
    );
  }
}

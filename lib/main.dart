import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';

import 'core/router_name.dart';
import 'state_injector.dart';
import 'utils/k_strings.dart';
import 'utils/my_theme.dart';
import 'utils/k_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await StateInjector.init();

  print(await KStorage.determineStorage());
  // change the status bar color to material color [green-400]
  await FlutterStatusbarcolor.setStatusBarColor(Colors.orange[400]!);
  if (useWhiteForeground(Colors.orange[400]!)) {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
  } else {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
  }

  // change the navigation bar color to material color [orange-200]
  await FlutterStatusbarcolor.setNavigationBarColor(Colors.orange[300]!);
  if (useWhiteForeground(Colors.orange[300]!)) {
    FlutterStatusbarcolor.setNavigationBarWhiteForeground(true);
  } else {
    FlutterStatusbarcolor.setNavigationBarWhiteForeground(false);
  }

  // get statusbar color and navigationbar color
  Color? statusbarColor = await FlutterStatusbarcolor.getStatusBarColor();
  Color? navigationbarColor = await FlutterStatusbarcolor.getNavigationBarColor();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: StateInjector.repositoryProviders,
      child: MultiBlocProvider(
        providers: StateInjector.blocProviders,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: KStrings.appName,
          theme: MyTheme.theme,
          onGenerateRoute: RouteNames.generateRoute,
          initialRoute: RouteNames.animatedSplashScreen,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: child!,
            );
          },
        ),
      ),
    );
  }
}

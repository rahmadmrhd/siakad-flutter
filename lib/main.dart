import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siakad/src/utils/database.dart';

import 'src/pages/home_page.dart';
import 'src/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MainApp(await getInitialRoute()));
}

//mengecek apakah user sudah login atau belum
Future<String> getInitialRoute() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final result = await MyDb.pool.execute(
        'SELECT count(*) as count FROM `user` WHERE token = :token',
        {"token": token});
    if (result.rows.first.colByName('count') == '0') {
      return LoginPage.routeName;
    }
    return HomePage.routeName;
  } catch (e) {
    return LoginPage.routeName;
  }
}

class MainApp extends StatelessWidget {
  const MainApp(this.initialRoute, {super.key});
  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: null,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue[700]!),
            useMaterial3: true,
          ),
          debugShowCheckedModeBanner: false,
          initialRoute: initialRoute,
          routes: {
            LoginPage.routeName: (context) => const LoginPage(),
            HomePage.routeName: (context) => const HomePage(),
          },
        );
      },
    );
  }
}

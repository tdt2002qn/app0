import 'package:app0/db/db_helper.dart';
import 'package:app0/services/theme_services.dart';
import 'package:app0/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:app0/ui/HomePage.dart';
import 'package:flutter/widgets.dart';
import 'package:app0/ui/theme.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDb();
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeService().theme,
      home: HomePage(),
    );
  }
}

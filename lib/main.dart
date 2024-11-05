import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models.dart';
import 'manage_lists_page.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  runApp(const MyApp());
}

Future<dynamic> callAsyncFetch() async {
  //await Future.delayed(Duration(seconds: 3));
  final prefs = await SharedPreferences.getInstance();
  String data = prefs.getString('data') ?? "";
  //data = "";

  if (data == "") {
    data = await rootBundle.loadString('assets/data.json');
  }

  return UserData.fromJson(jsonDecode(data));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  void saveUserData(data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("data", jsonEncode(data));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        /**/
        future: callAsyncFetch(),
        /**/
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return MaterialApp(
              title: 'Simplist',

              //THEMES
              theme: ThemeData(
                colorScheme: ColorScheme.highContrastDark(),
                useMaterial3: true,
              ),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: ManageListsPage(
                  title: "Lists",
                  data: snapshot.data,
                  onNeedSave: () async => {saveUserData(snapshot.data)}),
            );
          } else {
            return Center(
                child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(),
            ));
          }
        });
  }
}

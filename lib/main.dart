import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models.dart';
import 'manage_lists_page.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() async {
  runApp(const MyApp());
}

Future<dynamic> callAsyncFetch() async {
  //await Future.delayed(Duration(seconds: 3));
  final prefs = await SharedPreferences.getInstance();
  String data = prefs.getString('data') ?? "";
  //data = "";

  if(data == "") {
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
              theme: ThemeData(
                colorScheme: ColorScheme.highContrastDark(),
//                scaffoldBackgroundColor:                    const Color.fromARGB(255, 123, 73, 131),
                useMaterial3: true,
              ),
              home: ManageListsPage(
                  title: 'Lists',
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

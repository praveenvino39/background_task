import 'dart:convert';
import 'dart:developer';

import 'package:background_task/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')
Future<void> backgroundHandler(RemoteMessage message) async {
  log(jsonEncode(message.data));
  final id = message.data["id"].toString();
  //PERFORM ANY TASK HERE
  final response = await http
      .get(Uri.parse("https://jsonplaceholder.typicode.com/todos/$id"));
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  sharedPreferences.setString("RESPONSE", response.body);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.requestPermission(alert: true);
  final token = await FirebaseMessaging.instance.getToken();
  log(token.toString());
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: MainApp(),
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  String response = '';
  String token = '';
  @override
  void initState() {
    loadRespons();
    super.initState();
  }

  loadRespons() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      response = sharedPreferences.getString("RESPONSE") ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const Text('Response from background handler'),
            const SizedBox(
              height: 50,
            ),
            Text(response),
            const SizedBox(
              height: 20,
            ),
            Text(token),
            ElevatedButton(
                onPressed: () async {
                  final fcmToken = await FirebaseMessaging.instance.getToken();
                  setState(() {
                    token = fcmToken.toString();
                  });
                },
                child: const Text("GET TOKEN"))
          ],
        ),
        // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}

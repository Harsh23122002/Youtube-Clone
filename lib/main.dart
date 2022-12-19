import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtubeclone/pages/home-page/home.dart';
import 'package:youtubeclone/pages/login-page/login.dart';
import 'package:youtubeclone/utils/google_sign_in_provider.dart';
import 'package:youtubeclone/utils/youtube_api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: ApiServiceProvider(),
        ),
        ChangeNotifierProvider.value(
          value: GoogleSignInProvider(),
        )
      ],
      child: Consumer<ApiServiceProvider>(
          builder: (context, ApiServiceProvider, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
              primarySwatch: Colors.red, secondaryHeaderColor: Colors.red),
          home: const Home(),
        );
      }),
    );
  }
}

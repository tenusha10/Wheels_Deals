import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wheels_deals/HomeScreen.dart';
import 'package:wheels_deals/authentication_service.dart';
import 'package:wheels_deals/loginScreen.dart';
import 'package:wheels_deals/splashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<AuthenticationService>(
            create: (_) => AuthenticationService(FirebaseAuth.instance),
          ),
          StreamProvider(
            create: (context) =>
                context.read<AuthenticationService>().authStateChanges,
          )
        ],
        child: MaterialApp(
          title: 'Wheels and Deals',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            textTheme: GoogleFonts.patrickHandTextTheme(
              Theme.of(context).textTheme,
            ),
            primarySwatch: Colors.purple,
          ),
          home: splashScreen(),
        ));
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if (firebaseUser != null) {
      return HomeScreen();
    } else {
      //return splashScreen();
      return loginScreen();
    }
  }
}

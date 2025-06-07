import 'package:flutter/material.dart';
import 'package:innov_digital/screens/All_documents_screen.dart';
import 'package:innov_digital/screens/SplashScreen.dart';
import 'package:innov_digital/screens/profile_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}
final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [routeObserver],
      title: 'Doc Manager',
      theme: ThemeData(
        fontFamily: 'Nunito',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',  // Utilise la route pour l'écran de démarrage
      routes: {
        '/splash': (_) => SplashScreen(),
        '/home': (_) => const HomeScreen(),
        '/documents': (_) => AllDocumentsPage(),
        '/profile': (_) => const ProfileScreen(),
      },
    );
  }
}

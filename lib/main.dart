import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_firebase/Views/liste_livre_view.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart'; // ← Fichier de configuration
import 'controllers/livre_controller.dart';
//import 'views/liste_livres_view.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialisation Firebase avec la configuration spécifique
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // ← Utilise notre config
  );
  
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<LivreController>(
          create: (_) => LivreController(),
        ),
      ],
      child: MaterialApp(
        title: 'Ma Bibliothèque',
         // theme: ThemeData(
        //   primarySwatch: Colors.blue,
        //   useMaterial3: true,
        // ),
        theme: ThemeData(
          useMaterial3: false, // Pour compatibilité avec cardTheme comme ci-dessous
          primaryColor: const Color(0xFF4CAF50),
          scaffoldBackgroundColor: const Color(0xFFF5F5F5),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF4CAF50),
            foregroundColor: Colors.white,
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xFF4CAF50),
          ),
          cardTheme: CardThemeData( // ← ICI : CardThemeData au lieu de CardTheme ancienne version
            color: Colors.white,
            elevation: 4,
            shadowColor: Colors.black12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          popupMenuTheme: PopupMenuThemeData(
  color: Colors.white,
  elevation: 8,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
    side: BorderSide(color: Colors.grey[300]!, width: 1),
  ),
  textStyle: TextStyle(
    color: Colors.grey[800],
    fontSize: 14,
    fontWeight: FontWeight.w500,
  ),
 
),
        ),
        home: const ListeLivresView(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
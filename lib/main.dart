import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vscode_explorer/models/settings_model.dart';
import 'package:window_size/window_size.dart';
import 'models/file_system_model.dart';
import 'services/auth_service.dart';
import 'views/login_screen.dart';
import 'views/main_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows) {
    setWindowTitle('Mentora');
    setWindowMinSize(const Size(800, 600));
    setWindowMaxSize(Size.infinite);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => FileSystemModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => SettingsModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthService(),
        ),
      ],
      child: Consumer<AuthService>(
        builder: (context, authService, _) {
          // Initialize the auth service
          WidgetsBinding.instance.addPostFrameCallback((_) {
            authService.initialize();
          });

          return MaterialApp(
            title: 'Mentora',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              brightness: Brightness.dark,
              primaryColor: const Color(0xFF1E1E1E),
              scaffoldBackgroundColor: const Color(0xFF1E1E1E),
              dividerColor: const Color(0xFF333333),
              colorScheme: ColorScheme.fromSwatch().copyWith(
                secondary: const Color(0xFF007ACC),
                brightness: Brightness.dark,
              ),
              appBarTheme: const AppBarTheme(
                foregroundColor: Color.fromARGB(255, 255, 255, 255),
                backgroundColor: Color.fromARGB(255, 116, 115, 115),
                elevation: 10,
              ),
              textTheme: const TextTheme(
                bodyMedium: TextStyle(color: Colors.white70),
              ),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: const Color(0xFF252526),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF3C3C3C)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF3C3C3C)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF007ACC)),
                ),
              ),
            ),
            home: authService.isLoading
                ? const LoadingScreen()
                : authService.isLoggedIn
                    ? const MainLayout()
                    : const LoginScreen(),
          );
        },
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading...'),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mypinter/pages/homePage.dart';
import 'package:mypinter/config/theme.dart';
import 'package:mypinter/config/app_settings.dart';
import 'package:mypinter/config/auth_state.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppSettings()),
        ChangeNotifierProvider(create: (_) => AuthState()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Load auth state after widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthState>(context, listen: false).loadAuthState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppSettings>(
      builder: (context, settings, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Pinter',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: settings.themeMode,
          home: const HomePage(),
        );
      },
    );
  }
}

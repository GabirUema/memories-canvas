import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'screens/home_screen.dart';

// Cores do app: roxo lilás como cor principal e um verde claro nos detalhes.
const _roxoLilas = Color(0xFF9C6ADE);
const _verdeClaro = Color(0xFF4FC78A);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // precisa disso pra formatar as datas em português
  await initializeDateFormatting('pt_BR', null);

  runApp(const MemoriesCanvasApp());
}

class MemoriesCanvasApp extends StatelessWidget {
  const MemoriesCanvasApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Gero a paleta a partir do roxo e troco a cor "tertiary" pelo verde,
    // que é o que uso nos detalhes (ícones de data, FAB, etc).
    final base = ColorScheme.fromSeed(seedColor: _roxoLilas);
    final scheme = base.copyWith(
      tertiary: _verdeClaro,
      onTertiary: Colors.white,
      tertiaryContainer: const Color(0xFFCFF3DE),
      onTertiaryContainer: const Color(0xFF0C3F26),
    );

    return MaterialApp(
      title: 'MemoriesCanvas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        scaffoldBackgroundColor: const Color(0xFFFCFAFF),
        appBarTheme: const AppBarTheme(centerTitle: false),
        // FAB verdinho pra dar o contraste com o roxo
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: scheme.tertiaryContainer,
          foregroundColor: scheme.onTertiaryContainer,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

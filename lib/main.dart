import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'presentation/perfil/perfil_selection_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitUp,
  ]);
  runApp(const ProviderScope(child: EduPlayApp()));
}

class EduPlayApp extends StatelessWidget {
  const EduPlayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LuPe',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.tema,
      home: const PerfilSelectionScreen(),
    );
  }
}

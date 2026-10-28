import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamed/core/constants/app_constants.dart';
import 'package:streamed/core/theme/app_theme.dart';
import 'package:streamed/presentation/providers/theme_provider.dart';
import 'package:streamed/presentation/screens/main_shell_screen.dart';

class StreamedApp extends ConsumerWidget {
  const StreamedApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const MainShellScreen(),
    );
  }
}
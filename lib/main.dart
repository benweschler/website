import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:website/initializer.dart';
import 'package:website/screens/initialization_screen.dart';
import 'package:website/screens/main_app_scaffold/main_app_scaffold.dart';
import 'package:website/screens/under_construction_page.dart';
import 'package:website/style/theme.dart';
import 'package:website/utils/theme_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final platformBrightness =
      WidgetsBinding.instance.platformDispatcher.platformBrightness;
  final themeConfig = ThemeConfig(initialBrightness: platformBrightness);

  runApp(
    ChangeNotifierProvider.value(
      value: themeConfig,
      child: const WebApp(),
    ),
  );
}

class WebApp extends StatefulWidget {
  const WebApp({super.key});

  @override
  State<WebApp> createState() => _WebAppState();
}

class _WebAppState extends State<WebApp> {
  late final initializationStream = initializeApp(context);
  bool _isAdminValidated = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ben Weschler',
      debugShowCheckedModeBanner: false,
      theme: AppColors.fromType(
        context.watch<ThemeConfig>().themeType,
      ).toThemeData(),
      home: StreamBuilder(
        stream: initializationStream,
        initialData: 0,
        builder: (context, snapshot) {
          if (!_isAdminValidated && kReleaseMode) {
            return UnderConstructionScreen(
              validateAdmin: () => setState(() => _isAdminValidated = true),
            );
          }

          return snapshot.connectionState == ConnectionState.done
              ? const MainAppScaffold()
              : InitializationScreen(loadingPercentage: snapshot.data!);
        },
      ),
    );
  }
}

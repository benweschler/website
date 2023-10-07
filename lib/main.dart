import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:website/media_cache.dart';
import 'package:website/screens/main_app_scaffold/main_app_scaffold.dart';
import 'package:website/style/theme.dart';
import 'package:website/utils/theme_config.dart';

void main() {
  runApp(const WebApp());
}

class WebApp extends StatefulWidget {
  const WebApp({super.key});

  @override
  State<WebApp> createState() => _WebAppState();
}

class _WebAppState extends State<WebApp> {
  late final ThemeConfig _themeConfig = ThemeConfig(
    initialBrightness: MediaQuery.of(context).platformBrightness,
  );
  final _mediaCache = MediaCache();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _themeConfig),
        Provider.value(value: _mediaCache),
      ],
      child: ListenableBuilder(
        listenable: _themeConfig,
        builder: (_, __) => StreamBuilder(
          stream: _mediaCache.initializationController.stream,
          initialData: 0,
          builder: (context, snapshot) {
            final content = snapshot.connectionState == ConnectionState.done
                ? const MainAppScaffold()
                : _LoadingScreen(loadingPercentage: snapshot.data!);
            return MaterialApp(
              title: 'Ben Weschler',
              debugShowCheckedModeBanner: false,
              theme: AppColors.fromType(_themeConfig.themeType).toThemeData(),
              home: content,
            );
          },
        ),
      ),
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  final int loadingPercentage;

  const _LoadingScreen({required this.loadingPercentage});

  @override
  Widget build(BuildContext context) {
    final loadingIndicatorColor =
        AppColors.of(context).isDark ? Colors.white : Colors.black;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  'Loading',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.25,
                    letterSpacing: 1.33,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: CustomMultiChildLayout(
                delegate: _LoadingIndicatorLayoutDelegate(),
                children: [
                  LayoutId(
                    id: 'loading-indicator',
                    child: Container(
                      width: 200,
                      height: 6,
                      decoration: ShapeDecoration(
                        shape: StadiumBorder(
                          side: BorderSide(color: loadingIndicatorColor),
                        ),
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) => Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            color: loadingIndicatorColor,
                            width:
                                constraints.maxWidth * loadingPercentage / 100,
                          ),
                        ),
                      ),
                    ),
                  ),
                  LayoutId(
                    id: 'loading-percentage',
                    child: Text(
                      '$loadingPercentage%',
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.25,
                        letterSpacing: 1.33,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingIndicatorLayoutDelegate extends MultiChildLayoutDelegate {
  @override
  void performLayout(Size size) {
    final loadingIndicatorSize =
        layoutChild('loading-indicator', const BoxConstraints());
    positionChild(
      'loading-indicator',
      Offset(
        size.width / 2 - loadingIndicatorSize.width / 2,
        -1 * loadingIndicatorSize.height / 2,
      ),
    );

    final textSize = layoutChild('loading-percentage', const BoxConstraints());
    positionChild(
      'loading-percentage',
      Offset(
        size.width / 2 + loadingIndicatorSize.width / 2 + 15,
        -1 * textSize.height / 2,
      ),
    );
  }

  @override
  bool shouldRelayout(_LoadingIndicatorLayoutDelegate oldDelegate) => false;
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selendra_marketplace_app/core/enums/connectivity_status.dart';
import 'package:selendra_marketplace_app/core/services/connectivity_services.dart';
import 'all_export.dart';
import 'core/providers/products_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

final navigationKey = GlobalKey<NavigatorState>();
final sfKey = GlobalKey<ScaffoldState>();

void main() {
  // debugPaintSizeEnabled = true;
  runApp(SelendraApp());
}

class SelendraApp extends StatefulWidget {
  @override
  _SelendraAppState createState() => _SelendraAppState();
}

class _SelendraAppState extends State<SelendraApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<ConnectivityStatus>(
          create: (context) => ConnectivityServices().streamController.stream,
        ),
        ChangeNotifierProvider<LangProvider>(
          create: (context) => LangProvider(),
        ),
        ChangeNotifierProvider<CartProvider>(
          create: (context) => CartProvider(),
        ),
        ChangeNotifierProvider<ProductsProvider>(
            create: (context) => ProductsProvider()),
        ChangeNotifierProvider<FavoriteProvider>(
          create: (context) => FavoriteProvider(),
        ),
        ChangeNotifierProvider<Auth>(
          create: (context) => Auth(),
        ),
        ChangeNotifierProvider<ApiGetServices>(
          create: (context) => ApiGetServices(),
        ),
        ChangeNotifierProvider<ApiPostServices>(
          create: (context) => ApiPostServices(),
        ),
      ],
      child: Consumer<LangProvider>(
        builder: (context, value, child) => MaterialApp(
          builder: (context, child) => ScrollConfiguration(
            behavior: ScrollBehavior()
              ..buildViewportChrome(context, child, AxisDirection.down),
            child: child,
          ),
          locale: value.manualLocale,
          supportedLocales: [
            const Locale('en', 'US'),
            const Locale('km', 'KH'),
          ],
          localizationsDelegates: [
            AppLocalizeService.delegate,
            //build-in localization for material wiidgets
            GlobalWidgetsLocalizations.delegate,

            GlobalMaterialLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            // Check if the current device locale is supported
            if (locale != null) {
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale.languageCode &&
                    supportedLocale.countryCode == locale.countryCode) {
                  return supportedLocale;
                }
              }
            }
            // If the locale of the device is not supported, use the first one
            // from the list (English, in this case).
            return supportedLocales.first;
          },
          initialRoute: '/',
          routes: {
            '/root': (context) => RootServices(),
            '/detail': (context) => DetailScreen(),
          },
          debugShowCheckedModeBanner: true,
          theme: ThemeData(
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: SplashScreen(),
          navigatorKey: navigationKey,
        ),
      ),
    );
  }
}

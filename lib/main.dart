// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_if_null_operators

import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:poultry_pal/controllers/language_controller.dart';
import 'package:poultry_pal/firebase_options.dart';
import 'package:poultry_pal/views/splash_screen/splach_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'consts/consts.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Stripe.publishableKey =
      "pk_test_51NRfsYIxw1u7K45rHsOVnnLrGcYlYMmnehPJDwcsUCRa8nFqy1fPLiU8yltxIwRvW2AH8d5IwfLFVg8StGwkze8S006Timd8p6";
  Stripe.merchantIdentifier = 'any string works';
  await Stripe.instance.applySettings();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
    print('language');
    state.setLocale(newLocale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });

    print(_locale == Locale('en') ? false : true);
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        this._locale = locale;
        Get.updateLocale(_locale!);
      });
    });
    super.didChangeDependencies();
  }

  Future<Locale> getLocale() async {
    // print(LAGUAGE_CODE);
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String languageCode = _prefs.getString('language') ?? 'en';
    return Locale(languageCode);
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(LanguageChangeController());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: appname,
      theme: ThemeData(
        //To set appbar icons color
        iconTheme: const IconThemeData(color: darkFontGrey),
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
            elevation: 0.0),
        fontFamily: regular,
      ),
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'),
        Locale('ur'),
      ],
      home: const SplashScreen(),
    );
  }
}

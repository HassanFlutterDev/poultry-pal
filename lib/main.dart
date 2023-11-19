import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:poultry_pal/firebase_options.dart';
import 'package:poultry_pal/views/splash_screen/splach_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'consts/consts.dart';
import 'package:get/get.dart';

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

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      home: const SplashScreen(),
    );
  }
}

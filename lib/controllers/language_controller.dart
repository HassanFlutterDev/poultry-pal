import 'package:get/get.dart';
import 'package:poultry_pal/consts/consts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageChangeController extends GetxController {
  var appLocale = Locale('en').obs;
  void changeLanguage(Locale type) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    appLocale.value = type;
    if (type == Locale('en')) {
      pref.setString('language', 'en');
    } else {
      pref.setString('language', 'ur');
    }
  }
}

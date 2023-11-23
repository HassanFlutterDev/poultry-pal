// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'package:poultry_pal/consts/consts.dart';
import 'package:poultry_pal/controllers/auth_controller.dart';
import 'package:poultry_pal/views/auth_screen/signup_screen.dart';
import 'package:poultry_pal/views/home_screen/home.dart';
import 'package:poultry_pal/widget_common/applpgo_widget.dart';
import 'package:poultry_pal/widget_common/bg_widget.dart';
import 'package:poultry_pal/consts/list.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widget_common/our_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());

    return bgWidget(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
          child: Column(
        children: [
          (context.screenHeight * 0.03).heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: PopupMenuButton(
                    child: Icon(
                      Icons.language,
                      color: Colors.white,
                      size: 35,
                    ),
                    onSelected: (value) async {
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      if (value == 0) {
                        Get.updateLocale(Locale('en'));
                        pref.setString('language', 'en');
                      } else {
                        Get.updateLocale(Locale('ur'));
                        pref.setString('language', 'ur');
                      }
                    },
                    itemBuilder: (_) => [
                          PopupMenuItem(
                            child: Text('English'),
                            value: 0,
                          ),
                          PopupMenuItem(
                            child: Text('Urdu'),
                            value: 1,
                          ),
                        ]),
              )
            ],
          ),
          applogoWidget(),
          10.heightBox,
          AppLocalizations.of(context)!
              .login
              .text
              .fontFamily(bold)
              .white
              .size(18)
              .make(),
          15.heightBox,
          Obx(
            () => Column(
              children: [
                TextFormField(
                  controller: controller.emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: whiteColor,
                    prefixIcon: Icon(
                      Icons.email,
                      color: redColor,
                    ),
                    border: InputBorder.none,
                    hintText: AppLocalizations.of(context)!.enteremail,
                  ),
                ),
                10.heightBox,
                TextFormField(
                  obscureText: true,
                  controller: controller.passwordController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: whiteColor,
                    prefixIcon: Icon(
                      Icons.lock,
                      color: redColor,
                    ),
                    border: InputBorder.none,
                    hintText: AppLocalizations.of(context)!.enterpass,
                  ),
                ),
                Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () {},
                        child: AppLocalizations.of(context)!
                            .forgotpass
                            .text
                            .make())),
                10.heightBox,
                controller.isloading.value
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(redColor),
                      )
                    : ourButton(
                        color: redColor,
                        title: AppLocalizations.of(context)!.loginb,
                        textColor: whiteColor,
                        onPress: () async {
                          controller.isloading(true);

                          await controller
                              .loginMethod(context: context)
                              .then((value) {
                            if (value != null) {
                              VxToast.show(context, msg: loggedin);
                              Get.offAll(() => const Home());
                            } else {
                              controller.isloading(false);
                            }
                          });
                        },
                      ).box.width(context.screenWidth - 50).make(),
                10.heightBox,
                AppLocalizations.of(context)!.orcreateaccout.text.make(),
                10.heightBox,
                ourButton(
                    color: lightGolden,
                    title: AppLocalizations.of(context)!.signup,
                    textColor: redColor,
                    onPress: () {
                      Get.to(() => const SignupScreen());
                    }).box.width(context.screenWidth - 50).make(),
                10.heightBox,
                AppLocalizations.of(context)!
                    .loginwith
                    .text
                    .color(fontGrey)
                    .make(),
                10.heightBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    1,
                    (index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () async {
                          if (index == 0) {
                            await controller
                                .signInWithGoogle(context)
                                .then((value) {
                              if (value == true) {
                                VxToast.show(context, msg: loggedin);
                                Get.offAll(() => const Home());
                              }
                            });
                          }
                        },
                        child: CircleAvatar(
                          backgroundColor: lightGrey,
                          radius: 25,
                          child: Image.asset(
                            socialIconList[index],
                            width: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
                .box
                .white
                .rounded
                .padding(const EdgeInsets.all(16))
                .width(context.screenWidth - 70)
                .make(),
          ),
          10.heightBox,
          credits.text.color(Colors.black).fontFamily(semibold).make(),
        ],
      )),
    ));
  }
}

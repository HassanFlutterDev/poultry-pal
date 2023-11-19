import 'package:poultry_pal/consts/consts.dart';
import 'package:poultry_pal/controllers/auth_controller.dart';
import 'package:poultry_pal/views/auth_screen/signup_screen.dart';
import 'package:poultry_pal/views/home_screen/home.dart';
import 'package:poultry_pal/widget_common/applpgo_widget.dart';
import 'package:poultry_pal/widget_common/bg_widget.dart';
import 'package:poultry_pal/consts/list.dart';
import 'package:get/get.dart';
import '../../widget_common/our_button.dart';

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
          (context.screenHeight * 0.1).heightBox,
          applogoWidget(),
          10.heightBox,
          "Log in to $appname".text.fontFamily(bold).white.size(18).make(),
          15.heightBox,
          Obx(
            () => Column(
              children: [
                TextFormField(
                  controller: controller.emailController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: whiteColor,
                    prefixIcon: Icon(
                      Icons.email,
                      color: redColor,
                    ),
                    border: InputBorder.none,
                    hintText: emailHint,
                  ),
                ),
                10.heightBox,
                TextFormField(
                  obscureText: true,
                  controller: controller.passwordController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: whiteColor,
                    prefixIcon: Icon(
                      Icons.lock,
                      color: redColor,
                    ),
                    border: InputBorder.none,
                    hintText: passwordHint,
                  ),
                ),
                Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () {}, child: forgetPass.text.make())),
                10.heightBox,
                controller.isloading.value
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(redColor),
                      )
                    : ourButton(
                        color: redColor,
                        title: login,
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
                createNewAccount.text.make(),
                10.heightBox,
                ourButton(
                    color: lightGolden,
                    title: signup,
                    textColor: redColor,
                    onPress: () {
                      Get.to(() => const SignupScreen());
                    }).box.width(context.screenWidth - 50).make(),
                10.heightBox,
                loginWith.text.color(fontGrey).make(),
                10.heightBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () async {
                          if (index == 1) {
                            await controller
                                .signInWithGoogle(context)
                                .then((value) {
                              if (value == true) {
                                VxToast.show(context, msg: loggedin);
                                Get.offAll(() => const Home());
                              }
                            });
                          } else if (index == 0) {
                            await controller
                                .signInWithFacebook(context)
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

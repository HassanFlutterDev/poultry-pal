import 'package:poultry_pal/controllers/auth_controller.dart';
import 'package:poultry_pal/views/home_screen/home.dart';
import 'package:get/get.dart';
import '../../consts/consts.dart';
import '../../widget_common/applpgo_widget.dart';
import '../../widget_common/bg_widget.dart';
import '../../widget_common/our_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool? isCheck = false;
  var controller = Get.put(AuthController());

  //text controller
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordRetypeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return bgWidget(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
          child: Column(
        children: [
          (context.screenHeight * 0.1).heightBox,
          applogoWidget(),
          10.heightBox,
          "Join The $appname".text.fontFamily(bold).white.size(18).make(),
          15.heightBox,
          Obx(
            () => Column(
              children: [
                TextFormField(
                  obscureText: false,
                  controller: nameController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: whiteColor,
                    prefixIcon: Icon(
                      Icons.supervised_user_circle_rounded,
                      color: redColor,
                    ),
                    border: InputBorder.none,
                    hintText: nameHint,
                  ),
                ),
                10.heightBox,
                TextFormField(
                  obscureText: false,
                  controller: emailController,
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
                  controller: passwordController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: whiteColor,
                    prefixIcon: Icon(
                      Icons.lock_person,
                      color: redColor,
                    ),
                    border: InputBorder.none,
                    hintText: passwordHint,
                  ),
                ),
                10.heightBox,
                TextFormField(
                  obscureText: false,
                  controller: passwordRetypeController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: whiteColor,
                    prefixIcon: Icon(
                      Icons.lock_reset_outlined,
                      color: redColor,
                    ),
                    border: InputBorder.none,
                    hintText: retypePasswordHint,
                  ),
                ),
                10.heightBox,
                Row(
                  children: [
                    Checkbox(
                        checkColor: redColor,
                        value: isCheck,
                        onChanged: (newValue) {
                          setState(() {
                            isCheck = newValue;
                          });
                        }),
                    10.widthBox,
                    Expanded(
                      child: RichText(
                          text: const TextSpan(children: [
                        TextSpan(
                            text: 'I agree to the ',
                            style: TextStyle(
                                fontFamily: regular, color: fontGrey)),
                        TextSpan(
                            text: termsAndConditions,
                            style:
                                TextStyle(fontFamily: bold, color: redColor)),
                        TextSpan(
                            text: '&',
                            style: TextStyle(
                                fontFamily: regular, color: fontGrey)),
                        TextSpan(
                            text: privacyPolicy,
                            style:
                                TextStyle(fontFamily: bold, color: redColor)),
                      ])),
                    )
                  ],
                ),
                10.heightBox,
                controller.isloading.value
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(redColor),
                      )
                    : ourButton(
                        color: isCheck == true ? redColor : lightGrey,
                        title: signup,
                        textColor: whiteColor,
                        onPress: () async {
                          if (isCheck != false) {
                            controller.isloading(true);
                            try {
                              await controller
                                  .signupMethod(
                                      context: context,
                                      email: emailController.text,
                                      password: passwordController.text)
                                  .then((value) {
                                return controller.storeUserData(
                                    email: emailController.text,
                                    password: passwordController.text,
                                    name: nameController.text);
                              }).then((value) {
                                VxToast.show(context, msg: loggedin);
                                Get.offAll(() => const Home());
                              });
                            } catch (e) {
                              auth.signOut();
                              VxToast.show(context, msg: e.toString());
                              controller.isloading(false);
                            }
                          }
                        },
                      ).box.width(context.screenWidth - 50).make(),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              alreadyHaveAccount.text.color(fontGrey).make(),
              login.text.color(redColor).make().onTap(() {
                Get.back();
              })
            ],
          ),
          10.heightBox,
          credits.text.color(Colors.black).fontFamily(semibold).make(),
        ],
      )),
    ));
  }
}

import 'dart:convert';

import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:poultry_pal/consts/consts.dart';
import 'package:poultry_pal/controllers/cart_controller.dart';
import 'package:poultry_pal/views/home_screen/home.dart';
import 'package:poultry_pal/widget_common/loading_indicator.dart';
import 'package:poultry_pal/widget_common/our_button.dart';
import 'package:get/get.dart';
import '../../consts/list.dart';
import 'package:http/http.dart';

class PaymentMethods extends StatefulWidget {
  const PaymentMethods({Key? key}) : super(key: key);

  @override
  State<PaymentMethods> createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods> {
  Map<String, dynamic>? paymentIntent;
  Future<bool> makepayment(String amount, String username) async {
    bool res = false;
    try {
      paymentIntent = await createPayment(amount);
      var gpay = PaymentSheetGooglePay(
        merchantCountryCode: "PK",
        currencyCode: "PK",
        testEnv: true,
      );
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntent!["client_secret"],
        style: Theme.of(context).scaffoldBackgroundColor == Colors.black
            ? ThemeMode.dark
            : ThemeMode.light,
        merchantDisplayName: username,
        googlePay: gpay,
      ));
      res = await displayPayment();
      return res;
    } catch (e) {
      res = false;
      print(e.toString());
      return res;
      // print(e.toString());
    }
  }

  Future<bool> displayPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      print('payment success');
      return true;
    } on StripeException catch (e) {
      print(e.toString());
      return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  createPayment(String amount) async {
    try {
      Map<String, dynamic> body = {
        "amount": '${amount}00',
        "currency": "PKR",
      };
      var res = await post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            "Authorization":
                "Bearer sk_test_51NRfsYIxw1u7K45rcMj8m1o1ctnvAkWMyNCHR1uVQZgaaiQJlpaSjV8OIDi1eyJr16JpSg5kXVHkHMJhutr4TXxy009YXOQLR0",
            "Content-Type": "application/x-www-form-urlencoded",
          });
      print(res.body);
      return json.decode(res.body);
    } catch (e) {
      print(e.toString());
    }
  }

  bool stripe = false;
  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();
    return Obx(
      () => Scaffold(
        backgroundColor: whiteColor,
        bottomNavigationBar: SizedBox(
          height: 60,
          child: controller.placingOrder.value
              ? Center(
                  child: loadingIndicator(),
                )
              : ourButton(
                  onPress: () async {
                    if (controller.paymentIndex.value == 0) {
                      var res = await makepayment(
                          controller.totalP.value.toString(), "User");
                      if (res) {
                        controller.placeMyOrder(
                            orderPaymentMethod:
                                paymentMethods[controller.paymentIndex.value],
                            totalAmount: controller.totalP.value);
                        await controller.clearCart();
                        VxToast.show(context, msg: "Order placed successfully");
                        Get.offAll(const Home());
                      }
                    } else {
                      controller.placeMyOrder(
                          orderPaymentMethod:
                              paymentMethods[controller.paymentIndex.value],
                          totalAmount: controller.totalP.value);
                      await controller.clearCart();
                      VxToast.show(context, msg: "Order placed successfully");
                      Get.offAll(const Home());
                    }
                  },
                  color: redColor,
                  textColor: whiteColor,
                  title: "Place my order",
                ),
        ),
        appBar: AppBar(
          title: "Chose Payment Method"
              .text
              .fontFamily(semibold)
              .color(darkFontGrey)
              .make(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Obx(
            () => Column(
              children: List.generate(paymentMethodsImg.length, (index) {
                return GestureDetector(
                  onTap: () {
                    controller.changePaymentIndex(index);
                  },
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: controller.paymentIndex.value == index
                                ? redColor
                                : Colors.transparent,
                            width: 4)),
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Image.asset(
                          paymentMethodsImg[index],
                          width: double.infinity,
                          height: 120,
                          fit: BoxFit.cover,
                          colorBlendMode: controller.paymentIndex.value == index
                              ? BlendMode.darken
                              : BlendMode.color,
                          color: controller.paymentIndex.value == index
                              ? Colors.black.withOpacity(0.4)
                              : Colors.transparent,
                        ),
                        controller.paymentIndex.value == index
                            ? Transform.scale(
                                scale: 1.3,
                                child: Checkbox(
                                  activeColor: Colors.green,
                                  value: true,
                                  onChanged: (value) {},
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                ),
                              )
                            : Container(),
                        Positioned(
                            bottom: 10,
                            right: 10,
                            child: paymentMethods[index]
                                .text
                                .white
                                .fontFamily(semibold)
                                .size(16)
                                .make())
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

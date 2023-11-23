import 'package:poultry_pal/consts/consts.dart';
import 'package:poultry_pal/controllers/cart_controller.dart';
import 'package:poultry_pal/views/cart_screen/payment_mathod.dart';
import 'package:poultry_pal/widget_common/custome_textfield.dart';
import 'package:poultry_pal/widget_common/our_button.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShippingDetails extends StatelessWidget {
  const ShippingDetails({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: AppLocalizations.of(context)!
            .shippinginfo
            .text
            .fontFamily(semibold)
            .color(darkFontGrey)
            .make(),
      ),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: ourButton(
          onPress: () {
            if (controller.addressController.text.length > 10 ||
                controller.postalcodeController.text.length > 4 ||
                controller.phoneController.text.length > 10) {
              Get.to(() => const PaymentMethods());
            } else {
              VxToast.show(context,
                  msg: AppLocalizations.of(context)!.pleasefillform);
            }
          },
          color: redColor,
          textColor: whiteColor,
          title: AppLocalizations.of(context)!.continu,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            customTextField(
                hint: AppLocalizations.of(context)!.address,
                isPass: false,
                title: AppLocalizations.of(context)!.address,
                controller: controller.addressController),
            customTextField(
                hint: AppLocalizations.of(context)!.city,
                isPass: false,
                title: AppLocalizations.of(context)!.city,
                controller: controller.cityController),
            customTextField(
                hint: AppLocalizations.of(context)!.state,
                isPass: false,
                title: AppLocalizations.of(context)!.state,
                controller: controller.stateController),
            customTextField(
                hint: AppLocalizations.of(context)!.postalcode,
                isPass: false,
                title: AppLocalizations.of(context)!.postalcode,
                controller: controller.postalcodeController),
            customTextField(
                hint: AppLocalizations.of(context)!.phone,
                isPass: false,
                title: AppLocalizations.of(context)!.phone,
                controller: controller.phoneController),
          ],
        ),
      ),
    );
  }
}

import 'package:poultry_pal/consts/consts.dart';
import 'package:poultry_pal/controllers/product_controller.dart';
import 'package:poultry_pal/views/chat_screen/chat_screen.dart';
import 'package:poultry_pal/views/reviews/reviews_screen.dart';
import 'package:poultry_pal/widget_common/our_button.dart';
import 'package:get/get.dart';
import '../../consts/list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ItemDetails extends StatelessWidget {
  final String? title;
  final dynamic data;
  const ItemDetails({Key? key, required this.title, this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProductController>();
    return WillPopScope(
      onWillPop: () async {
        controller.resetValues();
        return true;
      },
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              controller.resetValues();
              Get.back();
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: title!.text.color(darkFontGrey).fontFamily(bold).make(),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.share),
            ),
            Obx(
              () => IconButton(
                onPressed: () {
                  if (controller.isFav.value) {
                    controller.removeFromWhishlist(data.id, context);
                  } else {
                    controller.addToWhishlist(data.id, context);
                  }
                },
                icon: Icon(
                  Icons.favorite_outline,
                  color: controller.isFav.value ? redColor : darkFontGrey,
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Swiper Section
                      VxSwiper.builder(
                        autoPlay: true,
                        height: 350,
                        itemCount: data["p_imgs"].length,
                        aspectRatio: 16 / 9,
                        viewportFraction: 1.0,
                        itemBuilder: (context, index) {
                          return Image.network(
                            data['p_imgs'][index],
                            width: double.infinity,
                            fit: BoxFit.cover,
                          );
                        },
                      ),

                      10.heightBox,
                      // Title and Detail section
                      title!.text
                          .size(16)
                          .color(darkFontGrey)
                          .fontFamily(semibold)
                          .make(),
                      10.heightBox,
                      // Rating
                      VxRating(
                        isSelectable: false,
                        value: ratings(
                          data['star1'],
                          data['star2'],
                          data['star3'],
                          data['star4'],
                          data['star5'],
                        ),
                        onRatingUpdate: (value) {},
                        normalColor: textfieldGrey,
                        selectionColor: golden,
                        count: 5,
                        maxRating: 5,
                        size: 25,
                      ),
                      10.heightBox,
                      "${data['p_price']}"
                          .numCurrency
                          .text
                          .color(redColor)
                          .fontFamily(bold)
                          .size(18)
                          .make(),
                      10.heightBox,
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppLocalizations.of(context)!
                                    .seller
                                    .text
                                    .white
                                    .fontFamily(semibold)
                                    .make(),
                                5.heightBox,
                                "${data['p_seller']}"
                                    .text
                                    .color(darkFontGrey)
                                    .fontFamily(semibold)
                                    .size(16)
                                    .make(),
                              ],
                            ),
                          ),
                          const CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.message_rounded,
                              color: darkFontGrey,
                            ),
                          ).onTap(() {
                            Get.to(
                              () => const ChatScreen(),
                              arguments: [data['p_seller'], data['vendor_id']],
                            );
                          }),
                        ],
                      )
                          .box
                          .height(60)
                          .padding(const EdgeInsets.symmetric(horizontal: 16))
                          .color(textfieldGrey)
                          .make(),

                      // Quantity section
                      20.heightBox,
                      Obx(
                        () => Column(
                          children: [
                            //Quantity
                            Row(
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: AppLocalizations.of(context)!
                                      .quantity
                                      .text
                                      .fontFamily(bold)
                                      .color(Colors.black)
                                      .make(),
                                ),
                                Obx(
                                  () => Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            controller.decreaseQuantity();
                                            controller.calculateTotalPrice(
                                                int.parse(data['p_price']));
                                          },
                                          icon: const Icon(Icons.remove)),
                                      controller.quantity.value.text
                                          .size(16)
                                          .color(darkFontGrey)
                                          .fontFamily(bold)
                                          .make(),
                                      IconButton(
                                          onPressed: () {
                                            controller.increaseQuantity(
                                                int.parse(data['p_quantity']));
                                            controller.calculateTotalPrice(
                                                int.parse(data['p_price']));
                                          },
                                          icon: const Icon(Icons.add)),
                                      10.widthBox,
                                      "(${data['p_quantity']} available)"
                                          .text
                                          .color(textfieldGrey)
                                          .make()
                                    ],
                                  ),
                                )
                              ],
                            ).box.padding(const EdgeInsets.all(8)).make(),
                            //total row
                            Row(
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: AppLocalizations.of(context)!
                                      .total
                                      .text
                                      .fontFamily(bold)
                                      .color(Colors.black)
                                      .make(),
                                ),
                                "${controller.totalPrice.value}"
                                    .numCurrency
                                    .text
                                    .color(redColor)
                                    .size(16)
                                    .fontFamily(bold)
                                    .make()
                              ],
                            ).box.padding(const EdgeInsets.all(8)).make(),
                          ],
                        ).box.white.shadowSm.make(),
                      ),
                      //description section
                      10.heightBox,
                      AppLocalizations.of(context)!
                          .description
                          .text
                          .color(darkFontGrey)
                          .fontFamily(semibold)
                          .make(),
                      10.heightBox,
                      "${data['p_desc']}".text.color(textfieldGrey).make(),
                      //button section
                      10.heightBox,
                      ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: List.generate(
                            [
                              AppLocalizations.of(context)!.review,
                              AppLocalizations.of(context)!.sellerpolicy,
                              AppLocalizations.of(context)!.returnpolicy,
                              AppLocalizations.of(context)!.supportpolicy,
                            ].length,
                            (index) => ListTile(
                                  title: [
                                    AppLocalizations.of(context)!.review,
                                    AppLocalizations.of(context)!.sellerpolicy,
                                    AppLocalizations.of(context)!.returnpolicy,
                                    AppLocalizations.of(context)!.supportpolicy,
                                  ][index]
                                      .text
                                      .fontFamily(semibold)
                                      .color(darkFontGrey)
                                      .make(),
                                  trailing: InkWell(
                                      onTap: () {
                                        if (index == 0) {
                                          Get.to(ReviewScreen(
                                            id: data['id'],
                                          ));
                                        }
                                      },
                                      child: const Icon(Icons.arrow_forward)),
                                )),
                      ),
                      20.heightBox,
                      //product you may also like
                      AppLocalizations.of(context)!
                          .productsalsolike
                          .text
                          .fontFamily(bold)
                          .size(16)
                          .color(darkFontGrey)
                          .make(),
                      10.heightBox,
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                              6,
                              (index) => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        imgP1,
                                        width: 130,
                                        fit: BoxFit.cover,
                                      ),
                                      10.heightBox,
                                      "Laptop 4GB/64GB"
                                          .text
                                          .fontFamily(semibold)
                                          .color(darkFontGrey)
                                          .make(),
                                      10.heightBox,
                                      "\$299"
                                          .text
                                          .color(redColor)
                                          .fontFamily(bold)
                                          .size(16)
                                          .make()
                                    ],
                                  )
                                      .box
                                      .white
                                      .margin(const EdgeInsets.symmetric(
                                          horizontal: 4))
                                      .roundedSM
                                      .padding(const EdgeInsets.all(8))
                                      .make()),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ourButton(
                color: redColor,
                onPress: () {
                  if (controller.quantity.value > 0) {
                    controller.addToCart(
                        vendorId: data['vendor_id'],
                        img: data['p_imgs'][0],
                        qty: controller.quantity.value,
                        sellername: data['p_seller'],
                        title: data['p_name'],
                        id: data['id'],
                        tprice: controller.totalPrice.value);
                    VxToast.show(context, msg: "Added to cart");
                  } else {
                    VxToast.show(context, msg: "Minimum 1 product is required");
                  }
                },
                textColor: whiteColor,
                title: AppLocalizations.of(context)!.addtocart,
              ),
            )
          ],
        ),
      ),
    );
  }
}

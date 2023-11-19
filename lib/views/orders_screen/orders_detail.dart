// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:poultry_pal/consts/consts.dart';
import 'package:poultry_pal/views/orders_screen/components/order_place_detail.dart';
import 'package:poultry_pal/views/orders_screen/components/orders_status.dart';
import 'package:intl/intl.dart' as intl;

class OrdersDetails extends StatefulWidget {
  final dynamic data;
  const OrdersDetails({Key? key, this.data}) : super(key: key);

  @override
  State<OrdersDetails> createState() => _OrdersDetailsState();
}

class _OrdersDetailsState extends State<OrdersDetails> {
  int rate = 0;
  TextEditingController review = TextEditingController();
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        elevation: 0.0,
        title: "Order Details"
            .text
            .fontFamily(semibold)
            .color(darkFontGrey)
            .make(),
      ),
      bottomNavigationBar: widget.data['order_delivered']
          ? GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (_) {
                      return Dialog(
                        child: Container(
                          height: 310,
                          color: Colors.white,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Rate & Review',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: RatingBar.builder(
                                    // rating: 3.5,
                                    onRatingUpdate: (value) {
                                      setState(() {
                                        rate = value.toInt();
                                      });
                                    },

                                    itemBuilder: (context, index) => Icon(
                                      CupertinoIcons.star_fill,
                                      color: Colors.amber,
                                    ),
                                    itemCount: 5,
                                    itemSize: 45.0,
                                    direction: Axis.horizontal,
                                  ),
                                ),
                              ),
                              CustomTextFieldM(
                                  email: review, text: 'Write a review'),
                              isloading
                                  ? CircularProgressIndicator()
                                  : CustomButton3(
                                      text: 'Submit',
                                      ontap: () async {
                                        if (rate > 0) {
                                          setState(() {
                                            isloading = true;
                                          });
                                          for (var i = 0;
                                              i < widget.data['orders'].length;
                                              i++) {
                                            if (rate == 1) {
                                              await FirebaseFirestore.instance
                                                  .collection('products')
                                                  .doc(widget.data['orders'][i]
                                                      ['id'])
                                                  .update({
                                                'star1': FieldValue.arrayUnion([
                                                  FirebaseAuth
                                                      .instance.currentUser!.uid
                                                ]),
                                              });
                                            } else if (rate == 2) {
                                              await FirebaseFirestore.instance
                                                  .collection('products')
                                                  .doc(widget.data['orders'][i]
                                                      ['id'])
                                                  .update({
                                                'star2': FieldValue.arrayUnion([
                                                  FirebaseAuth
                                                      .instance.currentUser!.uid
                                                ]),
                                              });
                                            } else if (rate == 3) {
                                              await FirebaseFirestore.instance
                                                  .collection('products')
                                                  .doc(widget.data['orders'][i]
                                                      ['id'])
                                                  .update({
                                                'star3': FieldValue.arrayUnion([
                                                  FirebaseAuth
                                                      .instance.currentUser!.uid
                                                ]),
                                              });
                                            } else if (rate == 4) {
                                              await FirebaseFirestore.instance
                                                  .collection('products')
                                                  .doc(widget.data['orders'][i]
                                                      ['id'])
                                                  .update({
                                                'star4': FieldValue.arrayUnion([
                                                  FirebaseAuth
                                                      .instance.currentUser!.uid
                                                ]),
                                              });
                                            } else {
                                              await FirebaseFirestore.instance
                                                  .collection('products')
                                                  .doc(widget.data['orders'][i]
                                                      ['id'])
                                                  .update({
                                                'star5': FieldValue.arrayUnion([
                                                  FirebaseAuth
                                                      .instance.currentUser!.uid
                                                ]),
                                              });
                                            }
                                            var userData =
                                                await FirebaseFirestore.instance
                                                    .collection('users')
                                                    .doc(FirebaseAuth.instance
                                                        .currentUser!.uid)
                                                    .get();
                                            await FirebaseFirestore.instance
                                                .collection('products')
                                                .doc(widget.data['orders'][i]
                                                    ['id'])
                                                .collection('reviews')
                                                .doc()
                                                .set({
                                              'rate': rate,
                                              'time': DateTime.now(),
                                              'name': userData.data()!['name'],
                                              'url': userData.data()![
                                                          'imageUrl'] ==
                                                      ""
                                                  ? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRhW0hzwECDKq0wfUqFADEJaNGESHQ8GRCJIg&usqp=CAU'
                                                  : userData
                                                      .data()!['imageUrl'],
                                              'message': review.text,
                                            });
                                            await FirebaseFirestore.instance
                                                .collection('products')
                                                .doc(widget.data['orders'][i]
                                                    ['id'])
                                                .update({
                                              'reviews':
                                                  FieldValue.increment(1),
                                            });
                                          }
                                          isloading = false;
                                          review.clear();
                                          Get.back();
                                          setState(() {});
                                        } else {
                                          Get.back();
                                        }
                                      }),
                            ],
                          ),
                        ),
                      );
                    });
              },
              child: Container(
                height: 60,
                color: Colors.green,
                width: double.infinity,
                child: Center(
                  child: Text(
                    'Rate This Product',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            )
          : Container(
              height: 10,
              color: Colors.transparent,
            ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              orderStatus(
                  color: redColor,
                  icon: Icons.done,
                  title: "Placed",
                  showDone: widget.data['order_placed']),
              orderStatus(
                  color: Colors.blue,
                  icon: Icons.thumb_up,
                  title: "Confirmed",
                  showDone: widget.data['order_confirm']),
              orderStatus(
                  color: Colors.yellow,
                  icon: Icons.car_crash_outlined,
                  title: "On Delivery",
                  showDone: widget.data['order_on_delivery']),
              orderStatus(
                  color: Colors.purple,
                  icon: Icons.done_all_rounded,
                  title: "Delivered",
                  showDone: widget.data['order_delivered']),
              const Divider(),
              10.heightBox,
              Column(
                children: [
                  orderPlacedDetails(
                    d1: widget.data['order_code'],
                    d2: widget.data['shipping_method'],
                    title1: "Order Code",
                    title2: "Shipping Method",
                  ),
                  orderPlacedDetails(
                    d1: intl.DateFormat("h:mma")
                        .add_yMd()
                        .format((widget.data['order_date'].toDate())),
                    d2: widget.data['payment_method'],
                    title1: "Order Date",
                    title2: "Payment Method",
                  ),
                  orderPlacedDetails(
                    d1: "Unpaid",
                    d2: "Order Placed",
                    title1: "Payment Status",
                    title2: "Payment Method",
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "Shipping Address".text.fontFamily(semibold).make(),
                            "${widget.data['order_by_name']}"
                                .text
                                .fontFamily(semibold)
                                .make(),
                            "${widget.data['order_by_email']}"
                                .text
                                .fontFamily(semibold)
                                .make(),
                            "${widget.data['order_by_address']}"
                                .text
                                .fontFamily(semibold)
                                .make(),
                            "${widget.data['order_by_city']}"
                                .text
                                .fontFamily(semibold)
                                .make(),
                            "${widget.data['order_by_state']}"
                                .text
                                .fontFamily(semibold)
                                .make(),
                            "${widget.data['order_by_phone']}"
                                .text
                                .fontFamily(semibold)
                                .make(),
                            "${widget.data['order_by_postalcode']}"
                                .text
                                .fontFamily(semibold)
                                .make(),
                          ],
                        ),
                        SizedBox(
                          width: 130,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              "Total Amount".text.fontFamily(semibold).make(),
                              "${widget.data['total_amount']}"
                                  .text
                                  .color(redColor)
                                  .fontFamily(bold)
                                  .make()
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ).box.outerShadowMd.white.make(),
              const Divider(),
              10.heightBox,
              "Ordered Product"
                  .text
                  .size(16)
                  .color(darkFontGrey)
                  .fontFamily(semibold)
                  .makeCentered(),
              10.heightBox,
              ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: List.generate(widget.data['orders'].length, (index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      orderPlacedDetails(
                          title1: widget.data['orders'][index]['title'],
                          title2: widget.data['orders'][index]['tprice'],
                          d1: "${widget.data['orders'][index]['qty']}x",
                          d2: "Refundable"),
                      const Divider(),
                    ],
                  );
                }).toList(),
              )
                  .box
                  .outerShadowMd
                  .white
                  .margin(const EdgeInsets.only(bottom: 4))
                  .make(),
              20.heightBox,
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextFieldM extends StatelessWidget {
  const CustomTextFieldM({
    super.key,
    required this.email,
    required this.text,
  });

  final TextEditingController email;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        height: 130,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              strokeAlign: BorderSide.strokeAlignOutside,
              color: const Color.fromARGB(255, 223, 223, 223),
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            style: TextStyle(fontSize: 13, color: Colors.black),
            controller: email,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: text,
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                )),
          ),
        ),
      ),
    );
  }
}

class CustomButton3 extends StatelessWidget {
  const CustomButton3({
    super.key,
    required this.text,
    required this.ontap,
  });
  final String text;
  final VoidCallback ontap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 8),
        height: 62,
        decoration: ShapeDecoration(
          color: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 19.59,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.20,
            ),
          ),
        ),
      ),
    );
  }
}

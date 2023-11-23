// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:poultry_pal/views/orders_screen/orders_detail.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RateScreen extends StatefulWidget {
  var data;
  RateScreen({super.key, required this.data});

  @override
  State<RateScreen> createState() => _RateScreenState();
}

class _RateScreenState extends State<RateScreen> {
  int rate = 0;
  TextEditingController review = TextEditingController();
  bool isloading = false;
  String text = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Rate & Review',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: RatingBar.builder(
                // rating: 3.5,
                initialRating: rate.toDouble(),
                onRatingUpdate: (value) {
                  if (value.toInt() == 2) {
                    setState(() {
                      text = 'Bad';
                    });
                  } else if (value.toInt() == 3) {
                    setState(() {
                      text = 'Good';
                    });
                  }
                  if (value.toInt() == 4) {
                    setState(() {
                      text = 'Excellent';
                    });
                  }
                  if (value.toInt() == 5) {
                    setState(() {
                      text = 'Amazing!';
                    });
                  }
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
          rate != 1
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              : CustomTextFieldM(email: review, text: 'Write a review'),
          isloading
              ? CircularProgressIndicator()
              : CustomButton3(
                  text: AppLocalizations.of(context)!.save,
                  ontap: () async {
                    if (rate > 0) {
                      setState(() {
                        isloading = true;
                      });
                      for (var i = 0; i < widget.data['orders'].length; i++) {
                        if (rate == 1) {
                          await FirebaseFirestore.instance
                              .collection('products')
                              .doc(widget.data['orders'][i]['id'])
                              .update({
                            'star1': FieldValue.arrayUnion(
                                [FirebaseAuth.instance.currentUser!.uid]),
                          });
                        } else if (rate == 2) {
                          await FirebaseFirestore.instance
                              .collection('products')
                              .doc(widget.data['orders'][i]['id'])
                              .update({
                            'star2': FieldValue.arrayUnion(
                                [FirebaseAuth.instance.currentUser!.uid]),
                          });
                        } else if (rate == 3) {
                          await FirebaseFirestore.instance
                              .collection('products')
                              .doc(widget.data['orders'][i]['id'])
                              .update({
                            'star3': FieldValue.arrayUnion(
                                [FirebaseAuth.instance.currentUser!.uid]),
                          });
                        } else if (rate == 4) {
                          await FirebaseFirestore.instance
                              .collection('products')
                              .doc(widget.data['orders'][i]['id'])
                              .update({
                            'star4': FieldValue.arrayUnion(
                                [FirebaseAuth.instance.currentUser!.uid]),
                          });
                        } else {
                          await FirebaseFirestore.instance
                              .collection('products')
                              .doc(widget.data['orders'][i]['id'])
                              .update({
                            'star5': FieldValue.arrayUnion(
                                [FirebaseAuth.instance.currentUser!.uid]),
                          });
                        }
                        var userData = await FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .get();
                        await FirebaseFirestore.instance
                            .collection('products')
                            .doc(widget.data['orders'][i]['id'])
                            .collection('reviews')
                            .doc()
                            .set({
                          'rate': rate,
                          'time': DateTime.now(),
                          'name': userData.data()!['name'],
                          'url': userData.data()!['imageUrl'] == ""
                              ? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRhW0hzwECDKq0wfUqFADEJaNGESHQ8GRCJIg&usqp=CAU'
                              : userData.data()!['imageUrl'],
                          'message': rate != 1 ? text : review.text,
                        });
                        await FirebaseFirestore.instance
                            .collection('products')
                            .doc(widget.data['orders'][i]['id'])
                            .update({
                          'reviews': FieldValue.increment(1),
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
    );
  }
}

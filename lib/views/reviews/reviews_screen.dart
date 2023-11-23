// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:poultry_pal/consts/consts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReviewScreen extends StatefulWidget {
  String id;
  ReviewScreen({super.key, required this.id});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.review,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('products')
                    .doc(widget.id)
                    .collection('reviews')
                    .orderBy('time', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var snap = snapshot.data!.docs[index].data();
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(snap['url']),
                                radius: 25,
                              ),
                              Container(
                                width: MediaQuery.sizeOf(context).width - 100,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          snap['name'],
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        VxRating(
                                          isSelectable: false,
                                          value:
                                              int.parse(snap['rate'].toString())
                                                  .toDouble(),
                                          onRatingUpdate: (value) {},
                                          normalColor: textfieldGrey,
                                          selectionColor: golden,
                                          count: 5,
                                          maxRating: 5,
                                          size: 15,
                                        ),
                                      ],
                                    ),
                                    Container(
                                        width:
                                            MediaQuery.sizeOf(context).width -
                                                60,
                                        child: Text(snap['message'])),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      });
                })
          ],
        ),
      ),
    );
  }
}

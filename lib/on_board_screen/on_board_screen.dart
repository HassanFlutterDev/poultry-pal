import 'dart:async';

import 'package:poultry_pal/consts/consts.dart';
import 'package:poultry_pal/views/auth_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboard/flutter_onboard.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class onBoardScreen extends StatelessWidget {
  final PageController _pageController = PageController();

  onBoardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnBoard(
        pageController: _pageController,
        // Either Provide onSkip Callback or skipButton Widget to handle skip state
        onSkip: () {
          Get.to(() => const LoginScreen());
        },
        // Either Provide onDone Callback or nextButton Widget to handle done state
        onDone: () {
          Get.to(() => const LoginScreen());
        },
        onBoardData: onBoardData,
        titleStyles: const TextStyle(
          color: Colors.deepOrange,
          fontSize: 18,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.15,
        ),
        descriptionStyles: TextStyle(
          fontSize: 16,
          color: Colors.brown.shade300,
        ),
        pageIndicatorStyle: const PageIndicatorStyle(
          width: 100,
          inactiveColor: Colors.deepOrangeAccent,
          activeColor: Colors.deepOrange,
          inactiveSize: Size(8, 8),
          activeSize: Size(12, 12),
        ),
        // Either Provide onSkip Callback or skipButton Widget to handle skip state
        skipButton: TextButton(
          onPressed: () {
            Get.to(() => const LoginScreen());
          },
          child: const Text(
            "Skip",
            style: TextStyle(color: Colors.deepOrangeAccent),
          ),
        ),
        // Either Provide onDone Callback or nextButton Widget to handle done state
        // nextButton:  Consumer<OnBoardState>(
        //   builder: (context, ref, child) {
        //     final state = ref.watch(onBoardStateProvider);
        //     return InkWell(
        //       onTap: () => _onNextTap(state),
        //       child: Container(
        //         width: 230,
        //         height: 50,
        //         alignment: Alignment.center,
        //         decoration: BoxDecoration(
        //           borderRadius: BorderRadius.circular(30),
        //           gradient: const LinearGradient(
        //             colors: [Colors.redAccent, Colors.deepOrangeAccent],
        //           ),
        //         ),
        //         child: Text(
        //           state.isLastPage ? "Done" : "Next",
        //           style: const TextStyle(
        //             color: Colors.white,
        //             fontWeight: FontWeight.bold,
        //           ),
        //         ),
        //       ),
        //     );
        //   },
        // ),
        nextButton: Consumer<OnBoardState>(
          builder: (BuildContext context, OnBoardState state, Widget? child) {
            return InkWell(
              onTap: () => _onNextTap(state),
              child: Container(
                width: 230,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    colors: [Colors.redAccent, Colors.deepOrangeAccent],
                  ),
                ),
                child: Text(
                  state.isLastPage ? "Done" : "Next",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _onNextTap(OnBoardState onBoardState) {
    if (!onBoardState.isLastPage) {
      _pageController.animateToPage(
        onBoardState.page + 1,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOutSine,
      );
    } else {
      Get.to(() => const LoginScreen());
    }
  }
}

final List<OnBoardModel> onBoardData = [
  const OnBoardModel(
    title: "Healthy Choices",
    description:
        "Make healthy choices for your family by finding fresh and nutritious poultry products through Poultry_Pal",
    imgUrl: "assets/onboardimages/onboard1.png",
  ),
  const OnBoardModel(
    title: "Stay in the Know",
    description:
        "Track your orders in real-time, from farm to doorstep. Our order tracking feature keeps you updated at every step, so you can anticipate your delivery and shop with confidence.",
    imgUrl: 'assets/onboardimages/onboard2.png',
  ),
  const OnBoardModel(
    title: "24/7 Service",
    description:
        "We're here for you around the clock. Our 24/7 service ensures you can shop, get assistance, or have your questions answered at any time that suits you. Your convenience is our priority",
    imgUrl: 'assets/onboardimages/onboard3.png',
  ),
];

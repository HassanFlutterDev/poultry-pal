import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poultry_pal/consts/consts.dart';
import 'package:poultry_pal/controllers/home_controller.dart';
import 'package:get/get.dart';
import 'dart:math';

class CartController extends GetxController {
  var totalP = 0.obs;

  //text controller for shipping details
  var addressController = TextEditingController();
  var cityController = TextEditingController();
  var stateController = TextEditingController();
  var postalcodeController = TextEditingController();
  var phoneController = TextEditingController();
  var paymentIndex = 0.obs;
  late dynamic productSnapshot;
  var products = [];
  var vendors = [];
  var placingOrder = false.obs;

  calculate(data) {
    totalP.value = 0;
    for (var i = 0; i < data.length; i++) {
      totalP.value = totalP.value + int.parse(data[i]['tprice'].toString());
    }
  }

  //change payment index
  changePaymentIndex(index) {
    paymentIndex.value = index;
  }

  placeMyOrder({required orderPaymentMethod, required totalAmount}) async {
    placingOrder(true);
    await getProductDetails();
    await firestore.collection(ordersCollection).doc().set({
      'order_code': generateOrderCode(),
      'order_date': FieldValue.serverTimestamp(),
      'order_by': currentUser!.uid,
      'order_by_name': Get.find<HomeController>().username,
      'order_by_email': currentUser!.email,
      'order_by_address': addressController.text,
      'order_by_state': stateController.text,
      'order_by_city': cityController.text,
      'order_by_phone': phoneController.text,
      'order_by_postalcode': postalcodeController.text,
      'shipping_method': "Home Delivery",
      'payment_method': orderPaymentMethod,
      'paid': orderPaymentMethod == 'Stripe' ? 'Paid' : 'Unpaid',
      'order_placed': true,
      'order_confirm': false,
      'order_delivered': false,
      'order_on_delivery': false,
      'total_amount': totalAmount,
      'orders': FieldValue.arrayUnion(products),
      'vendors': FieldValue.arrayUnion(vendors),
    });
    placingOrder(false);
  }

  getProductDetails() {
    products.clear();
    vendors.clear();
    for (var i = 0; i < productSnapshot.length; i++) {
      products.add({
        'img': productSnapshot[i]['img'],
        'vendor_id': productSnapshot[i]['vendor_id'],
        'tprice': productSnapshot[i]['tprice'],
        'qty': productSnapshot[i]['qty'],
        'title': productSnapshot[i]['title'],
        'id': productSnapshot[i]['id'],
      });
      vendors.add(productSnapshot[i]['vendor_id']);
    }
  }

  clearCart() {
    for (var i = 0; i < productSnapshot.length; i++) {
      firestore.collection(cartCollection).doc(productSnapshot[i].id).delete();
    }
  }

  String generateOrderCode() {
    // You can use a timestamp as part of the order code for uniqueness
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

    // Generate a random 4-digit number as part of the order code
    String randomDigits = Random().nextInt(10000).toString().padLeft(4, '0');

    // Define a prefix for your order code, such as 'ORDER-'
    String prefix = 'Order-';

    // Combine the prefix, timestamp, and random digits to create the order code
    String orderCode = '$prefix$timestamp$randomDigits';

    return orderCode;
  }
}

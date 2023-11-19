import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poultry_pal/consts/consts.dart';
import 'package:poultry_pal/consts/list.dart';
import 'package:poultry_pal/controllers/auth_controller.dart';
import 'package:poultry_pal/controllers/profile_controller.dart';
import 'package:poultry_pal/services/fire_store_services.dart';
import 'package:poultry_pal/views/auth_screen/login_screen.dart';
import 'package:poultry_pal/views/chat_screen/messaging_screen.dart';
import 'package:poultry_pal/views/orders_screen/orders_screen.dart';
import 'package:poultry_pal/views/profile_screen/components/details_card.dart';
import 'package:poultry_pal/views/profile_screen/edit_profile_screen.dart';
import 'package:poultry_pal/views/wishlist_screen/wishlist_screen.dart';
import 'package:poultry_pal/widget_common/bg_widget.dart';
import 'package:poultry_pal/widget_common/loading_indicator.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());
    return bgWidget(
      child: Scaffold(
          body: StreamBuilder(
        stream: FirestoreServices.getUser(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(redColor),
              ),
            );
          } else {
            var data = snapshot.data!.docs[0];
            return SafeArea(
              child: Column(
                children: [
                  //edit profile button
                  const Align(
                          alignment: Alignment.topRight,
                          child: Icon(Icons.edit, color: whiteColor))
                      .onTap(() {
                    controller.nameController.text = data['name'];
                    Get.to(() => EditProfileScreen(
                          data: data,
                        ));
                  }),
                  //user detail section
                  Row(
                    children: [
                      data['imageUrl'] == ''
                          ? Image.asset(imgProfile2,
                                  width: 100, fit: BoxFit.cover)
                              .box
                              .roundedFull
                              .clip(Clip.antiAlias)
                              .make()
                          : Image.network(data['imageUrl'],
                                  width: 100, fit: BoxFit.cover)
                              .box
                              .roundedFull
                              .clip(Clip.antiAlias)
                              .make(),
                      10.widthBox,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "${data['name']}"
                                .text
                                .fontFamily(semibold)
                                .white
                                .make(),
                            "${data['email']}".text.white.make()
                          ],
                        ),
                      ),
                      OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: whiteColor,
                            ),
                          ),
                          onPressed: () async {
                            await Get.put(AuthController())
                                .signoutMethod(context);
                            Get.offAll(() => const LoginScreen());
                          },
                          child: logout.text.fontFamily(semibold).white.make())
                    ],
                  ),
                  20.heightBox,
                  FutureBuilder(
                    future: FirestoreServices.getCount(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: loadingIndicator());
                      } else {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            detailsCard(
                                count: data['cart_count'],
                                title: "in your cart",
                                width: context.screenWidth / 3.3),
                            detailsCard(
                                count: data['whishlist_count'],
                                title: "in your whishlist",
                                width: context.screenWidth / 3.3),
                            detailsCard(
                                count: data['oder_count'],
                                title: "your orders",
                                width: context.screenWidth / 3.3),
                          ],
                        );
                      }
                    },
                  ),
                  //Buttons Section
                  ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (context, index) {
                      return const Divider(
                        color: lightGrey,
                      );
                    },
                    itemCount: profileButtonsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        onTap: () {
                          switch (index) {
                            case 0:
                              Get.to(() => const OrderScreen());
                              break;
                            case 1:
                              Get.to(() => const WishlistScreen());
                              break;
                            case 2:
                              Get.to(() => const MessagesScreen());
                              break;
                            default:
                          }
                        },
                        leading: Image.asset(
                          profileButtonIcon[index],
                          width: 22,
                          color: darkFontGrey,
                        ),
                        title: profileButtonsList[index]
                            .text
                            .fontFamily(semibold)
                            .color(darkFontGrey)
                            .make(),
                      );
                    },
                  )
                      .box
                      .white
                      .rounded
                      .margin(const EdgeInsets.all(12))
                      .padding(const EdgeInsets.symmetric(horizontal: 16))
                      .shadowSm
                      .make()
                ],
              ),
            );
          }
        },
      )),
    );
  }
}

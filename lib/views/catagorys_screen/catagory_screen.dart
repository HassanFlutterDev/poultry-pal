import 'package:poultry_pal/consts/consts.dart';
import 'package:poultry_pal/consts/list.dart';
import 'package:poultry_pal/controllers/product_controller.dart';
import 'package:poultry_pal/views/catagorys_screen/catagory_detail.dart';
import 'package:poultry_pal/widget_common/bg_widget.dart';
import 'package:get/get.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductController());
    return bgWidget(
      child: Scaffold(
        appBar: AppBar(
          title: categories.text.fontFamily(bold).white.make(),
        ),
        body: Container(
          padding: const EdgeInsets.all(12),
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisExtent: 220,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.8, // Adjust the aspect ratio as needed
            ),
            itemCount:
                categoriesList.length, // Use the length of your categoriesList
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  controller.getSubCategories(categoriesList[index]);
                  Get.to(() => CategoryDetails(title: categoriesList[index]));
                },
                child: Column(
                  children: [
                    Image.asset(
                      categoriesImages[index],
                      height: 120,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                    10.heightBox,
                    categoriesList[index]
                        .text
                        .color(darkFontGrey)
                        .align(TextAlign.center)
                        .make(),
                  ],
                ).box.white.rounded.clip(Clip.antiAlias).make(),
              );
            },
          ),
        ),
      ),
    );
  }
}

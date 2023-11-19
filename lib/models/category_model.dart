import 'dart:convert';

CategoryModel categoryModelFromJson(String str) =>
    CategoryModel.fromJson(json.decode(str));

class CategoryModel {
  List<Category> categories;

  CategoryModel({
    required this.categories,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        categories: List<Category>.from(
            json["catagories"].map((x) => Category.fromJson(x))),
      );
}

class Category {
  String name;
  List<String> subcategories;

  Category({
    required this.name,
    required this.subcategories,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        name: json["name"],
        subcategories: List<String>.from(json["subcatagories"].map((x) => x)),
      );
}

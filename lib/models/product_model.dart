// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductModel with ChangeNotifier {
  final String id;
  final String name;
  final String category;
  final String description;
  final String imageUrl;
  final double price;
  final bool isPopular;
  final bool isRecommended;

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    // data.containsKey("")
    return ProductModel(
      id: data["id"],
      name: data["name"],
      category: data["category"],
      description: data["description"],
      imageUrl: data["imageUrl"],
      price: data["price"],
      isPopular: data["isPopular"],
      isRecommended: data["isRecommended"],
    );
  }

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.isPopular,
    required this.isRecommended,
  });
  late List<ProductModel> products;

  final productDb = FirebaseFirestore.instance.collection("products");
  Future<List<ProductModel>> fetchProducts() async {
    try {
      await productDb
          .orderBy('createdAt', descending: false)
          .get()
          .then((productSnapshot) {
        products.clear();
        // products = []
        for (var element in productSnapshot.docs) {
          products.insert(0, ProductModel.fromFirestore(element));
        }
      });
      notifyListeners();
      return products;
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<ProductModel>> fetchProductsStream() {
    try {
      return productDb.snapshots().map((snapshot) {
        products.clear();
        // products = []
        for (var element in snapshot.docs) {
          products.insert(0, ProductModel.fromFirestore(element));
        }
        return products;
      });
    } catch (e) {
      rethrow;
    }
  }
}

class Product {
  final String title;
  final String imagePath;

  Product({
    required this.title,
    required this.imagePath,
  });
}

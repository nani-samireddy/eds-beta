import 'dart:developer';
import 'package:eds_beta/models/app_models.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eds_beta/api/database_api.dart';
import 'package:eds_beta/data/testdata.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeScreenDataProvider = Provider<List<SectionItemsListModel>>((ref) =>
    homeScreenData.map((e) => SectionItemsListModel.fromMap(e)).toList());

final databaseAPIProvider = Provider<DatabaseAPI>((ref) {
  final db = FirebaseFirestore.instance;
  return DatabaseAPI(firestore: db);
});

final offersProvider = FutureProvider<List<Offer>?>((ref) async {
  log("Getting offers");
  final db = ref.watch(databaseAPIProvider);
  return await db.getOffers();
});

final categoriesProvider = FutureProvider<List<CategoryModel>?>((ref) async {
  log("Getting categories");
  final db = ref.watch(databaseAPIProvider);
  return await db.getCategories();
});

final latestProductsProvider = FutureProvider<List<ProductModel>?>((ref) async {
  log("Getting latest products");
  final db = ref.watch(databaseAPIProvider);

  return await db.getLatestProducts();
});

final similarProductsProvider =
    FutureProvider.family<List<ProductModel>, ProductModel>((ref, product) async {
  log("Getting similar products");
  final db = ref.watch(databaseAPIProvider);
  return await db.getSimilarProducts(tags: product.tags,productId: product.productId);
});

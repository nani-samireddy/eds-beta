import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eds_beta/constants/constans.dart';
import 'package:eds_beta/data/testdata.dart';
import 'package:eds_beta/models/category_model.dart';
import 'package:eds_beta/models/product_model.dart';
import 'package:eds_beta/models/section_list_model.dart';
import 'package:eds_beta/models/offer_model.dart';
import 'package:eds_beta/models/size_model.dart';
import 'package:eds_beta/models/user_model.dart';
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

abstract class IDatabaseAPI {
  Future<UserModel?> getUserDataFromDB({required String uid});
  Future<void> createUserDoc({required UserModel userModel});
  Future<List<Offer>?> getOffers();
  Future<void> addHomeSections({required Map<String, dynamic> sections});
  Future<List<CategoryModel>?> getCategories();
  Future<List<ProductModel>?> getLatestProducts();
  Future<void> addProduct();
}

class DatabaseAPI extends IDatabaseAPI {
  final FirebaseFirestore _firestore;
  DatabaseAPI({required FirebaseFirestore firestore}) : _firestore = firestore;

  @override
  Future<UserModel?> getUserDataFromDB({required String uid}) async {
    try {
      await _firestore
          .collection(FirestoreCollectionNames.usersCollection)
          .doc(uid)
          .get()
          .then((value) {
        if (value.exists) {
          return UserModel.fromMap(value.data()!);
        } else {
          log("User does not exist");
          //TODO:Create new user
          return null;
        }
      });
    } catch (e) {
      return null;
    }
    return null;
  }

  @override
  Future<void> createUserDoc({required UserModel userModel}) async {
    await _firestore
        .collection(FirestoreCollectionNames.usersCollection)
        .doc(userModel.uid)
        .set(userModel.toMap());
  }

  @override
  Future<List<Offer>?> getOffers() async {
    try {
      var results = await _firestore
          .collection(FirestoreCollectionNames.offersCollection)
          .get();

      if (results.docs.isNotEmpty) {
        List<Offer> offers = [];
        for (var element in results.docs) {
          offers.add(Offer.fromMap(element.data()));
        }

        return offers;
      } else {
        log("Offers does not exist");
        return null;
      }
    } catch (e) {
      log("Error while fetching offers from db $e");
      return null;
    }
  }

  @override
  Future<void> addHomeSections({required Map<String, dynamic> sections}) {
    try {
      _firestore.collection('screens').doc("homeScreen").set(sections);
    } catch (e) {
      log("Error while adding home sections $e");
    }
    return Future.value();
  }

  @override
  Future<List<CategoryModel>?> getCategories() async {
    try {
      final docRef = _firestore
          .collection(FirestoreCollectionNames.appData)
          .doc(FirestoreDocumentNames.categoriesDocument);
      return await docRef.get().then((value) {
        if (value.exists) {
          List<CategoryModel> categories = [];
          final data = value.data()!["categories"];
          for (var element in data) {
            categories.add(CategoryModel.fromMap(element));
          }
          return categories;
        } else {
          log("Categories does not exist");
          return null;
        }
      });
    } catch (e, s) {
      log("Error while fetching categories from db $e");
      log(s.toString());
      return null;
    }
  }

  @override
  Future<List<ProductModel>?> getLatestProducts() async {
    try {
      final productsRef = _firestore
          .collection(FirestoreCollectionNames.productsCollection)
          .orderBy("createdAt", descending: true)
          .limit(10);

      return await productsRef.get().then((value) {
        if (value.docs.isNotEmpty) {
          List<ProductModel> products = [];
          for (var element in value.docs) {
            String productId = element.id;
            products.add(ProductModel.fromMap(
                map: element.data(), productId: productId));
          }
          return products;
        } else {
          log("Products does not exist");
          return [];
        }
      });
    } catch (e, s) {
      log("Error while fetching products from db $e");
      log(s.toString());

      return null;
    }
  }

  @override
  Future<void> addProduct() {
    final ProductModel productModel = ProductModel(
      productId: "l5d0yTPSAiCC1CuUFF4q",
      name: "Cotton TSHIRT",
      description:
          "The Dal Silk Gown with Coddling Embroidery and Real Mirror is a stunning and elegant gown made from high-quality Dal Silk.",
      actualPrice: "1999",
      currentPrice: "1400",
      availableStock: 40,
      color: null,
      brand: null,
      sizes: [
        SizeModel(price: "700", size: "XS", stock: 0, actualPrice: "1000"),
        SizeModel(price: "1300", size: "S", stock: 10, actualPrice: "2000"),
        SizeModel(price: "1400", size: "M", stock: 10, actualPrice: "2000"),
        SizeModel(price: "1500", size: "L", stock: 10, actualPrice: "2000"),
        SizeModel(price: "1600", size: "XL", stock: 10, actualPrice: "2000"),
        SizeModel(price: "1700", size: "XXL", stock: 0, actualPrice: "2000"),
      ],
      availableColors: [],
      images: [
        "https://firebasestorage.googleapis.com/v0/b/endless-store-beta.appspot.com/o/images%2Fproducts_images%2Fpurecotton-t-shirt.jpeg?alt=media&token=7d3a5bc6-1f8f-411d-932f-f8f2781ca8e2",
        "https://firebasestorage.googleapis.com/v0/b/endless-store-beta.appspot.com/o/images%2Fproducts_images%2Fgown2.jpeg?alt=media&token=662925c2-45e6-4b08-b278-c8ad925c36e7",
        "https://firebasestorage.googleapis.com/v0/b/endless-store-beta.appspot.com/o/images%2Fproducts_images%2Fgown3.jpeg?alt=media&token=746d1ab9-2a60-4250-b186-3c6f313b072e",
        "https://firebasestorage.googleapis.com/v0/b/endless-store-beta.appspot.com/o/images%2Fproducts_images%2Fgown4.jpeg?alt=media&token=137021f8-873b-4f71-aae8-133c424330b0",
        "https://firebasestorage.googleapis.com/v0/b/endless-store-beta.appspot.com/o/images%2Fproducts_images%2Fgown5.jpeg?alt=media&token=ba2b5325-effb-40a1-82e4-16bb49c90ba6",
        "https://firebasestorage.googleapis.com/v0/b/endless-store-beta.appspot.com/o/images%2Fproducts_images%2Fgown6.jpeg?alt=media&token=b7b3ff1d-e61b-4322-906a-ddfe8decbd40"
      ],
      tags: [
        "women",
        "fashion",
        "gown",
        "white gown",
        "work gown",
        "women gown",
        "girl",
        "girl gown"
      ],
      category: "Women's Fashion",
      manufacturer: "",
      netQuantity: 1,
      details:
          "FABRIC:DalSilk;WORK:Coddling Embroidery Siqunce And Real Mirror;CUPS:Available;LENGTH:58;FLAIR:12Mtr;NECK:Round;BACKNECK:Deeply With DoriLatakn;SLEEVES:24Inch;WEIGHT:1Kg;NetQuant: 1piece;",
      createdAt: Timestamp.now(),
    );

    try {
      _firestore
          .collection(FirestoreCollectionNames.productsCollection)
          .doc()
          .set(productModel.toMap());
    } catch (e) {
      log("Error while adding product $e");
    }
    return Future.value();
  }
}

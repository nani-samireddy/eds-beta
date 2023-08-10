import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eds_beta/constants/constans.dart';

import '../models/app_models.dart';

abstract class IDatabaseAPI {
  Future<UserModel?> getUserDataFromDB({required String uid});
  Future<void> createUserDoc({required UserModel userModel});
  Future<List<Offer>?> getOffers();
  Future<void> addHomeSections({required Map<String, dynamic> sections});
  Future<List<CategoryModel>?> getCategories();
  Future<List<ProductModel>?> getLatestProducts();
  Future<void> addProduct();
  Future<List<ProductModel>> getSimilarProducts(
      {required List<String> tags, required String productId});
  Future<List<ProductModel>> getUserCartItems({required UserModel user});
  Future<void> removeCartItem(
      {required String productId, required UserModel user});
  Future<void> addCartItem(
      {required CartItemModel cartItem, required UserModel user});
  Future<void> updateCartItem(
      {required CartItemModel cartItem, required UserModel user});

  Future<List<ProductModel>> getProductsWithIds({required List<String> ids});
  Future<void> addUserToDB({required UserModel user});
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
          final user = UserModel.fromMap(value.data()!);
          log("UserModel: $user");
          return user;
        } else {
          log("User does not exist");

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

      return await productsRef.get().then(
        (value) {
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
        },
      );
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
      name: "White shirt",
      tagline: 'printed Pure Cotton white SHIRT',
      description: "Pure cotton white shirt ",
      actualPrice: "1999",
      currentPrice: "1400",
      availableStock: 40,
      rating: '4.5',
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
        //"https://firebasestorage.googleapis.com/v0/b/endless-store-beta.appspot.com/o/images%2Fproducts_images%2Fnewthshirt.jpeg?alt=media&token=6a793c3c-e0fe-4e62-a45f-f0a3345a3b22",
        "https://firebasestorage.googleapis.com/v0/b/endless-store-beta.appspot.com/o/images%2Fproducts_images%2Fpurecotton-t-shirt.jpeg?alt=media&token=7d3a5bc6-1f8f-411d-932f-f8f2781ca8e2",
        "https://firebasestorage.googleapis.com/v0/b/endless-store-beta.appspot.com/o/images%2Fproducts_images%2Fgown2.jpeg?alt=media&token=662925c2-45e6-4b08-b278-c8ad925c36e7",
        "https://firebasestorage.googleapis.com/v0/b/endless-store-beta.appspot.com/o/images%2Fproducts_images%2Fgown3.jpeg?alt=media&token=746d1ab9-2a60-4250-b186-3c6f313b072e",
        //"https://firebasestorage.googleapis.com/v0/b/endless-store-beta.appspot.com/o/images%2Fproducts_images%2Fgown4.jpeg?alt=media&token=137021f8-873b-4f71-aae8-133c424330b0",
        //"https://firebasestorage.googleapis.com/v0/b/endless-store-beta.appspot.com/o/images%2Fproducts_images%2Fgown5.jpeg?alt=media&token=ba2b5325-effb-40a1-82e4-16bb49c90ba6",
        "https://firebasestorage.googleapis.com/v0/b/endless-store-beta.appspot.com/o/images%2Fproducts_images%2Fgown6.jpeg?alt=media&token=b7b3ff1d-e61b-4322-906a-ddfe8decbd40"
      ],
      tags: [
        "men",
        "men fashion",
        "tsirt",
        "cotton",
        "pure cotton",
        "white",
        "white tshirt",
        "printed",
        "printed tshirt",
        "printed white tshirt",
        "printed pure cotton tshirt",
        "printed pure cotton white tshirt",
      ],
      category: "Men's Fashion",
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

  Future<void> addUser() async {
    //TODO: REMOVE THIS MEHTOD IN THE PRODUCTION
    final UserModel userModel = UserModel(
        uid: "l5d0yTPSAiCC1CuUFF4q",
        name: "Rahul",
        email: "example@example.com",
        cartItems: [],
        phone: '+9191234567890',
        wishListItems: []);
    try {
      _firestore
          .collection(FirestoreCollectionNames.usersCollection)
          .doc()
          .set(userModel.toMap());
    } catch (e) {
      log("Error while adding product $e");
    }
  }

  @override
  Future<List<ProductModel>> getSimilarProducts(
      {required List<String> tags, required String productId}) async {
    try {
      final docRef = _firestore
          .collection(FirestoreCollectionNames.productsCollection)
          .where("tags", arrayContainsAny: tags.getRange(0, 10))
          .where(FieldPath.documentId, isNotEqualTo: productId)
          .limit(8);
      return await docRef.get().then((value) {
        if (value.docs.isNotEmpty) {
          List<ProductModel> products = [];
          log(value.docs.length.toString());
          for (var element in value.docs) {
            String productId = element.id;
            products.add(ProductModel.fromMap(
                map: element.data(), productId: productId));
          }
          return products;
        } else {
          log("Products related does not exist");
          return [];
        }
      });
    } catch (e) {
      log("Error while fetching similar products $e");
      return [];
    }
  }

  @override
  Future<List<ProductModel>> getUserCartItems({required UserModel user}) async {
    try {
      if (user.cartItems.isEmpty) {
        log("User cart is empty");
        return [];
      }
      final docRef = _firestore
          .collection(FirestoreCollectionNames.productsCollection)
          .where(FieldPath.documentId, whereIn: user.cartItems.toList());
      return await docRef.get().then((value) {
        if (value.docs.isNotEmpty) {
          List<ProductModel> products = [];
          log(value.docs.length.toString());
          for (var element in value.docs) {
            String productId = element.id;
            products.add(ProductModel.fromMap(
                map: element.data(), productId: productId));
          }
          return products;
        } else {
          log("User cart is empty from firebase");
          return [];
        }
      });
    } catch (e) {
      log("Error while fetching user cart $e");
      return [];
    }
  }

  @override
  Future<void> removeCartItem(
      {required String productId, required UserModel user}) async {
    try {
      user.cartItems.removeWhere((element) => element.productId == productId);
      _firestore
          .collection(FirestoreCollectionNames.usersCollection)
          .doc(user.uid)
          .update({"cartItems": user.cartItems.map((e) => e.toMap()).toList()});
    } catch (e) {
      log("Error while removing cart item $e");
    }
  }

  @override
  Future<void> addCartItem(
      {required CartItemModel cartItem, required UserModel user}) async {
    try {
      user.cartItems.add(cartItem);
      log(user.cartItems.length.toString());
      await _firestore
          .collection(FirestoreCollectionNames.usersCollection)
          .doc(user.uid)
          .update({"cartItems": user.cartItems.map((e) => e.toMap()).toList()});
    } catch (e) {
      log("Error while adding cart item $e");
    }
  }

  @override
  Future<void> updateCartItem(
      {required CartItemModel cartItem, required UserModel user}) async {
    try {
      user.cartItems.forEach((element) {
        if (element.productId == cartItem.productId) {
          element.setQuantity = cartItem.quantity;
        }
      });
    } catch (e) {
      log("Error while updating cart item $e");
    }
  }

  @override
  Future<List<ProductModel>> getProductsWithIds(
      {required List<String> ids}) async {
    try {
      return await _firestore
          .collection(FirestoreCollectionNames.productsCollection)
          .where(FieldPath.documentId, whereIn: ids)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          List<ProductModel> products = [];
          log(value.docs.length.toString());
          for (var element in value.docs) {
            String productId = element.id;
            products.add(ProductModel.fromMap(
                map: element.data(), productId: productId));
          }
          return products;
        } else {
          log("Products with ids does not exist");
          return [];
        }
      });
    } catch (e) {
      log("Error while fetching products with ids $e");
      return [];
    }
  }

  @override
  Future<void> addUserToDB({required UserModel user}) async {
    try {
      await _firestore
          .collection(FirestoreCollectionNames.usersCollection)
          .doc(user.uid)
          .set(user.toMap());
      log("Added user to db");
    } catch (e) {
      log("Error while adding user to db $e");
    }
  }
}

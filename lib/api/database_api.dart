import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eds_beta/constants/constans.dart';
import 'package:eds_beta/controllers/products_controller.dart';
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

  Future<void> updateCartItem(
      {required CartItemDatabaseModel cartItem, required UserModel user});

  Future<List<ProductModel>> getProductsWithIds({required List<String> ids});
  Future<void> addUserToDB({required UserModel user});

  Future<void> updateUserCartItems(
      {required UserModel user,
      required List<CartItemDatabaseModel> cartItems});

  Future<List<WishlistItemModel>> getWishlistItems({required UserModel user});

  /// Updates the user's wishlist items in the database
  /// that includes ADD, REMOVE and UPDATE operations
  Future<void> updateUserWishListItems(
      {required List<WishlistItemModel> wishlistItems,
      required UserModel user});

  Future<List<ProductModel>> getProductsByCategory({required String category});
  Future<List<ProductModel>> getProductsByTag(
      {required String tag, required ProductsController controller});

  Future<List<ProductModel>> getProductsByQuery(
      {required Query<Map<String, dynamic>> query});

  Future<List<ProductModel>> loadMore(
      {required String querTag,
      required ProductsController controller,
      int limit = 20});

  // Query<Map<String, dynamic>> buildFirebaseSearchQuery(
  //     {required SearchResultModel searchResultModel});

  Future<List<String>> getTags();

  Future<void> updateUserAddresses(
      {required List<AddressModel> addresses, required String uid});

  Future<bool?> isNewUser({required String uid});

  Future<UserModel?> updateUserDetails(
      {required String uid, required Map<String, dynamic> data});

  Future<List<Offer>?> getFreshKartOffersSlides();
  Future<List<CategoryModel>?> getFreshKartCategories();
}

class DatabaseAPI extends IDatabaseAPI {
  late final FirebaseFirestore _firestore;
  DatabaseAPI({required FirebaseFirestore firestore}) {
    _firestore = firestore;
    _firestore.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
  }

  @override
  Future<UserModel?> getUserDataFromDB({required String uid}) async {
    try {
      return await _firestore
          .collection(FirestoreCollectionNames.usersCollection)
          .doc(uid)
          .get()
          .then((value) {
        if (value.exists) {
          return UserModel.fromMap(value.data()!);
        } else {
          log("User does not exist");

          return null;
        }
      });
    } catch (e) {
      log("Error while fetching user data from db ${e.toString()}");

      return null;
    }
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
          .where('active', isEqualTo: true)
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
          .limit(20);

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
      name: "shorts",
      tagline: 'samiple 121',
      description: "Pure cotton white shirt ",
      actualPrice: "1999",
      currentPrice: "1400",
      availableStock: 40,
      gender: "male",
      rating: '4.5',
      color: null,
      brand: null,
      sizes: [
        SizeModel(price: "1600", size: "XL", stock: 10, actualPrice: "2000"),
        SizeModel(price: "1700", size: "XXL", stock: 0, actualPrice: "2000"),
      ],
      availableColors: [],
      images: [
        "https://images.unsplash.com/photo-1591195853828-11db59a44f6b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1770&q=80",
        //"https://firebasestorage.googleapis.com/v0/b/endless-store-beta.appspot.com/o/images%2Fproducts_images%2Fnewthshirt.jpeg?alt=media&token=6a793c3c-e0fe-4e62-a45f-f0a3345a3b22",
        // "https://firebasestorage.googleapis.com/v0/b/endless-store-beta.appspot.com/o/images%2Fproducts_images%2Fpurecotton-t-shirt.jpeg?alt=media&token=7d3a5bc6-1f8f-411d-932f-f8f2781ca8e2",
        //  "https://firebasestorage.googleapis.com/v0/b/endless-store-beta.appspot.com/o/images%2Fproducts_images%2Fgown2.jpeg?alt=media&token=662925c2-45e6-4b08-b278-c8ad925c36e7",
        //   "https://firebasestorage.googleapis.com/v0/b/endless-store-beta.appspot.com/o/images%2Fproducts_images%2Fgown3.jpeg?alt=media&token=746d1ab9-2a60-4250-b186-3c6f313b072e",
        //"https://firebasestorage.googleapis.com/v0/b/endless-store-beta.appspot.com/o/images%2Fproducts_images%2Fgown4.jpeg?alt=media&token=137021f8-873b-4f71-aae8-133c424330b0",
        //"https://firebasestorage.googleapis.com/v0/b/endless-store-beta.appspot.com/o/images%2Fproducts_images%2Fgown5.jpeg?alt=media&token=ba2b5325-effb-40a1-82e4-16bb49c90ba6",
        "https://firebasestorage.googleapis.com/v0/b/endless-store-beta.appspot.com/o/images%2Fproducts_images%2Fgown6.jpeg?alt=media&token=b7b3ff1d-e61b-4322-906a-ddfe8decbd40"
      ],
      tags: ["men", "men fashion", "shorts", "men's shorts"],
      category: "Men's Fashion",
      type: "casual",
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
        addresses: [],
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
          log("user cart items count: ${value.docs.length}");
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
  Future<void> updateCartItem(
      {required CartItemDatabaseModel cartItem,
      required UserModel user}) async {
    try {
      for (var element in user.cartItems) {
        if (element.productId == cartItem.productId) {
          element.setQuantity = cartItem.quantity;
        }
      }
    } catch (e) {
      log("Error while updating cart item $e");
    }
  }

  @override
  Future<List<ProductModel>> getProductsWithIds(
      {required List<String> ids}) async {
    try {
      if (ids.isEmpty) {
        log("Ids is empty");
        return [];
      }
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

  @override
  Future<void> updateUserCartItems(
      {required UserModel user,
      required List<CartItemDatabaseModel> cartItems}) async {
    try {
      await _firestore
          .collection(FirestoreCollectionNames.usersCollection)
          .doc(user.uid)
          .update({
        "cartItems":
            cartItems.isEmpty ? [] : cartItems.map((e) => e.toMap()).toList()
      });
      log("Updated user cart items");
    } catch (e) {
      log("Error while updating user cart items $e");
    }
  }

  @override
  Future<List<WishlistItemModel>> getWishlistItems(
      {required UserModel user}) async {
    try {
      return [];
    } catch (e) {
      log("Error while fetching wishlist items $e");
      return [];
    }
  }

  @override
  Future<void> updateUserWishListItems(
      {required List<WishlistItemModel> wishlistItems,
      required UserModel user}) async {
    try {
      await _firestore
          .collection(FirestoreCollectionNames.usersCollection)
          .doc(user.uid)
          .update({
        "wishListItems": wishlistItems.isEmpty
            ? []
            : wishlistItems.map((e) => e.toMap()).toList()
      });
      log("Updated wishlist items");
    } catch (e) {
      log("error while updating wishlist items $e");
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(
      {required String category}) async {
    try {
      final docRef = _firestore
          .collection(FirestoreCollectionNames.productsCollection)
          .where("category", isEqualTo: category)
          .limit(1);
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
      log("Error while getting products by category $e");
      return [];
    }
  }

  @override
  Future<List<ProductModel>> getProductsByQuery(
      {required Query<Map<String, dynamic>> query}) async {
    try {
      return await query.get().then((value) {
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
      log("Error while getting products by query $e");
      return [];
    }
  }

  @override
  Future<List<ProductModel>> loadMore(
      {required String querTag,
      required ProductsController controller,
      int limit = 20}) async {
    log("load more with $querTag ${controller.lastDocument.id.toString()}}");
    final query = _firestore
        .collection(FirestoreCollectionNames.productsCollection)
        .orderBy("createdAt", descending: true)
        .where("tags", arrayContains: querTag)
        .startAfterDocument(controller.lastDocument)
        .limit(limit);
    try {
      return await query.get().then((value) {
        log(value.docs.length.toString());

        if (value.docs.isNotEmpty) {
          controller.lastDocument = value.docs.last;
          List<ProductModel> products = [];
          log(value.docs.toString());
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
      log("Error while loading more products $e");
      return [];
    }
  }

  // @override
  // Query<Map<String, dynamic>> buildFirebaseSearchQuery(
  //     {required SearchResultModel searchResultModel}) {
  //   Query<Map<String, dynamic>> query =
  //       _firestore.collection(FirestoreCollectionNames.productsCollection);

  //   if (searchResultModel.query.isNotEmpty) {
  //     var queryList = searchResultModel.query.split('&');
  //     for (String q in queryList) {
  //       switch (q.split(':').first) {
  //         case 'category':
  //           if (q.split(':').last.contains('|')) {
  //             query = query.where('category',
  //                 whereIn: q.split(':').last.split('|'));
  //           } else {
  //             query = query.where('category', isEqualTo: q.split(':').last);
  //           }
  //           break;
  //         case 'brand':
  //           if (q.split(':').last.contains('|')) {
  //             query =
  //                 query.where('brand', whereIn: q.split(':').last.split('|'));
  //           } else {
  //             query = query.where('brand', isEqualTo: q.split(':').last);
  //           }
  //           break;
  //         case 'color':
  //           if (q.split(':').last.contains('|')) {
  //             query =
  //                 query.where('color', whereIn: q.split(':').last.split('|'));
  //           } else {
  //             query = query.where('color', isEqualTo: q.split(':').last);
  //           }
  //           break;
  //         case 'tag':
  //           if (q.split(':').last.contains('|')) {
  //             query = query.where('tags',
  //                 arrayContainsAny: q.split(':').last.split('|'));
  //           } else {
  //             query = query.where('tags', arrayContains: q.split(':').last);
  //           }
  //           break;

  //         default:
  //       }
  //     }
  //   }

  //   return query;
  // }

  @override
  Future<List<String>> getTags() async {
    try {
      final docRef = _firestore
          .collection(FirestoreCollectionNames.appData)
          .doc(FirestoreDocumentNames.tagsDocument);
      return await docRef.get().then((value) {
        if (value.exists) {
          List<String> tags = [];
          final data = value.data()!["tags"];
          for (var element in data) {
            tags.add(element);
          }
          return tags;
        } else {
          log("Tags does not exist");
          return [];
        }
      });
    } catch (e) {
      log("Error while getting tags $e ");
      return [];
    }
  }

  @override
  Future<List<ProductModel>> getProductsByTag(
      {required String tag, required ProductsController controller}) async {
    try {
      log("getting products by tag $tag");
      final docRef = _firestore
          .collection(FirestoreCollectionNames.productsCollection)
          .orderBy("createdAt", descending: true)
          .where("tags", arrayContains: tag)
          .limit(2);
      return await docRef.get().then((value) {
        if (value.docs.isNotEmpty) {
          List<ProductModel> products = [];
          controller.lastDocument = value.docs[value.docs.length - 1];
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
      log("Error while getting products by tag $e");
      return [];
    }
  }

  @override
  Future<void> updateUserAddresses(
      {required List<AddressModel> addresses, required String uid}) async {
    try {
      await _firestore
          .collection(FirestoreCollectionNames.usersCollection)
          .doc(uid)
          .update({
        "addresses":
            addresses.isEmpty ? [] : addresses.map((e) => e.toMap()).toList()
      });
      log("Added address");
    } catch (e) {
      log("Error while adding address $e");
    }
  }

  @override
  Future<bool?> isNewUser({required String uid}) async {
    try {
      return await _firestore
          .collection(FirestoreCollectionNames.usersCollection)
          .doc(uid)
          .get()
          .then((value) {
        if (value.exists) {
          return false;
        } else {
          return true;
        }
      });
    } catch (e) {
      log("Error while checking if user is new $e");
      return null;
    }
  }

  @override
  Future<UserModel?> updateUserDetails(
      {required String uid, required Map<String, dynamic> data}) async {
    try {
      return await _firestore
          .collection(FirestoreCollectionNames.usersCollection)
          .doc(uid)
          .update(
            data,
          )
          .then((value) {
        return _firestore
            .collection(FirestoreCollectionNames.usersCollection)
            .doc(uid)
            .get()
            .then((value) {
          if (value.exists) {
            return UserModel.fromMap(value.data()!);
          } else {
            return null;
          }
        });
      });
    } catch (e) {
      log("Error while updating user details $e");
      return null;
    }
  }

  @override
  Future<List<Offer>?> getFreshKartOffersSlides() async {
    try {
      return await _firestore
          .collection(FirestoreCollectionNames.freshKartOffersSlidesCollection)
          .where('active', isEqualTo: true)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          List<Offer> offers = [];
          log(value.docs.length.toString());
          for (var element in value.docs) {
            offers.add(Offer.fromMap(element.data()));
          }
          return offers;
        } else {
          log("Freshkart offers does not exist");
          return null;
        }
      });
    } catch (e) {
      log("Error while getting freshkart offers $e");
      return null;
    }
  }

  @override
  Future<List<CategoryModel>?> getFreshKartCategories() async {
    try {
      final docRef = _firestore
          .collection(FirestoreCollectionNames.appData)
          .doc(FirestoreDocumentNames.freshKartCategoriesDocument);
      return await docRef.get().then((value) {
        if (value.exists) {
          List<CategoryModel> categories = [];
          final data = value.data()!["freshKartCategories"];
          for (var element in data) {
            categories.add(CategoryModel.fromMap(element));
          }
          return categories;
        } else {
          log("Freshkart categories does not exist");
          return [];
        }
      });
    } catch (e, st) {
      log("Error while getting freshkart categories $e\n $st");
      return null;
    }
  }
}

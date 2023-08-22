import 'dart:collection';
import 'dart:developer';
import 'package:eds_beta/core/enums.dart';
import 'package:eds_beta/models/app_models.dart';

class ProductsController {
  List<ProductModel> _products = [];
  Map<String, dynamic> _selectedFilters = {};

  Map<String, ProductModel> _filteredproductsHashMap = {};
  Map<String, ProductModel> _productsHashMap = {};

  List<ProductModel> get products {
    return _filteredproductsHashMap.values.toList();
  }

  set products(List<ProductModel> products) {
    _products = products;
    for (var p in products) {
      _productsHashMap[p.productId] = p;
      _filteredproductsHashMap[p.productId] = p;
    }
    _updateCategoryFilterProperties();
    applyFilterstoProducts();
  }

  Map<String, dynamic> filteringProperites = {
    "Category": null,
    "Type": null,
    "Brand": null,
    "Gender": null,
    "Color": null,
  };
  void sortProductsBasedOnPrice({required bool isAscending}) {
    var sortedMap = SplayTreeMap<String, ProductModel>.from(_productsHashMap,
        ((key1, key2) {
      if (isAscending) {
        return _productsHashMap[key1]!
            .getMinPrice
            .compareTo(_productsHashMap[key2]!.getMinPrice);
      } else {
        return _productsHashMap[key2]!
            .getMinPrice
            .compareTo(_productsHashMap[key1]!.getMinPrice);
      }
    }));

    _filteredproductsHashMap.clear();
    _filteredproductsHashMap = sortedMap;
    // _products.sort((a, b) {
    //   if (isAscending) {
    //     return a.getMinPrice.compareTo(b.getMinPrice);
    //   } else {
    //     return b.getMinPrice.compareTo(a.getMinPrice);
    //   }
    // });
  }

  void sortProductsBasedOnRating({required bool isAscending}) {
    var sortedMap = SplayTreeMap<String, ProductModel>.from(_productsHashMap,
        ((key1, key2) {
      if (isAscending) {
        return double.parse(_productsHashMap[key1]!.rating)
            .compareTo(double.parse(_productsHashMap[key2]!.rating));
      } else {
        return double.parse(_productsHashMap[key2]!.rating)
            .compareTo(double.parse(_productsHashMap[key1]!.rating));
      }
    }));
    _filteredproductsHashMap.clear();
    _filteredproductsHashMap = sortedMap;
    // _products.sort((a, b) {
    //   if (isAscending) {
    //     return double.parse(a.rating).compareTo(double.parse(b.rating));
    //   } else {
    //     return double.parse(b.rating).compareTo(double.parse(a.rating));
    //   }
    // });
  }

  void sortProductsBasedOnDiscount({required bool isAscending}) {
    var sortedMap = SplayTreeMap<String, ProductModel>.from(_productsHashMap,
        ((key1, key2) {
      if (isAscending) {
        return _productsHashMap[key1]!
            .getDiscount
            .compareTo(_productsHashMap[key2]!.getDiscount);
      } else {
        return _productsHashMap[key2]!
            .getDiscount
            .compareTo(_productsHashMap[key1]!.getDiscount);
      }
    }));
    _filteredproductsHashMap.clear();
    _filteredproductsHashMap = sortedMap;

    // _products.sort((a, b) {
    //   if (isAscending) {
    //     return a.getDiscount.compareTo(b.getDiscount);
    //   } else {
    //     return b.getDiscount.compareTo(a.getDiscount);
    //   }
    // });
  }

  void sortProdctsBasedOnDate({required bool isAscending}) {
    var sortedMap = SplayTreeMap<String, ProductModel>.from(_productsHashMap,
        (((key1, key2) {
      if (isAscending) {
        return _productsHashMap[key1]!
            .createdAt
            .compareTo(_productsHashMap[key2]!.createdAt);
      } else {
        return _productsHashMap[key2]!
            .createdAt
            .compareTo(_productsHashMap[key1]!.createdAt);
      }
    })));
    _filteredproductsHashMap.clear();
    _filteredproductsHashMap = sortedMap;

    // _products.sort((a, b) {
    //   if (isAscending) {
    //     return a.createdAt.compareTo(b.createdAt);
    //   } else {
    //     return b.createdAt.compareTo(a.createdAt);
    //   }
    // });
  }

  void sortProductsBasedOnName({required bool isAscending}) {
    var sortedMap = SplayTreeMap<String, ProductModel>.from(_productsHashMap,
        (((key1, key2) {
      if (isAscending) {
        return _productsHashMap[key1]!
            .name
            .compareTo(_productsHashMap[key2]!.name);
      } else {
        return _productsHashMap[key2]!
            .name
            .compareTo(_productsHashMap[key2]!.name);
      }
    })));

    _filteredproductsHashMap.clear();
    _filteredproductsHashMap = sortedMap;
    // _products.sort((a, b) {
    //   if (isAscending) {
    //     return a.name.compareTo(b.name);
    //   } else {
    //     return b.name.compareTo(a.name);
    //   }
    // });
  }

  void sortProducts(productSortRadioTypes sortType) {
    switch (sortType) {
      case productSortRadioTypes.newestFirst:
        sortProdctsBasedOnDate(isAscending: false);
        break;
      case productSortRadioTypes.priceLowToHigh:
        sortProductsBasedOnPrice(isAscending: true);
        break;
      case productSortRadioTypes.priceHighToLow:
        sortProductsBasedOnPrice(isAscending: false);
        break;
      case productSortRadioTypes.ratingHighToLow:
        sortProductsBasedOnRating(isAscending: false);
        break;
      case productSortRadioTypes.highestDiscount:
        sortProductsBasedOnDiscount(isAscending: false);
        break;
      default:
    }
  }

  void _updateCategoryFilterProperties() {
    final brands = filteringProperites['Brand'] ?? <String, dynamic>{};
    final categories = filteringProperites["Category"] ?? <String, dynamic>{};
    final types = filteringProperites['Type'] ?? <String, dynamic>{};
    final genders = filteringProperites['Gender'] ?? <String, dynamic>{};
    final colors = filteringProperites['Color'] ?? <String, dynamic>{};
    final sizes = filteringProperites['Size'] ?? <String, dynamic>{};
    for (final p in _products) {
      ///CATEGORIES
      if (p.category != "") {
        if (categories[p.category] == null) {
          categories[p.category] = {
            "count": 1,
            "selected": false,
            "products": [p.productId]
          };
        } else {
          categories[p.category]["count"] = categories[p.category]["count"] + 1;
          categories[p.category]["products"].add(p.productId);
        }
      }

      ///TYPES
      if (p.type != "" && p.type != null) {
        if (types[p.type] == null) {
          types[p.type] = {
            "count": 1,
            "selected": false,
            "products": [p.productId]
          };
        } else {
          types[p.type]["count"] = types[p.type]["count"] + 1;
          types[p.type]["products"].add(p.productId);
        }
      }

      ///BRANDS
      if (p.brand != null && p.brand != "") {
        if (brands[p.brand] == null) {
          brands[p.brand] = {
            "count": 1,
            "selected": false,
            "products": [p.productId]
          };
        } else {
          brands[p.brand]["count"] = brands[p.brand]["count"] + 1;
          brands[p.brand]["products"].add(p.productId);
        }
      }

      ///GENDER
      if (p.gender != null && p.gender != "") {
        if (genders[p.gender] == null) {
          genders[p.gender] = {
            "count": 1,
            "selected": false,
            "products": [p.productId]
          };
        } else {
          genders[p.gender]['count'] = genders[p.gender]['count'] + 1;
          genders[p.gender]['products'].add(p.productId);
        }
      }

      ///COLORS
      if (p.hasDifferentColors) {
        for (var e in p.availableColors!) {
          colors[e.color] = colors[e.color] == null ? 1 : colors[e.color] + 1;
          if (colors[e.color] == null) {
            colors[e.color] = {
              "count": 1,
              "selected": false,
              "products": [p.productId]
            };
          } else {
            colors[e.color]['count'] = colors[e.color]['count'] + 1;
            colors[e.color]['products'].add(p.productId);
          }
        }
      } else {
        if (colors[p.color] == null) {
          colors[p.color] = {
            "count": 1,
            "selected": false,
            "products": [p.productId]
          };
        } else {
          colors[p.color]['count'] = colors[p.color]['count'] + 1;
          colors[p.color]['products'].add(p.productId);
        }
      }

      ///SIZES
      if (p.hasDifferentSizes) {
        for (var e in p.sizes!) {
          if (sizes[e.size] == null) {
            sizes[e.size] = {
              "count": 1,
              "selected": false,
              "products": [p.productId]
            };
          } else {
            sizes[e.size]['count'] = sizes[e.size]['count'] + 1;
            sizes[e.size]['products'].add(p.productId);
          }
        }
      }
    }
    filteringProperites["Type"] = types;
    filteringProperites["Category"] = categories;
    filteringProperites["Brand"] = brands;
    filteringProperites['Gender'] = genders;
    filteringProperites['Color'] = colors;
    filteringProperites['Size'] = sizes;
  }

  void applyFilterstoProducts() {
    _filteredproductsHashMap.clear();
    filteringProperites.forEach((key, value) {
      if (value != null) {
        value.forEach((key, value) {
          if (value['selected']) {
            for (var id in value['products']) {
              _filteredproductsHashMap[id] = _productsHashMap[id]!;
            }
          }
        });
      }
    });
    if (_filteredproductsHashMap.isEmpty) {
      _filteredproductsHashMap = _productsHashMap;
    }
  }
}

import 'package:eds_beta/core/enums.dart';
import 'package:eds_beta/models/app_models.dart';

class ProductsController {
  List<ProductModel> products = [];

  void sortProductsBasedOnPrice({required bool isAscending}) {
    products.sort((a, b) {
      if (isAscending) {
        return a.getMinPrice.compareTo(b.getMinPrice);
      } else {
        return b.getMinPrice.compareTo(a.getMinPrice);
      }
    });
  }

  void sortProductsBasedOnRating({required bool isAscending}) {
    products.sort((a, b) {
      if (isAscending) {
        return double.parse(a.rating).compareTo(double.parse(b.rating));
      } else {
        return double.parse(b.rating).compareTo(double.parse(a.rating));
      }
    });
  }

  void sortProductsBasedOnDiscount({required bool isAscending}) {
    products.sort((a, b) {
      if (isAscending) {
        return a.getDiscount.compareTo(b.getDiscount);
      } else {
        return b.getDiscount.compareTo(a.getDiscount);
      }
    });
  }

  void sortProdctsBasedOnDate({required bool isAscending}) {
    products.sort((a, b) {
      if (isAscending) {
        return a.createdAt.compareTo(b.createdAt);
      } else {
        return b.createdAt.compareTo(a.createdAt);
      }
    });
  }

  void sortProductsBasedOnName({required bool isAscending}) {
    products.sort((a, b) {
      if (isAscending) {
        return a.name.compareTo(b.name);
      } else {
        return b.name.compareTo(a.name);
      }
    });
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
}

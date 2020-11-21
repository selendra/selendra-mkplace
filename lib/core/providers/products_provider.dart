import 'package:http/http.dart' as http;
import 'package:selendra_marketplace_app/all_export.dart';
import 'package:selendra_marketplace_app/core/models/products.dart';

class ProductsProvider with ChangeNotifier {
  //List of all product items
  List<Product> _items = [];

  //List of all owner product items
  List<Product> _oItems = [];
  //List of all order product items
  List<OrderProduct> _orItems = [];

  //List of all order product item that is available
  List<Product> _isAvailable = [];

  //List of all order product item that is sold
  List<Product> _isSold = [];

  List<String> _imageList = [];

  PrefService _prefService = PrefService();

  List<Product> get items => [..._items];
  List<Product> get oItems => [..._oItems];
  List<Product> get isAvailable => [..._isAvailable];
  List<Product> get isSold => [..._isSold];
  List<OrderProduct> get orItems => [..._orItems];
  List<String> get imageList => [..._imageList];

  int _orderQty = 1;
  int get orderQty => _orderQty;

  Future<void> fetchListingProduct() async {
    try {
      _prefService.read('token').then((value) async {
        if (value != null) {
          http.Response response =
              await http.get(ApiUrl.LISTING, headers: <String, String>{
            "accept": "application/json",
            "authorization": "Bearer " + value,
          });
          print(response.body);
          dynamic responseJson = json.decode(response.body);
          _prefService.saveString('products', jsonEncode(responseJson));
          for (var item in responseJson) {
            _items.add(Product.fromMap(item));
          }
          notifyListeners();
          fetchOListingProduct(value);
          fetchOrListingProduct(value);
          fetchImage(value);
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void clearList() {
    _items.clear();
    _oItems.clear();
    notifyListeners();
  }

  Future<void> fetchImage(String token) async {
    try {
      http.Response response =
          await http.get(ApiUrl.GET_PRODUCT_IMAGE, headers: <String, String>{
        "accept": "application/json",
        "authorization": "Bearer " + token,
      });

      print(response.body);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> fetchOrListingProduct(token) async {
    try {
      http.Response response =
          await http.get(ApiUrl.ORDER_LISTING, headers: <String, String>{
        "accept": "application/json",
        "authorization": "Bearer " + token,
      });
      print('order list' + response.body);
      dynamic responseJson = json.decode(response.body);
      _orItems.add(OrderProduct.fromMap(responseJson));
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> fetchOListingProduct(String token) async {
    try {
      http.Response response =
          await http.get(ApiUrl.OWNER_LISTING, headers: <String, String>{
        "accept": "application/json",
        "authorization": "Bearer " + token,
      });
      print(response.body);
      dynamic responseJson = json.decode(response.body);
      //_oItems.add(Product.fromMap(responseJson));
      _prefService.saveString('oproducts', jsonEncode(responseJson));

      for (var item in responseJson) {
        _oItems.add(Product.fromMap(item));
      }

      findIsSold(oItems);
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }

  void findIsSold(List<Product> allListing) {
    for (int i = 0; i < allListing.length; i++) {
      if (allListing[i].isSold) {
        _isSold.add(allListing[i]);
      } else {
        _isAvailable.add(allListing[i]);
      }
    }
  }

  // Future<void> readLocalProduct() async {
  //   await _prefService.read('products').then((value) {
  //     if (value != null) {
  //       dynamic repsonseJson = json.decode(value);
  //       for (var item in repsonseJson) {
  //         _items.add(Product.fromMap(item));
  //       }
  //     }
  //   });
  //   await _prefService.read('oproducts').then((value) {
  //     if (value != null) {
  //       dynamic responseJson = json.decode(value);
  //       _oItems.add(Product.fromMap(responseJson));
  //     }
  //   });
  // }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  //ADD NEW PRODUCT
  void addItem(String _title, double _price, String _description,
      String sellerName, String sellerPhone) {}

  //INCREASE ORDER QUANTITY OF PRODUCT
  void addOrderQty(Product product) {
    _orderQty++;
    notifyListeners();
    // product.orderQty++;
    // notifyListeners();
  }

  //DECREASE ORDER QUANTIY OF PRODUCT
  void minusOrderQty(Product product) {
    _orderQty--;
    notifyListeners();
    // if (product.orderQty > 1) {
    //   product.orderQty--;
    //   notifyListeners();
    // }
  }
}

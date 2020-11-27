import 'package:selendra_marketplace_app/all_export.dart';
import 'package:selendra_marketplace_app/core/models/seller_m.dart';

class SellerProvider with ChangeNotifier {

  Backend _backend = Backend();

  GetRequest _getRequest = GetRequest();

  PostRequest _postRequest = PostRequest();

  List<SellerModel> allBuyerOrder = [];

  SellerProvider(){
    fetchBuyerOrder();
  }

  void fetchBuyerOrder() async {
    allBuyerOrder.clear();
    _backend.response = await _getRequest.getAllBuyerOrder();

    _backend.data = json.decode(_backend.response.body);

    for(var data in _backend.data){
      allBuyerOrder.add(SellerModel.fromJson(data));
    }
    print(allBuyerOrder);
    notifyListeners();
  }
}
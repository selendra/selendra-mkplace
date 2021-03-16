import 'package:albazaar_app/ui/screens/shop/create_shop/create_shop.dart';
import 'package:albazaar_app/ui/screens/shop/create_shop/create_shop_body.dart';
import 'package:flutter/material.dart';
import 'package:albazaar_app/all_export.dart';
import 'package:albazaar_app/ui/screens/shop/components/body.dart';

class ListingScreen extends StatefulWidget {
  @override
  _ListingScreenState createState() => _ListingScreenState();
}

class _ListingScreenState extends State<ListingScreen>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  bool isSold = false;
  String shopCreate = 'no';

  void submit(){
    setState(() {
      shopCreate = 'created';
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _lang = AppLocalizeService.of(context);
    return Scaffold(
      appBar: ReuseAppBar.getTitle(
        _lang.translate('listing'),
        context,
        _lang.translate('all_seller'),
        _lang.translate('pending'),
        _lang.translate('complete'),
        _controller
      ), //lang.translate('Products')
      body: BodyScaffold(
        height: shopCreate == 'creating' ? MediaQuery.of(context).size.height : null,
        child: shopCreate == 'created' ? Body(_controller) : 
        shopCreate == 'creating' ? CreateShopBody(submit: submit) :Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/create_shop.svg', width: 293, height: 293),

              MyFlatButton(
                edgeMargin: EdgeInsets.only(left: 90, right: 90),
                height: 70,
                border: Border.all(color: AppServices.hexaCodeToColor(AppColors.primary), width: 2),
                isTransparent: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/icons/plus.svg', width: 15, height: 15, color: AppServices.hexaCodeToColor(AppColors.primary)),
                    MyText(left: pd10, text: "Create Shop", fontWeight: FontWeight.w600, color: AppColors.primary,),
                  ],
                ),
                action: (){
                  setState(() {
                    shopCreate = 'creating';
                  });
                },
              )

              // MyFlatButton(
              //   isTransparent: true,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       SvgPicture.asset('assets/icons/plus.svg', color: AppServices.hexaCodeToColor(AppColors.primary)),
              //       MyText(
              //         pLeft: 10,
              //         pTop: pd20,
              //         pBottom: pd20,
              //         text: "Create Shop",
              //         color: AppColors.primary,
              //         fontWeight: FontWeight.w600,
              //         fontSize: 25,
              //       )
              //     ],
              //   ),
              //   action: (){

              //   }
              // )
            ],
          )
        )
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:selendra_marketplace_app/models/products.dart';
import 'package:selendra_marketplace_app/constants.dart';


class RealEstateCategories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'All Categories',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(icon: Icon(Icons.close,color: kDefualtColor,),onPressed: (){
          Navigator.pop(context);
        },),
      ),
      body: _buildList(),
    );
  }
  Widget _buildList(){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: houseCategories.length,
        itemBuilder: (context,index){
          return ListTile(
            onTap: (){ Navigator.pop(context, houseCategories[index]); },
            title: Text(houseCategories[index]),
            trailing: Icon(Icons.arrow_forward_ios,),
          );
        }
      ),
    );
  }
}

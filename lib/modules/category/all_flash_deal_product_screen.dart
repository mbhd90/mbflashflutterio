// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import '../../widgets/rounded_app_bar.dart';
import '../home/model/product_model.dart';
import 'component/product_card.dart';
import '/utils/language_string.dart';

class AllFlashDealProductScreen extends StatefulWidget {
  const AllFlashDealProductScreen({Key? key,
    required this.products}) : super(key: key);
  final List<ProductModel> products;

  @override
  State<AllFlashDealProductScreen> createState() =>
      _AllFlashDealProductScreen(products);
}

class _AllFlashDealProductScreen extends State<AllFlashDealProductScreen> {
  
  _AllFlashDealProductScreen(this.products);

  final List<ProductModel> products;
  
  @override
  Widget build(BuildContext context) {
    
    final double theWidth = MediaQuery.of(context).size.width * 0.8;
    return Scaffold(
      appBar: RoundedAppBar(
        titleText: Language.flashDeal,
        onTap: () {
          Navigator.pop(context);
        },
      ),
      body: products.isEmpty
          ? Center(child: Text(Language.noItem))
          : _buildProductGrid(),
    );
  }

  Widget _buildProductGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 18,
        mainAxisSpacing: 18,
        mainAxisExtent: 210,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      itemCount: products.length,
      itemBuilder: (context, index) =>
          ProductCard(productModel: products[index]),
    );
  }
}

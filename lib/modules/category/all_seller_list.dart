import 'package:bm_flash/utils/language_string.dart';
import 'package:bm_flash/widgets/capitalized_word.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/rounded_app_bar.dart';
import '../home/component/single_circuler_seller.dart';
import '../home/model/home_seller_model.dart';

class AllSellerList extends StatelessWidget {
  const AllSellerList({Key? key, required this.sellers}) : super(key: key);
  final List<HomeSellerModel> sellers;

  @override
  Widget build(BuildContext context) {
    //context.read<CategoryCubit>().getCategoryList();
    final double theWidth = MediaQuery.of(context).size.width * 0.8;
    return Scaffold(
      appBar: RoundedAppBar(
        titleText: Language.allSeller.capitalizeByWord(),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
          mainAxisExtent: 130,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        itemCount: sellers.length,
        itemBuilder: (context, index) {
          return SingleCircularSeller(
            seller: sellers[index],
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cart/controllers/checkout/checkout_cubit.dart';
import '/utils/utils.dart';

import '../../widgets/primary_button.dart';
import '../../widgets/rounded_app_bar.dart';
import 'controllers/bank/bank_cubit.dart';
import '/utils/language_string.dart';

class BankPaymentScreen extends StatefulWidget {
  const BankPaymentScreen({Key? key, required this.mapBody}) : super(key: key);
  final Map<String, dynamic> mapBody;

  @override
  State<BankPaymentScreen> createState() => _BankPaymentScreenState();
}

class _BankPaymentScreenState extends State<BankPaymentScreen> {
  final formKey = GlobalKey<FormState>();
  final textController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
   final bankInfo =  context.read<CheckoutCubit>().checkoutResponseModel;
    return Scaffold(
      appBar: RoundedAppBar(titleText: 'Bank Payment'),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
          child: Column(
            children: [
              TextFormField(
                maxLines: 10,
                controller: textController,
                decoration:  InputDecoration(
                  hintText: bankInfo!.bankStatus!.accountInfo,
                ),
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                onPressed: () {
                  if(textController.text.isEmpty){
                    Utils.showSnackBar(context, "Please enter bank information");

                  }else{
                    final Map<String, String> body = {
                      'agree_terms_condition': '1',
                      'shipping_address_id': widget.mapBody['shipping_address_id'],
                      'billing_address_id': widget.mapBody['billing_address_id'],
                      'shipping_method_id': widget.mapBody['shipping_method_id'],
                      'tnx_info': textController.text
                    };
                    debugPrint(body.toString());
                    context.read<BankCubit>().makeBankPayment(body);
                  }

                },
                text: Language.continue_,
              )
            ],
          ),
        ),
      ),
    );
  }
}

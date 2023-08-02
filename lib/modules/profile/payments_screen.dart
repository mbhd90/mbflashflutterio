import 'package:flutter/material.dart'; 
import '../../core/router_name.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/rounded_app_bar.dart';
import '../cart/component/single_payment_card_component.dart';
import '../../utils/language_string.dart';

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const headerStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
    return Scaffold(
      appBar: RoundedAppBar(titleText: Language.payments),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(Language.paymentsMethod, style: headerStyle),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: SinglePaymentCardComponent(),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: SinglePaymentCardComponent(),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: SinglePaymentCardComponent(),
          ),
          const SizedBox(height: 18),
          PrimaryButton(
            text: Language.addPaymentsMethod,
            onPressed: () {
              Navigator.pushNamed(context, RouteNames.addNewPaymentCardScreen);
            },
          ),
        ],
      ),
    );
  }
}

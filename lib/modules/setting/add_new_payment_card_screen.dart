import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/constants.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/rounded_app_bar.dart';
import 'component/payment_card.dart';
import '/utils/language_string.dart';

class AddNewPaymentCardScreen extends StatefulWidget {
  const AddNewPaymentCardScreen({Key? key}) : super(key: key);

  @override
  State<AddNewPaymentCardScreen> createState() =>
      AddNewPaymentCardScreenState();
}

class AddNewPaymentCardScreenState extends State<AddNewPaymentCardScreen> {
  int currentCardIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RoundedAppBar(titleText: Language.addPaymentMethod),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                Language.payment_,
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w600, height: 1.5),
              ),
            ),
            const SizedBox(height: 9),
            SizedBox(
              height: 66,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                separatorBuilder: (_, __) => const SizedBox(width: 18),
                itemBuilder: (context, index) => PaymentCard(
                  index: index,
                  isSelected: index == currentCardIndex,
                  onTap: (int i) {
                    setState(() {
                      currentCardIndex = i;
                    });
                  },
                ),
                itemCount: 6,
                padding: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
            const SizedBox(height: 22),
            _buildPaymentForm()
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Language.addCardInfo,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w600, height: 1.5),
          ),
          const SizedBox(height: 12),
          TextFormField(
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              hintText: Language.cardNumber,
              fillColor: borderColor.withOpacity(.10),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            keyboardType: TextInputType.streetAddress,
            decoration: InputDecoration(
              fillColor: borderColor.withOpacity(.10),
              hintText: Language.cardHolderName,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Flexible(
                child: TextFormField(
                  keyboardType: TextInputType.streetAddress,
                  decoration: InputDecoration(
                    hintText: Language.expiredDate,
                    fillColor: borderColor.withOpacity(.10),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Flexible(
                child: TextFormField(
                  keyboardType: TextInputType.streetAddress,
                  decoration: InputDecoration(
                    hintText: 'Cvv',
                    fillColor: borderColor.withOpacity(.10),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 12),
          CheckboxListTile(
            value: true,
            activeColor: lightningYellowColor,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            dense: true,
            title: Text(
              Language.saveMyCardDetails,
              style: TextStyle(
                  fontSize: 14,
                  color: blackColor.withOpacity(0.5),
                  fontWeight: FontWeight.w400),
            ),
            onChanged: (v) {},
          ),
          const SizedBox(height: 30),
          PrimaryButton(text: Language.addNewCard, onPressed: () {}),
        ],
      ),
    );
  }

  Widget playListField() {
    return DropdownButtonFormField<String>(
      value: 'Ok',
      hint: Text(Language.playlist),
      decoration: InputDecoration(
        isDense: true,
        fillColor: borderColor.withOpacity(.10),
        border: const OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: borderColor),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
      ),
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
      onChanged: (value) {},
      validator: (value) => value == null ? 'field required' : null,
      isDense: true,
      isExpanded: true,
      items: ['Ok', "Hello"].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

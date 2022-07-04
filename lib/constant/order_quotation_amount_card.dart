import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Utils/utils.dart';

class OrderQuotationAmountCard extends StatelessWidget {
  final List list;

  const OrderQuotationAmountCard(
      {Key? key, required this.list})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.cyan.shade100.withOpacity(0.5),
          border: Border.all(color: Color(0xffE6ECF2), width: 0.7),
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: getWidth(0.18, context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CommanRowInAmountCard(
                      "Subtotal", list[0]['amount_total'] ?? 0, false),
                  CommanRowInAmountCard(
                      "Discount", list[0]['discount_amount'] ?? 0, false),
                  list[0]['extra_item_amount'] > 0 && list[0]['extra_item_amount'] != null
                      ? CommanRowInAmountCard(
                          "Ex. Charge", list[0]['extra_item_amount'], false)
                      : Container(),
                  CommanHorizontalDeviderInAmountCard(),
                  CommanRowInAmountCard(
                      "Final Amt.", list[0]['final_amount'] ?? 0, true),
                  CommanRowInAmountCard(
                      "Ad. Amt.", list[0]['advance_amount'] ?? 0, false),
                  CommanHorizontalDeviderInAmountCard(),
                  Container(
                    padding: EdgeInsets.all(5),
                    color: Colors.cyan.shade100,
                    child: CommanRowInAmountCard(
                        "Ord. Due.", list[0]['order_due'] ?? 0, true),
                  ),
                ],
              ),
            ),
            VerticalDivider(
              color: Colors.grey,
              thickness: 0.5,
            ),
            Container(
              width: getWidth(0.18, context),
              child: Column(
                children: [
                  CommanRowInAmountCard(
                      "Req. Depo.", list[0]['required_deposit'] ?? 0, false),
                  CommanRowInAmountCard(
                      "Paid. Amt.", list[0]['paid_amount'] ?? 0, false),
                  list[0]['extra_item_amount'] != null &&
                          list[0]['damage_charge'] > 0
                      ? CommanRowInAmountCard(
                          "Damage", list[0]['damage_charge'], false)
                      : Container(),
                  Divider(
                    color: Colors.grey,
                    thickness: 0.5,
                    height: 5,
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    color: Colors.cyan.shade100,
                    child: CommanRowInAmountCard(
                        "Due. Amt.", list[0]['residual'] ?? 0, true),
                  ),
                  Divider(
                    color: Colors.grey,
                    thickness: 0.5,
                    height: 5,
                  ),

                  Column(
                    children: [
                      CommanRowInAmountCard(
                          "Rec. Depo.", list[0]['receive_deposit'] ?? 0, false),
                      CommanRowInAmountCard(
                          "Ref. Depo.", list[0]['refund_deposit'] ?? 0, false),
                      Divider(
                        color: Colors.grey,
                        thickness: 0.5,
                        height: 1,
                      ),
                      CommanRowInAmountCard(
                          "Unpay. Depo.", list[0]['unpaid_deposit'] ?? 0, true)
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

CommanRowInAmountCard(String mainText, double subText, bool isMainAmount) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 5),
    child: Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            mainText,
            style: amountCardMainTextStyle,
          ),
          Text(
            subText.toInt().toString(),
            style: isMainAmount == false
                ? amountCardSubTextStyle
                : TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 18),
          ),
        ],
      ),
    ),
  );
}

CommanHorizontalDeviderInAmountCard() {
  return Divider(
    color: Colors.grey,
    thickness: 0.5,
  );
}

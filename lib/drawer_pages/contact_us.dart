import 'package:flutter/material.dart';
import 'package:gj5_rental/Utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constant/order_quotation_amount_card.dart';
import 'package:share_plus/share_plus.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactUsPage extends StatelessWidget {
  ContactUsPage({Key? key}) : super(key: key);
  Color contactUsPrimaryColor = Color(0xff9C5789);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: getHeight(0.4, context),
                width: double.infinity,
                color: contactUsPrimaryColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Image.asset(
                    "assets/images/developer_logo.png",
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: getHeight(0.33, context),
                    left: getWidth(0.1, context),
                    right: getWidth(0.1, context)),
                height: getHeight(0.48, context),
                width: getWidth(0.8, context),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Name",
                          style: contactusTitleText,
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Shivam Dudhat",
                              style: TextStyle(
                                  fontSize: 16.5, fontWeight: FontWeight.w500),
                            ),
                            Icon(Icons.person,
                                size: 22, color: contactUsPrimaryColor),
                          ],
                        ),
                        CommanHorizontalDeviderInAmountCard(),
                        SizedBox(
                          height: getHeight(0.03, context),
                        ),
                        Text(
                          "E-mail",
                          style: contactusTitleText,
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "info@laxicon.in",
                              style: TextStyle(
                                  fontSize: 16.5, fontWeight: FontWeight.w500),
                            ),
                            Icon(Icons.email,
                                size: 22, color: contactUsPrimaryColor),
                          ],
                        ),
                        CommanHorizontalDeviderInAmountCard(),
                        SizedBox(
                          height: getHeight(0.03, context),
                        ),
                        Text(
                          "Mobile",
                          style: contactusTitleText,
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "+91 90992 33354",
                              style: TextStyle(
                                  fontSize: 16.5, fontWeight: FontWeight.w500),
                            ),
                            InkWell(
                              onTap: () {
                                makingPhoneCall("90992 33354", context);
                              },
                              child: Icon(Icons.call,
                                  size: 22, color: contactUsPrimaryColor),
                            ),
                          ],
                        ),
                        CommanHorizontalDeviderInAmountCard(),
                        SizedBox(
                          height: getHeight(0.03, context),
                        ),
                        Text(
                          "Website",
                          style: contactusTitleText,
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "laxicon.in",
                              style: TextStyle(
                                  fontSize: 16.5, fontWeight: FontWeight.w500),
                            ),
                            Icon(Icons.blur_circular,
                                size: 22, color: contactUsPrimaryColor)
                          ],
                        ),
                        CommanHorizontalDeviderInAmountCard(),
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Share.share(
                      "Laxicon Solution \n 422 - Apple Square , Yogichowk , Varachha , Surat");
                },
                child: Container(
                  margin: EdgeInsets.only(
                      top: getHeight(0.765, context),
                      left: getWidth(0.4, context),
                      right: getWidth(0.4, context)),
                  child: CircleAvatar(
                      radius: 35,
                      backgroundColor: contactUsPrimaryColor,
                      child: Icon(
                        Icons.share,
                        size: 35,
                        color: Colors.white,
                      )),
                ),
              ),
            ],
          ),
          SizedBox(
            height: getHeight(0.02, context),
          ),
          Text(
            "Follow us on",
            style: TextStyle(
                color: contactUsPrimaryColor,
                fontWeight: FontWeight.w500,
                fontSize: 17),
          ),
          SizedBox(
            height: getHeight(0.01, context),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  launchApp(
                      context, "https://www.instagram.com/laxiconsolution/");
                },
                icon: Icon(
                  FontAwesomeIcons.instagram,
                  color: contactUsPrimaryColor,
                  size: 28,
                ),
                //using font awesome icon in action list of appbar
              ),
              IconButton(
                onPressed: () {
                  launchApp(
                      context, "https://www.facebook.com/Laxiconsolution/");
                },
                icon: Icon(
                  FontAwesomeIcons.facebook,
                  color: contactUsPrimaryColor,
                  size: 28,
                ),
                //using font awesome icon in action list of appbar
              ),
              IconButton(
                onPressed: () {
                  launchApp(context, "https://twitter.com/Laxiconsolution");
                },
                icon: Icon(
                  FontAwesomeIcons.twitter,
                  color: contactUsPrimaryColor,
                  size: 28,
                ),
                //using font awesome icon in action list of appbar
              ),
            ],
          )
        ],
      ),
    );
  }

  launchApp(BuildContext context, String url) async {
    try {
      final Uri launchUri = Uri.parse(url);
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri, mode: LaunchMode.externalApplication);
      } else if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        dialog(context, "Failed To Open", Colors.red.shade300);
      }
    } catch (e) {
      print(e);
      dialog(context, e.toString(), Colors.red.shade300);
    }
  }
}

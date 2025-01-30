
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rest_reservation/pages/home_page/all_cuisines_page.dart';

class HeaderWidget extends StatelessWidget {
  late String title;

  HeaderWidget(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xff1F1F1F)),
          ),
          TextButton(
            onPressed: () {
              if(
                title == "Cuisines"
              ){
                Get.to(()=>AllCuisinesPage());
              }
            },
            style: TextButton.styleFrom(
                padding: EdgeInsets.all(0),
                splashFactory: NoSplash.splashFactory),
            child: Text(
              "See All",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff5B4CBD)),
            ),
          )
        ],
      ),
    );
  }
}

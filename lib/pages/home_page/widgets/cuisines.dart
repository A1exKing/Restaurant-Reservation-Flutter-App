

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rest_reservation/pages/home_page/cuisines_rest_page.dart';

class CuisinesWidget extends StatelessWidget {
   CuisinesWidget({
    super.key,
  });
  List<Map<String, String>> cuisines = [
    {"title": "Italian", "image": "assets/images/italian-cuisine.jpg"},
    {"title": "Mexican", "image": "assets/images/mexican-cuisine.jpg"},
    {"title": "Japanese", "image": "assets/images/japanese-cuisine.jpg"},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        itemCount: cuisines.length,
        padding: EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemBuilder: (content, e) => InkWell(
          onTap: ()=> Get.to(
            CuisinesRestPage(cuisine: cuisines[e]["title"]!),
            transition: Transition.fade,
          
            ),
          child: Container(
            margin: EdgeInsets.only(right: 12),
            height: 46,
            padding: EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(44),
              image: DecorationImage(image: AssetImage(cuisines[e]["image"]!),
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5), // Затемнення
                BlendMode.darken, // Спосіб змішування
              ),
               fit: BoxFit.cover)
            ),
            child: Text(cuisines[e]["title"]!, 
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
        )),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rest_reservation/pages/home_page/cuisines_rest_page.dart';
List<Map<String, String>> cuisines = [
    {"title": "Italian", "image": "assets/images/italian-cuisine.jpg"},
    {"title": "Mexican", "image": "assets/images/mexican-cuisine.jpg"},
    {"title": "Japanese", "image": "assets/images/japanese-cuisine.jpg"},
  ];

class AllCuisinesPage extends StatelessWidget {
  const AllCuisinesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Cuisine"),
      ),
      body: GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        itemCount: cuisines.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisExtent: 120, crossAxisSpacing: 12, mainAxisSpacing: 12), 
        itemBuilder: (context, i) =>InkWell(
          onTap: ()=> Get.to(
            CuisinesRestPage(cuisine: cuisines[i]["title"]!),
            transition: Transition.cupertino,
          
            ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(image: AssetImage(cuisines[i]["image"]!),
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5), // Затемнення
                  BlendMode.darken // Спосіб змішування
                ),
                 fit: BoxFit.cover)
            ),
            
            child: Center(
              child: Text(
                cuisines[i]["title"]!,
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600),
                ),
                  
              ),
          ),
        )),
    );
  }
}
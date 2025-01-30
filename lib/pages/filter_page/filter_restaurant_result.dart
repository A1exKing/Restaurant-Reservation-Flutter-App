import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rest_reservation/models/restaurant_model.dart';
import 'package:rest_reservation/pages/filter_page/filter_page.dart';
import 'package:rest_reservation/pages/home_page/widgets/restaurants_big_item.dart';

class FilteredRestPage extends StatelessWidget {
 
  const FilteredRestPage({super.key});
 @override
  Widget build(BuildContext context) {
      final filterController = Get.put(FilterController());
   final List<Restaurant> restaurants = filterController.filteredRestaurants;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        // title: Text(
        //   cuisine,
        //   style: TextStyle(color: Colors.black),
        // ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body:  Obx(() {
              final restaurants = filterController.filteredRestaurants;
              //    print(restaurants);
              if (restaurants.isEmpty)
                return Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Center(child: Text("No restaurants match your filters.")),
                );
              else
                return ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: 8,),
            padding: EdgeInsets.symmetric(horizontal: 24),
            itemCount: restaurants.length,
            itemBuilder: (context, index) {
              final restaurant = restaurants[index];
              return RestaurantsBigItem(restaurant: restaurant);
            },
          );
            })
    );
  }
}
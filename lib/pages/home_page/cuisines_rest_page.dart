import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rest_reservation/models/restaurant_model.dart';
import 'package:rest_reservation/pages/home_page/widgets/restaurants_big_item.dart';

class CuisinesRestPage extends StatelessWidget {
  Future<List<Restaurant>> fetchRestaurantsByCuisine() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('restaurants')
          .where('cuisine', isEqualTo: cuisine)
          .get();

      return snapshot.docs
          .map((doc) => Restaurant.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print("Error fetching restaurants: $e");
      return [];
    }
  }
  final String cuisine;
  const CuisinesRestPage({super.key, required this.cuisine});
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          cuisine,
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder<List<Restaurant>>(
        future: fetchRestaurantsByCuisine(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Показуємо процес завантаження
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("Error loading restaurants. Please try again."),
            );
          }
          final restaurants = snapshot.data ?? [];
          if (restaurants.isEmpty) {
            return Center(
              child: Text("No restaurants found for $cuisine cuisine."),
            );
          }

          return ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: 8,),
            padding: EdgeInsets.symmetric(horizontal: 24),
            itemCount: restaurants.length,
            itemBuilder: (context, index) {
              final restaurant = restaurants[index];
              return RestaurantsBigItem(restaurant: restaurant);
            },
          );
        },
      ),
    );
  }
}
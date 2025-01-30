import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rest_reservation/models/restaurant_model.dart';
import 'package:rest_reservation/pages/filter_page/filter_page.dart';
import 'package:rest_reservation/pages/home_page/widgets/app_bar_container.dart';
import 'package:rest_reservation/pages/home_page/widgets/cuisines.dart';
import 'package:rest_reservation/pages/home_page/widgets/filter_widget.dart';
import 'package:rest_reservation/pages/home_page/widgets/header.dart';
import 'package:rest_reservation/pages/home_page/widgets/restaurants_big_item.dart';
import 'package:rest_reservation/pages/home_page/widgets/special_offers.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
 Future<List<Restaurant>> fetchData() async {
    final snapshot = await FirebaseFirestore.instance.collection('restaurants').get();
    // Повертаємо список документів як Map
    return snapshot.docs.map((doc) => Restaurant.fromJson(doc.data())).toList();
  }
  @override
  Widget build(BuildContext context) {
    final filterController = Get.put(FilterController());

    final TextStyle whiteText14 = TextStyle(color: Colors.white, fontSize: 14);
    final TextStyle whiteText18Bold = TextStyle(
        color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600);

    return ColorfulSafeArea(
      color: Colors.transparent,
      overflowTappable: true,
      overflowRules: OverflowRules.all(true),
      child: Scaffold(
        
        extendBody: true,
        backgroundColor: Colors.white,
        body: CustomScrollView(
          // shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: AppBarContainer(
                whiteText14: whiteText14,
                whiteText18Bold: whiteText18Bold,
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 12)),
            SliverToBoxAdapter(child: HeaderWidget("Spacial Offers")),
            SliverToBoxAdapter(child: SpecialOffersContainer()),
            SliverToBoxAdapter(child: SizedBox(height: 12)),
            SliverToBoxAdapter(child: HeaderWidget("Cuisines")),
            SliverToBoxAdapter(child: CuisinesWidget()),
            SliverToBoxAdapter(child: SizedBox(height: 12)),

            SliverPersistentHeader(
              pinned: true,
              floating: false,
              delegate: _FilterChipsHeaderDelegate(expandedHeight: 80),
            ),
            // Ось блок, який замінюємо:
            FutureBuilder<List<Restaurant>>(
                    future: fetchData(), // Передаємо асинхронну функцію
                    builder: (context, snapshot) {
                      // Перевіряємо стан Future
                      if (snapshot.connectionState == ConnectionState.waiting) {
            return SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())); // Стан завантаження
                      } else if (snapshot.hasError) {
            return SliverToBoxAdapter(child: Center(child: Text('Error: ${snapshot.error}'))); // Помилка
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return SliverToBoxAdapter(child: Center(child: Text('No data available'))); // Пусті дані
                      } else {
            // Дані успішно отримані
            final restaurants = snapshot.data!;
                        return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final data = restaurants[index];
                    return Padding(
                      padding:
                          const EdgeInsets.only(left: 24, right: 24, top: 8),
                      child: RestaurantsBigItem(
                       restaurant: data,
                      ),
                    );
                  },
                  childCount: restaurants.length,
                ),
              );
                      }
                    },
                  ),
         

          ],
        ),
      ),
    );
  }
}

class _FilterChipsHeaderDelegate extends SliverPersistentHeaderDelegate {
  late double expandedHeight;

  _FilterChipsHeaderDelegate({required this.expandedHeight});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    late double a;
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (shrinkOffset == 0) {
            expandedHeight = 80;
            a = 0;
          } else {
            expandedHeight = MediaQuery.of(context).padding.top + 80;
            a = 0.8;
          }

         // print(MediaQuery.of(context).padding);
          return Center(
            child: Container(
              alignment: Alignment(0, a),
              //  margin: EdgeInsets.only(top: 50),
              height: constraints.maxHeight,
              color: Colors.white,
              //    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  HeaderWidget("Popular Restaurants"),
                  FilterChipsExample(),
                ],
              ), // Переконайтеся, що цей віджет має чіткі обмеження
            ),
          );
        },
      ),
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => expandedHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false; // Логіка залежить від того, чи потрібно оновлювати віджет
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rest_reservation/models/restaurant_model.dart';
import 'package:rest_reservation/pages/main_page.dart';
import 'package:rest_reservation/pages/restaurant_detail_page/restaurant_details_page.dart';
import 'search_restaurants_controller.dart';

class SearchPage extends StatelessWidget {
  final SearchResController controller = Get.put(SearchResController());
 final TextEditingController searchController = TextEditingController();
  final MainPageController tabController = Get.find();
  @override
  Widget build(BuildContext context) {
    // Скидання пошукового запиту після завершення першої побудови
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.resetSearch();
      
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: buildSearchField(),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => {  if (Navigator.canPop(context)) {
                // Закриваємо сторінку, якщо вона в стеку
                Navigator.pop(context)
              } else {
                // Перемикаємо вкладку
                tabController.changeTab(0)
              }
            },
        ),
      ),
      body: Obx(() {
         if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(), // Індикатор завантаження
          );
        } else if (controller.searchQuery.isEmpty && controller.searchResults.isEmpty) {
        return buildRecentSections();
      } else {
        return buildSearchResults();
      }
      }),
    );
  }

  // Поле для пошуку
  Widget buildSearchField() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          color: Color(0xffF6F6F6),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Image.asset("assets/icons/search.png",
                  width: 22, color: const Color(0xff5B4CBD)),
            ),
            Expanded(
              child: TextField(

                controller:searchController,
                   // TextEditingController(text: controller.searchQuery.value),
                onChanged: (value) {
                  controller.searchQuery.value = value;
                  controller.searchRestaurants(value);
                },
                onSubmitted: (value) {
                  controller.addToRecentSearch(value);
                  controller.searchRestaurants(value);
                },
                onTapOutside: (e) => Get.focusScope?.unfocus(),
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  contentPadding: EdgeInsets.symmetric(horizontal: 9),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Розділи "Recent Searches" та "Recently Viewed"
  Widget buildRecentSections() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      children: [
          if (controller.recentSearches.isEmpty && controller.recentlyViewed.isEmpty)
          Center(child: Text("Search History"),),
          
        if (controller.recentSearches.isNotEmpty) ...[
          Text(
            "Recent Searches",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          Column(
            children: controller.recentSearches
                .map((query) => ListTile(
                  onTap: () {print(query);},
                  visualDensity: VisualDensity(vertical:VisualDensity.minimumDensity),
                  contentPadding: EdgeInsets.symmetric(vertical: 4),
                      title: Text(query),
                      trailing: SizedBox(
                        width: 24,
                        height: 24,
                        child: IconButton(
                          padding: EdgeInsets.all(0),
                          iconSize: 22,
                          icon: Icon(Icons.close, color: Color(0xff5B4CBD)),
                          onPressed: () {
                            controller.recentSearches.remove(query);
                          },
                        ),
                      ),
                    ))
                .toList(),
          ),
          SizedBox(height: 16),
        ],
        if (controller.recentlyViewed.isNotEmpty) ...[
          Text(
            "Recently Viewed",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Column(
            children: controller.recentlyViewed
                .map((restaurant) => RecentViewItem(data: restaurant))
                .toList(),
          ),
        ],
      ],
    );
  }

  // Результати пошуку
  Widget buildSearchResults() {
  return Obx(() {
    if (controller.searchQuery.isEmpty) {
      return SizedBox();
    }

    if (controller.searchResults.isEmpty) {
      return Center(
        child: Text(
          'No results found for "${controller.searchQuery.value}"',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: controller.searchResults.length,
      itemBuilder: (context, index) {
        final restaurant = controller.searchResults[index];
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              restaurant['gallery']?.first ?? '',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.broken_image,
                color: Colors.grey,
              ),
            ),
          ),
          title: Text(restaurant['name'] ?? 'No Name'),
          subtitle: Text(restaurant['cuisine'] ?? 'Unknown'),
          onTap: () {
              final restaurantObj = Restaurant.fromJson(restaurant);
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailsPageRestaurant(
              restaurant: restaurantObj,
            )),);
            controller.addToRecentlyViewed(restaurant);
          },
        );
      },
    );
  });
}

}

class RecentViewItem extends StatelessWidget {
  final Map<String, dynamic> data;

  RecentViewItem({required this.data});

  @override
  Widget build(BuildContext context) {
    return Material(
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.hardEdge,
        color: Colors.transparent,
        child:  InkWell(
        onTap: () {
          final restaurantObj = Restaurant.fromJson(data);
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailsPageRestaurant(
              restaurant: restaurantObj,
            )),);
        },
      child:  Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                              data['gallery'][0],
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                width: 80,
                                height: 80,
                                color: Color(0xffF6F6F6),
                                child: Icon(
                                  Icons.broken_image,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['name'],
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        // Image.asset('assets/images/wallet.png', width: 16,),
                       
                        // SizedBox(width: 4),
                       // Text(data['priceCategory'], style: TextStyle(color: Colors.grey)),
                   //     SizedBox(width: 16),
                        Image.asset(
                          "assets/icons/cuisines.png",
                          width: 16.w,
                          color: Color(0xff5B4CBD),
                        ),
                        SizedBox(width: 4),
                        Text(data['cuisine'], style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Image.asset(
                          "assets/icons/location.png",
                          color: const Color(0xff5B4CBD),
                          width: 16.w,
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            data['address']['street'],
                            style: TextStyle(color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
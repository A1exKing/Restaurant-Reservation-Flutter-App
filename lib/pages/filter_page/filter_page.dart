import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


import 'package:get/get.dart';
import 'package:rest_reservation/models/restaurant_model.dart';
import 'package:rest_reservation/pages/filter_page/filter_restaurant_result.dart';
class Filter {
  final String name;
  bool isSelected;

  Filter(this.name, this.isSelected);
}
class FilterController extends GetxController {
  // Вихідні (усі) дані, які потрібно відфільтрувати
      final RxList<Restaurant> filteredRestaurants = <Restaurant>[].obs;

void onInit() {
  super.onInit();
  applyFilters();
}
  // Реактивні змінні для фільтрів
  var selectedLocation = "All".obs;
  var selectedService = "All".obs;
  var selectedPrice = "All".obs;
 
  var selectedReview = "3.0 - 3.5".obs;
  var selectedSort = "All".obs;

  // Список із результатами фільтрації
  final RxList<Map<String, dynamic>> filteredItems = <Map<String, dynamic>>[].obs;

  // Списки для вибору (демо)
  final List<String> locations = ["New York, USA", "Los Angeles, USA", "Chicago, USA", "All"];
  final List<String> cuisines = ['All', 'Italian', 'Chinese', 'Indian', 'Mexican', 'Japanese'];
  final List<String> price = ["All","\$", "\$\$", "\$\$\$", "\$\$\$\$"];
  final List<String> reviews = [
    "4.5 and above",
    "4.0 - 4.5",
    "3.5 - 4.0",
    "3.0 - 3.5",
  ];
  final List<String> sortOptions = ["All", "Popular", "Nearby", "Price - Low to High", "Price - High to Low"];
  var filterChips = [
    Filter('Nearest', false),
    Filter('Great Offers', false),
    Filter('Ratings 4.5+', false),
  ].obs;


Future<void> fetchRestaurants() async {
    try {
      Query query = FirebaseFirestore.instance.collection('restaurants');

      // Фільтруємо за кухнею
      if (selectedService.value != 'All') {
        query = query.where('cuisine', isEqualTo: selectedService.value);
      }
  if (selectedPrice.value != 'All') {
        query = query.where('priceCategory', isEqualTo: selectedPrice.value);
      }

      // Додаткові фільтри з Chips
      if (filterChips.any((chip) => chip.name == 'Ratings 4.5+' && chip.isSelected)) {
        query = query.where('averageRating', isGreaterThanOrEqualTo: 4.5);
      }

      if (filterChips.any((chip) => chip.name == 'Great Offers' && chip.isSelected)) {
        query = query.where('hasOffer', isEqualTo: true);
      }

      // Запит до Firestore
      final snapshot = await query.get();
final restaurants = snapshot.docs
          .map((doc) => Restaurant.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();
      // Збереження отриманих даних
      filteredRestaurants.assignAll(restaurants);
    } catch (e) {
      print("Error fetching restaurants: $e");
      filteredRestaurants.clear(); // Очистити список, якщо є помилка
    }
  }

   // Викликається при кожній зміні фільтрів
  void applyFilters() {
    fetchRestaurants();
  }
  // Скидання фільтрів
  void resetFilters() {
    selectedLocation.value = "All";
    selectedService.value = "All";
   selectedPrice.value = "All";
    
    selectedReview.value = "4.5 and above";
    selectedSort.value = "All";
    applyFilters();
  }
}

class FilterPage extends StatelessWidget {
  const FilterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Створюємо/отримуємо екземпляр контролера
   final filterController = Get.put(FilterController(), permanent: true);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Filter", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          // Основна частина з фільтрами
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              children: [
                // Location
                const Text("Location",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),

                Obx(() {
                  return DropdownButtonFormField<String>(
                    value: filterController.selectedLocation.value,
                    items: filterController.locations
                        .map((loc) => DropdownMenuItem(
                              value: loc,
                              child: Text(loc),
                            ))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        filterController.selectedLocation.value = val;
                        filterController.applyFilters();
                      }
                    },
                    decoration: InputDecoration(
                      fillColor: const Color(0xffF6F6F6),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                          borderSide: BorderSide.none),
                      filled: true,
                    ),
                  );
                }),

                const SizedBox(height: 16),

                // Services
                const Text("Services",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),

                Obx(() {
                  return Wrap(
                    spacing: 8,
                    children: filterController.cuisines.map((service) {
                      final selected = filterController.selectedService.value == service;
                      return ChoiceChip(
                        label: Text(service),
                        selected: selected,
                        onSelected: (isSelected) {
                          filterController.selectedService.value = service;
                          filterController.applyFilters();
                        },
                        side: BorderSide.none,
                        shape: const StadiumBorder(side: BorderSide()),
                        showCheckmark: false,
                        selectedColor: const Color(0xff5B4CBD),
                        backgroundColor: const Color(0xffF6F6F6),
                        labelStyle: TextStyle(
                          color: selected ? Colors.white : const Color(0XFF5C5C5C),
                        ),
                      );
                    }).toList(),
                  );
                }),

                const SizedBox(height: 16),

                // Price Range
                const Text("Price Range",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
               Obx(() {
                  return Wrap(
                    spacing: 8,
                    children: filterController.price.map((price) {
                      final selected = filterController.selectedPrice.value == price;
                      return ChoiceChip(
                        label: Text(price),
                        selected: selected,
                        onSelected: (isSelected) {
                          filterController.selectedPrice.value = price;
                          filterController.applyFilters();
                        },
                        side: BorderSide.none,
                        shape: const StadiumBorder(side: BorderSide()),
                        showCheckmark: false,
                        selectedColor: const Color(0xff5B4CBD),
                        backgroundColor: const Color(0xffF6F6F6),
                        labelStyle: TextStyle(
                          color: selected ? Colors.white : const Color(0XFF5C5C5C),
                        ),
                      );
                    }).toList(),
                  );
                }),

              

                const SizedBox(height: 16),

                // Reviews
                const Text("Reviews",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),

                Obx(() {
                  return Column(
                    children: filterController.reviews.map((review) {
                      return SizedBox(
                        height: 42,
                        child: RadioListTile(
                          value: review,
                          groupValue: filterController.selectedReview.value,
                          onChanged: (value) {
                            if (value != null) {
                              filterController.selectedReview.value = value;
                              filterController.applyFilters();
                            }
                          },
                          contentPadding: EdgeInsets.all(0),
                          visualDensity: VisualDensity(vertical:VisualDensity.minimumDensity),
                          controlAffinity: ListTileControlAffinity.trailing,
                          activeColor: const Color(0xff5B4CBD),
                          title: Row(
                            children: [
                              // Демонстративно показуємо зірочки:
                              // (у реальному проекті можна кастомізувати)
                              Row(
                                children: List.generate(5, (index) {
                                  return const Icon(Icons.star,
                                      size: 18, color: Color.fromARGB(255, 255, 191, 0));
                                }),
                              ),
                              const SizedBox(width: 8),
                              Text(review),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }),

                const SizedBox(height: 16),

                // Sort
                const Text("Sortby",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),

                Obx(() {
                  return Wrap(
                    spacing: 8,
                    children: filterController.sortOptions.map((option) {
                      final selected = filterController.selectedSort.value == option;
                      return ChoiceChip(
                        label: Text(option),
                        selected: selected,
                        onSelected: (isSelected) {
                          filterController.selectedSort.value = option;
                          filterController.applyFilters();
                        },
                        side: BorderSide.none,
                        shape: const StadiumBorder(side: BorderSide()),
                        showCheckmark: false,
                        selectedColor: const Color(0xff5B4CBD),
                        backgroundColor: const Color(0xffF6F6F6),
                        labelStyle: TextStyle(
                          color: selected ? Colors.white : const Color(0XFF5C5C5C),
                        ),
                      );
                    }).toList(),
                  );
                }),

                const SizedBox(height: 32),
              ],
            ),
          ),

          // Кнопки внизу (Reset / Apply)
          Container(
            padding: const EdgeInsets.only(top: 12, left: 24, right: 18, bottom: 24),
            height: 88,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(115, 192, 192, 192),
                  offset: const Offset(0, -1),
                  blurRadius: 18,
                )
              ],
            ),
            child: Row(
              children: [
                // RESET
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      filterController.resetFilters();
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xffF6F6F6),
                    ),
                    child: const Text("Reset Filter", style: TextStyle(color: Colors.black)),
                  ),
                ),
                const SizedBox(width: 16),

                // APPLY
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Приклад: після натискання "Apply" —
                      // повертаємося назад із вибраними фільтрами
                      // Get.back(result: {
                      //   "location": filterController.selectedLocation.value,
                      //   "service": filterController.selectedService.value,
                      //   "priceRange": [
                      //     filterController.selectedPrice.value,
                         
                      //   ],
                      //   "review": filterController.selectedReview.value,
                      //   "sort": filterController.selectedSort.value,
                      // });
                      Get.to(()=>FilteredRestPage());
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xff5B4CBD),
                    ),
                    child: const Text("Apply", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
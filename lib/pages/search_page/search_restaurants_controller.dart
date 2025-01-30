import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class SearchResController extends GetxController {
  // Пошуковий рядок
  var searchQuery = ''.obs;

  // Результати пошуку
  var searchResults = <Map<String, dynamic>>[].obs;

  // Недавні пошуки
  var recentSearches = <String>[].obs;

  // Переглянуті ресторани
  var recentlyViewed = <Map<String, dynamic>>[].obs;

  // Стан завантаження
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  // Завантаження початкових даних
  void loadInitialData() {
    recentSearches.value = [];
    recentlyViewed.value = [];
  }

  // Пошук ресторанів
  Future<void> searchRestaurants(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }

    isLoading.value = true; // Початок завантаження

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('restaurants')
          .where('nameParts', arrayContains: query.toLowerCase())
          .get();

      searchResults.assignAll(
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList(),
      );
    } catch (e) {
      print("Error searching in Firestore: $e");
    } finally {
      isLoading.value = false; // Завершення завантаження
    }
  }

  // Додаємо пошуковий запит
  void addToRecentSearch(String query) {
    if (query.isNotEmpty && !recentSearches.contains(query)) {
      recentSearches.insert(0, query);
      if (recentSearches.length > 5) {
        recentSearches.removeLast();
      }
    }
  }

  // Додаємо ресторан до переглянутих
  void addToRecentlyViewed(Map<String, dynamic> restaurant) {
    if (!recentlyViewed.any((item) => item['name'] == restaurant['name'])) {
      recentlyViewed.insert(0, restaurant);

      if (recentlyViewed.length > 6) {
        recentlyViewed.removeLast();
      }
    }
  }

  // Очистка поля пошуку
  void resetSearch() {
    searchQuery.value = '';
    searchResults.clear();
    
  }
}

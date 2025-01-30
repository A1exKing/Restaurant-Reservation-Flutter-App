
import 'package:rest_reservation/models/address_model.dart';
import 'package:rest_reservation/models/menu_item.dart';
import 'package:rest_reservation/models/offer_models.dart';
import 'package:rest_reservation/models/table_model.dart';
import 'package:rest_reservation/models/working_hours.dart';


class Restaurant {
  final String name;
  final Address address;
  final String phone;
  final String description;
  final String website;
  final String cuisine;
  final double averageRating;
  final int reviewsCount;
  final String priceCategory;
  final bool deliveryAvailable;
  final bool pickupAvailable;
  final WorkingHours workingHours;
  final List<String> gallery;
  final List<Offer> offers;
  final Map<String, MenuItem> menu;
  final Map<String, Table> tables;

  Restaurant({
    required this.name,
    required this.address,
    required this.phone,
    required this.description,
    required this.website,
    required this.cuisine,
    required this.averageRating,
    required this.reviewsCount,
    required this.priceCategory,
    required this.deliveryAvailable,
    required this.pickupAvailable,
    required this.workingHours,
    required this.gallery,
    required this.offers,
    required this.menu,
    required this.tables,
  });

  // Функція для перетворення з JSON
  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      name: json['name'],
      address: Address.fromJson(json['address']),
      phone: json['phone'],
      description: json['description'],
      website: json['website'],
      cuisine: json['cuisine'],
      averageRating: (json['averageRating'] as num).toDouble(),
      reviewsCount: json['reviewsCount'],
      priceCategory: json['priceCategory'],
      deliveryAvailable: json['deliveryAvailable'],
      pickupAvailable: json['pickupAvailable'],
      workingHours: WorkingHours.fromJson(json['workingHours']),
      gallery: List<String>.from(json['gallery']),
      offers: (json['offers'] as List)
          .map((offer) => Offer.fromJson(offer))
          .toList(),
      menu: (json['menu'] as Map<String, dynamic>).map((key, value) =>
          MapEntry(key, MenuItem.fromJson(value as Map<String, dynamic>))),
      tables: (json['tables'] as Map<String, dynamic>).map((key, value) =>
          MapEntry(key, Table.fromJson(value as Map<String, dynamic>))),
    );
  }

  // Функція для перетворення в JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address.toJson(),
      'phone': phone,
      'description': description,
      'website': website,
      'cuisine': cuisine,
      'averageRating': averageRating,
      'reviewsCount': reviewsCount,
      'priceCategory': priceCategory,
      'deliveryAvailable': deliveryAvailable,
      'pickupAvailable': pickupAvailable,
      'workingHours': workingHours.toJson(),
      'gallery': gallery,
      'offers': offers.map((offer) => offer.toJson()).toList(),
      'menu': menu.map((key, value) => MapEntry(key, value.toJson())),
      'tables': tables.map((key, value) => MapEntry(key, value.toJson())),
    };
  }

  // Функція для перетворення з Firestore
  factory Restaurant.fromFirestore(Map<String, dynamic> data) {
    return Restaurant(
      name: data['name'] ?? '',
      address: Address.fromJson(data['address'] ?? {}),
      phone: data['phone'] ?? '',
      description: data['description'] ?? '',
      website: data['website'] ?? '',
      cuisine: data['cuisine'] ?? '',
      averageRating: (data['averageRating'] as num?)?.toDouble() ?? 0.0,
      reviewsCount: data['reviewsCount'] ?? 0,
      priceCategory: data['priceCategory'] ?? '',
      deliveryAvailable: data['deliveryAvailable'] ?? false,
      pickupAvailable: data['pickupAvailable'] ?? false,
      workingHours: WorkingHours.fromJson(data['workingHours'] ?? {}),
      gallery: List<String>.from(data['gallery'] ?? []),
      offers: (data['offers'] as List<dynamic>? ?? [])
          .map((offer) => Offer.fromJson(offer))
          .toList(),
      menu: (data['menu'] as Map<String, dynamic>? ?? {}).map((key, value) =>
          MapEntry(key, MenuItem.fromJson(value as Map<String, dynamic>))),
      tables: (data['tables'] as Map<String, dynamic>? ?? {}).map((key, value) =>
          MapEntry(key, Table.fromJson(value as Map<String, dynamic>))),
    );
  }
}

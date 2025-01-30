class MenuItem {
  final String name;
  final String description;
  final int price;
  final String category;
  final String imageUrl;
  final double rating;
  final int calories;
  final List<String> ingredients;
  final bool isVegan;
  final bool isGlutenFree;

  MenuItem({
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.calories,
    required this.ingredients,
    required this.isVegan,
    required this.isGlutenFree,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      name: json['name'],
      description: json['description'],
      price: json['price'],
      category: json['category'],
      imageUrl: json['imageUrl'],
      rating: (json['rating'] as num).toDouble(),
      calories: json['calories'],
      ingredients: List<String>.from(json['ingredients']),
      isVegan: json['isVegan'],
      isGlutenFree: json['isGlutenFree'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'imageUrl': imageUrl,
      'rating': rating,
      'calories': calories,
      'ingredients': ingredients,
      'isVegan': isVegan,
      'isGlutenFree': isGlutenFree,
    };
  }
}

import 'package:flutter/material.dart';
import 'package:rest_reservation/models/restaurant_model.dart';
import 'package:rest_reservation/pages/restaurant_detail_page/restaurant_details_page.dart';

class RestaurantsBigItem extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantsBigItem({
    super.key,
    required this.restaurant,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.circular(16), // Радіус для відповідності дизайну
        color: Colors.white, // Фон кнопки
        elevation: 2, // Невелика тінь для Material
        shadowColor: Color.fromARGB(113, 192, 192, 192),
        child: InkWell(
          
          borderRadius: BorderRadius.circular(16), // Радіус для ефекту хвилі
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailsPageRestaurant(
              restaurant: restaurant,
            )),
          ),
          splashColor: Color(0xff5B4CBD).withOpacity(0.2), // Колір ефекту натискання
          highlightColor: Colors.grey.withOpacity(0.1), // Колір при тривалому натисканні
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section with InkWell effect
              Ink(
                height: 140,
                 color: Color(0xfff6f6f6),
               // decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),
                child: Stack(
                  children: [
                    Image.network(
              restaurant.gallery.isNotEmpty
                          ? restaurant.gallery.first
                          : '',
             width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Center(
                  child: Icon(
                    Icons.broken_image,
                    color: Colors.grey,
                  ),
                
              ),
            ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Icon(Icons.favorite, color: Colors.red, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Text Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          restaurant.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.star_rounded,
                          color: Colors.amber,
                          size: 20,
                        ),
                        Text(
                         restaurant.averageRating.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Image.asset(
                          "assets/icons/location.png",
                          color: Color(0xff5B4CBD),
                          width: 18,
                        ),
                        SizedBox(width: 6),
                        Text(
                          restaurant.address.street,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(width: 26),
                        Image.asset(
                          "assets/icons/wallet.png",
                          color: Color(0xff5B4CBD),
                          width: 18,
                        ),
                        SizedBox(width: 6),
                        Text(
                         restaurant.priceCategory,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            fontWeight: FontWeight.w400,
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

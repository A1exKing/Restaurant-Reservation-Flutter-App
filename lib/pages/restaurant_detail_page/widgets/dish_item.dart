import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DishItem extends StatelessWidget {
  const DishItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Material(
        borderRadius: BorderRadius.circular(16.r), // Радіус для відповідності дизайну
        color: Colors.white, // Фон кнопки
        elevation: 2, // Невелика тінь для Material
        shadowColor: Color.fromARGB(113, 192, 192, 192),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r), // Радіус для ефекту хвилі
          onTap: () {
            // Додайте вашу логіку при натисканні, наприклад, перехід на іншу сторінку
          },
          splashColor: Color(0xff5B4CBD).withOpacity(0.2), // Колір хвилі
          highlightColor: Colors.grey.withOpacity(0.1), // Колір при тривалому натисканні
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section
              Ink(
                height: 110.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                  image: DecorationImage(
                    image: AssetImage("assets/images/italian-cuisine.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.all(12.h),
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Icon(Icons.favorite, color: Colors.red, size: 20),
                    ),
                  ),
                ),
              ),
              // Text Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Name Dish",
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
                          "4.6",
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
                          "assets/icons/wallet.png",
                          color: Color(0xff5B4CBD),
                          width: 18.w,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          "150 грн",
                          style: TextStyle(
                            fontSize: 14.sp,
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

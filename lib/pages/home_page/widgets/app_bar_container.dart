

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rest_reservation/pages/filter_page/filter_page.dart';
import 'package:rest_reservation/pages/search_page/search_page.dart';
import 'package:collection/collection.dart';


class AppBarContainer extends StatelessWidget {
   AppBarContainer({
    super.key,
    required this.whiteText14,
    required this.whiteText18Bold,
  });

  final TextStyle whiteText14;
  final TextStyle whiteText18Bold;
  RxBool hasFilters = false.obs;


  // Оголошуємо дефолтні фільтри
  final Map<String, dynamic> _defaultFilters = {
    "location": "All",
    "service": "All",
    "priceRange": ["All"],
    "review": "4.5 and above",
    "sort": "All"
  };
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 22, right: 22, bottom: 24),
      decoration: BoxDecoration(
        color: const Color(0xff5B4CBD),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: SafeArea(
        top: true,
        bottom: false,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Location", style: whiteText14),
                    Row(
                      children: [
                        Image.asset("assets/icons/location.png", width: 24, color: const Color(0xffE24601)),
                        const SizedBox(width: 6),
                        Text("New York", style: whiteText18Bold),
                        const SizedBox(width: 6),
                        Image.asset("assets/icons/down-chevron.png", width: 18, color: const Color(0xffE24601)),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color(0xff776AC7),
                  ),
                  child: Badge(
                    smallSize: 8,
                    backgroundColor: const Color(0xffE24601),
                    child: Image.asset("assets/icons/bell.png", width: 22, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Image.asset("assets/icons/search.png", width: 22, color: const Color(0xff5B4CBD)),
                        ),
                        Expanded(
                          child: TextField(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => SearchPage())),
                            readOnly: true,
                            onTapOutside: (e) => FocusScope.of(context).unfocus(),
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
                ),
                const SizedBox(width: 12),
                Material(
                  borderRadius: BorderRadius.circular(9),
                  color: Colors.white,
                  child: InkWell(
                    onTap: () async {
                      final result = await Get.to(() => const FilterPage());
                      if (result != null) {
                        print("Selected filters: $result");

                        // Перевіряємо, чи result = _defaultFilters
                        final equals = const DeepCollectionEquality().equals(result, _defaultFilters);
                        if (equals) {
                          // Якщо збігається з дефолтом
                          hasFilters.value = false;
                        } else {
                          // Якщо користувач щось змінив
                          hasFilters.value = true;
                        }
                      }
                    },
                    borderRadius: BorderRadius.circular(9),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Obx(() {
                        return Badge(
                          smallSize: 9,
                          isLabelVisible: hasFilters.value,
                          backgroundColor: Colors.redAccent,
                          child: Image.asset(
                            "assets/icons/filter.png",
                            width: 22,
                            color: const Color(0xff5B4CBD),
                          ),
                        );
                      }),
                    ),
                  ),
                )

              ],
            ),
          ],
        ),
      ),
    );
  }
}

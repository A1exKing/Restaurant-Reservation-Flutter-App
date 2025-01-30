
import 'package:flutter/material.dart';
import 'package:rest_reservation/pages/restaurant_detail_page/widgets/filter_widget.dart';

class SearchAndFilter extends SliverPersistentHeaderDelegate {
   final bool isScrollingUp;
  SearchAndFilter({required this.isScrollingUp});
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    // TODO: implement build
     final currentHeight = maxExtent - shrinkOffset;
      final visibleHeight = isScrollingUp ? currentHeight : 0.8;
    final opacity = isScrollingUp ? 1.0 : 0.0;
     final availableHeight = (maxExtent - shrinkOffset).clamp(minExtent, maxExtent);
    print(isScrollingUp);
     print("shrinkOffset");
     print(shrinkOffset);
    return  SizedBox(
      height: availableHeight,
      child: Opacity(
        opacity: shrinkOffset > 10 ? opacity : 1,
        child: Container(
      child: ww())));
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => 150;

  @override
  // TODO: implement minExtent
  double get minExtent => 150;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    // TODO: implement shouldRebuild
   return true;
  }
}

class ww extends StatelessWidget {
  const   ww({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
    height: 200,
      child: Column(
                  mainAxisSize: MainAxisSize.min,
                 
                    children: [
                      Padding(
                      padding: const EdgeInsets.only(left: 24, right: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Menu",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff1F1F1F)),
                          ),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.all(0),
                                splashFactory: NoSplash.splashFactory),
                            child: Text(
                              "View Full Menu",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff5B4CBD)),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                margin: EdgeInsets.symmetric(horizontal: 24),
                height: 42,
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(9),
                   color: Color(0xffF6F6F6),
                 ),
                 child: Row(
                   children: [
                     Padding(
                       padding: const EdgeInsets.only(left: 12),
                       child: Image.asset("assets/icons/search.png", width: 22, color: const Color(0xff5B4CBD)),
                     ),
                     Expanded(
                       child: TextField(
                         onTapOutside: (e) => FocusScope.of(context).unfocus(),
                         decoration: const InputDecoration(
                           hintText: 'Search item',
                           hintStyle: TextStyle(color: Color(0xff797979)),
                           contentPadding: EdgeInsets.symmetric(horizontal: 9, vertical: 10),
                           border: InputBorder.none,
                         ),
                       ),
                     ),
                   ],
                 ),
               ),
               SizedBox(height: 8,),
               MenuFilterChips(),
                    ],
                  ), // Пере
    );
  }
}


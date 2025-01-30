import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rest_reservation/models/restaurant_model.dart';
import 'package:rest_reservation/pages/book_a_table_page/book_a_table_page.dart';
import 'package:rest_reservation/pages/restaurant_detail_page/widgets/dish_item.dart';
import 'package:rest_reservation/pages/restaurant_detail_page/widgets/search_and_filter.dart';
import 'package:rest_reservation/pages/restaurant_detail_page/widgets/sliver_app_bar.dart';

class DetailsPageRestaurant extends StatefulWidget {
  final Restaurant restaurant;

  const DetailsPageRestaurant({Key? key, required this.restaurant})
      : super(key: key);


  @override
  State<DetailsPageRestaurant> createState() => _DetailsPageRestaurantState();
}
class _DetailsPageRestaurantState extends State<DetailsPageRestaurant>
    with SingleTickerProviderStateMixin {

  late TabController controller;
  late ScrollController _scrollController;
  bool _isScrollingUp = true;
  double _lastOffset = 0.0;
  @override
  void initState() {
    super.initState();
    controller = TabController(length: 4, vsync: this);

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      final currentOffset = _scrollController.offset;
      if (currentOffset > _lastOffset) {
        if (_isScrollingUp) {
          setState(() {
            _isScrollingUp = false;
          });
        }
      } else {
        if (!_isScrollingUp) {
          setState(() {
            _isScrollingUp = true;
          });
        }
      }
      _lastOffset = currentOffset;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Завжди звільняйте ScrollController
    controller.dispose(); // Завжди звільняйте TabController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      final restaurant = widget.restaurant;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBarRes(restaurant: restaurant,),
              TabBarRestaurant(controller: controller),
              SliverPersistentHeader(
                pinned: true,
                delegate: SearchAndFilter(isScrollingUp: _isScrollingUp),
              ),
              // SliverToBoxAdapter(
              //   child: TabBarView(
              //     physics: NeverScrollableScrollPhysics(),
              //     controller: controller,
              //     children: [
              //          Container(),
              //         Container(),
              //         Container(),
              //         Container()
              //     ]
              //   ),
              // ),
              GridDishItems(),
            ],
          ),
          BottomBotton(),
        ],
      ),
    );
  }
}


class TabBarRestaurant extends StatelessWidget {
  const TabBarRestaurant({
    super.key,
    required this.controller,
  });

  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 30,
        child: TabBar(
          
          controller: controller,
          isScrollable: true,
          labelColor: Color(0xff5B4CBD),
          unselectedLabelColor: Color.fromARGB(255, 116, 116, 116),
          indicatorColor: Color(0xff5B4CBD),
          labelStyle: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w500),
          indicatorWeight: 2,
          padding: const EdgeInsets.only(left: 0, top: 0),
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorPadding: EdgeInsets.only(top: 26, ),
          indicator: BoxDecoration(
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(8)),
              color: Color(0xff5B4CBD)),
          labelPadding:
              const EdgeInsets.only(left: 14, right: 14, bottom: 8, top: 0),
          tabs: const [
            Text("Menu"),
            Text("About"),
            Text("Gallery"),
            Text("Review"),
          ],
        ),
      ),
    );
  }
}

class GridDishItems extends StatelessWidget {
  const GridDishItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding:  EdgeInsets.symmetric(horizontal: 16.0.w),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          //  mainAxisExtent: 190.h,
            crossAxisSpacing: 10.h,
            childAspectRatio: 0.86),
        delegate: SliverChildBuilderDelegate(
          (context, index) => DishItem(),
          childCount: 18,
        ),
      ),
    );
  }
}


class BottomBotton extends StatelessWidget {
  const BottomBotton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding:
            EdgeInsets.only(top: 12.h, left: 24, right: 18, bottom: 24.h),
        height: 88.h,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
            boxShadow: [
              BoxShadow(
                  color: const Color.fromARGB(115, 157, 157, 157),
                  offset: Offset(0, -1),
                  blurRadius: 18)
            ]),
        child: ElevatedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TableBookingPage())),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff5B4CBD),
            ),
            child: Text(
              "Book a Table",
              style: TextStyle(color: Colors.white, fontSize: 18.h),
            )),
      ),
    );
  }
}

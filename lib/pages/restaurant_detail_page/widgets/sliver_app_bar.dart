import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rest_reservation/models/restaurant_model.dart';

class SliverAppBarRes extends StatelessWidget {
  final Restaurant restaurant;

  SliverAppBarRes({
    Key? key,
    required this.restaurant,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 420.h - MediaQuery.of(context).padding.top.h,
      elevation: 0,
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      actions: [
        const _ActionCircle(icon: Icons.share),
        Padding(
          padding: EdgeInsets.only(right: 16.w, left: 12.w),
          child: const _ActionCircle(icon: Icons.favorite_outline_rounded),
        ),
      ],
      leading: Padding(
        padding: EdgeInsets.only(left: 16.w),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const _ActionCircle(icon: Icons.chevron_left),
        ),
      ),
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return FlexibleSpaceBar(
            collapseMode: CollapseMode.pin,
            stretchModes: const [StretchMode.blurBackground],
            background: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Верхній блок із зображенням
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Image.network(
                      restaurant.gallery.isNotEmpty
                          ? restaurant.gallery.first
                          : 'https://img.freepik.com/free-photo/interior-shot-cafe-with-chairs-near-bar-with-wooden-tables_181624-1669.jpg?t=st=1737744061~exp=1737747661~hmac=5db43f555df8b4ad751829589a38a39d0b2aa9b4f0d4882e26f8473168315387&w=20000',
                      height: 320.h - MediaQuery.of(context).padding.top.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Image.asset("assets/images/splash.jpeg"),
                    ),
                    Positioned(
                      bottom: -1,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 12.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(18.r)),
                        ),
                      ),
                    )
                  ],
                ),
                // Контент
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          if (restaurant.offers.isNotEmpty)
                            _DiscountBadge(
                              discount: restaurant.offers.first.discount,
                            ),
                          const Spacer(),
                          Row(
                            children: [
                              Image.asset(
                                "assets/icons/star.png",
                                color: Colors.amber,
                                width: 16.h,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                "${restaurant.averageRating.toStringAsFixed(1)} (${restaurant.reviewsCount} reviews)",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black45,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        restaurant.name,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      _InfoRow(
                        items: [
                          const _InfoItem(
                            icon: Icons.timer,
                            text: "15 min",
                          ),
                          _InfoItem(
                            asset: "assets/icons/wallet.png",
                            text: restaurant.priceCategory,
                          ),
                          _InfoItem(
                            asset: "assets/icons/cuisines.png",
                            text: restaurant.cuisine,
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Image.asset(
                            "assets/icons/location.png",
                            color: const Color(0xff5B4CBD),
                            width: 18.w,
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              "${restaurant.address.street}, ${restaurant.address.city}",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black45,
                              ),
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
          );
        },
      ),
    );
  }
}

class _ActionCircle extends StatelessWidget {
  final IconData icon;

  const _ActionCircle({required this.icon});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      child: Icon(icon, color: Colors.black),
    );
  }
}

class _DiscountBadge extends StatelessWidget {
  final String discount;

  const _DiscountBadge({required this.discount});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffF5F5F5),
        borderRadius: BorderRadius.circular(8.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      child: Text(
        discount,
        style: TextStyle(color: Color(0xff03AC45), fontSize: 12.sp),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final List<_InfoItem> items;

  const _InfoRow({required this.items});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: items.expand((item) {
        return [
          item,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Icon(
              Icons.circle,
              size: 6.w,
              color: const Color.fromARGB(255, 99, 99, 99),
            ),
          ),
        ];
      }).toList()
        ..removeLast(),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData? icon;
  final String? asset;
  final String text;

  const _InfoItem({this.icon, this.asset, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null)
          Icon(icon, color: const Color(0xff5B4CBD), size: 18.w),
        if (asset != null)
          Image.asset(asset!, color: const Color(0xff5B4CBD), width: 18.w),
        SizedBox(width: 4.w),
        Text(
          text,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black45,
          ),
        ),
      ],
    );
  }
}

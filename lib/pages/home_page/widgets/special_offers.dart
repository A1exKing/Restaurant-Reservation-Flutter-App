
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SpecialOffersContainer extends StatefulWidget {
  const SpecialOffersContainer({
    super.key,
  });

  @override
  State<SpecialOffersContainer> createState() => _SpecialOffersContainerState();
}

class _SpecialOffersContainerState extends State<SpecialOffersContainer> {
  final controller = PageController(viewportFraction: 1, keepPage: true);
  final pages = List.generate(
      4,
      (index) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage("https://img.freepik.com/free-psd/web-banner-template-japanese-restaurant_23-2148203260.jpg?t=st=1737581479~exp=1737585079~hmac=2ea6190a7f10e1dad9cc9b91db79f06c7509405cd434b0843b518bcb5522fee2&w=2000"))
            ),
            margin: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
            child: SizedBox(
              height: 160,
              child: Center(
                  child: Text(
                "Page $index",
                style: TextStyle(color: Colors.indigo),
              )),
            ),
          ));
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: controller,
            // itemCount: pages.length,
            itemBuilder: (_, index) {
              return pages[index % pages.length];
            },
          ),
        ),

        SmoothPageIndicator(
          controller: controller,
          count: pages.length,
          effect: const WormEffect(
            dotHeight: 10,
            dotWidth: 10,
            activeDotColor: Color(0xff5B4CBD),
            dotColor: Color(0xffE3E3E3),
            type: WormType.thinUnderground,
          ),
        ),
      ],
    );
  }
}

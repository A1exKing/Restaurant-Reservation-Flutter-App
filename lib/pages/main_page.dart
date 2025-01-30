import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rest_reservation/pages/home_page/home_page.dart';
import 'package:rest_reservation/pages/search_page/search_page.dart';
class MainPageController extends GetxController {
  var currentIndex = 0.obs; // Поточний індекс активної вкладки

  void changeTab(int index) {
    currentIndex.value = index;
  }
  void handleBackAction(String previousRoute) {
    print(previousRoute);
    if (previousRoute.isEmpty || previousRoute == "/Home") {
      changeTab(0); // Повернутися на Home
    } else {
      Get.back(); // Закрити сторінку
    }
  }
}

class MainPage extends StatelessWidget {
  final MainPageController controller = Get.put(MainPageController());

  final List<Widget> pages = [
    HomePage(),
    SearchPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: IndexedStack(
            index: controller.currentIndex.value,
            children: pages,
          ),
      bottomNavigationBar: Container(
      
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
           boxShadow: [
              BoxShadow(
                  color: const Color.fromARGB(159, 196, 196, 196),
                  offset: Offset(0, -1),
                  blurRadius: 18)
            ],
        ),
        child: SizedBox(
          height: 100,
          child: BottomNavigationBar(
            selectedFontSize: 12,
            unselectedFontSize: 12,
            backgroundColor: Colors.white,
            selectedItemColor:  Color(0xff5B4CBD),
            elevation: 1,
          
            currentIndex: controller.currentIndex.value,
            onTap:  controller.changeTab,
            items: [
              BottomNavigationBarItem(
                icon: Stack(
                  alignment: Alignment.topCenter,
                  clipBehavior: Clip.none,
                // fit: StackFit.passthrough,
                  children: [
                    Positioned(
                      top: -13,
                      child: Container(
                        
                        height: 9,
                        width: 20,
                        decoration: BoxDecoration(
                          color:  controller.currentIndex.value == 0 ? Color(0xff5B4CBD) : Colors.transparent,
                          borderRadius: BorderRadius.vertical(bottom: Radius.circular(18))
                        ),
                      ),
                    ),
                    Icon(Icons.home),
                  ],
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon:  Stack(
                  alignment: Alignment.topCenter,
                  clipBehavior: Clip.none,
                // fit: StackFit.passthrough,
                  children: [
                    Positioned(
                       top: -13,
                      child: Container(
                        
                        height: 9,
                        width: 20,
                        decoration: BoxDecoration(
                          color:  controller.currentIndex.value == 1 ? Color(0xff5B4CBD) : Colors.transparent,
                          borderRadius: BorderRadius.vertical(bottom: Radius.circular(18))
                        ),
                      ),
                    ),
                    
                    Icon(Icons.search),
                  ],
                ),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon:  Stack(
                  alignment: Alignment.topCenter,
                  clipBehavior: Clip.none,
                // fit: StackFit.passthrough,
                  children: [
                    Positioned(
                      top: -13,
                      child: Container(
                        
                        height: 9,
                        width: 20,
                        decoration: BoxDecoration(
                          color:  controller.currentIndex.value == 2 ? Color(0xff5B4CBD) : Colors.transparent,
                          borderRadius: BorderRadius.vertical(bottom: Radius.circular(18))
                        ),
                      ),
                    ),
                    Icon(Icons.person),
                  ],
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    ));
  }
}



class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
   return Scaffold(
    backgroundColor: Colors.green,
      body: Center(child: Text("Profile")),
    );
  }
}
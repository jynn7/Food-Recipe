import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe/view/reusable_layout/add_recipe_page.dart';
import 'package:food_recipe/view/reusable_layout/edit_recipe_page.dart';
import 'package:food_recipe/view/reusable_layout/home_page.dart';
import 'package:get/get.dart';

import '../../controller/recipe_controller.dart';

class BottomNavigationMenu extends StatelessWidget{
  const BottomNavigationMenu({super.key});


  @override
  Widget build(BuildContext context) {
    final controller=Get.find<NavigationController>();
    return Obx(
      () => NavigationBar(
        elevation: 20,
        selectedIndex: controller.selectedIndex.value,
        onDestinationSelected: (index){
          controller.selectedIndex.value=index;
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.add_outlined), label: 'Add Recipe'),
        ],
      ),
    );
  }

}

class NavigationController extends GetxController{
  final Rx<int>selectedIndex=0.obs;
  final List<Widget>screens=[
    HomePage(),
    AddRecipePage(),
  ];
  //Widget get currentScreen=>screens[selectedIndex.value];
  Widget currentScreen(){
    return screens[selectedIndex.value];
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe/view/reusable_layout/bottom_navigation_menu.dart';
import 'package:get/get.dart';
import '../../controller/recipe_controller.dart';
import '../reusable_layout/appbar.dart';

class MobileBody extends StatefulWidget{
  const MobileBody({Key?key}):super(key:key);

  @override
  _MobileBodyState createState()=>_MobileBodyState();

}

class _MobileBodyState extends State<MobileBody>{
  final NavigationController controller=Get.put(NavigationController());
  //final NavigationController controller=Get.find<NavigationController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(),
      body: Obx(
        () => controller.currentScreen(),
      ),
      bottomNavigationBar: const BottomNavigationMenu(),
    );
  }
}
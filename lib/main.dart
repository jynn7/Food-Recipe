import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe/floor/floor_database/app_database_manager.dart';
import 'package:food_recipe/floor/floor_database/recipe_database.dart';
import 'package:food_recipe/view/home_page_view.dart';
import 'package:food_recipe/view/reusable_layout/bottom_navigation_menu.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'controller/recipe_controller.dart';

Future<void>main()async{
  await WidgetsFlutterBinding.ensureInitialized();
  final RecipeController recipeController=Get.put(RecipeController());
  final NavigationController controller=Get.put(NavigationController());
  final database=await AppDatabaseManager.getDatabaseInstance();
  await _requestStoragePermission();
  runApp(const FoodRecipeMain());
}

Future<void> _requestStoragePermission() async {
  DeviceInfoPlugin deviceInfoPlugin=DeviceInfoPlugin();
  AndroidDeviceInfo androidDeviceInfo=await deviceInfoPlugin.androidInfo;
  // Check if the platform is Android
  if (Platform.isAndroid) {
    print('platform version ==== ${Platform.operatingSystemVersion}');
    // Check if the storage permission is already granted
    if (await Permission.storage.isGranted) {
      print('Storage permission already granted.');
      return;
    }
    // Check for Android version
    if (androidDeviceInfo.version.sdkInt>=33) { // Android 13 (API 33) or above
      // Request photos permission
      var status = await Permission.photos.request();
      if (status.isGranted) {
        print('Photos permission granted.');
      }
      else if (status.isDenied) {
        // If the permission was denied, show a dialog or handle accordingly
        print('Photos permission denied. Showing settings.');
        openAppSettings();
      } else if (status.isPermanentlyDenied) {
        print('Photos permission permanently denied. Showing settings.');
        openAppSettings(); // Open app settings for permanently denied permissions
      }
    }
    else {
      // For below Android 13
      var status = await Permission.storage.request();
      if (status.isGranted) {
        print('Storage permission granted.');
      }
      else if (status.isDenied) {
        print('Storage permission denied. Showing settings.');
        openAppSettings(); // Open app settings for denied permissions
      }
      else if (status.isPermanentlyDenied) {
        print('Storage permission permanently denied. Showing settings.');
        openAppSettings(); // Open app settings for permanently denied permissions
      }
    }
  } else {
    // Handle other platforms or provide a fallback
    print('Not running on Android.');
  }
}

class FoodRecipeMain extends StatelessWidget{
  const FoodRecipeMain({super.key});

  @override
  Widget build(BuildContext context){
    return GetMaterialApp(
      title: 'Food Recipe',
      theme: ThemeData(
        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: const HomePageView(),
    );
  }
}
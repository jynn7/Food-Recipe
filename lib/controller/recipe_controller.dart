import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:food_recipe/floor/floor_database/app_database_manager.dart';
import 'package:food_recipe/model/recipe_model.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class RecipeController{
  ValueNotifier<List<Recipe>> filteredList = ValueNotifier<List<Recipe>>([]);
  List<Recipe>recipeList=[];
  //List<Recipe>filteredList=[];

  void notifyChanges() {
    filteredList.notifyListeners(); // Notify listeners of changes
  }

  Future<void> copyAssetImagesToDownloadFolder() async {
    // Request permission to write to storage
    if (await Permission.storage.request().isGranted || await Permission.photos.request().isGranted) {
      try {
        // List of asset image paths
        List<String> assetImagePaths = [
          'android/lib/assets/images/nasi_lemak.jpg',
          'android/lib/assets/images/chicken_salad.jpg',
          'android/lib/assets/images/chicken_soup.jpg',
          'android/lib/assets/images/chocolate_cake.jpg',
          'android/lib/assets/images/fried_chicken.jpg',
          'android/lib/assets/images/fried_crab.jpg',
          'android/lib/assets/images/kiwi_juice.jpg',
          'android/lib/assets/images/Spaghetti.jpg',
          'android/lib/assets/images/vegeterian_noodles.jpg',
        ];

        // Get the path to the downloads directory
        Directory? downloadsDirectory;
        if (Platform.isAndroid) {
          downloadsDirectory = Directory('/storage/emulated/0/Download');
        }
        else if (Platform.isIOS) {
          downloadsDirectory = await getApplicationDocumentsDirectory(); // For iOS, use the app's doc folder
        }

        if (downloadsDirectory != null) {
          for (String assetPath in assetImagePaths) {
            // Load the asset as byte data
            final byteData = await rootBundle.load(assetPath);

            // Get the file name from the asset path
            String fileName = assetPath.split('/').last.toString();

            // Create a file in the download directory
            final file = File('${downloadsDirectory.path}/$fileName');

            // Write the byte data to the file
            await file.writeAsBytes(byteData.buffer.asUint8List());

            print("Image saved to: ${file.path}");
          }

          print("All images downloaded successfully!");
        }
      }
      catch (e) {
        print("Failed to save images: $e");
      }

    } else {
      print("Permission denied.");
    }
  }
  ///add dummy data
  Future<void>addDummyData()async{
    final String response=await rootBundle.loadString('lib/JSON/dummydata.json');
    final List<dynamic>dummyData=jsonDecode(response);
    for(var recipe in dummyData){
      String recipeName = recipe['recipeName'];
      String recipeDesc = recipe['recipeDesc'];
      String recipeTypes = recipe['recipeTypes'];
      String ingredients = recipe['ingredients'];
      String preparationSteps = recipe['preparationSteps'];
      String picturePath = recipe['picturePath'];

      // Add the recipe into the database
      await addRecipe(
          recipeName,
          recipeDesc,
          recipeTypes,
          ingredients,
          preparationSteps,
          picturePath
      );
    }
  }
  //read JSON recipe type list
  Future<dynamic>readRecipeTypeList()async{
    try{
      final String jsonResponse=await rootBundle.loadString('lib/JSON/recipetypes.json');
      final data=await json.decode(jsonResponse);
      return data;

    }
    catch(e){
      log('Error loading JSON DUE TO $e');
      return null;
    }

  }

  //Read food recipe from database
  Future<void>readRecipe() async {
    final database=await AppDatabaseManager.getDatabaseInstance();
    final recipeDao=database.recipeModelDao;
    recipeList=await recipeDao.findAllRecipe();
    filteredList.value=List.from(recipeList);
    for(var recipe in recipeList){
      log('Recipe '+ recipe.recipeName);
    }
  }

  //add food recipe
  Future<void>addRecipe(String recipeName,String recipeDesc,String recipeTypes,String ingredients, String preparationSteps,String picturePath)async{
    //recipeList.add(Recipe(recipeName: recipeName,recipeDesc: recipeDesc,recipeTypes: recipeTypes, ingredients: ingredients, preparationSteps: preparationSteps, picturePath: picturePath,));
    //filteredList.add(Recipe(recipeName: recipeName,recipeDesc: recipeDesc,recipeTypes: recipeTypes, ingredients: ingredients, preparationSteps: preparationSteps, picturePath: picturePath));
    final database=await AppDatabaseManager.getDatabaseInstance();
    final recipeDao=database.recipeModelDao;
    Recipe recipe=Recipe(recipeName: recipeName, recipeDesc: recipeDesc, recipeTypes: recipeTypes, ingredients: ingredients, preparationSteps: preparationSteps, picturePath: picturePath);
    await recipeDao.insertRecipe(recipe);
    await readRecipe();
    for(int i=0;i<recipeList.length;i++){
      log(recipeList[i].recipeName.toString());
    }

  }

  //delete food recipe
  Future<void>deleteRecipe(int index)async{
    if(index>=0 && index<filteredList.value.length){
      final database=await AppDatabaseManager.getDatabaseInstance();
      final recipeDao=database.recipeModelDao;
      final recipeId=filteredList.value[index].id;
      if(recipeId!=null){
        recipeDao.deleteRecipeById(recipeId);
        await readRecipe();
      }
      else{
        print('Index out of bound: $index');
      }
    }
    else{
      print('Index out of bound: $index');
    }

  }
  //edit food recipe
  Future<void>editRecipe(int index,String recipeName,String recipeDesc,String recipeTypes,String ingredients, String preparationSteps,String picturePath)async{
    if(index>=0 && index<filteredList.value.length){
      int id=filteredList.value[index].id ?? 0;
      if(id==0){
        return;
      }
      else{
        final database=await AppDatabaseManager.getDatabaseInstance();
        final recipeDao=database.recipeModelDao;
        await recipeDao.updateRecipe(id, recipeName, recipeDesc,recipeTypes, ingredients, preparationSteps,picturePath);
        await readRecipe();
      }

    }
    else{
      print('Index out of bound: $index');
    }

  }

  //filter process
  Future<void>filterRecipe(String selectedRecipe)async{
    log('Selected recipe: $selectedRecipe');
    if(selectedRecipe=='All'){
      readRecipe();
    }
    else{
      List<Recipe> newFilteredList = [];
      for(var recipe in recipeList){
        if(recipe.recipeTypes==selectedRecipe){
          newFilteredList.add(recipe);
        }
        else{
          log('Recipe removed: ${recipe.recipeTypes}');
        }
      }
      filteredList.value=newFilteredList;

    }


  }

}
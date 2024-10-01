import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:food_recipe/model/recipe_model.dart';
import 'package:food_recipe/view/reusable_layout/edit_recipe_page.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe/controller/recipe_controller.dart';

class HomePage extends StatefulWidget{
  @override
  _HomePageState createState()=>_HomePageState();

}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver{
  final recipeController=Get.find<RecipeController>();
  TextEditingController subtitleController=TextEditingController();
  SearchController searchController=SearchController();
  ValueNotifier<String?> selectedRecipe=ValueNotifier<String?>('All');
  List<DropdownMenuItem<String>> recipeTypeList = [];

  @override
  void initState(){
    super.initState();
    //read database and load the data to ui
    loadRecipeList();
    loadRecipeType();
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    // This will run after the context is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showAddDummyDataDialog();
    });
  }

  Future<void> loadRecipeType() async {
    try {
      final data=await recipeController.readRecipeTypeList();
      if(data!=null){
        final List<String> recipeTypes=List<String>.from(data["recipe_types"]);
        setState(() {
          recipeTypeList = recipeTypes.map<DropdownMenuItem<String>>((type) {
            return DropdownMenuItem<String>(
              value: type,
              child: Text(type),
            );
          }).toList();
          recipeTypeList.add(
            const DropdownMenuItem<String>(
              value: 'All',
              child: Text('All'),
            )
          );
        });
      }

    }
    catch (e) {
      log('Error loading recipe types: $e');
    }
    finally {
      // Ensure that we return if needed
      return; // This is optional since void methods don't need an explicit return
    }
  }

  //logic process of read database initial runtime
  Future<void> loadRecipeList() async {
    try {
      await recipeController.readRecipe();
      setState(() {});
    }
    catch (e) {
      log('Error loading recipe types: $e');
    }
    finally {
      // Ensure that we return if needed
      return; // This is optional since void methods don't need an explicit return
    }
  }

  void showAddDummyDataDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add Dummy Data"),
          content: const Text("Do you want to add dummy data for testing purposes?"),
          actions: [
            TextButton(
              onPressed: () async{
                // Add dummy data logic
                await recipeController.copyAssetImagesToDownloadFolder();
                recipeController.addDummyData();

                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Add"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without doing anything
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }


  void showRecipeDetails(int index,var screenHeight, var screenWidth){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return Align(
          alignment: Alignment.center,
          child: Container(
            color: Color(0xFFFFFBEA),
            height: screenHeight*0.6,
            width: screenWidth*0.8,
            padding: EdgeInsets.fromLTRB(screenWidth*0.05, screenHeight*0.01, screenWidth*0.05, screenHeight*0.01),
            child: ListView(
              shrinkWrap: true,
              children: [
                Text(
                  recipeController.filteredList.value[index].recipeName.toString(),
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  //color: Colors.purple,
                  height: screenHeight*0.2,
                  width: screenWidth*0.5,
                  child: Image.file(
                    File(recipeController.filteredList.value[index].picturePath),
                  ),
                ),
                SizedBox(height: screenHeight*0.01),
                Text(
                  recipeController.filteredList.value[index].recipeDesc.toString(),
                  style: TextStyle(
                      fontSize: 20
                  ),
                ),
                SizedBox(height: screenHeight*0.02),
                Text(
                  'Recipe Type',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(screenWidth*0.02, screenHeight*0.01, screenWidth*0.02, screenHeight*0.01),
                  width: screenWidth,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white, // Optional background color
                    border: Border.all(
                      color: Colors.lime, // Border color
                      width: 2.0, // Border width
                    ),
                    borderRadius: BorderRadius.circular(10), // Optional: Rounded corners
                  ),
                  child: Text(
                    recipeController.filteredList.value[index].recipeTypes.toString(),
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight*0.02),
                Text(
                  'Ingredient Required',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(screenWidth*0.02, screenHeight*0.01, screenWidth*0.02, screenHeight*0.01),
                  width: screenWidth,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white, // Optional background color
                    border: Border.all(
                      color: Colors.lime, // Border color
                      width: 2.0, // Border width
                    ),
                    borderRadius: BorderRadius.circular(10), // Optional: Rounded corners
                  ),
                  child: Text(
                    recipeController.filteredList.value[index].ingredients,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight*0.02),
                Text(
                  'Recipe Detail Steps',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(screenWidth*0.02, screenHeight*0.01, screenWidth*0.02, screenHeight*0.01),
                  width: screenWidth,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white, // Optional background color
                    border: Border.all(
                      color: Colors.lime, // Border color
                      width: 2.0, // Border width
                    ),
                    borderRadius: BorderRadius.circular(10), // Optional: Rounded corners
                  ),
                  child: Text(
                    recipeController.filteredList.value[index].preparationSteps,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),

              ],
            ),
          ),

        );
      }
    );
  }

  void showEditPage(BuildContext context,int index){
    showModalBottomSheet(
      context: context,
      builder: (context){
        return EditRecipePage(
          index: index,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height
        - MediaQuery.of(context).padding.top
        - kToolbarHeight
        - kBottomNavigationBarHeight;

    return Container(
      //color: Color(0xFFFDEBD0),
      color: Color(0xFFE8F5E9),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(screenWidth*0.05, screenHeight*0.01, screenWidth*0.05, screenHeight*0.01),
            child: Row(
              children: [
                Expanded(
                  flex: 9,
                  child: Container(
                    height: screenHeight*0.09,
                    padding: EdgeInsets.fromLTRB(screenWidth*0.01, screenHeight*0.01, screenWidth*0.01, screenHeight*0.01),
                    child: SearchBar(
                      controller: searchController,
                      hintText: 'Search with food name',
                      backgroundColor:  WidgetStateProperty.all(Color(0xFFE0F7FA)),
                      //controller: controller,
                      leading: Icon(Icons.search),
                      trailing: [
                        IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            searchController.clear();
                            recipeController.filteredList.value.clear();
                            recipeController.filterRecipe(selectedRecipe.value!);
                            setState(() {});
                          },
                        ),
                      ],
                      onTap: () {
                        //selectedRecipe='All';
                        setState(() {});
                      },
                      onChanged: (value) async {
                        // Update suggestions based on input

                        log('search value changed = ${value.toString()}');
                        if(value==''){
                          await recipeController.filterRecipe(selectedRecipe.value!);
                          return;
                        }

                        List<Recipe>tempList=List.from(recipeController.filteredList.value);
                        recipeController.filteredList.value.clear();
                        for(int i=0;i<tempList.length;i++){
                          //if contain the value then add to filtered list
                          String curRecipe=tempList[i].recipeName.toString().toLowerCase();
                          if(curRecipe.contains(value.toLowerCase())){
                            recipeController.filteredList.value.add(tempList[i]);
                          }
                        }


                        /*
                        recipeController.filteredList.value.clear();
                        for(int i=0;i<recipeController.recipeList.length;i++){
                          //if contain the value then add to filtered list
                          String curRecipe=recipeController.recipeList[i].recipeName.toString().toLowerCase();
                          if(curRecipe.contains(value.toLowerCase())){
                            recipeController.filteredList.value.add(recipeController.recipeList[i]);
                          }
                        }

                         */

                        setState(() {});
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(),
                ),
                IntrinsicWidth(
                  child: Card(
                    elevation: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.amber[50],
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      padding: EdgeInsets.fromLTRB(screenWidth*0.01, screenHeight*0.01, screenWidth*0.01, screenHeight*0.01),
                      child: DropdownButton<String>(
                        value: selectedRecipe.value, // Set the currently selected value
                        items: recipeTypeList,
                        iconEnabledColor: Colors.green,
                        onChanged: (String? newRecipe) async {
                          setState((){
                            searchController.text='';
                            selectedRecipe.value = newRecipe; // Update the selected value
                          });
                          await recipeController.filterRecipe(selectedRecipe.value!);
                          setState(() {});
                        },
                        hint: Text('Select Recipe Type'), // Optional hint text
                      ),
                    ),
                  ),

                ),
              ],
            ),
          ),

          Expanded(
            flex: 10,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: screenHeight * 0.02, horizontal: 0),
              child: ValueListenableBuilder<List<Recipe>>(
                valueListenable: recipeController.filteredList,
                builder: (context, filteredList, _) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          print('Container clicked! $index');
                          showRecipeDetails(index, screenHeight, screenWidth);
                        },
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            screenWidth * 0.05,
                            screenHeight * 0.01,
                            screenWidth * 0.05,
                            screenHeight * 0.01,
                          ),
                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: IntrinsicHeight(
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                                decoration: BoxDecoration(
                                  color: Color(0xFFFFFBEA),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 8.0,
                                      offset: Offset(4.0, 4.0),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Row 1
                                    Container(
                                      padding: EdgeInsets.fromLTRB(screenWidth * 0.01, screenHeight * 0.01, screenWidth * 0.05, screenHeight * 0.01),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: screenWidth*0.035),
                                            width: screenWidth * 0.35,
                                            child: Text(
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              filteredList[index].recipeName.toString(),
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed: () async {
                                              showEditPage(context, index);
                                              recipeController.notifyChanges();  // Notify updates in controller
                                            },
                                          ),
                                          Spacer(),
                                          IconButton(
                                            icon: Icon(Icons.delete_outline),
                                            color: Colors.red,
                                            onPressed: () async {
                                              await recipeController.deleteRecipe(index);
                                              recipeController.notifyChanges();  // Notify after deletion
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Row 2
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(screenWidth * 0.05, screenHeight * 0.0005, screenWidth * 0.05, screenHeight * 0.0005),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Text(
                                              filteredList[index].recipeDesc.toString(),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 4,
                                              textAlign: TextAlign.justify,
                                            ),
                                            width: screenWidth * 0.4,
                                            height: screenHeight * 0.1,
                                          ),
                                          Container(
                                            width: screenWidth * 0.3,
                                            height: screenHeight * 0.12,
                                            margin: EdgeInsets.symmetric(vertical: screenWidth * 0.00005, horizontal: screenHeight * 0.018),
                                            child: Opacity(
                                              opacity: 0.4,
                                              child: Image.file(
                                                File(filteredList[index].picturePath.toString()),
                                                fit: BoxFit.fill, // Adjust this if needed
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),



        ],

      ),
    );
  }
}
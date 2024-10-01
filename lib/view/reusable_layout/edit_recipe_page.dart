import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe/controller/recipe_controller.dart';
import 'package:food_recipe/view/reusable_layout/home_page.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';


class EditRecipePage extends StatefulWidget{

  final int index;
  EditRecipePage({required this.index});

  _EditRecipePageState createState()=>_EditRecipePageState();

}

class _EditRecipePageState extends State<EditRecipePage>{
  HomePage homePage=HomePage();
  TextEditingController recipeNameController=TextEditingController();
  TextEditingController recipeDescController=TextEditingController();
  TextEditingController ingredientsController=TextEditingController();
  TextEditingController preparationStepsController=TextEditingController();
  RecipeController recipeController=Get.find<RecipeController>();
  String? selectedRecipe;
  List<DropdownMenuItem<String>> recipeTypeList = [];
  List<String>labelTextList=['Food Recipe Name','Food Recipe Description','Recipe Types','Ingredients','Preparation Steps'];

  @override
  void initState(){
    super.initState();
    recipeNameController.text = recipeController.filteredList.value[widget.index].recipeName;
    recipeDescController.text = recipeController.filteredList.value[widget.index].recipeDesc;
    ingredientsController.text = recipeController.filteredList.value[widget.index].ingredients;
    preparationStepsController.text = recipeController.filteredList.value[widget.index].preparationSteps;
    loadRecipeType();
    selectedRecipe=recipeController.filteredList.value[widget.index].recipeTypes;
    setState(() {});
  }
  //title text style
  TextStyle titleTextStyle(){
    return const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );
  }
  //border for inputbox
  OutlineInputBorder inputOutline(){
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0), // Rounded corners
      borderSide: const BorderSide(
        color: Color(0xFF8BC34A), // Border color
        width: 2.0, // Border width
      ),
    );
  }
  //inputbox decoration
  InputDecoration inputBoxDeco(int index){
    return InputDecoration(
      labelText: labelTextList[index], // Label inside the TextFormField
      labelStyle: TextStyle(color: Colors.grey), // Style for label text
      fillColor: Colors.white70,
      filled: true,
      border: inputOutline(),
      focusedBorder: inputOutline(),
    );
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

  Future<void>saveChanges(int index)async{
    if(recipeNameController.text.isNotEmpty && recipeDescController.text.isNotEmpty &&selectedRecipe.toString().isNotEmpty
        && ingredientsController.text.isNotEmpty && preparationStepsController.text.isNotEmpty){
      await recipeController.editRecipe(index,
        recipeNameController.text.toString().trim(),
        recipeDescController.text.toString().trim(),
        selectedRecipe.toString(),
        ingredientsController.text.toString().trim(),
        preparationStepsController.text.toString().trim(),
        recipeController.recipeList[widget.index].picturePath.toString().trim(),
      );
      await recipeController.readRecipe();
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All information must be filled'),
          duration: Duration(seconds: 5),
        ),
      );
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height
        - MediaQuery.of(context).padding.top
        - kToolbarHeight
        - kBottomNavigationBarHeight;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.amber[50],
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      child: ListView(
        children: [
          Row(
            children: [
              const Spacer(),
              IconButton(
                icon: Icon(Icons.save_outlined),
                style: IconButton.styleFrom(
                  iconSize: 30,
                ),
                onPressed: ()async{
                  saveChanges(widget.index);
                },
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [

              Text(
                'Food Recipe Name',
                style: titleTextStyle(),
              ),
              SizedBox(height: screenHeight*0.01),
              TextFormField(
                maxLines: 1,
                minLines: 1,
                controller: recipeNameController,
                decoration: inputBoxDeco(0),
              ),
              SizedBox(height: screenHeight*0.02),
              Text(
                'Food Recipe Description',
                style: titleTextStyle(),
              ),
              SizedBox(height: screenHeight*0.01),
              TextFormField(
                maxLines: 1,
                minLines: 1,
                controller: recipeDescController,
                decoration: inputBoxDeco(1),
              ),
              SizedBox(height: screenHeight*0.02),
              Text(
                'Recipe Types',
                style: titleTextStyle(),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(20)
                ),
                child: DropdownButton<String>(
                  value: selectedRecipe, // Set the currently selected value
                  items: recipeTypeList,
                  iconEnabledColor: Colors.green,
                  onChanged: (String? newRecipe) {
                    setState(() {
                      selectedRecipe = newRecipe; // Update the selected value
                    });
                  },
                  hint: Text('Select Recipe Type'), // Optional hint text
                ),
              ),
              SizedBox(height: screenHeight*0.02),
              Text(
                'Ingredients',
                style: titleTextStyle(),
              ),
              SizedBox(height: screenHeight*0.01),
              TextFormField(
                maxLines: 1,
                minLines: 1,
                controller: ingredientsController,
                decoration: inputBoxDeco(3),
              ),
              SizedBox(height: screenHeight*0.02),
              Text(
                'Preparation Steps',
                style: titleTextStyle(),
              ),
              SizedBox(height: screenHeight*0.01),
              TextFormField(
                maxLines: 1,
                minLines: 1,
                controller: preparationStepsController,
                decoration: inputBoxDeco(4),
              ),
            ],
          ),
        ],
      ),
    );
  }

}

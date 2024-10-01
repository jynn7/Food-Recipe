import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:food_recipe/view/home_page_view.dart';
import 'package:food_recipe/view/reusable_layout/bottom_navigation_menu.dart';
import 'package:food_recipe/view/reusable_layout/home_page.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe/controller/recipe_controller.dart';
import 'package:image_picker/image_picker.dart';

class AddRecipePage extends StatefulWidget {
  @override
  _AddRecipePageState createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage>with SingleTickerProviderStateMixin{
  RecipeController recipeController=Get.find<RecipeController>();
  TextEditingController recipeNameController=TextEditingController();
  TextEditingController recipeDescController=TextEditingController();
  TextEditingController ingredientsController=TextEditingController();
  TextEditingController prepStepsController=TextEditingController();
  TextEditingController picturePathController=TextEditingController();
  TextEditingController uploadedImageTextController=TextEditingController();
  late AnimationController _controller;

  List<DropdownMenuItem<String>> recipeTypeList = [];
  String? selectedRecipe;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    loadRecipeType();  // No await here
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

  //submit the add recipe process
  Future<void>submitProcess()async{

    await recipeController.addRecipe(
        recipeNameController.text.toString().trim(),
        recipeDescController.text.toString().trim(),
        selectedRecipe.toString().trim(),
        ingredientsController.text.toString().trim(),
        prepStepsController.text.toString().trim(),
        picturePathController.text.toString().trim(),
    );

    final NavigationController navigationController = Get.find<NavigationController>();
    navigationController.selectedIndex.value=0;

    // Clear the text fields after submission
    recipeNameController.clear();
    recipeDescController.clear();
    ingredientsController.clear();
    prepStepsController.clear();
    picturePathController.clear();
    uploadedImageTextController.clear();

    Get.back();
  }
  //add photo
  Future<void>addPhotoProcess()async{
    File? pickedImage;
    final ImagePicker picker=ImagePicker();
    final XFile? image=await picker.pickImage(source: ImageSource.gallery,imageQuality: 100);
    if(image==null){
      return;
    }
    //success
    else{
      pickedImage = File(image.path);
      print('Image picked: ${pickedImage!.path}');
      picturePathController.text=pickedImage.path.toString();
      List<String>fileName=pickedImage.path.split('/');
      uploadedImageTextController.text=fileName.last.toString();
    }

  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height
        - MediaQuery.of(context).padding.top
        - kToolbarHeight
        - kBottomNavigationBarHeight;
    return Container(
      //color: Color(0xFFE8F5E9),
      child: ListView(
        children: [
          Container(
            //height: screenHeight*0.9,
            child: Card(
              //fcolor: Colors.deepPurple[50],
              child: Padding(
                padding: EdgeInsets.fromLTRB(screenWidth*0.05, screenHeight*0.02, screenWidth*0.05, screenHeight*0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title for the input field
                    Text(
                      'Food Recipe Name', // Title text
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple[500],
                      ),
                    ),
                    SizedBox(height: screenHeight*0.01),
                    TextFormField(
                      maxLines: 1,
                      minLines: 1,
                      controller: recipeNameController,
                      decoration: InputDecoration(
                        labelText: 'Food Recipe Name', // Label inside the TextFormField
                        labelStyle: TextStyle(color: Colors.grey), // Style for label text
                        fillColor: Colors.white70,
                        filled: true,
                        border: OutlineInputBorder( // Adds a border around the input field
                          borderRadius: BorderRadius.circular(10.0), // Rounded corners
                          borderSide: BorderSide(
                            color: Color(0xFF8BC34A), // Border color
                            width: 2.0, // Border width
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Colors.deepPurple, // Border color when focused
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight*0.02),
                    Text(
                      'Food Recipe Description', // Title text
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple[500],
                      ),
                    ),
                    SizedBox(height: screenHeight*0.01),
                    TextFormField(
                      maxLines: 3,
                      minLines: 3,
                      controller: recipeDescController,
                      decoration: InputDecoration(
                        labelText: 'Chinese Cuisine', // Label inside the TextFormField
                        labelStyle: TextStyle(color: Colors.grey), // Style for label text
                        fillColor: Colors.white70,
                        filled: true,
                        border: OutlineInputBorder( // Adds a border around the input field
                          borderRadius: BorderRadius.circular(10.0), // Rounded corners
                          borderSide: BorderSide(
                            color: Color(0xFF8BC34A), // Border color
                            width: 2.0, // Border width
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Colors.deepPurple, // Border color when focused
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight*0.02),

                    Text(
                      'Recipe Types',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple[500],
                      ),
                    ),
                    SizedBox(height: screenHeight*0.01),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: DropdownButton<String>(
                        value: selectedRecipe,
                        items: recipeTypeList,
                        iconEnabledColor: Colors.green,
                        onChanged: (String? newRecipe) {
                          setState(() {
                            selectedRecipe = newRecipe;
                          });
                        },
                        hint: Text('Select Recipe Type'),
                      ),
                    ),
                    SizedBox(height: screenHeight*0.02),
                    Text(
                      'Ingredients', // Title text
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple[500],
                      ),
                    ),
                    SizedBox(height: screenHeight*0.01),
                    TextFormField(
                      maxLines: 3,
                      minLines: 3,
                      controller: ingredientsController,
                      decoration: InputDecoration(
                        labelText: 'List of ingredients (e.g., 2 eggs, 1 cup rice)',
                        labelStyle: TextStyle(color: Colors.grey),
                        //fillColor:  Color(0xFFFFFFFF),
                        fillColor: Colors.white70,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Color(0xFF8BC34A),
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Colors.deepPurple,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight*0.02),
                    Text(
                      'Preparation Steps',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple[500],
                      ),
                    ),
                    SizedBox(height: screenHeight*0.02),
                    TextFormField(
                      //controller: stepsController,
                      maxLines: 6,
                      controller: prepStepsController,
                      decoration: InputDecoration(
                        fillColor: Colors.white70,
                        filled: true,
                        labelText: 'Preparation Steps',
                        hintText: 'Describe the cooking steps...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Color(0xFF8BC34A),
                            width: 2.0,
                          ),
                        ),
                        //filled: true,

                      ),
                    ),
                    SizedBox(height: screenHeight*0.01),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        elevation: 10,
                      ),

                      icon: Icon(Icons.add_a_photo_outlined),
                      onPressed: ()async{
                        await addPhotoProcess();
                        setState(() {});
                      },

                      /*
                      icon: AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _controller.value * 6.3,
                            child: child,
                          );
                        },
                        child: Icon(Icons.add_a_photo_outlined),
                      ),
                      onPressed: () {
                        if (_controller.isCompleted) {
                          _controller.reverse();
                        }
                        else {
                          _controller.forward();
                        }
                      },

                       */
                      label: Text(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        uploadedImageTextController.text.isEmpty?'Upload Recipe Image' : uploadedImageTextController.text.toString(),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child:FilledButton.icon(
                        icon: Icon(Icons.send_outlined),
                        onPressed: (){
                          if(recipeNameController.text.isNotEmpty && recipeDescController.text.isNotEmpty
                              &&ingredientsController.text.isNotEmpty && prepStepsController.text.isNotEmpty
                              && picturePathController.text.isNotEmpty && uploadedImageTextController.text.isNotEmpty && selectedRecipe!=null){
                            submitProcess();
                          }
                          else{
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('All information must be filled'),
                                duration: Duration(seconds: 5),
                              ),
                            );
                          }

                        },
                        label: const Text('Submit'),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
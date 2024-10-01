import 'package:floor/floor.dart';

@entity
class Recipe{
  @PrimaryKey(autoGenerate:true)
  final int? id;
  final String recipeName;
  final String recipeDesc;
  final String ingredients;
  final String recipeTypes;
  final String preparationSteps; // Fixed the spelling of "preparation"
  final String picturePath; // New variable for the picture path

  Recipe({
    this.id,
    required this.recipeName,
    required this.recipeDesc,
    required this.ingredients,
    required this.recipeTypes,
    required this.preparationSteps,
    required this.picturePath, // Include picturePath in the constructor
  });
}
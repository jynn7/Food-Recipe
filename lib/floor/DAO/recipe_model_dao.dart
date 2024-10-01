import 'package:floor/floor.dart';
import '../../model/recipe_model.dart';

@dao
abstract class RecipeModelDao{
  @Query('SELECT * FROM Recipe')
  Future<List<Recipe>>findAllRecipe();

  @Query('SELECT * FROM Recipe WHERE id=:id')
  Stream<Recipe?>findRecipeById(int id);

  @insert
  Future<void>insertRecipe(Recipe recipe);

  @delete
  Future<void>deleteRecipe(Recipe recipe);
  
  //delete by id
  @Query('DELETE FROM Recipe WHERE id=:id')
  Future<void>deleteRecipeById(int id);

  @Query('UPDATE Recipe SET recipeName = :newName, recipeDesc = :newDesc,recipeTypes = :recipeTypes, ingredients = :ingredients, preparationSteps = :preparationSteps, picturePath = :picturePath WHERE id = :id')
  Future<void> updateRecipe(
      int id,
      String newName,
      String newDesc,
      String recipeTypes,
      String ingredients,
      String preparationSteps,
      String picturePath,
      );
}
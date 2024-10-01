import 'dart:async';
import 'package:floor/floor.dart';
import 'package:food_recipe/floor/DAO/recipe_model_dao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import '../../model/recipe_model.dart';
part 'recipe_database.g.dart';


@Database(version: 1, entities: [Recipe])
abstract class AppDatabase extends FloorDatabase{
  RecipeModelDao get recipeModelDao;
}


import 'package:food_recipe/floor/floor_database/recipe_database.dart';

class AppDatabaseManager{
  static AppDatabase? _database;

  static Future<AppDatabase>getDatabaseInstance()async{
    if(_database==null){
      _database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    }
    return _database!;
  }
}
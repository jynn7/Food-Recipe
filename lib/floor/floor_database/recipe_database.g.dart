// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  RecipeModelDao? _recipeModelDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Recipe` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `recipeName` TEXT NOT NULL, `recipeDesc` TEXT NOT NULL, `ingredients` TEXT NOT NULL, `recipeTypes` TEXT NOT NULL, `preparationSteps` TEXT NOT NULL, `picturePath` TEXT NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  RecipeModelDao get recipeModelDao {
    return _recipeModelDaoInstance ??=
        _$RecipeModelDao(database, changeListener);
  }
}

class _$RecipeModelDao extends RecipeModelDao {
  _$RecipeModelDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _recipeInsertionAdapter = InsertionAdapter(
            database,
            'Recipe',
            (Recipe item) => <String, Object?>{
                  'id': item.id,
                  'recipeName': item.recipeName,
                  'recipeDesc': item.recipeDesc,
                  'ingredients': item.ingredients,
                  'recipeTypes': item.recipeTypes,
                  'preparationSteps': item.preparationSteps,
                  'picturePath': item.picturePath
                },
            changeListener),
        _recipeDeletionAdapter = DeletionAdapter(
            database,
            'Recipe',
            ['id'],
            (Recipe item) => <String, Object?>{
                  'id': item.id,
                  'recipeName': item.recipeName,
                  'recipeDesc': item.recipeDesc,
                  'ingredients': item.ingredients,
                  'recipeTypes': item.recipeTypes,
                  'preparationSteps': item.preparationSteps,
                  'picturePath': item.picturePath
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Recipe> _recipeInsertionAdapter;

  final DeletionAdapter<Recipe> _recipeDeletionAdapter;

  @override
  Future<List<Recipe>> findAllRecipe() async {
    return _queryAdapter.queryList('SELECT * FROM Recipe',
        mapper: (Map<String, Object?> row) => Recipe(
            id: row['id'] as int?,
            recipeName: row['recipeName'] as String,
            recipeDesc: row['recipeDesc'] as String,
            ingredients: row['ingredients'] as String,
            recipeTypes: row['recipeTypes'] as String,
            preparationSteps: row['preparationSteps'] as String,
            picturePath: row['picturePath'] as String));
  }

  @override
  Stream<Recipe?> findRecipeById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM Recipe WHERE id=?1',
        mapper: (Map<String, Object?> row) => Recipe(
            id: row['id'] as int?,
            recipeName: row['recipeName'] as String,
            recipeDesc: row['recipeDesc'] as String,
            ingredients: row['ingredients'] as String,
            recipeTypes: row['recipeTypes'] as String,
            preparationSteps: row['preparationSteps'] as String,
            picturePath: row['picturePath'] as String),
        arguments: [id],
        queryableName: 'Recipe',
        isView: false);
  }

  @override
  Future<void> deleteRecipeById(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM Recipe WHERE id=?1', arguments: [id]);
  }

  @override
  Future<void> updateRecipe(
    int id,
    String newName,
    String newDesc,
    String recipeTypes,
    String ingredients,
    String preparationSteps,
    String picturePath,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE Recipe SET recipeName = ?2, recipeDesc = ?3,recipeTypes = ?4, ingredients = ?5, preparationSteps = ?6, picturePath = ?7 WHERE id = ?1',
        arguments: [
          id,
          newName,
          newDesc,
          recipeTypes,
          ingredients,
          preparationSteps,
          picturePath
        ]);
  }

  @override
  Future<void> insertRecipe(Recipe recipe) async {
    await _recipeInsertionAdapter.insert(recipe, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteRecipe(Recipe recipe) async {
    await _recipeDeletionAdapter.delete(recipe);
  }
}

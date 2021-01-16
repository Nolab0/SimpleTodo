import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models/task.dart';

class DataBaseUtility {
  //open the database or create one if doesn't exist
  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), "todo.db"),
      version: 1,
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          "CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT, is_done INTEGER)",
        );
      },
    );
  }

  //insert a task in the database and return it id
  Future<int> insert_task(Task task) async {
    int task_id = 0;
    Database db = await database();
    //insert the data, if already exists, it replace it
    await db
        .insert("tasks", task.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) => task_id = value);
    return task_id;
  }

  //update the title in the db
  Future<void> update_task_title(int id, String title) async {
    Database db = await database();
    await db.rawUpdate("UPDATE tasks SET title = '$title' WHERE id = '$id'");
  }

  //update the description in the db
  Future<void> update_task_description(int id, String desc) async {
    Database db = await database();
    await db
        .rawUpdate("UPDATE tasks SET description = '$desc' WHERE id = '$id'");
  }

  Future<void> update_task_done(int id, int is_done) async {
    Database db = await database();
    await db
        .rawUpdate("UPDATE tasks SET is_done = '$is_done' WHERE id = '$id'");
  }

  //retrieve the list of tasks
  Future<List<Task>> get_tasks() async {
    Database db = await database();
    List<Map<String, dynamic>> taskMap = await db.query("tasks");
    return List.generate(taskMap.length, (index) {
      return Task(
          id: taskMap[index]['id'],
          title: taskMap[index]['title'],
          description: taskMap[index]['description'],
          is_done: taskMap[index]['is_done']);
    });
  }

  //delete a task from the database
  Future<void> deleteTask(int id) async {
    Database db = await database();
    await db.rawDelete("DELETE FROM tasks WHERE id = '$id'");
  }
}

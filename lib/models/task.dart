class Task {
  //field
  int id;
  String title;
  String description;
  int is_done;

  //constructor
  Task({this.id, this.title, this.description, this.is_done});

  //methods
  //create the map of a task
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "is_done": is_done,
    };
  }
}

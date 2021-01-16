import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_features/database.dart';
import 'package:test_features/models/task.dart';
import 'package:test_features/screens/widget.dart';

class task_add extends StatefulWidget {
  final Task task; //pass the task
  task_add({@required this.task});

  @override
  _task_addState createState() => _task_addState();
}

class _task_addState extends State<task_add> {
  DataBaseUtility db_utility = DataBaseUtility();
  String task_tittle = "";
  String task_description = "";
  int task_is_done;
  int task_id = 0;
  FocusNode _title_focus;
  FocusNode _desc_focus;
  bool content_visibilty = false;

  @override
  void initState() {
    //retrieve the title if there is one
    if (widget.task != null) {
      task_id = widget.task.id;
      task_tittle = widget.task.title;
      task_description = widget.task.description;
      task_is_done = widget.task.is_done;
      //set visibility to true
      content_visibilty = true;
    } else {
      task_is_done = 0;
    }
    _title_focus = FocusNode();
    _desc_focus = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _title_focus.dispose();
    _desc_focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Container(
            child: Stack(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_back, color: Colors.black87),
                            iconSize: 30,
                          ),
                        ),
                        Expanded(
                            child: TextField(
                          focusNode: _title_focus,
                          decoration: InputDecoration(
                              hintText: "Enter task title",
                              border: InputBorder.none),
                          onSubmitted: (value) async {
                            //verify that the title is not empty
                            if (value != "") {
                              //check if the task is null = new task
                              if (widget.task == null) {
                                Task current_task = Task(title: value);
                                current_task.is_done = 0;

                                task_id =
                                    await db_utility.insert_task(current_task);
                                setState(() {
                                  content_visibilty = true;
                                  task_tittle = value;
                                });
                              } else {
                                //update the task title
                                await db_utility.update_task_title(
                                    task_id, value);
                                print("Task updated");
                              }
                              //focus on the description feild
                              _desc_focus.requestFocus();
                            }
                          },
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                          controller: TextEditingController()
                            ..text = task_tittle,
                        ))
                      ],
                    ),
                    Visibility(
                      visible: content_visibilty,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: TextField(
                            onSubmitted: (value) {
                              if (value != "") {
                                if (task_id != 0) {
                                  db_utility.update_task_description(
                                      task_id, value);
                                }
                              }
                            },
                            focusNode: _desc_focus,
                            decoration: InputDecoration(
                              hintText: "Enter task description",
                              border: InputBorder.none,
                            ),
                            controller: TextEditingController()
                              ..text = task_description),
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: content_visibilty,
                  child: Positioned(
                      bottom: 18,
                      left: 20,
                      child: GestureDetector(
                        onTap: () {
                          if (task_is_done == 0) {
                            db_utility.update_task_done(task_id, 1);
                          } else {
                            db_utility.update_task_done(task_id, 0);
                          }
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          child: task_is_done == 0
                              ? Icon(Icons.check, color: Colors.white)
                              : Icon(Icons.undo, color: Colors.white),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: task_is_done == 0
                                  ? Colors.green
                                  : Colors.orange),
                        ),
                      )),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: Visibility(
          visible: content_visibilty,
          child: FloatingActionButton(
            onPressed: () async {
              if (task_id != 0) {
                await db_utility.deleteTask(task_id);
                Navigator.pop(context);
              }
            },
            backgroundColor: Colors.red[400],
            child: Icon(
              Icons.delete_forever,
              size: 28,
            ),
          ),
        ));
  }
}

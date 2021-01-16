import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_features/screens/task_page.dart';
import 'package:test_features/database.dart';
import 'package:test_features/screens/widget.dart';

class MainDisplay extends StatefulWidget {
  @override
  _MainDisplayState createState() => _MainDisplayState();
}

class _MainDisplayState extends State<MainDisplay> {
  DataBaseUtility db_utility = DataBaseUtility();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.grey[100],
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 50),
                child: Text("My ToDos",
                    style:
                        TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                  child: FutureBuilder(
                initialData: [],
                future: db_utility.get_tasks(),
                builder: (context, snapshot) {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => task_add(
                                            task: snapshot.data[index])))
                                .then((value) {
                              setState(() {});
                            });
                          },
                          child: task_card(
                            title: snapshot.data[index].title,
                            description: snapshot.data[index].description,
                            is_done: snapshot.data[index].is_done,
                          ),
                        );
                      });
                },
              ))
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => task_add(task: null)))
              .then((value) {
            setState(() {});
          });
        },
      ),
    );
  }
}

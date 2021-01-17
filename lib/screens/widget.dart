import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_features/models/task.dart';

class task_card extends StatelessWidget {
  String title;
  String description;
  int is_done;

  task_card({this.title, this.description, this.is_done});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 25),
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 28.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Text(
                title ?? "(Unnamed task)",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight:
                        is_done == 1 ? FontWeight.w200 : FontWeight.bold,
                    decoration:
                        is_done == 1 ? TextDecoration.lineThrough : null,
                    color: is_done == 1 ? Colors.black54 : Colors.black),
              ),
            ),
            Text(description ?? "(No description)")
          ],
        ),
      ),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
    );
  }
}

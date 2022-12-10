import 'package:flutter/material.dart';
import 'package:student_db_crud_ops/edit.dart';
import 'package:student_db_crud_ops/student.dart';
import 'package:student_db_crud_ops/tile.dart';
import 'package:student_db_crud_ops/view.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'db.dart';

class StudentSelection extends StatelessWidget {
  const StudentSelection(
      {Key? key, required this.students, this.modeFor = SelectionMode.edit})
      : super(key: key);
  final List<Student> students;
  final SelectionMode modeFor;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
              'Select a student to ${modeFor == SelectionMode.edit ? 'edit' : 'delete'}'),
          centerTitle: true),
      body: students.isEmpty
          ? const Center(
              child: Text('No student data available.'),
            )
          : ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) => StudentTile(
                student: students[index],
                onTapped: () {
                  modeFor == SelectionMode.edit
                      ? editStudent(context, students[index])
                      : deleteStudent(context, students[index]);
                },
              ),
            ),
    );
  }

  void editStudent(context, student) async {
    await navigateToPage(context, AddOrEditStudent(student: student), true);
  }

  void deleteStudent(context, student) async {
    try {
      await DbHelper.instance.deleteStudent(student.rollNo);
      Fluttertoast.showToast(
        msg: "Student '${student.rollNo.toUpperCase()}' Deleted Successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 14.0,
      );
      Navigator.pop(context);
    } catch (e) {}
  }
}

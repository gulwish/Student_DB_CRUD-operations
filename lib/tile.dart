import 'package:flutter/material.dart';
import 'package:student_db_crud_ops/db.dart';
import 'package:student_db_crud_ops/student.dart';

class StudentTile extends StatelessWidget {
  StudentTile({Key? key, required this.student, required this.onTapped})
      : super(key: key);
  final Student student;
  final VoidCallback onTapped;
  final DbHelper dbHelper = DbHelper.instance;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
        side: const BorderSide(width: 0.1),
      ),
      child: ListTile(
        onTap: onTapped,
        title: Text(
          student.rollNo.toUpperCase(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: CircleAvatar(
          radius: 27,
          child: Text(
            student.name.toUpperCase().characters.first,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        subtitle: Text("${student.name}(${student.age})"),
        contentPadding: const EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}

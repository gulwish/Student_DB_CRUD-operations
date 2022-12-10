import 'package:flutter/material.dart';
import 'package:student_db_crud_ops/student.dart';

import 'db.dart';

class ListStudents extends StatefulWidget {
  const ListStudents({Key? key}) : super(key: key);

  @override
  State<ListStudents> createState() => _ListStudentsState();
}

class _ListStudentsState extends State<ListStudents> {
  List<Student> students = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List of Students'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : students.isEmpty
              ? const Center(child: Text('No records available.'))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 30, 0),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          'Total:${students.length}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: students.length,
                        itemBuilder: (context, index) => StudentTile(
                          student: students[index],
                          onTapped: () {
                            viewStudent(context, students[index]);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  toggleIsLoading() => setState(() {
        isLoading = !isLoading;
      });

  void loadStudents() async {
    toggleIsLoading();
    final instance = DbHelper.instance;
    final stds = await instance.getAllStudents();
    setState(() {
      students = stds.cast<Student>();
    });
    await Future.delayed(const Duration(milliseconds: 200));
    toggleIsLoading();
  }
}
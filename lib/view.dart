import 'package:flutter/material.dart';
import 'package:student_db_crud_ops/student.dart';
import 'package:student_db_crud_ops/tile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key, required this.students}) : super(key: key);
  final List<Student> students;
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final searchTextController = TextEditingController();
  List<Student> students = [];
  @override
  void initState() {
    super.initState();
    setState(() {
      students = widget.students;
    });
    searchTextController.addListener(() {
      setState(() {
        filterStudents();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    searchTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search a student',
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: searchTextController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search with roll no or name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.cancel),
                  onPressed: () {
                    searchTextController.clear();
                    setState(() {});
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
              child: Align(
                alignment: Alignment.topLeft,
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
            )
          ],
        ),
      ),
    );
  }

  void filterStudents() {
    students = widget.students
        .where(
          (student) =>
              student.rollNo
                  .toLowerCase()
                  .contains(searchTextController.text.toLowerCase()) ||
              student.name
                  .toLowerCase()
                  .contains(searchTextController.text.toLowerCase()),
        )
        .toList();
  }
}

Widget buildButton(context, text, icon, {required VoidCallback onPressed}) {
  return Container(
    margin: const EdgeInsets.all(3),
    width: MediaQuery.of(context).size.width * 0.6,
    child: ElevatedButton.icon(
      onPressed: onPressed,
      label: Text(text),
      icon: Icon(icon),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10),
      ),
    ),
  );
}

Future navigateToPage(context, Widget widget, [bool replace = false]) {
  if (replace) {
    return Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => widget));
  } else {
    return Navigator.push(
        context, MaterialPageRoute(builder: (context) => widget));
  }
}

void viewStudent(context, Student student) async {
  await showDialog(
    context: context,
    builder: (context) => Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
      padding: const EdgeInsets.all(20.0),
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.3,
          horizontal: MediaQuery.of(context).size.height * 0.07),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            child: Text(
              student.name.toUpperCase().characters.first,
              style: const TextStyle(
                fontSize: 45,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            student.rollNo.toUpperCase(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "${student.name}\n(${student.age})",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

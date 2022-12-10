import 'package:flutter/material.dart';
import 'package:student_db_crud_ops/student.dart';

class AddOrEditStudent extends StatefulWidget {
  const AddOrEditStudent({Key? key, this.student}) : super(key: key);
  final Student? student;

  @override
  State<AddOrEditStudent> createState() => _AddOrEditStudentState();
}

class _AddOrEditStudentState extends State<AddOrEditStudent> {
  final formKey = GlobalKey<FormState>();
  final rollNoController = TextEditingController();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  @override
  void initState() {
    super.initState();
    isCreateMode = widget.student == null;
    if (!isCreateMode) {
      setState(() {
        nameController.text = widget.student!.name;
        ageController.text = widget.student!.age.toString();
      });
    }
  }

  bool isCreateMode = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: labAppBar,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isCreateMode ? 'Add a Student' : 'Update a Student',
                style: const TextStyle(fontSize: 30),
              ),
              const SizedBox(height: 20),
              Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (isCreateMode)
                        TextFormField(
                          controller: rollNoController,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "enter a roll no";
                            }
                            return null;
                          },
                          decoration: buildDecoration('roll number'),
                        ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: nameController,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "enter a name";
                          }
                          return null;
                        },
                        decoration: buildDecoration('name'),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: ageController,
                        keyboardType: TextInputType.number,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            "enter age";
                          }
                          try {
                            int.parse(val!);
                          } catch (e) {
                            return "enter a number";
                          }
                          return null;
                        },
                        decoration: buildDecoration('age'),
                      ),
                      const SizedBox(height: 10),
                      buildButton(
                        context,
                        isCreateMode ? 'Add Student' : 'Update Student',
                        isCreateMode ? Icons.add : Icons.edit,
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            final instance = DbHelper.instance;
                            final student = Student(
                              rollNo: isCreateMode
                                  ? rollNoController.text.toLowerCase()
                                  : widget.student!.rollNo,
                              name: nameController.text,
                              age: int.parse(ageController.text),
                            );
                            await isCreateMode
                                ? instance.insertStudent(student)
                                : instance.updateStudent(student);
                            setState(() {});
                            Fluttertoast.showToast(
                              msg: "Student added/updated succesffully.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 5,
                              backgroundColor: Colors.blue,
                              textColor: Colors.white,
                              fontSize: 14.0,
                            );
                            print("Data inserted/updated");
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildDecoration(hint) => InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      hintText: hint);
}
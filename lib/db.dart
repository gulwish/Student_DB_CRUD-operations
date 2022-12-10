

import 'package:student_db_crud_ops/student.dart';

class DbHelper {
  static DbHelper instance = DbHelper._init();
  DbHelper._init();
  Database? _database;
  static String dbName = "Mydb.db";
  static String tableName = "Students";
  Future<Database> get database async => _database ??= await openDatabase(
        join(await getDatabasesPath(), dbName),
        onCreate: onCreate,
        version: 1,
      );

  Future<void> onCreate(Database db, int version) async {
    final result = await db.execute(
        "CREATE TABLE $tableName(rollNo Text Primary Key, name Text, age INTEGER)");
    print("Table created");
  }

  Future<void> insertStudent(Student student) async {
    final db = await instance.database;
    var result = await db.insert(tableName, student.toJson());
    print("data inserted ${result}");
  }

  Future<void> updateStudent(Student student) async {
    final db = await instance.database;
    var result = await db.update(
      tableName,
      student.toJson(),
      where: 'rollNo=?',
      whereArgs: [student.rollNo],
    );
    print("data inserted ${result}");
  }

  Future<void> deleteStudent(String rollNo) async {
    final db = await instance.database;
    var result = await db.delete(
      tableName,
      where: 'rollNo=?',
      whereArgs: [rollNo],
    );
    print("data deleted ${result}");
  }

  Future<List<Student>> getAllStudents() async {
    List<Student> students = [];
    final db = await instance.database;
    final result = await db.query(tableName);
    for (final data in result) {
      final student = Student.fromJson(data);
      students.add(student);
    }
    return students;
  }
}
 
final labAppBar = AppBar(
  title: const Text('Lab 12'),
  centerTitle: true,
);

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: labAppBar,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: MediaQuery.of(context).size.width),
          buildButton(
            context,
            'Add Student',
            Icons.add,
            onPressed: () {
              navigateToPage(context, const AddOrEditStudent());
            },
          ),
          buildButton(
            context,
            'Edit Student Data',
            Icons.edit,
            onPressed: () {
              onEditPressed(context);
            },
          ),
          buildButton(
            context,
            'Delete a Student',
            Icons.delete,
            onPressed: () {
              onDeletePressed(context);
            },
          ),
          buildButton(
            context,
            'List Students',
            Icons.list,
            onPressed: () {
              navigateToPage(context, const ListStudents());
            },
          ),
          buildButton(
            context,
            'Search Student',
            Icons.search,
            onPressed: () async {
              final students = await DbHelper.instance.getAllStudents();
              // ignore: use_build_context_synchronously
              navigateToPage(context, SearchScreen(students: students));
            },
          ),
        ],
      ),
    );
  }

  void onEditPressed(context) async {
    final students = await DbHelper.instance.getAllStudents();
    navigateToPage(
      context,
      StudentSelection(students: students),
    );
  }

  void onDeletePressed(context) async {
    final students = await DbHelper.instance.getAllStudents();
    navigateToPage(
      context,
      StudentSelection(students: students, modeFor: SelectionMode.delete),
    );
  }
}

enum SelectionMode {
  edit,
  delete,
}
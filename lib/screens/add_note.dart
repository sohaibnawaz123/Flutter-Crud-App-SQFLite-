import 'package:db_crudapp/screens/note_detail.dart';
import 'package:db_crudapp/utils/helper_database.dart';
import 'package:flutter/material.dart';

class NotesList extends StatefulWidget {
  const NotesList({super.key});

  @override
  State<NotesList> createState() => NotesListState();
}

class NotesListState extends State<NotesList> {
  static List<Map<String, dynamic>> journals = [];
  static bool isLoading = true;
  void reFreshJournal() async {
    final data = await DatabaseHelper.instance.readData();
    setState(() {
      journals = data;
    });
  }

  @override
  void initState() {
    super.initState();
    reFreshJournal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ADD NOTES",
          style: TextStyle(
              color: Color.fromARGB(218, 0, 0, 0),
              fontWeight: FontWeight.w900,
              fontSize: 24.0),
        ),
        backgroundColor: Colors.blue[100],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const NoteDetails(
              title: "ADD NOTES",
              id: null,
            );
          })).then((_) => reFreshJournal());
        },
      ),
      body: ListView.builder(
          itemCount: journals.length,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.white,
              elevation: 2.0,
              child: ListTile(
                leading:CircleAvatar(
                    backgroundColor: Colors.yellow[200],
                    child: const Icon(
                      Icons.file_upload,
                    )),
                title: Text(journals[index]['name'].toString()),
                subtitle: Text(journals[index]['description']),
                trailing: GestureDetector(
                  child: const Icon(Icons.delete),
                  onTap: () async {
                    var getid = journals[index]['id'];
                    await DatabaseHelper.instance
                        .deleteData(getid)
                        .then((_) => reFreshJournal());
                  },
                ),
                onTap: () {
                  var getid = journals[index]['id'];
                  
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return NoteDetails(
                      title: "EDIT NOTES",
                      id: getid,
                    );
                  })).then((_)=>reFreshJournal());
                },
              ),
            );
          }),
    );
  }
}

// ignore_for_file: use_build_context_synchronously

import 'package:db_crudapp/utils/helper_database.dart';
import 'package:flutter/material.dart';

class NoteDetails extends StatefulWidget {
  final String title;
  final int? id;

  const NoteDetails({super.key, required this.title, this.id});

  @override
  State<NoteDetails> createState() => _NoteDetailsState();
}

class _NoteDetailsState extends State<NoteDetails> {
  late String appTitle;
  late int? id;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    appTitle = widget.title;
    id = widget.id;

    if (id != null) {
      loadNoteDetails();
    }
  }

  void loadNoteDetails() async {
    final note = await DatabaseHelper.instance.readNoteById(id!);
    setState(() {
      _titleController.text = note[DatabaseHelper.col_name];
      _descController.text = note[DatabaseHelper.col_desc];
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void saveNote() async {
    if (id == null) {
      await DatabaseHelper.instance.insert({
        DatabaseHelper.col_name: _titleController.text,
        DatabaseHelper.col_desc: _descController.text
      });
    } else {
      await DatabaseHelper.instance.updataData({
        DatabaseHelper.col_id: id,
        DatabaseHelper.col_name: _titleController.text,
        DatabaseHelper.col_desc:_descController.text
        
      });
    }
    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        title: Text(
          appTitle,
          style: const TextStyle(
            color: Color.fromARGB(218, 0, 0, 0),
            fontWeight: FontWeight.w900,
            fontSize: 24.0,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10.0),
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Title',
              labelStyle: const TextStyle(color: Colors.blue, fontSize: 18.0),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: const BorderSide(width: 2.0, color: Colors.blue),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(width: 2.0, color: Color.fromARGB(148, 73, 165, 240)),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: const BorderSide(width: 2.0, color: Colors.blue),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          TextField(
            controller: _descController,
            decoration: InputDecoration(
              labelText: 'Description',
              labelStyle: const TextStyle(color: Colors.blue, fontSize: 18.0),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: const BorderSide(width: 2.0, color: Colors.blue),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(width: 2.0, color: Color.fromARGB(148, 73, 165, 240)),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: const BorderSide(width: 2.0, color: Colors.blue),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: const BorderSide(width: 1.5, color: Colors.blue),
                  ),
                  backgroundColor: Colors.blue[100],
                ),
                onPressed: saveNote,
                child: Row(
                  children: [
                    Text(id != null ? "Edit" : "Add", style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 15),
                    Icon(id != null ? Icons.edit : Icons.save, size: 20.0),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

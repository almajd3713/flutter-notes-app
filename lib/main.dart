import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider(
        create: (context) => AppState(), 
        child: Scaffold(
          appBar: AppBar(
            title: Text("Notes App"),
          ),
          body: Center(
            child: MasterInterface(),
          ),
        ),
      ),
    );
  }
}

class AppState extends ChangeNotifier {
  var notes = <Note>[];

  void addNote() {
    notes.add(Note());
    notifyListeners();
  }

  void updateNote(Key key, String newName, String newDesc) {
    final index = notes.indexWhere((note) => note.key == key);
    if(index > -1) {
      notes[index].name = newName;
      notes[index].description = newDesc;
      notifyListeners();
    }
  }

  void deleteNote(Key key) {
    notes.removeWhere((note) => note.key == key);
    notifyListeners();
  }
}

class Note {
  Note({this.name = "New Note", this.description = "Praise the leafblower"})
  : key = UniqueKey(); 
  final Key key;
  String name;
  String description;
}

class MasterInterface extends StatelessWidget {
  const MasterInterface({super.key});

  @override
  Widget build(BuildContext context) {
    AppState appstate = Provider.of<AppState>(context);
    var noteList = appstate.notes;
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: noteList.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if(index == noteList.length) {
                return Padding(padding: EdgeInsets.all(4.0),
                  child: OutlinedButton(onPressed: () {
                    appstate.addNote();
                  }, 
                    child: Text("+", style: TextStyle(fontSize: 32),)
                  ),  
                );
              }
              return NoteWidget(index: index);
            },
            separatorBuilder: (_, __) => SizedBox(height: 10,),
          ),
        ),
      ],
    );
  }
}



class NoteWidget extends StatelessWidget {
  const NoteWidget({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    var appstate = Provider.of<AppState>(context);
    Note note = appstate.notes[index];
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: ChangeNotifierProvider.value(value: appstate, builder: (context, _) {
                return Text(note.name);
              },),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: IconButton(onPressed: () {
                    appstate.deleteNote(note.key);
                    Navigator.pop(context);
                  }, icon: Icon(Icons.delete, color: Colors.red, size: 32,)),
                )
              ],
            ),
            body: Column(
              children: [
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: TextEditingController.fromValue(TextEditingValue(text: note.name)),
                        onChanged: (newName) => appstate.updateNote(note.key, newName, note.description),
                        decoration: InputDecoration(hintText: "Very namey name...")
                      ),
                      SizedBox(height: 30,),
                      TextField(
                        controller: TextEditingController.fromValue(
                            TextEditingValue(text: note.description)),
                        onChanged: (newDesc) => appstate.updateNote(
                            note.key, note.name, newDesc),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        minLines: 12,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: "Very describing decription..."
                        ),
                        
                      )
                    ],
                  ),
                )
              ],
            )
          );
        }));
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.symmetric(horizontal: BorderSide(color: Colors.black, width: 1))
        ),
        child: Row(
          children: [
            Padding(  
              padding: const EdgeInsets.all(16.0),
              child: Text(note.name, style: TextStyle(fontSize: 20)),
            )
            
          ],
        ),
      ),
    );
  }
}


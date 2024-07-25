import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_kepper/models/Note.dart';
import 'package:note_kepper/utils/database_helper.dart';

class NoteDetail extends StatefulWidget {
 final String appBarTitle;
 final Note note;

 NoteDetail(this.note,this.appBarTitle);

 @override
 State<StatefulWidget> createState() {
   return NoteDetailState( appBarTitle, note);
 }
}

class NoteDetailState extends State<NoteDetail> {

  static var _priorities = ['High', 'Low'];
  DatabaseHelper helper=DatabaseHelper();
  String _selectedPriority = 'Low';
  String appBarTitle;
  Note note;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  NoteDetailState(this.appBarTitle,this.note);

  @override
  Widget build(BuildContext context) {

    TextStyle? textStyle = Theme.of(context).textTheme.titleMedium;
    titleController.text= note.title;
    descriptionController.text=note.description;

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle!),
      ),

      body: Padding(
        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: ListView(
          children: <Widget>[

            // First element
            ListTile(
              title: DropdownButton<String>(
                  items: _priorities.map((String dropDownStringItem) {
                    return DropdownMenuItem<String>(
                      value: dropDownStringItem,
                      child: Text(dropDownStringItem),
                    );
                  }).toList(),

                  style: textStyle,

                  value: getPriorityAsString(note.priority),

                  onChanged: (String? valueSelectedByUser) {
                    setState(() {
                      _selectedPriority = valueSelectedByUser!;
                      debugPrint('User selected $_selectedPriority');
                      updatePriorityAsInt(valueSelectedByUser);
                    });
                  }
              ),
            ),

            // Second Element
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: titleController,
                style: textStyle,
                onChanged: (value) {
                  debugPrint('Something changed in Title Text Field');
                  updateTitle();
                },
                decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)
                    )
                ),
              ),
            ),

            // Third Element
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: descriptionController,
                style: textStyle,
                onChanged: (value) {
                  debugPrint('Something changed in Description Text Field');
                  updateDescription();
                },
                decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)
                    )
                ),
              ),
            ),

            // Fourth Element
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Theme.of(context).primaryColorLight, backgroundColor: Theme.of(context).primaryColorDark,
                        textStyle: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      child: Text(
                        'Save',
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        setState(() {
                          debugPrint("Save button clicked");
                          _save();
                        });
                      },
                    ),
                  ),

                  Container(width: 5.0,),

                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Theme.of(context).primaryColorLight, backgroundColor: Theme.of(context).primaryColorDark,
                        textStyle: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      child: Text(
                        'Delete',
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        setState(() {
                          debugPrint("Delete button clicked");
                          _delete();
                        });
                      },
                    ),
                  ),

                ],
              ),
            ),

          ],
        ),
      ),
    );

  }
  //convert the string priority in the form of integer before saving it to database
  void updatePriorityAsInt(String value){
    switch(value){
      case 'High':note.priority= 1;
      break;
      case 'Law':note.priority= 2;
      break;
    }
  }
  //convert int priority to string priority and display it to user in dropdown
  String getPriorityAsString(int value){
    String priority='';
    switch(value){
      case 1:priority= _priorities[0];
      break;
      case 2:priority=_priorities[1];
      break;
    }
    return priority;
  }
  void updateTitle(){
    note.title=titleController.text;
  }
  void updateDescription(){
    note.description=titleController.text;
  }

  void _delete() async {
    // Check if note.id is null
    if (note.id == null) {
      _showAlterDialog('Status', 'No Note was deleted');
      return;
    }

    // If note.id is not null, proceed with deletion
    int result = await helper.deleteNote(note.id!);

    // Optionally, handle the result here if needed
    if (result != 0) {
      _showAlterDialog('Status', 'Note deleted successfully');
    } else {
      _showAlterDialog('Status', 'Failed to delete the note');
    }
  }


  void _save() async{
    note.date=DateFormat.yMMMd().format(DateTime.now());
    int resault;
    if(note.id != null){
       resault =await helper.updateNote(note);
    }else{
      resault= await helper.insertNote(note);
    }
    if(resault != 0){
      _showAlterDialog('status','Note Saved Succesfully');
    }else{
      _showAlterDialog('status','Problem Saving Note');
    }
  }

  void _showAlterDialog(String title, String message) {
    AlertDialog alertDialog=AlertDialog(
      title:Text(title),
      content: Text(message),
    );
    showDialog(context: context,
        builder: (_)=>alertDialog);
  }
}

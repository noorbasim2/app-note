import 'dart:io';
import 'dart:math';
import 'package:appnote/component/alert.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditNotes extends StatefulWidget {
  final docid;
  final list;

  const EditNotes({Key? key, this.docid, this.list}) : super(key: key);

  @override
  State<EditNotes> createState() => _EditNotesState();
}

class _EditNotesState extends State<EditNotes> {
  CollectionReference noteref = FirebaseFirestore.instance.collection("notes");

  File? file;
  Reference? ref;

  var title, note, imageurl;

  GlobalKey<FormState> formstate = new GlobalKey<FormState>();

  editNote(context) async {
    var formdata = formstate.currentState;

    if (file == null) {
      if (formdata!.validate()) {
        showLoading(context);

        formdata.save();
        // await ref?.putFile(file!);
        // imageurl = await ref?.getDownloadURL();
        await noteref.doc(widget.docid).update({
          "title": title,
          "note": note,
          // "imageurl": imageurl,
        }).then((value) {
          Navigator.of(this.context).pushNamed("homepage");
        }).catchError((e) {
          print("$e");
        });
      }
    } else {
      if (formdata!.validate()) {
        showLoading(context);
        formdata.save();

        await ref?.putFile(file!);
        imageurl = await ref?.getDownloadURL();

        await noteref.doc(widget.docid).update({
          "title": title,
          "note": note,
          "imageurl": imageurl,
        }).then((value) {
          Navigator.of(this.context).pushNamed("homepage");
        }).catchError((e) {
          print("$e");
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          title: Text("Edit Note"),
        ),
        // drawer: Drawer(),
        body: Container(
          child: Column(
            children: [
              Form(
                key: formstate,
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: widget.list['title'],
                      onSaved: (val) {
                        title = val;
                      },
                      validator: (val) {
                        if (val!.length > 30) {
                          return "note title can't to be larger than 30 letter ";
                        }

                        if (val.length < 2) {
                          return "note title can't to be less than 2 letter ";
                        }
                        return null;
                      },
                      maxLength: 30,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Title Note",
                          prefixIcon: Icon(
                            Icons.note,
                            color: Colors.purple.shade500,
                          )),
                    ),
                    TextFormField(
                      initialValue: widget.list['note'],
                      onSaved: (val) {
                        note = val;
                      },
                      validator: (val) {
                        if (val!.length > 700) {
                          return "note can't to be larger than 700 letter ";
                        }
                        if (val.length < 1) {
                          return "note can't to be less than 1 letter ";
                        }
                        return null;
                      },
                      minLines: 1,
                      maxLines: 4,
                      maxLength: 700,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Note",
                          prefixIcon: Icon(
                            Icons.note,
                            color: Colors.purple.shade500,
                          )),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    RaisedButton(
                      padding:
                          EdgeInsets.symmetric(horizontal: 95, vertical: 15),
                      onPressed: () {
                        showBottomsSheet(context);
                      },
                      textColor: Colors.white,
                      child: Text(
                        "Edit Image For Note",
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    RaisedButton(
                      padding:
                          EdgeInsets.symmetric(horizontal: 140, vertical: 15),
                      onPressed: () async {
                        await editNote(context);
                      },
                      textColor: Colors.white,
                      child: Text(
                        "Edit Note",
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  showBottomsSheet(context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(20),
            height: 160,
            color: Color.fromARGB(255, 244, 207, 251),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Edit Image",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  onTap: () async {
                    var picked = await ImagePicker()
                        .getImage(source: ImageSource.gallery);

                    if (picked != null) {
                      file = File(picked.path);
                      var rand = Random().nextInt(1000000);
                      var imagename = "$rand" + basename(picked.path);
                      ref = FirebaseStorage.instance
                          .ref("images")
                          .child("$imagename");
                      Navigator.of(context).pop();
                    }
                  },
                  child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.collections,
                            size: 25,
                          ),
                          SizedBox(width: 12),
                          Text(
                            "From Gallery",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                ),
                InkWell(
                  onTap: () async {
                    var picked = await ImagePicker()
                        .getImage(source: ImageSource.camera);
                    if (picked != null) {
                      file = File(picked.path);
                      var rand = Random().nextInt(1000000);
                      var imagename = "$rand" + basename(picked.path);
                      ref = FirebaseStorage.instance
                          .ref("images")
                          .child("$imagename");
                      Navigator.of(context).pop();
                    }
                  },
                  child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Icon(Icons.photo_camera, size: 25),
                          SizedBox(width: 12),
                          Text(
                            "From Camera",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                ),
              ],
            ),
          );
        });
  }
}

import 'package:appnote/crud/editnotes.dart';
import 'package:appnote/crud/viewnote.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  CollectionReference notesref = FirebaseFirestore.instance.collection("notes");

  getUser() {
    var user = FirebaseAuth.instance.currentUser;
    print(user!.email);
  }

  var fbm = FirebaseMessaging.instance;
  @override
  void initState() {
    getUser();
    fbm.getToken().then((value) {
      print("========================");
      print(value);
      print("========================");
    });
    FirebaseMessaging.onMessage.listen((event) {
      AwesomeDialog(
        context: context,
        title: "title",
        body: Text(
          "${event.notification?.body}",
        ),
      )..show();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacementNamed("login");
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        leading: Icon(Icons.home),
        title: Text("Home page"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed("addnotes");
        },
      ),
      body: Container(
        child: FutureBuilder(
          future: notesref
              .where("userid",
                  isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, i) {
                    return Dismissible(
                      background: Container(
                        color: Colors.red,
                        child: Icon(
                          Icons.cancel,
                        ),
                      ),
                      secondaryBackground: Container(
                        color: Colors.red,
                        child: Icon(
                          Icons.cancel,
                        ),
                      ),
                      onDismissed: (direction) async {
                        await notesref.doc(snapshot.data.docs[i].id).delete();
                        await FirebaseStorage.instance
                            .refFromURL(snapshot.data.docs[i]['imageurl'])
                            .delete()
                            .then((value) {
                          print("Delete");
                        });
                      },
                      key: UniqueKey(),
                      child: ListNotes(
                        notes: snapshot.data.docs[i],
                        docid: snapshot.data.docs[i].id,
                      ),
                    );
                  });
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class ListNotes extends StatelessWidget {
  final notes;
  final docid;
  ListNotes({this.notes, this.docid});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ViewNote(
            note: notes,
          );
        }));
      },
      child: Card(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage("${notes['imageurl']}"),
              ),
            ),
            Expanded(
              flex: 3,
              child: ListTile(
                title: Text("${notes['title']}"),
                subtitle: Text(
                  "${notes['note']}",
                  style: TextStyle(fontSize: 14),
                ),
                trailing: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: ((context) {
                          return EditNotes(
                            docid: docid,
                            list: notes,
                          );
                        }),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.edit,
                  ),
                ),
              ),
            ),
          
          ],
        ),
      ),
    );
  }
}

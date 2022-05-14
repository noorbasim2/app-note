import 'package:flutter/material.dart';

class ViewNote extends StatefulWidget {
  final note;
  const ViewNote({Key? key, this.note}) : super(key: key);

  @override
  State<ViewNote> createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 0,
            title: Text("View Note")),
        body: Container(
          child: Column(
            children: [
              Container(
                child: Image.network(
                  "${widget.note['imageurl']}",
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.fill,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  "${widget.note['title']}",
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              Container(
                color: Colors.purple.shade100,
                padding: EdgeInsets.symmetric(horizontal: 10),
                margin: EdgeInsets.symmetric(vertical: 15,horizontal: 12),
                child: Text(
                  "${widget.note['note']}",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class NewPopMovie extends StatefulWidget {
  @override
  _NewPopMovieState createState() => _NewPopMovieState();
}

class _NewPopMovieState extends State<NewPopMovie> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Title(color: Colors.blue, child: Text('New Popular Movie')),
      ),
      body: Form(
          child: Column(
        children: <Widget>[Text('kolom')],
      )),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'popularmovie.dart';

class DetailPop extends StatefulWidget {
  final int movie_id;
  DetailPop({Key key, @required this.movie_id}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _DetailPopState();
  }
}

PopMovie pm;

class _DetailPopState extends State<DetailPop> {
  // tahap 1
  @override
  void initState() {
    super.initState();
    bacaData();
  }

  // tahap 2
  bacaData() {
    fetchData().then((value) {
      print('isi value $value');
      Map json = jsonDecode(value);
      pm = PopMovie.fromJson(json['data']);
      setState(() {});
    });
  }

  // tahap 3
  Future<String> fetchData() async {
    final response = await http
        .post(Uri.parse("http://ubaya.prototipe.net/daniel/detailmovie.php"),
            // parameter dikirim ke API
            body: {'id': widget.movie_id.toString()});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  // tahap 4
  Widget tampilData() {
    if (pm != null) {
      return Card(
          elevation: 10,
          margin: EdgeInsets.all(10),
          child: Column(children: <Widget>[
            Text(pm.title, style: TextStyle(fontSize: 25)),
            Padding(
                padding: EdgeInsets.all(10),
                child: Text(pm.overview, style: TextStyle(fontSize: 15))),
          ]));
    } else {
      return CircularProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Detail of Popular Movie'),
        ),
        body: ListView(children: <Widget>[
          // Text(widget.movie_id.toString()),
          Center(child: tampilData())
        ]));
  }
}

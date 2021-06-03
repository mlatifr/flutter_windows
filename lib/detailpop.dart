import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/editmovie.dart';
import 'package:http/http.dart' as http;
import 'editpop_dosen.dart';
import 'popularmovie.dart';

class DetailPop extends StatefulWidget {
  int movie_id;

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
      // print('isi value $value');
      Map json = jsonDecode(value);
      pm = PopMovie.fromJson(json['data']);
      setState(() {});
    });
  }

  // tahap 3
  Future<String> fetchData() async {
    final response = await http.post(
        // Uri.parse("http://ubaya.prototipe.net/daniel/detailmovie.php"),
        // .post(
        Uri.parse("http://52.148.78.159/emertech/local/detailmovie_actors.php"),

        // parameter dikirim ke API
        body: {'id': widget.movie_id.toString()});
    // print(response.body);
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
            Padding(padding: EdgeInsets.all(10), child: Text("Genre:")),
            Padding(
                padding: EdgeInsets.all(10),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: pm.genres.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return new Text(pm.genres[index]['genre_name']);
                    })),
            Padding(
                padding: EdgeInsets.all(10),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: pm.actors.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return new Text(pm.actors[index]['person_name'] +
                          ' as ' +
                          pm.actors[index]['character_name']);
                    })),
            Padding(
              padding: EdgeInsets.all(10),
              child: Image.network("http://ubaya.prototipe.net/daniel/images/" +
                  widget.movie_id.toString() +
                  ".jpg"),
            ),
          ]));
    } else {
      return CircularProgressIndicator();
    }
  }

  Future onGoBack(dynamic value) {
    print("masuk goback");
    setState(() {
      bacaData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Detail of Popular Movie'),
        ),
        body: ListView(children: <Widget>[
          // Text(widget.movie_id.toString()),
          Center(child: tampilData()),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                angkaReload = 1;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EditPopMovieDosen(movie_id: widget.movie_id),
                  ),
                ).then(onGoBack);
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => EditPopMovie(
                //               movie_id: widget.movie_id,
                //             )));
              },
              child: Text('Edit ' + widget.movie_id.toString()),
            ),
          ),
        ]));
  }
}

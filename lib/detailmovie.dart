import 'package:flutter/material.dart';
import 'main.dart';

class DetailMovie extends StatelessWidget {
  DetailMovie(this.idmovie);
  int idmovie;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Movie'),
      ),
      body: ListView(children: <Widget>[
        Card(
            elevation: 10,
            margin: EdgeInsets.all(10),
            child: Column(children: <Widget>[
              Text(movies[idmovie].title, style: TextStyle(fontSize: 25)),
              Image.network(movies[idmovie].photo),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(movies[idmovie].synopsis,
                      style: TextStyle(fontSize: 15))),
            ]))
      ]),
    );
  }
}

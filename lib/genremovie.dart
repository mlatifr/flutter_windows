import 'package:flutter/material.dart';
import 'main.dart';

class GenreMovie extends StatelessWidget {
  GenreMovie(this.genre);
  String genre;

  Widget _generateCardGenre(index, genre) {
    if (movies[index].genre == genre) {
      return Container(
        // color: Colors.blue,
        margin: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Image.network(movies[index].photo, width: 150),
            Text(
              ' Judul: ' + movies[index].title,
              style: TextStyle(fontSize: 15),
            ),
            Text(
              ' Genre: ' + movies[index].genre,
              style: TextStyle(fontSize: 15),
            ),
            Text(
              ' Sinopsis: ' + movies[index].synopsis,
              style: TextStyle(fontSize: 15),
            ),
          ],
        ),
      );
    } else {
      return Container(
        // color: Colors.blue,
        margin: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '-',
              style: TextStyle(fontSize: 19),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Genre Movie'),
      ),
      body: ListView.builder(
          itemCount: movies.length,
          itemBuilder: (BuildContext context, int index) {
            return _generateCardGenre(index, genre);
          }),
    );
  }
}

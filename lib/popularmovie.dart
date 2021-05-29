import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'detailpop.dart';

List<PopMovie> PMs = [];

// class PopMovie ==> menampung object
class PopMovie {
  final int movie_id;
  String title, overview, homepage;
  final String vote_average, release_date;
  final List genres, actors;

  // parameter dari class PopMovie
  PopMovie(
      {this.movie_id,
      this.title,
      this.overview,
      this.homepage,
      this.vote_average,
      this.release_date,
      this.genres,
      this.actors});

  // factory untuk convert jason MAP ==> array of object
  factory PopMovie.fromJson(Map<String, dynamic> json) {
    return PopMovie(
      movie_id: json['movie_id'],
      title: json['title'],
      overview: json['overview'],
      vote_average: json['vote_average'],
      genres: json['genres'],
      actors: json['actors'],
      homepage: json['homepage'],
      release_date: json['release_date'],
    );
  }
}

class PopularMovie extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PopularMovieState();
  }
}

class _PopularMovieState extends State<PopularMovie> {
  String _temp = 'menunggu API';
  Future<String> fetchData() async {
    final response = await http.post(
        // Uri.http("ubaya.prototipe.net", '/daniel/movielist.php'),
        Uri.http("52.148.78.159", '/emertech/local/movielist.php'),
        body: {'cari': _txtcari});

    // final response = await http
    //     .get(Uri.http("ubaya.prototipe.net", '/daniel/movielist.php'));
    if (response.statusCode == 200) {
      // print('responnya : ' + response.body);
      // Future.delayed ==> untuk delay agar muncul gbr loadingnya
      // return Future.delayed(Duration(seconds: 1), () => response.body);
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  String _txtcari = '';
  Future<String> data;
  bacaData() {
    PMs.clear();
    data = fetchData();
    data.then((value) {
      Map json = jsonDecode(value);
      for (var mov in json['data']) {
        PopMovie pm = PopMovie.fromJson(mov);
        PMs.add(pm);
      }
      setState(() {});
    });
  }

  Widget DaftarPopMovie() {
    final ScrollController _scrollController = ScrollController();
    if (PMs.length > 0) {
      return Scrollbar(
        thickness: 20,
        isAlwaysShown: true,
        controller: _scrollController,
        child: ListView.builder(
            controller: _scrollController,
            itemCount: PMs.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return new Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.movie,
                        size: 30,
                      ),
                      title: GestureDetector(
                          child: Text(PMs[index].title),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailPop(movie_id: PMs[index].movie_id),
                              ),
                            );
                          }),
                      // title: Text(PMs[index].title),
                      subtitle: Text(PMs[index].overview),
                    ),
                    // new Text(
                    //   PMs[index].id.toString() + ' ' + PMs[index].title,
                    //   textAlign: TextAlign.justify,
                    // ),
                  ],
                ),
              );
            }),
      );
    } else {
      return CircularProgressIndicator();
    }
  }

  @override
  void initState() {
    super.initState();
    //bacaData(); ditaruh disini agar saat di buka, data nda dipanggil terus
    bacaData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Popular Movie')),
        body: ListView(children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.search),
              labelText: 'Judul mengandung kata:',
            ),
            onFieldSubmitted: (value) {
              _txtcari = value;
              bacaData();
            },
          ),
          Container(
              height: MediaQuery.of(context).size.height - 100,
              child: Center(child: DaftarPopMovie())),
        ]));
  }
}

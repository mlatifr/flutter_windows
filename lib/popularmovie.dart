import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

int hlm = 1;
List<PopMovie> PMs = [];

// class PopMovie ==> menampung object
class PopMovie {
  final int id;
  final String title;
  final String overview;
  final String vote_average;

  // parameter dari class PopMovie
  PopMovie({this.id, this.title, this.overview, this.vote_average});

  // factory untuk convert jason MAP ==> array of obaject
  factory PopMovie.fromJson(Map<String, dynamic> json) {
    return PopMovie(
      id: json['movie_id'],
      title: json['title'],
      overview: json['overview'],
      vote_average: json['vote_average'],
    );
  }
}

Widget DaftarPopMovie() {
  if (PMs.length > 0) {
    return ListView.builder(
        itemCount: PMs.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return Card(
            child: Row(
              children: [
                Image.network(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ6IzKeimIZzmkyQvHw9v9vo5F5isIXyrVDOw&usqp=CAU'),
                new Text(
                  PMs[index].id.toString() + ' ' + PMs[index].title,
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          );
        });
  } else {
    return CircularProgressIndicator();
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
    final response = await http
        .get(Uri.http("ubaya.prototipe.net", '/daniel/movielist.php'));
    if (response.statusCode == 200) {
      // Future.delayed ==> untuk delay agar muncul gbr loadingnya
      return Future.delayed(Duration(seconds: 2), () => response.body);
    } else {
      throw Exception('Failed to read API');
    }
  }

  // bacaData() {
  //   Future<String> data = fetchData();
  //   data.then((value) {
  //     setState(() {
  //       _temp = value;
  //     });
  //   });
  // }
  bacaData(int halaman) {
    Future<String> data = fetchData();
    data.then((value) {
      Map json = jsonDecode(value);
      // var mov ==>Object
      for (var mov in json['data']) {
        PopMovie pm = PopMovie.fromJson(mov);
        PMs.add(pm);
      }
      setState(() {
        _temp = PMs[halaman].title;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    //bacaData(); ditaruh disini agar saat di buka, data nda dipanggil terus
    bacaData(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Popular Movie')),
        body: ListView(children: <Widget>[
          Container(
              height: MediaQuery.of(context).size.height - 2,
              child: Center(child: DaftarPopMovie())),
          TextButton(
            onPressed: () {
              hlm++;
              bacaData(hlm);
            },
            child: Text(hlm.toString()),
          )
        ]));
  }
}

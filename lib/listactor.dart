import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String _temp = 'menunggu API', _txtcariartis = '';
List<Actor> actors = [];

class Actor {
  final int id;
  final String nama;
  Actor({this.id, this.nama});
  factory Actor.fromJson(Map<String, dynamic> json) {
    return Actor(id: json['person_id'], nama: json['person_name']);
  }
}

Widget daftarActor() {
  final ScrollController _scrollController = ScrollController();
  if (actors.length > 0) {
    return Scrollbar(
      thickness: 20,
      isAlwaysShown: true,
      controller: _scrollController,
      child: ListView.builder(
          controller: _scrollController,
          itemCount: actors.length,
          itemBuilder: (BuildContext ctx, int idx) {
            return Card(
                // margin: EdgeInsets.fromLTRB(2, 2, 2, 20),
                child: new Text(actors[idx].nama));
          }),
    );
  } else {
    return Column(
      children: [
        Center(child: CircularProgressIndicator()),
        Text('Loading data...')
      ],
    );
  }
}

class actorList extends StatefulWidget {
  @override
  _actorListState createState() => _actorListState();
}

class _actorListState extends State<actorList> {
  Future<String> fetchData() async {
    final response = await http
        .get(Uri.http("13.76.91.251", '/emertech/local/actorlist.php'));
    if (response.statusCode == 200) {
      // Future.delayed ==> untuk delay agar muncul gbr loadingnya
      return Future.delayed(Duration(milliseconds: 700), () => response.body);
    } else {
      throw Exception('Failed to read API $response');
    }
  }

  bacaData() {
    try {
      Future<String> data = fetchData();
      data.then((value) {
        Map json = jsonDecode(value);
// print(json); //untuk cek isi json
// var mov ==>Object
        for (var mov in json['data']) {
          Actor pm = Actor.fromJson(mov);
          actors.add(pm);
        }
        setState(() {
          _temp = actors[1].nama;
        });
      });
    } catch (e) {
      print('error: $e');
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
      appBar: AppBar(
        title: Text('Latif List Actor'),
      ),
      body: ListView(children: <Widget>[
        TextFormField(
          decoration: const InputDecoration(
            icon: Icon(Icons.search),
            labelText: 'cari nama artis:',
          ),
          onFieldSubmitted: (value) {
            _txtcariartis = value;
            bacaData();
          },
        ),
        Container(
            height: MediaQuery.of(context).size.height - 2,
            child: daftarActor()),
      ]),
    );
  }
}

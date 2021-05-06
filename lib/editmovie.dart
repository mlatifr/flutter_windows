import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'popularmovie.dart';

// alur: terima id -> request autofill dari DB -> send data edit
class EditPopMovie extends StatefulWidget {
  final int movie_id;
  const EditPopMovie({Key key, @required this.movie_id}) : super(key: key);
  @override
  _EditPopMovieState createState() => _EditPopMovieState();
}

int angkaReload = 1;
PopMovie editpm;
List<PopMovie> EditPM = [];

class _EditPopMovieState extends State<EditPopMovie> {
  // tahap 2
  bacaData() {
    EditPM.clear();
    fetchData().then((value) {
      Map json = jsonDecode(value);
      // print(json);
      for (var item in json['data']) {
        print(item);
        editpm = PopMovie.fromJson(item);
        EditPM.add(editpm);
      }
      setState(() {
        // untuk setting initial value dari release_date
        _controllerdate..text = editpm.release_date;
        _title = editpm.title;
        _homepage = editpm.homepage;
        _overview = editpm.overview;
      });
    });
  }

  // tahap 3
  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse("http://mlatifr.ddns.net/emertech/local/geteditmovie.php"),

        // parameter dikirim ke API
        body: {'id': widget.movie_id.toString()});
    if (response.statusCode == 200) {
      // return Future.delayed(Duration(milliseconds: 700), () => response.body)
      angkaReload = 2;
      return response.body;
    } else {
      throw Exception('Failed to read API');
      // throw CircularProgressIndicator();
    }
  }

  String _title = "editpm.title",
      _homepage = "editpm.homepage",
      _overview = "editpm.overview";
  var _controllerdate = TextEditingController();

  // tahap 4
  // untuk kirim edit data
  void submit() async {
    final response = await http.post(
        // Uri.parse("http://ubaya.prototipe.net/daniel/newmovie.php"),
        Uri.parse("http://mlatifr.ddns.net/emertech/local/editmovie.php"),
        body: {
          'title': ''' ''$_title'' ''',
          'overview': ''' ''$_overview'' ''',
          'homepage': ''' ''$_homepage'' ''',
          'release_date': _controllerdate.text,
          'movie_id': widget.movie_id.toString(),
        });
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      print(json);
      if (json['result'] == 'success') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(json.toString())));
      }
    } else {
      throw Exception('Failed to read API');
    }
  }

  Widget formEdit() {
    if (angkaReload == 2) {
      return Column(
        children: [
          Text(_title +
              ' ' +
              widget.movie_id.toString() +
              ' ' +
              angkaReload.toString() +
              ' ' +
              editpm.release_date.toString() +
              ' '),
          Text(editpm.title +
              ' ' +
              widget.movie_id.toString() +
              ' ' +
              angkaReload.toString() +
              ' ' +
              editpm.release_date.toString() +
              ' '),
          Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                initialValue: editpm.title,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                onChanged: (value) {
                  _title = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'judul harus diisi';
                  }
                  return null;
                },
              )),
          Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                initialValue: editpm.homepage,
                decoration: const InputDecoration(
                  labelText: 'Homepage',
                ),
                onChanged: (value) {
                  _homepage = value;
                },
                // cek validasi alamat website
                validator: (value) {
                  if (!Uri.parse(value).isAbsolute) {
                    return 'alamat homepage salah';
                  }
                  return null;
                },
              )),
          Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                initialValue: editpm.overview,
                decoration: const InputDecoration(
                  labelText: 'Overview',
                ),
                onChanged: (value) {
                  _overview = value;
                },
                keyboardType: TextInputType.multiline,
                minLines: 3,
                maxLines: 6,
              )),
          Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      child: TextFormField(
                    // initialValue: editpm.release_date,
                    decoration: const InputDecoration(
                      labelText: 'Release Date',
                    ),
                    // text berubah berdasarkan button kalender value
                    controller: _controllerdate,
                  )),
                  // tombol kalender
                  ElevatedButton(
                      onPressed: () {
                        showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2200))
                            .then((value) {
                          setState(() {
                            // mengatur textform field
                            _controllerdate
                              ..text = value.toString().substring(0, 10);
                          });
                        });
                      },
                      child: Icon(
                        Icons.calendar_today_sharp,
                        color: Colors.white,
                        size: 24.0,
                      ))
                ],
              )),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                if (!_formKey.currentState.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Harap Isian diperbaiki')));
                } else {
                  submit();
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      );
    } else {
      Text(angkaReload.toString());
      return CircularProgressIndicator();
    }
  }

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    //bacaData(); ditaruh disini agar saat di buka, data nda dipanggil terus
    bacaData();
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        appBar: AppBar(
          title: Title(color: Colors.blue, child: Text('Edit Popular Movie')),
        ),
        body: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[formEdit()],
            )),
      );
    } catch (e) {
      print('error nya adalah: $e');
    }
  }
}

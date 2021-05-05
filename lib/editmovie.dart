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

PopMovie editpm;
List<PopMovie> EditPM = [];

class _EditPopMovieState extends State<EditPopMovie> {
  // tahap 2
  bacaData() {
    fetchData().then((value) {
      Map json = jsonDecode(value);
      for (var item in json['data']) {
        PopMovie editpm = PopMovie.fromJson(item);
        EditPM.add(editpm);
      }

      setState(() {});
    });
  }

  // tahap 3
  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse("http://180.247.221.100/emertech/local/geteditmovie.php"),

        // parameter dikirim ke API
        body: {'id': widget.movie_id.toString()});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  String _title, _homepage, _overview = "";
  final _controllerdate = TextEditingController();

  void submit() async {
    final response = await http.post(
        // Uri.parse("http://ubaya.prototipe.net/daniel/newmovie.php"),
        Uri.parse("http://192.168.1.2/emertech/local/editmovie.php"),
        body: {
          'title': _title,
          'overview': _overview,
          'homepage': _homepage,
          'release_date': _controllerdate.text
        });
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Sukses Menambah Data')));
      }
    } else {
      throw Exception('Failed to read API');
    }
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    bacaData();
    return Scaffold(
      appBar: AppBar(
        title: Title(color: Colors.blue, child: Text('Edit Popular Movie')),
      ),
      body: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
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
                        initialValue: editpm.realese_date,
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
                                _controllerdate.text =
                                    value.toString().substring(0, 10);
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
          )),
    );
  }
}

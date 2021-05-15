import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class NewPopMovie extends StatefulWidget {
  @override
  _NewPopMovieState createState() => _NewPopMovieState();
}

class _NewPopMovieState extends State<NewPopMovie> {
  String _title, _homepage, _overview = "";
  final _controllerdate = TextEditingController();

  void submit() async {
    final response = await http.post(
        // Uri.parse("http://ubaya.prototipe.net/daniel/newmovie.php"),
        Uri.parse("http://13.76.91.251/emertech/local/newmovie.php"),
        body: {
          'title': _title,
          'overview': _overview,
          'homepage': _homepage,
          'release_date': _controllerdate.text
        });
    if (response.statusCode == 200) {
      // print(_overview.runtimeType);
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
    return Scaffold(
      appBar: AppBar(
        title: Title(color: Colors.blue, child: Text('New Popular Movie')),
      ),
      body: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    initialValue: 'judul',
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
                    initialValue: 'http://google.com',
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
                    initialValue: 'an automatic Overview has been created ' +
                        '\nhehehe' +
                        '\nhehehe',
                    decoration: const InputDecoration(
                      labelText: 'Overview',
                    ),
                    onChanged: (value) {
                      _overview = value;
                    },
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 6,
                  )),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          child: TextFormField(
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

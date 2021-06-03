import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'popularmovie.dart';
import 'dart:io';

File _image = null;

class EditPopMovieDosen extends StatefulWidget {
  int movie_id;
  EditPopMovieDosen({Key key, @required this.movie_id}) : super(key: key);
  @override
  EditPopMovieDosenState createState() {
    return EditPopMovieDosenState();
  }
}

PopMovie pm;
TextEditingController _titleCont = new TextEditingController();
TextEditingController _homepageCont = new TextEditingController();
TextEditingController _overviewCont = new TextEditingController();

class Genre {
  int genre_id;
  String genre_name;
  Genre({this.genre_id, this.genre_name});

  factory Genre.fromJSON(Map<String, dynamic> json) {
    return Genre(
      genre_id: json["genre_id"],
      genre_name: json["genre_name"],
    );
  }
}

class EditPopMovieDosenState extends State<EditPopMovieDosen> {
  Future<List> daftarGenre() async {
    Map json;
    final response = await http.post(
      Uri.parse("http://ubaya.prototipe.net/daniel/genrelist.php"),
    );
    if (response.statusCode == 200) {
      print(response.body);
      json = jsonDecode(response.body);
      return json['data'];
    } else {
      throw Exception('Failed to read API');
    }
  }

  void submit() async {
    List<int> imageBytes = _image.readAsBytesSync();
    print(imageBytes);
    String base64Image = base64Encode(imageBytes);
    final response2 = await http.post(
        Uri.parse(
          'http://ubaya.prototipe.net/daniel/uploadpopmovieposter.php',
        ),
        body: {
          'movie_id': widget.movie_id.toString(),
          'image': base64Image,
        });
    if (response2.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response2.body)));
    }

    final response = await http.post(
        Uri.parse("http://ubaya.prototipe.net/daniel/updatemovie.php"),
        body: {
          'title': pm.title,
          'overview': pm.overview,
          'homepage': pm.homepage,
          'movie_id': widget.movie_id.toString()
        });
    if (response.statusCode == 200) {
      print(response.body);
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Sukses mengubah Data')));
      }
    } else {
      throw Exception('Failed to read API');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bacaData();
    setState(() {
      generateComboGenre();
    });
  }

  final _formKey = GlobalKey<FormState>();
  bacaData() {
    fetchData().then((value) {
      Map json = jsonDecode(value);
      pm = PopMovie.fromJson(json['data']);
      setState(() {
        _titleCont.text = pm.title;
        _homepageCont.text = pm.homepage;
        _overviewCont.text = pm.overview;
      });
    });
  }

  Future<String> fetchData() async {
    final response = await http.post(
        // Uri.parse("http://ubaya.prototipe.net/daniel/detailmovie.php"),
        Uri.parse("http://52.148.78.159/emertech/local/detailmovie.php"),
        body: {'id': widget.movie_id.toString()});
    if (response.statusCode == 200) {
      print(" addmoviegenre ${response.body}");
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  Widget comboGenre = Text('tambah genre');
  void generateComboGenre() {
    //widget function for city list
    List<Genre> genres;
    var data = daftarGenre();
    data.then((value) {
      genres = List<Genre>.from(value.map((i) {
        return Genre.fromJSON(i);
      }));

      comboGenre = DropdownButton(
          dropdownColor: Colors.grey[100],
          hint: Text("tambah genre"),
          isDense: false,
          items: genres.map((gen) {
            return DropdownMenuItem(
              child: Column(children: <Widget>[
                Text(gen.genre_name, overflow: TextOverflow.visible),
              ]),
              value: gen.genre_id,
            );
          }).toList(),
          onChanged: (value) {
            //memnaggil fungsi menambah genre disini
            addGenre(value);
          });
    });
  }

  void addGenre(genre_id) async {
    final response = await http.post(
        // Uri.parse("http://ubaya.prototipe.net/daniel/addmoviegenre.php"),
        Uri.parse("http://52.148.78.159/emertech/local/addmoviegenre.php"),
        body: {
          'genre_id': genre_id.toString(),
          'movie_id': widget.movie_id.toString()
        });
    if (response.statusCode == 200) {
      print(response.body);
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Sukses menambah genre')));
        setState(() {
          bacaData();
        });
      }
    } else {
      throw Exception('Failed to read API');
    }
  }

  _imgGaleri() async {
    final picker = ImagePicker();
    final image = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 600,
        maxWidth: 600);
    setState(() {
      _image = File(image.path);
    });
  }

  _imgKamera() async {
    final picker = ImagePicker();
    final image =
        await picker.getImage(source: ImageSource.camera, imageQuality: 20);
    setState(() {
      _image = File(image.path);
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              color: Colors.white,
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      tileColor: Colors.white,
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Galeri'),
                      onTap: () {
                        _imgGaleri();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Kamera'),
                    onTap: () {
                      _imgKamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit Popular Movie"),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            children: [
              Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Title',
                        ),
                        onChanged: (value) {
                          pm.title = value;
                        },
                        controller: _titleCont,
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
                        decoration: const InputDecoration(
                          labelText: 'Website',
                        ),
                        onChanged: (value) {
                          pm.homepage = value;
                        },
                        controller: _homepageCont,
                        validator: (value) {
                          if (!Uri.parse(value).isAbsolute) {
                            return 'alamat website salah';
                          }
                          return null;
                        },
                      )),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Overview',
                        ),
                        onChanged: (value) {
                          pm.overview = value;
                        },
                        controller: _overviewCont,
                        keyboardType: TextInputType.multiline,
                        minLines: 3,
                        maxLines: 6,
                      )),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: GestureDetector(
                      onTap: () {
                        _showPicker(context);
                      },
                      child: _image != null
                          ? Image.file(_image)
                          : Image.network(
                              "http://ubaya.prototipe.net/daniel/blank.png"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (!_formKey.currentState.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Harap Isian diperbaiki')));
                        } else {
                          submit();
                        }
                      },
                      child: Text('Submit'),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(10), child: Text('Genre:')),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: pm.genres.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return Row(
                              children: [
                                new Text(pm.genres[index]['genre_name']),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.3),
                                ElevatedButton(
                                    // nanti ada fungsi hapus genre dengan parameter
                                    //movie_id dan genre_id
                                    onPressed: null,
                                    child: Text('Hapus'))
                              ],
                            );
                          })),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: comboGenre),
                ],
              ),
            ],
          ),
        ));
  }
}

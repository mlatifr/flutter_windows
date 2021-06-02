import 'dart:convert';

import 'package:flutter/material.dart';
import 'main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

String user_id, password, error_login = '';

// void doLogin() async {
//   //nantinya ada pengecekan master_user melalui webservice
//   final prefs = await SharedPreferences.getInstance();
//   prefs.setString("user_id", user_id);
//   main();
// }

void doLogout() async {
  //nantinya ada pengecekan master_user melalui webservice
  final prefs = await SharedPreferences.getInstance();
  prefs.remove("user_id");
  main();
}

class MyLogin extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    try {
      return MaterialApp(
        title: 'Login page',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Login(),
      );
    } catch (e) {
      print('error karena $e');
    }
  }
}

class Login extends StatefulWidget {
  Login({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
    user_id = 'admin';
    password = 'admin';
  }

  void doLogin() async {
    final response = await http.post(
        // Uri.parse("http://ubaya.prototipe.net/daniel/login.php"),
        Uri.parse("http://52.148.78.159/emertech/local/login.php"),
        body: {'user_name': user_id, 'user_password': password});
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("user_id", user_id);
        prefs.setString("user_name", json['user_name']);
        main();
      } else {
        setState(() {
          error_login = "User id atau password error: " + json.toString();
        });
      }
    } else {
      throw Exception('Failed to read API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                initialValue: 'admin',
                onChanged: (value) {
                  user_id = value;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter valid email id as abc@gmail.com'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                initialValue: 'admin',
                onChanged: (value) {
                  password = value;
                },
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password:admin',
                    hintText: 'Enter secure password'),
              ),
            ),
            Padding(padding: EdgeInsets.all(10), child: Text(error_login)),
            Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  height: 50,
                  width: 300,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20)),
                  child: TextButton(
                    onPressed: () {
                      doLogin();
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

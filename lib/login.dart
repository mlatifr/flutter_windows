import 'package:flutter/material.dart';
import 'main.dart';
import 'package:shared_preferences/shared_preferences.dart';

String user_id;

void doLogin() async {
  //nantinya ada pengecekan master_user melalui webservice
  final prefs = await SharedPreferences.getInstance();
  prefs.setString("user_id", user_id);
  main();
}

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
              child: TextField(
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
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
              ),
            ),
            Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  height: 50,
                  width: 300,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20)),
                  child: FlatButton(
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

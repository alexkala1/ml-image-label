import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ml_image_label/imagehome.dart';
import 'package:ml_image_label/register.dart';

void main() {
  runApp(MaterialApp(routes: {
    '/login': (context) => loginSection(),
    '/register': (context) => registerApp(),
    '/image_label': (context) => imageUpload(),
  }, home: loginSection()));
}

class loginSection extends StatelessWidget {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ML-Image-Label'),
          centerTitle: true,
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Image Label for machine learning',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                        fontSize: 30,
                      ),
                    )),
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Sign in',
                      style: TextStyle(fontSize: 20),
                    )),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'User Name',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),
                Container(
                    height: 100,
                    padding: EdgeInsets.fromLTRB(10, 50, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: Text('Login'),
                      onPressed: () async {
                        print(nameController.text);
                        print(passwordController.text);
                        login(nameController.text, passwordController.text);
                        if (await login(
                                nameController.text, passwordController.text) ==
                            true) {
                          Navigator.pushNamed(context, '/image_label');
                        }
                      },
                    )),
                Container(
                    padding: EdgeInsets.fromLTRB(10, 25, 10, 0),
                    child: Row(
                      children: <Widget>[
                        Text('Do you not have an account?'),
                        FlatButton(
                          textColor: Colors.blue,
                          child: Text(
                            'Sign Up',
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/register');
                          },
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ))
              ],
            )));
  }
}

login(email, password) async {
  final http.Response response = await http.post(
    "http://10.0.2.2:3001/api/v1/auth/login-mobile",
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'email': email,
      'password': password,
    }),
  );

  print(response.statusCode);

  if (response.statusCode == 200) {
    SharedPreferences store = await SharedPreferences.getInstance();
    var user = jsonDecode(response.body);
    store.setString('firstName', user['firstName']);
    store.setString('lastName', user['lastName']);
    store.setString('email', user['email']);
    store.setString('userType', user['userType']);
    store.setString('id', user['id']);

    return true;
  } else
    return false;
}

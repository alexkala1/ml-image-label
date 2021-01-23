import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(loginApp());
}

class loginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: loginSection(),
    );
  }
}

class loginSection extends StatelessWidget {
  var firstName;
  var lastName;
  var email;
  var password;
  var confirmPassword;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          automaticallyImplyLeading: false,
        ),
        child: SafeArea(
            child: ListView(padding: const EdgeInsets.all(16), children: [
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: CupertinoTextField(
                  placeholder: "Email",
                  onChanged: (value) {
                    email = value;
                  })),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: CupertinoTextField(
                  placeholder: "Password",
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  })),
          RaisedButton.icon(
              onPressed: () {
                print(email);
                print(password);
                login(email, password);
              },
              color: Colors.blue,
              textColor: Colors.white,
              icon: Icon(Icons.save),
              label: Text("Login"))
        ])));
  }
}

login(email, password) async {
  final http.Response response = await http.post(
    "http://10.0.2.2:3001/api/v1/auth/login",
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'email': email,
      'password': password,
    }),
  );

  if (response.statusCode == 200)
    //navigate to image picker view wip
    return true;
  else return false;
}

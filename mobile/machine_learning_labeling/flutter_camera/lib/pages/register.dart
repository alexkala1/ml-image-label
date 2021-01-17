import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: registerSection(),
    );
  }
}

class registerSection extends StatelessWidget {
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
                  placeholder: "First Name",
                  onChanged: (value) {
                    firstName = value;
                  })),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: CupertinoTextField(
                  placeholder: "Last Name",
                  onChanged: (value) {
                    lastName = value;
                  })),
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
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: CupertinoTextField(
                  placeholder: "Confirm Password",
                  obscureText: true,
                  onChanged: (value) {
                    confirmPassword = value;
                  })),
          RaisedButton(
              onPressed: () {
                print(email);
                print(password);
                register(firstName, lastName, email, password, confirmPassword);
              },
              color: Colors.blue,
              textColor: Colors.white,
              child: Text("Register"))
        ])));
  }
}

register(firstName, lastName, email, password, confirmPassword) async {
  if (password == confirmPassword) {
    var url = "http://10.0.2.2:3001/api/v1/auth/register";
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "firstName": firstName,
        "lastName": lastName,
        'email': email,
        'password': password,
        'userType': 'user'
      }),
    );

    return "Register Successful";
  } else {
    return "Invalid Password";
  }
}

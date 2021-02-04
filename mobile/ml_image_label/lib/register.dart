import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(registerApp());
}

class registerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: registerSection(),
    );
  }
}


class registerSection extends StatelessWidget {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmedController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Register'),
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
                      'Register',
                      style: TextStyle(fontSize: 20),
                    )),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: firstNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'First Name',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: lastNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Last Name',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
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
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    obscureText: true,
                    controller: passwordConfirmedController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Confirm Password',
                    ),
                  ),
                ),
                Container(
                    height: 100,
                    padding: EdgeInsets.fromLTRB(10, 50, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: Text('Register'),
                      onPressed: () async {
                        print(firstNameController.text);
                        print(passwordController.text);
                        register(firstNameController.text, lastNameController.text, emailController.text, passwordController.text, passwordConfirmedController.text);
                        if (await register(
                            firstNameController.text, lastNameController.text, emailController.text, passwordController.text, passwordConfirmedController.text) ==
                            true) {
                          Navigator.pushNamed(context, '/image_label');
                        }
                      },
                    )),
                Container(
                    padding: EdgeInsets.fromLTRB(10, 25, 10, 0),
                    child: Row(
                      children: <Widget>[
                        Text('Do you have an account?'),
                        FlatButton(
                          textColor: Colors.blue,
                          child: Text(
                            'Sign In',
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/image_label');
                          },
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ))
              ],
            )));
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

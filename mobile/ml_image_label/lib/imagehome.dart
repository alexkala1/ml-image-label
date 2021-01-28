import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(imageUpload());
}

class imageUpload extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  String error = 'Error';
  String user = "";

  chooseImage() {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.gallery);
    });
    setStatus('');
  }

  @override
  void initState() {
    fetchUser();
  }


  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  fetchUser() async {
    SharedPreferences store = await SharedPreferences.getInstance();
    user = "Welcome back " + store.getString('firstName') + " " + store.getString('lastName');
    return;
  }

  uploadImg() {
    if (null == tmpFile) {
      setStatus(error);
      return;
    }


    String fileName = tmpFile.path.split('/').last;
    fetchUser();
    upload(fileName);
  }

  upload(String fileName) async {
    SharedPreferences store = await SharedPreferences.getInstance();
    // var email = store.getString('email');
    // var id = store.getString('id');
    await http.post('http://10.0.2.2:3001/api/v1/images',
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "image": base64Image,
              "imageName": fileName,
              "email": store.getString('email'),
              "isHumanChecked": false,
              "user_id": store.getString('id'),
              "dataset": "asdasdasd",
              "dataset_id": "1",
              "object": [
                {
                  "label": "lounge",
                  "bbox": [
                    {
                      "x": 300,
                      "y": 250,
                      "width": 500,
                      "height": 500,
                    }
                  ]
                }
              ]
            }))
        .then((result) {
      print(result.body);
      setStatus(result.statusCode == 200 ? result.body : error);
    }).catchError((error) {
      setStatus(error);
    });
  }
  _onTapDown(TapDownDetails details) {
    var x = details.globalPosition.dx;
    var y = details.globalPosition.dy;
    // or user the local position method to get the offset
    print(details.localPosition);
    print("tap down " + x.toString() + ", " + y.toString());
  }

  _onTapUp(TapUpDetails details) {
    var x = details.globalPosition.dx;
    var y = details.globalPosition.dy;
    // or user the local position method to get the offset
    print(details.localPosition);
    print("tap up " + x.toString() + ", " + y.toString());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image/Data'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(10, 25, 10, 25),
                child: Text(
                  user,
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                    fontSize: 30,
                  ),
                )),
            FutureBuilder<File>(
              future: file,
              builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    null != snapshot.data) {
                  tmpFile = snapshot.data;
                  base64Image = base64Encode(snapshot.data.readAsBytesSync());

                  return Container(
                    margin: EdgeInsets.all(15),
                    child: new GestureDetector(
                      onTap: () => print('tapped!'),
                      onTapDown: (TapDownDetails details) => _onTapDown(details),
                      onTapUp: (TapUpDetails details) => _onTapUp(details),
                      child: Material(
                        elevation: 3.0,
                        child: Image.file(
                          snapshot.data,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  );
                } else if (null != snapshot.error) {
                  return const Text(
                    'Error!',
                    textAlign: TextAlign.center,
                  );
                } else {
                  return Container(
                    margin: EdgeInsets.all(15),
                    child: Material(
                      elevation: 3.0,
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          InkWell(
                            onTap: () {
                              chooseImage();
                            },
                            child: Padding(
                              padding: EdgeInsets.only(top: 10.0, right: 10.0),
                              child: Icon(
                                Icons.edit,
                                size: 30.0,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              height: 50.0,
              width: 360.0,
              child: RaisedButton(
                child: Text(
                  'Upload Image',
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
                color: Colors.blue,
                onPressed: () {
                  uploadImg();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

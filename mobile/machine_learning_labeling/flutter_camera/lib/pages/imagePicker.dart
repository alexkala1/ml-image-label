import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(imagePicker());
}

class imagePicker extends StatelessWidget {
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

  chooseImage() {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.gallery);
    });
    setStatus('');
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  uploadImg() {
    if (null == tmpFile) {
      setStatus(error);
      return;
    }

    String fileName = tmpFile.path.split('/').last;

    upload(fileName);
  }

  upload(String fileName) {
    http.post('http://10.0.2.2:3001/api/v1/images',
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "image": base64Image,
          "imageName": fileName,
          "email": "asd@asd.asd",
          "isHumanChecked": false,
          "user_id": "1",
          "dataset": "asdasdasd",
          "dataset_id": "1",
          "object": [
            {
              "label": "lounge",
              "bbox": [
                {
                  "x": 100,
                  "y": 100,
                  "width": 100,
                  "height": 100,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image/Data'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder<File>(
              future: file,
              builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    null != snapshot.data) {
                  tmpFile = snapshot.data;
                  base64Image = base64Encode(snapshot.data.readAsBytesSync());
                  return Container(
                    margin: EdgeInsets.all(15),
                    child: Material(
                      elevation: 3.0,
                      child: Image.file(
                        snapshot.data,
                        fit: BoxFit.fill,
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
                          Container(
                            child: Image.asset('assets/placeholder-image.png'),
                          ),
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

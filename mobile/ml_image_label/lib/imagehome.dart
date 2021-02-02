import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  List datasets = List();
  List labels = List();
  File tmpFile;
  String error = 'Error';
  var imagex;
  var imagey;
  var datasetValue;
  var labelValue;
  var tempWidth;
  var tempHeight;
  var width;
  var height;

  chooseImage() {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.gallery);
    });
    setStatus('done.');
  }

  Future<String> fetchDatasets() async {
    var response = await http.get('http://10.0.2.2:3001/api/v1/datasets');
    var allResponses = json.decode(response.body);

    setState(() {
      allResponses.map((dataset) {
        print(dataset["labels"].toString());
      });
      labelValue = allResponses[0]['labels'][0];
      datasets = allResponses;
    });

    return "Success";
  }

  @override
  void initState() {
    super.initState();
    this.fetchDatasets();
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

  upload(String fileName) async {
    SharedPreferences store = await SharedPreferences.getInstance();
    await http
        .post('http://10.0.2.2:3001/api/v1/images',
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "image": base64Image,
              "imageName": fileName,
              "email": store.getString('email'),
              "isHumanChecked": false,
              "user_id": store.getString('id'),
              "dataset_id": datasetValue,
              "object": [
                {
                  "label": labelValue,
                  "bbox": [
                    {
                      "x": imagex,
                      "y": imagey,
                      "width": width,
                      "height": height,
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

  onTap(details) {
    imagex = details.globalPosition.dx;
    imagey = details.globalPosition.dy;
  }

  onPanUpdate(details) {
    if (details.delta.dx != null) tempWidth += details.delta.dx;
    if (details.delta.dy != null) tempHeight += details.delta.dy;
    print(tempWidth);
    print(tempHeight);
  }

  onPanEnd() async {
    SharedPreferences store = await SharedPreferences.getInstance();

    width = tempWidth;
    height = tempHeight;
    tempWidth = 0;
    tempHeight = 0;

    store.setDouble('width', width);
    store.setDouble('height', height);
    store.setDouble('x', imagex);
    store.setDouble('y', imagey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Upload Image/Data'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            FutureBuilder<File>(
              future: file,
              builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    null != snapshot.data) {
                  tmpFile = snapshot.data;
                  base64Image = base64Encode(snapshot.data.readAsBytesSync());
                  var image = Image.file(
                    snapshot.data,
                    fit: BoxFit.fitHeight,
                  );
                  // print(image.height);

                  return Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        child: new GestureDetector(
                          onTap: () => print(snapshot.data),
                          onPanStart: (details) => onTap(details),
                          onPanUpdate: (details) => onPanUpdate(details),
                          onPanEnd: (details) => onPanEnd(),
                          child: Material(
                            elevation: 3.0,
                            child: image,
                          ),
                        ),
                      ),
                      Container(
                        child: CustomPaint(
                          painter: OpenPainter(),
                        ),
                      ),
                    ],
                  );
                } else if (null != snapshot.error) {
                  return const Text(
                    'Error!',
                    textAlign: TextAlign.center,
                  );
                } else {
                  return Container(
                      margin: EdgeInsets.all(25),
                      child: FlatButton(
                        child: Text(
                          'Choose an image',
                          style: TextStyle(fontSize: 20.0),
                        ),
                        onPressed: () {
                          chooseImage();
                        },
                      ));
                }
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              padding: EdgeInsets.all(12),
              child: Text("X: " +
                  imagex.toString() +
                  " Y: " +
                  imagey.toString() +
                  " Width: " +
                  width.toString() +
                  " Height: " +
                  height.toString()),
            ),
            Container(
              width: 360,
              height: 50,
              child: new DropdownButton(
                isExpanded: true,
                items: datasets
                    .map((dataset) => new DropdownMenuItem(
                        child: new Text(dataset['name']),
                        value: dataset['id'].toString()))
                    .toList(),
                onChanged: (newVal) {
                  setState(() {
                    datasetValue = newVal;
                    print(datasetValue);
                  });
                },
                value: datasetValue,
                hint: Text("Please select a dataset"),
              ),
            ),
            Container(
              width: 360,
              height: 50,
              child: new DropdownButton(
                isExpanded: true,
                items: datasets
                    .map((dataset) => new DropdownMenuItem(
                        child: new Text(dataset['name']),
                        value: dataset['id'].toString()))
                    .toList(),
                onChanged: (newVal) {
                  setState(() {
                    datasetValue = newVal;
                  });
                },
                value: datasetValue,
                hint: Text("Please select a Label from the dataset"),
              ),
            ),
            Container(
              padding: EdgeInsets.all(6),
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

class OpenPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) async {
    SharedPreferences store = await SharedPreferences.getInstance();

    var paint1 = Paint()
      ..color = Colors.lightGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0;
    canvas.drawRect(
        Offset(store.getDouble('x'), store.getDouble('y')) &
            Size(store.getDouble('width'), store.getDouble('height')),
        paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

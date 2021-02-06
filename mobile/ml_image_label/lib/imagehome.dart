import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

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
  File tmpFile;
  String base64Image;

  var imageRect;
  Future fetchRect;

  List datasets = List();
  var datasetName;
  var datasetValue;

  Future allLabels;
  List labels = List();
  var labelValue;

  var imagex;
  var imagey;
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
      datasets = allResponses;
    });

    return "Success";
  }

  Future<String> fetchLabels() async {
    var response = await http.get(
        'http://10.0.2.2:3001/api/v1/datasets/dataset/' +
            datasetValue.toString());

    var allResponses = json.decode(response.body);

    setState(() {
      var selected = allResponses[0];
      datasetName = selected['name'];
      labels = selected['labels'];
    });

    return "Success";
  }

  Future<String> drawRect() async {
    setState(() {
      imageRect = OpenPainter(imagex, imagey, width, height);
    });

    return 'Success';
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

  uploadImg() async {
    String fileName = tmpFile.path.split('/').last;
    await upload(fileName);
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
              "dataset": datasetName,
              "dataset_id": datasetValue,
              "object": {
                "label": labelValue,
                "bbox": {
                  "x": imagex,
                  "y": imagey,
                  "width": width,
                  "height": height,
                }
              }
            }))
        .then((result) {
      try {
        if (result.statusCode == 200) {
          clearData();
        }
      } catch (error) {
        print(error);
      }
      setStatus(result.statusCode == 200 ? result.body : result.statusCode);
    }).catchError((error) {
      setStatus(error);
    });
  }

  onPanStart(details) {
    imagex = details.localPosition.dx;
    imagey = details.localPosition.dy;
  }

  onPanUpdate(details) {
    if (details.delta.dx != null) tempWidth += details.delta.dx;
    if (details.delta.dy != null) tempHeight += details.delta.dy;
  }

  onPanEnd() async {
    width = tempWidth;
    height = tempHeight;
    tempWidth = 0;
    tempHeight = 0;

    fetchRect = this.drawRect();
  }

  void clearData() {
    this.tmpFile = null;
    this.base64Image = null;
    this.width = null;
    this.height = null;
    this.imagex = null;
    this.imagey = null;
    this.labelValue = null;
    this.datasetValue = null;
    this.datasetName = null;
  }

  @override
  Widget build(BuildContext context) {
    print(tmpFile);
    print(base64Image);
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image/Data'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            FutureBuilder<File>(
              future: file,
              builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  tmpFile = snapshot.data;
                  base64Image = base64Encode(snapshot.data.readAsBytesSync());
                  var image = Image.file(
                    snapshot.data,
                    fit: BoxFit.fitHeight,
                  );
                  return Container(
                    margin: EdgeInsets.all(16),
                    child: Stack(
                      // fit: StackFit.loose,
                      children: [
                        Container(
                          child: new GestureDetector(
                            onPanStart: (details) => onPanStart(details),
                            onPanUpdate: (details) => onPanUpdate(details),
                            onPanEnd: (details) => onPanEnd(),
                            child: Material(
                              elevation: 3.0,
                              child: image,
                            ),
                          ),
                        ),
                        FutureBuilder(
                            future: fetchRect,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Container();
                              } else if (snapshot.hasError) {
                                return Text(snapshot.error);
                              }
                              return Container(
                                child: CustomPaint(
                                  painter: imageRect,
                                ),
                              );
                            }),
                      ],
                    ),
                  );
                } if (snapshot.hasError) {
                  return const Text(
                    'Error!',
                    textAlign: TextAlign.center,
                  );
                } else {
                  return Container();
                }
              },
            ),
            SizedBox(
              height: 10.0,
            ),


            Container(
              margin: EdgeInsets.all(16),
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
                    allLabels = this.fetchLabels();
                  });
                },
                value: datasetValue,
                hint: Text("Please select a dataset"),
              ),
            ),
            FutureBuilder(
                future: allLabels,
                // ignore: missing_return
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(16),
                      child: Text("Select a dataset first."),
                    );
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error);
                  }
                  return Container(
                    margin: EdgeInsets.all(16),
                    child: new DropdownButton(
                      isExpanded: true,
                      items: labels
                          .map((label) => new DropdownMenuItem(
                              child: new Text(label), value: label))
                          .toList(),
                      onChanged: (newVal) {
                        setState(() {
                          labelValue = newVal;
                        });
                      },
                      value: labelValue,
                      hint: Text("Please select a Label from the dataset"),
                    ),
                  );
                }),
            Container(
              margin: EdgeInsets.fromLTRB(16,0,16,0),
              child: RaisedButton(
                child: Text(
                  'Upload Image',
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
                color: Colors.blue,
                onPressed: () {
                  uploadImg();
                  navigateToSubPage(context);
                },
              ),
            ),
            Container (
              margin: EdgeInsets.fromLTRB(16,0,16,0),
              child: Center(
                child: Text(
                  "or",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.fromLTRB(16,0,16,0),
                child: RaisedButton(
                  color: Colors.blue,
                  child: Text(
                    'Choose an image',
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                  onPressed: () {
                    chooseImage();
                  },
                )),
          ],
        ),
      ),
    );
  }
}

class OpenPainter extends CustomPainter {
  OpenPainter(this.x, this.y, this.width, this.height);

  final double x;
  final double y;
  final double width;
  final double height;

  @override
  void paint(Canvas canvas, Size size) async {
    var paint1 = new Paint()
      ..color = Colors.lightGreenAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;
    canvas.drawRect(new Rect.fromLTWH(x, y, width, height), paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}


class SubPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Completed!'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Your Upload Is Completed.'),
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: Text('Upload Another Label'),
                  color: Colors.blue,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text('Exit The App'),
                  color: Colors.blue,
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                ),
              ],
                alignment:MainAxisAlignment.center,
                mainAxisSize:MainAxisSize.max
            ),
          ],
        ),
      ),
    );
  }
}

Future navigateToSubPage(context) async {
  Navigator.push(context, MaterialPageRoute(builder: (context) => SubPage()));
}

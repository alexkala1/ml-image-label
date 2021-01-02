import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mongo_dart/mongo_dart.dart' show Db, DbCollection, GridFS;
import 'dart:convert';
import 'package:flutter_image_compress/flutter_image_compress.dart';



void main() => runApp(new MyApp());



class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geeks Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'GeeksforGeeks'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin{

  final url = [
  "http://192.168.1.6:27017/imageLabel/images",
  "mongodb://localhost:27017/imageLabel/images"
  ];

  final picker = ImagePicker();
  File _image;
  GridFS bucket;
  AnimationController _animationController;
  Animation<Color> _colorTween;
  ImageProvider provider;
  var flag = false;

  @override
  void initState() {

    _animationController = AnimationController(
      duration: Duration(milliseconds: 1800),
      vsync: this,
    );
    _colorTween = _animationController.drive(ColorTween(begin: Colors.green, end: Colors.deepOrange));
    _animationController.repeat();
    super.initState();
    connection();
  }

  Future getImage() async{

    final pickedFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    if(pickedFile!=null){

      var _cmpressed_image;
      try {
        _cmpressed_image = await FlutterImageCompress.compressWithFile(
            pickedFile.path,
            format: CompressFormat.heic,
            quality: 70
        );
      } catch (e) {

        _cmpressed_image = await FlutterImageCompress.compressWithFile(
            pickedFile.path,
            format: CompressFormat.jpeg,
            quality: 70
        );
      }
      setState(() {
        flag = true;
      });

      Map<String,dynamic> image = {
        "_id" : pickedFile.path.split("/").last,
        "data": base64Encode(_cmpressed_image)
      };
      var res = await bucket.chunks.insert(image);
      var img = await bucket.chunks.findOne({
        "_id": pickedFile.path.split("/").last
      });
      setState(() {
        provider = MemoryImage(base64Decode(img["data"]));
        flag = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Colors.green,
        ),
        body: SingleChildScrollView(
            child: Center(
              child:  Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  provider == null ? Text('No image selected.') : Image(image: provider,),
                  SizedBox(height: 10,),
                  if(flag==true)
                    CircularProgressIndicator(valueColor: _colorTween),
                  SizedBox(height: 20,),
                  RaisedButton(
                    onPressed: getImage,
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            Colors.green,
                            Colors.green[200],
                            Colors.green[900],
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(10.0),
                      child: const Text(
                          'Select Image',
                          style: TextStyle(fontSize: 20)
                      ),
                    ),

                  ),
                ],
              ),
            )
        )

    );
  }

  Future connection () async{
    Db _db = new Db.pool(url);
    await _db.open(secure: true);
    bucket = GridFS(_db,"image");
  }
}























//
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return new MaterialApp(
//       title: 'Flutter Simple Login Demo',
//       theme: new ThemeData(
//           primarySwatch: Colors.blue
//       ),
//       home: new LoginPage(),
//     );
//   }
// }
//
// class LoginPage extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => new _LoginPageState();
// }
//
// // Used for controlling whether the user is loggin or creating an account
// enum FormType {
//   login,
//   register
// }
//
// class _LoginPageState extends State<LoginPage> {
//
//   final TextEditingController _emailFilter = new TextEditingController();
//   final TextEditingController _passwordFilter = new TextEditingController();
//   String _email = "";
//   String _password = "";
//   FormType _form = FormType.login; // our default setting is to login, and we should switch to creating an account when the user chooses to
//
//   _LoginPageState() {
//     _emailFilter.addListener(_emailListen);
//     _passwordFilter.addListener(_passwordListen);
//   }
//
//   void _emailListen() {
//     if (_emailFilter.text.isEmpty) {
//       _email = "";
//     } else {
//       _email = _emailFilter.text;
//     }
//   }
//
//   void _passwordListen() {
//     if (_passwordFilter.text.isEmpty) {
//       _password = "";
//     } else {
//       _password = _passwordFilter.text;
//     }
//   }
//
//   // Swap in between our two forms, registering and logging in
//   void _formChange () async {
//     setState(() {
//       if (_form == FormType.register) {
//         _form = FormType.login;
//       } else {
//         _form = FormType.register;
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//       appBar: _buildBar(context),
//       body: new Container(
//         padding: EdgeInsets.all(16.0),
//         child: new Column(
//           children: <Widget>[
//             _buildTextFields(),
//             _buildButtons(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBar(BuildContext context) {
//     return new AppBar(
//       title: new Text("Login"),
//       centerTitle: true,
//     );
//   }
//
//   Widget _buildTextFields() {
//     return new Container(
//       child: new Column(
//         children: <Widget>[
//           new Container(
//             child: new TextField(
//               controller: _emailFilter,
//               decoration: new InputDecoration(
//                   labelText: 'Email'
//               ),
//             ),
//           ),
//           new Container(
//             child: new TextField(
//               controller: _passwordFilter,
//               decoration: new InputDecoration(
//                   labelText: 'Password'
//               ),
//               obscureText: true,
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget _buildButtons() {
//     if (_form == FormType.login) {
//       return new Container(
//         child: new Column(
//           children: <Widget>[
//             new RaisedButton(
//               child: new Text('Login'),
//               onPressed: _loginPressed,
//             ),
//             new FlatButton(
//               child: new Text('Dont have an account? Tap here to register.'),
//               onPressed: _formChange,
//             ),
//             new FlatButton(
//               child: new Text('Forgot Password?'),
//               onPressed: _passwordReset,
//             )
//           ],
//         ),
//       );
//     } else {
//       return new Container(
//         child: new Column(
//           children: <Widget>[
//             new RaisedButton(
//               child: new Text('Create an Account'),
//               onPressed: _createAccountPressed,
//             ),
//             new FlatButton(
//               child: new Text('Have an account? Click here to login.'),
//               onPressed: _formChange,
//             )
//           ],
//         ),
//       );
//     }
//   }
//
//   // These functions can self contain any user auth logic required, they all have access to _email and _password
//
//   void _loginPressed () {
//     print('The user wants to login with $_email and $_password');
//
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => ImageCapture()),
//     );
//   }
//
//   void _createAccountPressed () {
//     print('The user wants to create an accoutn with $_email and $_password');
//
//   }
//
//   void _passwordReset () {
//     print("The user wants a password reset request sent to $_email");
//   }
//
//
// }
//
//
// /// Widget to capture and crop the image
// class ImageCapture extends StatefulWidget {
//   createState() => _ImageCaptureState();
// }
//
// class _ImageCaptureState extends State<ImageCapture> {
//   /// Active image file
//   File _imageFile;
//
//
//   /// Select an image via gallery or camera
//   Future<void> _pickImage(ImageSource source) async {
//     File selected = await ImagePicker.pickImage(source: source);
//
//     setState(() {
//       _imageFile = selected;
//     });
//   }
//   /// Cropper plugin
//   Future<void> _cropImage() async {
//     File cropped = await ImageCropper.cropImage(
//         sourcePath: _imageFile.path,
//         // ratioX: 1.0,
//         // ratioY: 1.0,
//         // maxWidth: 512,
//         // maxHeight: 512,
//         toolbarColor: Colors.purple,
//         toolbarWidgetColor: Colors.white,
//         toolbarTitle: 'Crop It'
//     );
//
//     setState(() {
//       _imageFile = cropped ?? _imageFile;
//     });
//   }
//
//   /// Remove image
//   void _clear() {
//     setState(() => _imageFile = null);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//
//       // Select an image from the camera or gallery
//       bottomNavigationBar: BottomAppBar(
//         child: Row(
//           children: <Widget>[
//             IconButton(
//               icon: Icon(Icons.photo_camera),
//               onPressed: () => _pickImage(ImageSource.camera),
//             ),
//             IconButton(
//               icon: Icon(Icons.photo_library),
//               onPressed: () => _pickImage(ImageSource.gallery),
//             ),
//           ],
//         ),
//       ),
//
//       // Preview the image and crop it
//       body: ListView(
//         children: <Widget>[
//           if (_imageFile != null) ...[
//
//             Image.file(_imageFile),
//
//             Row(
//               children: <Widget>[
//                 FlatButton(
//                   child: Icon(Icons.crop),
//                   onPressed: _cropImage,
//                 ),
//                 FlatButton(
//                   child: Icon(Icons.refresh),
//                   onPressed: _clear,
//                 ),
//               ],
//             ),
//
//             // Uploader(file: _imageFile)
//           ]
//         ],
//       ),
//     );
//   }
// }
//
//
//
// class DBConnection {
//
//   static DBConnection _instance;
//
//   final String _host = "localhost";
//   final String _port = "27017";
//   final String _dbName = "imageLabel";
//   Db _db;
//
//   static getInstance(){
//     if(_instance == null) {
//       _instance = DBConnection();
//     }
//     return _instance;
//   }
//
//   Future<Db> getConnection() async{
//     if (_db == null){
//       try {
//         _db = Db(_getConnectionString());
//         await _db.open();
//       } catch(e){
//         print(e);
//       }
//     }
//     return _db;
//   }
//
//   _getConnectionString(){
//     return "mongodb://localhost/imageLabel";
//   }
//
//   closeConnection() {
//     _db.close();
//   }
//
// }

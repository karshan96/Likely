import 'package:Likely/models/data_model.dart';
import 'package:Likely/screens/view/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:Likely/screens/custom_widgets/menu_widget.dart';
import 'package:intl/intl.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:Likely/services/auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:image_picker_web/image_picker_web.dart';
// import 'package:firebase/firebase.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:path/path.dart';

import 'dart:async';
import 'dart:io' as io;
import 'package:flutter/foundation.dart';
// import 'dart:html';

// import 'package:mime_type/mime_type.dart';

import '../../services/auth.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final AuthService _auth = AuthService();
  List<House> houses = List();
  House house;
  // DatabaseReference houseRef;
  final firestoreInstance = Firestore.instance;

  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  // StreamSubscription<Event> _onTodoAddedSubscription;
  // StreamSubscription<Event> _onTodoChangedSubscription;
  String _error = '';
  String url = '';
  var imageUri;
  var mediaInfo;
  io.File sampleImage;

  PickedFile imageFile;
  dynamic pickImageError;
  String _retrieveDataError;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    try {
      house = House(
          amount: 0,
          address: '',
          date: DateTime.now().toString(),
          bedrooms: 0,
          bathrooms: 0,
          kitchen: 0,
          garages: 0,
          squarefoot: 0,
          description: '',
          phone: '');
      // final FirebaseDatabase database = FirebaseDatabase.instance;
      // database.setPersistenceEnabled(true);
      // database.setPersistenceCacheSizeBytes(10000000);
      // houseRef = database.reference().child('houses');
      // _onTodoAddedSubscription = houseRef.onChildAdded.listen(_onEntryAdded);
      // _onTodoChangedSubscription =
      //     houseRef.onChildChanged.listen(_onEntryChanged);
    } catch (e) {
      print(e);
    }
  }

  // @override
  // void dispose() {
  //   _onTodoAddedSubscription.cancel();
  //   _onTodoChangedSubscription.cancel();
  //   super.dispose();
  // }

  // _onEntryAdded(Event event) {
  //   setState(() {
  //     houses.add(House.fromSnapshot(event.snapshot));
  //   });
  // }

  // _onEntryChanged(Event event) {
  //   var old = houses.singleWhere((entry) {
  //     return entry.key == event.snapshot.key;
  //   });
  //   setState(() {
  //     houses[houses.indexOf(old)] = House.fromSnapshot(event.snapshot);
  //   });
  // }

  void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
    await _displayPickImageDialog(context,
        (double maxWidth, double maxHeight, int quality) async {
      try {
        final pickedFile = await _picker.getImage(
          source: source,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          imageQuality: quality,
        );
        setState(() {
          imageFile = pickedFile;
        });
      } catch (e) {
        setState(() {
          pickImageError = e;
        });
      }
    });
  }
  // imagePicker() async {
  //   mediaInfo = await ImagePickerWeb.getImageInfo;

  //   window.console.info(mediaInfo);
  // }

  // uploadFile(MediaInfo mediaInfo, String ref, String fileName) {
  //   try {
  //     String mimeType = mime(basename(mediaInfo.fileName));
  //     var metaData = UploadMetadata(contentType: mimeType);
  //     StorageReference storageReference = storage().ref(ref).child(fileName);

  //     UploadTask uploadTask = storageReference.put(mediaInfo.data, metaData);
  //     uploadTask.future.then((snapshot) => {
  //           Future.delayed(Duration(seconds: 1)).then((value) => {
  //                 snapshot.ref.getDownloadURL().then((dynamic uri) {
  //                   imageUri = uri;
  //                   window.console.info('Download URL: ${imageUri.toString()}');
  //                   handleSubmit(imageUri);
  //                 })
  //               })
  //         });
  //   } catch (e) {
  //     print('File Upload Error: $e');
  //   }
  // }

  Future<void> retrieveLostData() async {
    final LostData response = await _picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        imageFile = response.file;
      });
    } else {
      _retrieveDataError = response.exception.code;
    }
  }

  void uploadImage() async {
    final StorageReference postImageRef =
        FirebaseStorage.instance.ref().child('House images');

    var timeKey = new DateTime.now();

    final StorageUploadTask uploadTask =
        postImageRef.child(timeKey.toString() + '.jpg').putFile(sampleImage);

    var imageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    print(imageUrl);

    url = imageUrl.toString();
    // window.console.info(url);

    handleSubmit(url);
  }

  void handleSubmit(url) {
    try {
      // window.console.info(url.toString());
      house.imageUrl = url.toString();
      // final FormBuilderState form = formKey.currentState;
      // print(house.toJson());
      // houseRef.push().set(house.toJson());
      firestoreInstance.collection("houses").add(house.toJson()).then((value) {
        // window.console.info(url);
        // print(value.documentID);
      });
      formKey.currentState.reset();
      imageFile = null;
      Navigator.of(context).pop(false);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
      Navigator.of(context).pop(false);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 15,
                      right: 15,
                      left: 15,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        MenuWidget(
                            iconImg: Icons.arrow_back,
                            iconColor: Colors.grey,
                            conBackColor: Colors.transparent,
                            onbtnTap: () {
                              Navigator.of(context).pop(false);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Home(),
                                ),
                              );
                              Navigator.of(context).pop(false);
                            }),
                        MenuWidget(
                            iconImg: Icons.person,
                            iconColor: Colors.grey,
                            conBackColor: Colors.transparent,
                            onbtnTap: () async {
                              await _auth.signOut();
                              Navigator.of(context).pop(false);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Home()),
                              );
                              Navigator.of(context).pop(false);
                            })
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 15,
                  right: 15,
                  left: 15,
                ),
              ),
              FormBuilder(
                key: formKey,
                autovalidate: true,
                child: Column(
                  children: <Widget>[
                    FormBuilderDateTimePicker(
                        maxLines: 1,
                        autofocus: false,
                        attribute: "date",
                        inputType: InputType.date,
                        format: DateFormat("yyyy-MM-dd"),
                        decoration: InputDecoration(
                          labelText: "Date",
                          icon: new Icon(
                            Icons.date_range,
                            color: Colors.grey,
                          ),
                          // border: InputBorder.none,
                        ),
                        onChanged: (val) {
                          // house.date = val.toString();
                        },
                        validators: [
                          FormBuilderValidators.required(),
                        ]),
                    FormBuilderTextField(
                        attribute: "phone",
                        initialValue: null,
                        decoration: InputDecoration(
                          labelText: "Contact Number",
                          icon: new Icon(
                            Icons.phone,
                            color: Colors.grey,
                          ),
                          // border: InputBorder.none,
                        ),
                        onChanged: (val) => house.phone = val,
                        validators: [
                          FormBuilderValidators.required(),
                        ]),
                    FormBuilderTextField(
                        attribute: "address",
                        initialValue: null,
                        decoration: InputDecoration(
                          labelText: "Address",
                          icon: new Icon(
                            Icons.house,
                            color: Colors.grey,
                          ),
                          // border: InputBorder.none,
                        ),
                        onChanged: (val) => house.address = val,
                        validators: [
                          FormBuilderValidators.required(),
                        ]),
                    FormBuilderTextField(
                      maxLines: 1,
                      autofocus: false,
                      attribute: "amount",
                      initialValue: null,
                      decoration: InputDecoration(
                        labelText: "Amount",
                        icon: new Icon(
                          Icons.attach_money,
                          color: Colors.grey,
                        ),
                        // border: InputBorder.none,
                      ),
                      onChanged: (val) => house.amount = int.parse(val),
                      validators: [
                        FormBuilderValidators.required(),
                        FormBuilderValidators.numeric(),
                      ],
                    ),
                    FormBuilderTextField(
                      maxLines: 1,
                      autofocus: false,
                      attribute: "squarefoot",
                      initialValue: null,
                      decoration: InputDecoration(
                        labelText: "Squarefoot",
                        icon: new Icon(
                          Icons.square_foot,
                          color: Colors.grey,
                        ),
                        // border: InputBorder.none,
                      ),
                      onChanged: (val) => house.squarefoot = int.parse(val),
                      validators: [
                        FormBuilderValidators.required(),
                        FormBuilderValidators.numeric(),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: FormBuilderDropdown(
                            autofocus: false,
                            attribute: "bedrooms",
                            decoration: InputDecoration(
                              labelText: "Bedrooms",
                              icon: new Icon(
                                Icons.room,
                                color: Colors.grey,
                              ),
                              // border: InputBorder.none,
                            ),
                            onChanged: (val) => house.bedrooms = val,
                            hint: Text('-'),
                            validators: [FormBuilderValidators.required()],
                            items: [0, 1, 2, 3, 4, 5, 6]
                                .map((bedrooms) => DropdownMenuItem(
                                    value: bedrooms, child: Text("$bedrooms")))
                                .toList(),
                          ),
                        ),
                        Expanded(
                          child: FormBuilderDropdown(
                            autofocus: false,
                            attribute: "bathrooms",
                            decoration: InputDecoration(
                              labelText: "Bathrooms",
                              icon: new Icon(
                                Icons.room,
                                color: Colors.grey,
                              ),
                              // border: InputBorder.none,
                            ),
                            onChanged: (val) => house.bathrooms = val,
                            hint: Text('-'),
                            validators: [FormBuilderValidators.required()],
                            items: [0, 1, 2, 3, 4, 5, 6]
                                .map((bathrooms) => DropdownMenuItem(
                                    value: bathrooms,
                                    child: Text("$bathrooms")))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: FormBuilderDropdown(
                            autofocus: false,
                            attribute: "kitchen",
                            decoration: InputDecoration(
                              labelText: "Kitchen",
                              icon: new Icon(
                                Icons.room,
                                color: Colors.grey,
                              ),
                              // border: InputBorder.none,
                            ),
                            onChanged: (val) => house.kitchen = val,
                            hint: Text('-'),
                            validators: [FormBuilderValidators.required()],
                            items: [0, 1, 2, 3, 4, 5, 6]
                                .map((kitchen) => DropdownMenuItem(
                                    value: kitchen, child: Text("$kitchen")))
                                .toList(),
                          ),
                        ),
                        Expanded(
                          child: FormBuilderDropdown(
                            autofocus: false,
                            attribute: "garages",
                            decoration: InputDecoration(
                              labelText: "Garages",
                              icon: new Icon(
                                Icons.room,
                                color: Colors.grey,
                              ),
                              // border: InputBorder.none,
                            ),
                            onChanged: (val) => house.garages = val,
                            hint: Text('-'),
                            validators: [FormBuilderValidators.required()],
                            items: [0, 1, 2, 3, 4, 5, 6]
                                .map((garages) => DropdownMenuItem(
                                    value: garages, child: Text("$garages")))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        // imagePicker();
                        _onImageButtonPressed(ImageSource.gallery,
                            context: context);
                      },
                      heroTag: 'image',
                      tooltip: 'Pick Image from gallery',
                      child: const Icon(Icons.photo_library),
                    ),
                    Center(
                      child: !kIsWeb &&
                              defaultTargetPlatform == TargetPlatform.android
                          ? FutureBuilder<void>(
                              future: retrieveLostData(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<void> snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.none:
                                  case ConnectionState.waiting:
                                    return const Text(
                                      'You have not yet picked an image.',
                                      textAlign: TextAlign.center,
                                    );
                                  case ConnectionState.done:
                                    return previewImage();
                                  default:
                                    if (snapshot.hasError) {
                                      return Text(
                                        'Pick image: ${snapshot.error}}',
                                        textAlign: TextAlign.center,
                                      );
                                    } else {
                                      return const Text(
                                        'You have not yet picked an image.',
                                        textAlign: TextAlign.center,
                                      );
                                    }
                                }
                              },
                            )
                          : previewImage(),
                    ),
                    FormBuilderTextField(
                      attribute: "description",
                      initialValue: null,
                      decoration: InputDecoration(
                        labelText: "Description",
                        icon: new Icon(
                          Icons.description,
                          color: Colors.grey,
                        ),
                        // border: InputBorder.none,
                      ),
                      onChanged: (val) => house.description = val,
                      validators: [
                        FormBuilderValidators.required(),
                      ],
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    Text(
                      _error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                        child: SizedBox(
                          height: 40.0,
                          width: 400.0,
                          child: new RaisedButton(
                              elevation: 5.0,
                              // shape: new RoundedRectangleBorder(
                              //     borderRadius:
                              //         new BorderRadius.circular(30.0)),
                              color: Colors.grey,
                              child: new Text('Add Product',
                                  style: new TextStyle(
                                      fontSize: 20.0, color: Colors.white)),
                              onPressed: () {
                                if (formKey.currentState.saveAndValidate()) {
                                  // uploadFile(mediaInfo, 'House images',
                                  //     mediaInfo.fileName);
                                  uploadImage();
                                }
                              }),
                        )),
                    FlatButton(
                        child: new Text(
                          'Reset',
                        ),
                        onPressed: () {
                          formKey.currentState.reset();
                        }),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Future<void> _displayPickImageDialog(
      BuildContext context, OnPickImageCallback onPick) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add Photo'),
            actions: <Widget>[
              FlatButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                  child: const Text('PICK'),
                  onPressed: () {
                    onPick(null, null, null);
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  Widget previewImage() {
    final Text retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (imageFile != null) {
      sampleImage = io.File(imageFile.path);
      if (kIsWeb) {
        return Image.network(imageFile.path);
      } else {
        return Image.file(io.File((imageFile.path)));
      }
      // sampleImage = File(imageFile.path);
      // return Image.file(File(imageFile.path));
    } else if (pickImageError != null) {
      return Text(
        'Pick image error: $pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }

  Text _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }
}

typedef void OnPickImageCallback(
    double maxWidth, double maxHeight, int quality);

import 'package:Likely/screens/view/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:Likely/screens/custom_widgets/menu_widget.dart';
import 'package:intl/intl.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:Likely/services/auth.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:async';
import 'dart:io';

import '../../services/auth.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final AuthService _auth = AuthService();

  final _formKey = GlobalKey<FormState>();
  int amount = 0;
  int bedrooms = 0;
  int bathrooms = 0;
  int garages = 0;
  int kitchen = 0;
  String date;
  String address = '';
  double squarefoot = 0.0;
  String _error = '';

  PickedFile imageFile;
  dynamic pickImageError;
  String _retrieveDataError;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();

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
                            })
                      ],
                    ),
                  )
                ],
              ),
              FormBuilder(
                key: _formKey,
                autovalidate: true,
                child: Column(
                  children: <Widget>[
                    FormBuilderDateTimePicker(
                      maxLines: 1,
                      obscureText: true,
                      autofocus: false,
                      attribute: "date",
                      inputType: InputType.date,
                      format: DateFormat("yyyy-MM-dd"),
                      decoration: InputDecoration(labelText: "Date"),
                    ),
                    FormBuilderTextField(
                      attribute: "address",
                      decoration: InputDecoration(labelText: "Address"),
                    ),
                    FormBuilderTextField(
                      maxLines: 1,
                      obscureText: true,
                      autofocus: false,
                      attribute: "amount",
                      decoration: InputDecoration(labelText: "Amount"),
                      validators: [
                        FormBuilderValidators.numeric(),
                        FormBuilderValidators.max(70),
                      ],
                    ),
                    FormBuilderTextField(
                      maxLines: 1,
                      obscureText: true,
                      autofocus: false,
                      attribute: "squarefoot",
                      decoration: InputDecoration(labelText: "Squarefoot"),
                      validators: [
                        FormBuilderValidators.numeric(),
                        FormBuilderValidators.max(70),
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
                            decoration: InputDecoration(labelText: "Bedrooms"),
                            // initialValue: 'Male',
                            hint: Text('-'),
                            validators: [FormBuilderValidators.required()],
                            items: [1, 2, 3, 4, 5, 6]
                                .map((bedrooms) => DropdownMenuItem(
                                    value: bedrooms, child: Text("$bedrooms")))
                                .toList(),
                          ),
                        ),
                        Expanded(
                          child: FormBuilderDropdown(
                            autofocus: false,
                            attribute: "bedrooms",
                            decoration: InputDecoration(labelText: "Bedrooms"),
                            // initialValue: 'Male',
                            hint: Text('-'),
                            validators: [FormBuilderValidators.required()],
                            items: [1, 2, 3, 4, 5, 6]
                                .map((bedrooms) => DropdownMenuItem(
                                    value: bedrooms, child: Text("$bedrooms")))
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
                            decoration: InputDecoration(labelText: "Kitchen"),
                            // initialValue: 'Male',
                            hint: Text('-'),
                            validators: [FormBuilderValidators.required()],
                            items: [1, 2, 3, 4, 5, 6]
                                .map((kitchen) => DropdownMenuItem(
                                    value: kitchen, child: Text("$kitchen")))
                                .toList(),
                          ),
                        ),
                        Expanded(
                          child: FormBuilderDropdown(
                            autofocus: false,
                            attribute: "garages",
                            decoration: InputDecoration(labelText: "Garages"),
                            // initialValue: 'Male',
                            hint: Text('-'),
                            validators: [FormBuilderValidators.required()],
                            items: [1, 2, 3, 4, 5, 6]
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
                        _onImageButtonPressed(ImageSource.gallery,
                            context: context);
                      },
                      heroTag: 'image0',
                      tooltip: 'Pick Image from gallery',
                      child: const Icon(Icons.photo_library),
                    ),
                    Center(
                      child: (previewImage()),
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
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(30.0)),
                              color: Colors.blue,
                              child: new Text('Add Product',
                                  style: new TextStyle(
                                      fontSize: 20.0, color: Colors.white)),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {}
                              }),
                        )),
                    FlatButton(
                        child: new Text(
                          'Reset',
                        ),
                        onPressed: () {
                          _formKey.currentState.reset();
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
            title: Text('Add optional parameters'),
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
                    double width = maxWidthController.text.isNotEmpty
                        ? double.parse(maxWidthController.text)
                        : null;
                    double height = maxHeightController.text.isNotEmpty
                        ? double.parse(maxHeightController.text)
                        : null;
                    int quality = qualityController.text.isNotEmpty
                        ? int.parse(qualityController.text)
                        : null;
                    onPick(width, height, quality);
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
      return Image.file(File(imageFile.path));
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

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '/biz/docsite.dart';

class DocsiteValues extends StatefulWidget {
  const DocsiteValues({super.key, required this.store});

  final DocsiteValuesCore store;

  @override
  _DocsiteValuesState createState() => _DocsiteValuesState();
}

class _DocsiteValuesState extends State<DocsiteValues> {
  final TextEditingController $url = TextEditingController();
  final TextEditingController $name = TextEditingController();
  final TextEditingController $overview = TextEditingController();
  final TextEditingController $version = TextEditingController();
  DateTime? selectedDateTime;

  String? _image;
  bool showImagePicker = false;

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    $url.addListener(() {
      widget.store.setURL($url.text);
    });
    $name.addListener(() {
      widget.store.setName($name.text);
    });
    $version.addListener(() {
      widget.store.setVersion($version.text);
    });
    $overview.addListener(() {
      widget.store.setOverview($overview.text);
    });

    widget.store.onNameChange((_) {
      $name.text = widget.store.name;
    });
    widget.store.onFaviconChange((_) {
      _image = widget.store.favicon;
    });
    widget.store.onValuesChange((_) {
      $url.text = widget.store.url;
      $name.text = widget.store.name;
      $version.text = widget.store.version;
      $overview.text = widget.store.overview;
      _image = widget.store.favicon;
    });

    $url.text = widget.store.url;
    $name.text = widget.store.name;
    $version.text = widget.store.version;
    $overview.text = widget.store.overview;
    _image = widget.store.favicon;
    showImagePicker = widget.store.showImage;
  }

  Future<void> _pickImage() async {
    final file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      final bytes = await file.readAsBytes();
      widget.store.setFavicon(base64Encode(bytes));

      setState(() {
        _image = widget.store.favicon;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 480,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: $url,
              decoration: InputDecoration(labelText: '网站地址'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: $name,
              decoration: InputDecoration(labelText: '网站名称'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: $version,
              decoration: InputDecoration(labelText: '版本'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: $overview,
              decoration: InputDecoration(labelText: '概述'),
              maxLines: 3,
            ),
            showImagePicker
                ? Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 16),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "图标",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        SizedBox(height: 4),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              _pickImage();
                            },
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                clipBehavior: Clip.hardEdge,
                                child: Center(
                                  child: _image != null
                                      ? Image.memory(
                                          base64Decode(_image!),
                                          fit: BoxFit.contain,
                                        )
                                      : Icon(
                                          Icons.add,
                                          size: 48,
                                          color: Colors.white,
                                        ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    $name.dispose();
    $overview.dispose();
    super.dispose();
  }
}

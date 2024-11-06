import 'package:flutter/material.dart';
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
  DateTime? selectedDateTime;

  @override
  void initState() {
    super.initState();

    $url.addListener(() {
      widget.store.setURL($url.text);
    });
    $name.addListener(() {
      widget.store.setName($name.text);
    });
    $overview.addListener(() {
      widget.store.setOverview($overview.text);
    });
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
              controller: $overview,
              decoration: InputDecoration(labelText: '概述'),
              maxLines: 3,
            ),
            SizedBox(height: 16),
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

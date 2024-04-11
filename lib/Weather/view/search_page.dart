import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage._();

  static Route<String> route() {
    return MaterialPageRoute(builder: (_) => const SearchPage._());
  }

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _txtEditCtrl = TextEditingController();

  String get _city => _txtEditCtrl.text;
  @override
  void dispose() {
    _txtEditCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('City Search')),
      body: Row(
        children: [
          Expanded(
              child: Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              controller: _txtEditCtrl,
              decoration:
                  const InputDecoration(labelText: 'City', hintText: 'Chicago'),
            ),
          )),
          IconButton(
            key: const Key('city search'),
            onPressed: () => Navigator.of(context).pop(_city),
            icon: Icon(
              Icons.search,
              semanticLabel: 'Submit',
            ),
          )
        ],
      ),
    );
  }
}

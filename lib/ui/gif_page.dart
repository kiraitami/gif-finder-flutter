import 'package:flutter/material.dart';
import 'package:share/share.dart';

class GifPage extends StatelessWidget {

  final Map _gifData;

  GifPage(this._gifData); // constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_gifData["title"], style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueGrey,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: (){
              Share.share(_gifData["images"]["downsized_large"]["url"]);
            },
          )
        ],
      ),
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: Image.network(_gifData["images"]["downsized_large"]["url"]),
      ),
    );
  }
}

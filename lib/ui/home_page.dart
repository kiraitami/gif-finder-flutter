import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app_gif_finder/ui/gif_page.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String _search;
  int _offset = 0;

  static const String BASE_URL = "https://api.giphy.com/v1/gifs/trending?api_key=OtDnqqqu32ZU6wPcy74v2U2J5NoiTPhP&limit=20&rating=G";

  @override
  void initState() {
    super.initState();
    _getGifs().then((map){
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Image.network("https://developers.giphy.com/branch/master/static/header-logo-8974b8ae658f704a5b48a2d039b8ad93.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[

          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                  labelText: "Find Gifs",
                  labelStyle: TextStyle(color: Colors.blueGrey),
                  border: OutlineInputBorder()
              ),
              style: TextStyle(color: Colors.blueGrey, fontSize: 16.0),
              textAlign: TextAlign.center,
              onChanged: (text){
                setState(() {
                  _search = text;
                  _offset = 0;
                });
              },
            ),
          ),

          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              builder: (context, snapshot){

                switch(snapshot.connectionState){

                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200.0,
                      height: 200.0,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey),
                        strokeWidth: 5.0,
                      ),
                    );
                    break;

                  default:
                    if(snapshot.hasError) {
                      return Container();
                    } else {
                      return _createGifTable(context, snapshot);
                    }
                }

              },
            ),
          )

        ],
      ),
    );
  }


  Future<Map> _getGifs() async{
    http.Response response;

    if (_search == null ||_search.isEmpty){
      response = await http.get(BASE_URL);
    }
    else {
      response = await http.get("https://api.giphy.com/v1/gifs/search?api_key=OtDnqqqu32ZU6wPcy74v2U2J5NoiTPhP&q=$_search&limit=19&offset=$_offset&rating=G&lang=en");
    }

    return json.decode(response.body);
  }

  int _getCount(List data){
    return _search == null ? data.length : data.length +1;
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot){
    return GridView.builder(

      padding: EdgeInsets.all(8.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0
      ),
      itemCount: _getCount(snapshot.data["data"]),
      itemBuilder: (context, index){
        if (_search == null || index < snapshot.data["data"].length) {
          return GestureDetector(
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: snapshot.data["data"][index]["images"]["fixed_height"]["url"],
              height: 300.0,
              fit: BoxFit.cover,
            ),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => GifPage(snapshot.data["data"][index])));
            },
            onLongPress: () {
              Share.share(snapshot.data["data"][index]["images"]["downsized_large"]["url"]);
            }
          );
        }
        else {
          return Container(
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.add, color: Colors.blueGrey, size: 70.0),
                  Text("Load more", style: TextStyle(color: Colors.blueGrey, fontSize: 22.0))
                ],
              ),
              
              onTap: (){
                setState(() {
                  _offset += 19;
                });
              }
            ),
          );
        }
      },
    );
  }
}
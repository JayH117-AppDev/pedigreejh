import 'dart:io' show Platform;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pedigreejh/HomeScreen.dart';

import 'globalVar.dart';

class SearchPet extends StatefulWidget {
  const SearchPet({Key key}) : super(key: key);

  @override
  _SearchPetState createState() => _SearchPetState();
}

class _SearchPetState extends State<SearchPet> {
  TextEditingController _searchQueryController = TextEditingController();

  bool _isSearching = false;
  String searchQuery = "";

  FirebaseAuth _auth = FirebaseAuth.instance;
  String petType;
  String petBreed;
  QuerySnapshot pets;

  Widget _buildSearchField(){
    return TextField(
      controller: _searchQueryController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: "Search here...",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white30),
      ),
      style: TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  List<Widget>_buildAction(){
    if(_isSearching){
      return <Widget>[
        IconButton(
            icon: const Icon(Icons.clear),
            onPressed:(){
              if(_searchQueryController == null ||
                 _searchQueryController.text.isEmpty){
                Navigator.pop(context);
                return;
              }
              _clearSearchQuery();
            })
      ];
    }
    return<Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      )
    ];
  }

  _startSearch(){
    ModalRoute.of(context)
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));
    setState(() {
      _isSearching = true;
    });
  }

  _stopSearching(){
    _clearSearchQuery();
    setState(() {
      _isSearching = false;
    });
  }

  _clearSearchQuery(){
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery("");
    });
  }

  updateSearchQuery(String newQuery){
    setState(() {
      getResults();
      searchQuery = newQuery;
    });
  }

  _buildTitle(BuildContext context){
    return Text("Search pets");
  }

  Widget _buildBackButton(){
    return IconButton(
      onPressed: (){
        Route newRoute = MaterialPageRoute(builder: (_) => HomeScreen());
        Navigator.pushReplacement(context, newRoute);
      },
      icon: Icon(Icons.arrow_back, color: Colors.white),
    );
  }

  getResults(){
    FirebaseFirestore.instance.collection('pets')
        .where("petBreed", isGreaterThanOrEqualTo: _searchQueryController.text.trim())
        .get()
        .then((results){
          setState(() {
            pets = results;
            print("This result :: ");
            print("Result = "+ pets.docs[0]['petType']);
          });
    });
  }

  @override
  Widget build(BuildContext context) {

    double _screenWidth = MediaQuery
        .of(context)
        .size
        .width,
        _screenHeight = MediaQuery
            .of(context)
            .size
            .height;

    Widget showAdsList(){
      if(pets !=null){
        return ListView.builder(
          itemCount: pets.docs.length,
          padding: EdgeInsets.all(8.0),
          itemBuilder: (context, i){
            return Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  ListTile(
                    leading: GestureDetector(
                      onTap: ()
                      {
                      },
                      child: Container(
                        width: 60,
                        height:60,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    title: GestureDetector(
                        onTap: ()
                        {

                        },
                        child: Text(pets.docs[i]['userName'])
                    ),
                    subtitle: GestureDetector(
                      onTap: () {

                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Text(
                              pets.docs[i]['petLocation'],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.black.withOpacity(0.6)),
                            ),
                          ),
                          SizedBox(width: 4.0,),
                          Icon(Icons.location_pin, color: Colors.grey,),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.network(pets.docs[i]['urlImage'], fit: BoxFit.fill,),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      '\€ '+pets.docs[i]['petPrice'],
                      style: TextStyle(
                        fontFamily: "Bebas",
                        letterSpacing: 2.0,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.workspaces_outline),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Align(
                                child: Text(pets.docs[i]['petType']),
                                alignment: Alignment.topLeft,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.workspaces_outline),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Align(
                                child: Text(pets.docs[i]['petBreed']),
                                alignment: Alignment.topLeft,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.phone),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Align(
                                child: Text(pets.docs[i]['userNumber']),
                                alignment: Alignment.topRight,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 15.0),
                    child: Text(
                      pets.docs[i]['description'],
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                ],
              ),
            );
          },
        );
      }
      else{
        return Text('Loading...');
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: _isSearching ? const BackButton() : _buildBackButton(),
        title: _isSearching ? _buildSearchField() : _buildTitle(context),
        actions: _buildAction(),
        flexibleSpace: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
                colors: [
                  Colors.red[300],
                  Colors.amberAccent,
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
        ),
      ),
      body: Center(
        child: Container(
          width: !kIsWeb && (Platform.isIOS || Platform.isAndroid) ? _screenWidth : _screenWidth*.5,
          child: showAdsList(),
        ),
      ),
    );
  }
}

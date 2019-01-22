import 'package:flutter/material.dart';
import 'dart:async';

class NewsList extends StatelessWidget {
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top News'),
      ),
      body: buildList(),
    );
  }

  // demo on how ListView.builder works
  Widget buildList() {
    return ListView.builder(
      itemCount: 1000,
      itemBuilder: (context, int index) {
        return FutureBuilder(
          future: getFuture(),
          builder: (context, snapshot) {

            // ListView.builder adapts to the item Heights (visible items)
            return Container(
              height: 80.0,
              child: snapshot.hasData ? Text("I'm visible $index")
                  : Text("I haven't been fetched yet"),
            );
          }
        );
      },
    );
  }

  getFuture() {
    return Future.delayed(
      Duration(seconds: 2),
        () => 'hi',
    );
  }
}
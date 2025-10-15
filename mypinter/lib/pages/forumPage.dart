import 'package:flutter/material.dart';

class ForumPage extends StatelessWidget{
  const ForumPage({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Froum"),
        //titleTextStyle: ,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: (){},
            icon: Icon(Icons.search),
          )
        ],
      ),
    );
  }
}
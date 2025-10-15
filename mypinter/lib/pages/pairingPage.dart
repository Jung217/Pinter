import 'package:flutter/material.dart';

class PairingPage extends StatelessWidget{
  const PairingPage({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Pairing"),
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
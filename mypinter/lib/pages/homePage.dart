import 'package:flutter/material.dart';
import 'package:mypinter/pages/loginPage.dart';

class HomePage extends StatelessWidget{
  const HomePage({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Pinter"),
        //titleTextStyle: ,
        backgroundColor: Colors.white,
        elevation: 10,
        actions: [
          IconButton(
            onPressed: (){},
            icon: Icon(Icons.search),
          )
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children: [
            DrawerHeader(
              child: Icon(
                Icons.apps,
                size: 20,
              ),
            ),
            ListTile(
              leading: Icon(Icons.forum),
              title: Text("論壇"),
              //onTap: ,
            ),
            ListTile(
              leading: Icon(Icons.chat),
              title: Text("聊天"),
            ),
            ListTile(
              leading: Icon(Icons.compare_arrows),
              title: Text("配對"),
            ),
            ListTile(
              leading: Icon(Icons.map),
              title: Text("寵物地圖"),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),//verified / verified_user
              title: Text("帳號"),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              }, 
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
            ),
          ],
        )
      ),
      body: ListView(
          //scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              color: Colors.grey,
              height: 200,
            ),
            const SizedBox(height: 16),
            Container(
              color: Colors.grey,
              height: 200,
            ),
            const SizedBox(height: 16),
            Container(
              color: Colors.grey,
              height: 200,
            ),
          ],
        )
      // body: Center(
      //   child: ElevatedButton(
      //     child: Text("GO 2nd Page"),
      //     onPressed: (){
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) => LoginPage(),
      //         ),
      //       );
      //     }, 
      //   ),
      // ),
    );
  }
}
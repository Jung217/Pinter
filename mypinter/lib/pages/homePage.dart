import 'package:flutter/material.dart';
import 'package:mypinter/pages/loginPage.dart';
import 'package:mypinter/pages/forumPage.dart';
import 'package:mypinter/pages/chatPage.dart';
import 'package:mypinter/pages/pairingPage.dart';
import 'package:mypinter/pages/mapPage.dart';
import 'package:mypinter/pages/settingPage.dart';

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
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ForumPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.chat),
              title: Text("聊天"),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.compare_arrows),
              title: Text("配對"),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PairingPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.map),
              title: Text("寵物地圖"),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapPage(),
                  ),
                );
              },
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
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingPage(),
                  ),
                );
              },
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
        ),
    );
  }
}
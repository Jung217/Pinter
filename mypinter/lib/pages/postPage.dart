import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
  const PostPage({super.key});
}

class _PostPageState extends State<PostPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();

  bool isLoading = false;

  Future<void> submitPost() async {
    setState(() => isLoading = true);

    final url = Uri.parse("http://123.192.96.63:8000/api/posts/create/");

    final body = {
      "title": _titleController.text,
      "content": _contentController.text,
      "author": _authorController.text,
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        Navigator.pop(context, true);
      } else {
        print(response.body);
        showSnack("建立失敗 (${response.statusCode})");
      }
    } catch (e) {
      showSnack("連線錯誤");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("新增貼文"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: "標題"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: "內容"),
              maxLines: 5,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _authorController,
              decoration: InputDecoration(labelText: "作者"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : submitPost,
              child: isLoading
                  ? CircularProgressIndicator()
                  : Text("發布貼文"),
            ),
          ],
        ),
      ),
    );
  }
}

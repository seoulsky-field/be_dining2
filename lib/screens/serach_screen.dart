import 'package:be_dining/screens/board_screen.dart';
import 'package:be_dining/screens/serach_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/posts.dart';
import '../screens/edit_post_screen.dart';
import '../widgets/post_item.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = './search';
  const SearchScreen({Key? key}) : super(key: key);

  _SearchScreen createState() => _SearchScreen();
}

class _SearchScreen extends State<SearchScreen> {
  TextEditingController? _editingController;

  @override
  void initState() {
    super.initState();
    _editingController = new TextEditingController();
  }

  Future<void> _searchPosts(BuildContext context, TextEditingController editingController) async {
    await Provider.of<Posts>(context, listen: false).searchPosts(editingController.value.text);
  }

  Future<void> _refreshPosts(BuildContext context) async {
    await Provider.of<Posts>(context, listen: false).fetchAndSetPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: TextField(
          textInputAction: TextInputAction.go,
          controller: _editingController,
          style: TextStyle(color: Colors.black),
          keyboardType: TextInputType.text,
          decoration: InputDecoration(hintText: "검색어를 입력하세요"),
          onSubmitted: (text) {
            _searchPosts(context, _editingController!);
          },
        ),
        leading: IconButton(
          onPressed: () => {
            _refreshPosts(context),
            Navigator.pop(context)
          },
          icon: Icon(Icons.arrow_back_sharp),
        ),
      ),
      body: FutureBuilder(
        future: _refreshPosts(context),
        builder: (ctx, snapshot) =>
        snapshot.connectionState == ConnectionState.waiting
            ? Center(
          child: CircularProgressIndicator(),
        )
            : RefreshIndicator(
          onRefresh: () => _searchPosts(context, _editingController!),
          child: Consumer<Posts>(
            builder: (ctx, postsData, _) => Padding(
              padding: EdgeInsets.all(8),
              child: postsData.items.length > 0
                  ? ListView.builder(
                itemCount: postsData.items.length,
                itemBuilder: (_, i) => Column(
                  children: [
                    PostItem(
                      postsData.items[i].id,
                    ),
                    Divider(),
                  ],
                ),
              )
                  : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.insert_drive_file_outlined,
                      size: 48,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'No Posts Yet',
                      textScaleFactor: 1.5,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}



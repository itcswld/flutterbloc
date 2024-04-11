import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterbloc/InfiniteList/bloc/post_bloc.dart';
import 'package:flutterbloc/InfiniteList/view/posts_view.dart';
import 'package:flutterbloc/View/MenuPage.dart';
import 'package:http/http.dart' as http;

class PostsPage extends StatelessWidget {
  static const String id = 'PostsPage';
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Infinite List'),
        actions: [
          IconButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, MenuPage.id),
              icon: const Icon(Icons.menu))
        ],
      ),
      body: BlocProvider(
        //initial batch of Posts
        create: (_) => PostBloc(httpClient: http.Client())..add(PostFetched()),
        child: const PostsView(),
      ),
    );
  }
}

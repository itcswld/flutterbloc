import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterbloc/InfiniteList/BLOC/post_bloc.dart';
import 'package:flutterbloc/InfiniteList/View/post_item.dart';

import 'bottom_loader.dart';

class PostsView extends StatefulWidget {
  const PostsView({super.key});

  @override
  State<PostsView> createState() => _PostsViewState();
}

class _PostsViewState extends State<PostsView> {
  final _scrollCtrl = ScrollController();

  bool get _isBottom {
    if (!_scrollCtrl.hasClients) return false;
    final maxScroll = _scrollCtrl.position.maxScrollExtent;
    final currentScroll = _scrollCtrl.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onScroll() {
    if (_isBottom) context.read<PostBloc>().add(PostFetched());
  }

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollCtrl
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        switch (state.status) {
          case PostStatus.initial:
            return const Center(child: CircularProgressIndicator());
          case PostStatus.success:
            return (state.posts.isEmpty)
                ? const Center(child: Text('no posts'))
                : ListView.builder(
                    itemBuilder: (_, i) {
                      return i >= state.posts.length
                          ? const BottomLoader()
                          : PostItem(post: state.posts[i]);
                    },
                    itemCount: state.hasReachedAll
                        ? state.posts.length
                        : state.posts.length + 1,
                    controller: _scrollCtrl,
                  );
          case PostStatus.failure:
            return const Center(child: Text('failed to fetch posts'));
        }
      },
    );
  }
}

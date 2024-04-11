import 'package:flutter/material.dart';

import '../Model/post.dart';

class PostItem extends StatelessWidget {
  final Post post;
  const PostItem({required this.post, super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListTile(
        leading:
            Text('${post.id}', style: Theme.of(context).textTheme.bodySmall),
        title: Text(post.title),
        subtitle: Text(post.body),
        isThreeLine: true,
        dense: true,
      ),
    );
  }
}

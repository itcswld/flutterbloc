import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:stream_transform/stream_transform.dart';

import '../Model/post.dart';

part 'post_event.dart';
part 'post_state.dart';

EventTransformer<E> throttleDroppable<E>() {
  return (events, mapper) {
    //ignore any events added while an event is processing
    return droppable<E>()
        .call(events.throttle(const Duration(milliseconds: 100)), mapper);
  };
}

class PostBloc extends Bloc<PostEvent, PostState> {
  final http.Client httpClient;

  PostBloc({required this.httpClient}) : super(const PostState()) {
    on<PostFetched>(_onPostFetched,
        //to customize how events are processed.
        //implement throttling --to debounce the Events in order to prevent spamming our API unnecessarily
        transformer: throttleDroppable());
  }

  Future<List<Post>> _fetchPosts([int startIndex = 0]) async {
    int endIndex = 20;
    Uri url = Uri.https('jsonplaceholder.typicode.com', '/posts',
        <String, String>{'_start': '$startIndex', '_limit': '$endIndex'});
    print(url);
    final resp = await httpClient.get(url);
    if (resp.statusCode == 200) {
      final body = json.decode(resp.body) as List;
      return body.map((dynamic json) {
        final map = json as Map<String, dynamic>;
        return Post(
          id: map['id'] as int,
          title: map['title'] as String,
          body: map['body'] as String,
        );
      }).toList();
    }
    throw Exception('error fetching posts.');
  }

  Future<void> _onPostFetched(event, emit) async {
    if (state.hasReachedAll) return;
    try {
      if (state.status == PostStatus.initial) {
        final posts = await _fetchPosts();
        emit(state.copyWith(
          status: PostStatus.success,
          posts: posts,
          hasReachedAll: false,
        ));
      }
      //if it is a PostFetched event and there are more posts to fetch
      final posts = await _fetchPosts(state.posts.length);
      emit(posts.isEmpty
          //hasReachedAll: true --The API will return an empty array if we try to fetch beyond the maximum number of posts
          ? state.copyWith(hasReachedAll: true)
          : state.copyWith(
              status: PostStatus.success,
              posts: List.of(state.posts)..addAll(posts),
              hasReachedAll: false,
            ));
    } catch (_) {
      emit(state.copyWith(status: PostStatus.failure));
    }
  }
}

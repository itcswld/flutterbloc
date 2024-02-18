part of 'post_bloc.dart';

enum PostStatus { initial, success, failure }

final class PostState extends Equatable {
  final PostStatus status;
  final List<Post> posts;
  final bool hasReachedAll;
  const PostState(
      {this.status = PostStatus.initial,
      this.posts = const <Post>[],
      this.hasReachedAll = false});

//copyWith --copy an instance of PostSuccess and update zero or more properties conveniently
  PostState copyWith(
      {PostStatus? status, List<Post>? posts, bool? hasReachedAll}) {
    return PostState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      hasReachedAll: hasReachedAll ?? this.hasReachedAll,
    );
  }

  @override
  String toString() {
    return 'PostState {status: $status, hasReached: $hasReachedAll}';
  }

  @override
  List<Object?> get props => [status, posts, hasReachedAll];
}

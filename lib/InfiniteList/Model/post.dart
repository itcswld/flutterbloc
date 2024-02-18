import 'package:equatable/equatable.dart';

final class Post extends Equatable {
  final int id;
  final String title;
  final String body;
  const Post({required this.id, required this.title, required this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: int.parse(json["id"]),
      title: json["title"],
      body: json["body"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "title": this.title,
      "body": this.body,
    };
  }

  @override
  List<Object?> get props => [id, title, body];
}

import 'package:lapor_book/models/comment.dart';

class Report {
  final String uid;
  final String docId;
  final String title;
  final String institute;
  String? description;
  String? imageUrl;
  final String name;
  final String status;
  final DateTime date;
  final String maps;
  List<Comment>? comments;
  int likes;

  Report({
    required this.uid,
    required this.docId,
    required this.title,
    required this.institute,
    this.description,
    this.imageUrl,
    required this.name,
    required this.status,
    required this.date,
    required this.maps,
    this.comments,
    required this.likes,
  });
}

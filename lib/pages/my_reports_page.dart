import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lapor_book/components/list_item.dart';
import 'package:lapor_book/components/styles.dart';
import 'package:lapor_book/models/account.dart';
import 'package:lapor_book/models/comment.dart';
import 'package:lapor_book/models/report.dart';

class MyReportsPage extends StatefulWidget {
  final Account account;
  const MyReportsPage({super.key, required this.account});

  @override
  State<MyReportsPage> createState() => _MyReportsPageState();
}

class _MyReportsPageState extends State<MyReportsPage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  List<Report> reportList = [];
  void getReports() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('reports')
          .where('uid', isEqualTo: _auth.currentUser!.uid)
          .get();

      setState(() {
        reportList.clear();

        for (var documents in querySnapshot.docs) {
          List<dynamic>? comments = documents.data()['comments'];
          List<Comment>? commentList = comments?.map((map) {
            return Comment(name: map['name'], content: map['content']);
          }).toList();

          reportList.add(
            Report(
              uid: documents.data()['uid'],
              docId: documents.data()['docId'],
              title: documents.data()['title'],
              institute: documents.data()['institute'],
              name: documents.data()['name'],
              imageUrl: documents.data()['imageUrl'],
              description: documents.data()['description'],
              status: documents.data()['status'],
              date: documents.data()['date'].toDate(),
              maps: documents.data()['maps'],
              comments: commentList,
            ),
          );
        }
      });
    } catch (error) {
      final snackBar = SnackBar(content: Text(error.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    getReports();
    return reportList.isEmpty
        ? Center(
            child: Text('No Report Yet', style: headerStyle(level: 3)),
          )
        : SafeArea(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1 / 1.234,
                ),
                itemCount: reportList.length,
                itemBuilder: (context, index) {
                  return ListItem(
                    report: reportList[index],
                    account: widget.account,
                    isMyReport: true,
                  );
                },
              ),
            ),
          );
  }
}

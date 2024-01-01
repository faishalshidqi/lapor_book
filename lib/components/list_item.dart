import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lapor_book/components/styles.dart';
import 'package:lapor_book/models/account.dart';
import 'package:lapor_book/models/report.dart';

class ListItem extends StatefulWidget {
  final Report report;
  final Account account;
  final bool isMyReport;

  const ListItem(
      {super.key,
      required this.report,
      required this.account,
      required this.isMyReport});

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  void deleteReport() async {
    try {
      if (widget.report.imageUrl != '') {
        await _storage.refFromURL(widget.report.imageUrl!).delete();
      }
      _firestore.collection('reports').doc(widget.report.docId).delete();
      Navigator.popAndPushNamed(context, '/dashboard');
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/detail',
              arguments: {'report': widget.report, 'account': widget.account});
        },
        onLongPress: () {
          if (widget.isMyReport) {
            showDialog(
                context: context,
                builder: (BuildContext) {
                  return AlertDialog(
                    title: Text('Delete ${widget.report.title}?'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel')),
                      TextButton(
                          onPressed: () {
                            deleteReport();
                          },
                          child: const Text('Delete')),
                    ],
                  );
                });
          }
        },
        child: Column(
          children: [
            widget.report.imageUrl != ''
                ? Image.network(
                    widget.report.imageUrl!,
                    width: 130,
                    height: 130,
                  )
                : Image.asset(
                    'assets/istock-default.jpg',
                    width: 130,
                    height: 130,
                  ),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: const BoxDecoration(
                  border: Border.symmetric(horizontal: BorderSide(width: 2))),
              child: Text(
                widget.report.title,

                /// 4 mungkin error, ganti 3
                style: headerStyle(level: 3),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                        color: warningColor,
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(7)),
                        border: const Border.symmetric(
                            vertical: BorderSide(width: 1))),
                    alignment: Alignment.center,
                    child: Text(
                      widget.report.status,

                      /// 5 mungkin error, ganti 3
                      style: headerStyle(level: 4, dark: false),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(7)),
                        border: const Border.symmetric(
                            vertical: BorderSide(width: 1))),
                    alignment: Alignment.center,
                    child: Text(
                      DateFormat('dd/MM/yyyy').format(widget.report.date),

                      /// 5 mungkin error
                      style: headerStyle(level: 5, dark: false),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lapor_book/components/styles.dart';
import 'package:lapor_book/components/vars.dart';
import 'package:lapor_book/models/report.dart';

class StatusDialog extends StatefulWidget {
  final String status;
  final ValueChanged<String> onValueChanged;
  final Report report;
  const StatusDialog(
      {super.key,
      required this.status,
      required this.onValueChanged,
      required this.report});

  @override
  State<StatusDialog> createState() => _StatusDialogState();
}

class _StatusDialogState extends State<StatusDialog> {
  late String status;
  final _firestore = FirebaseFirestore.instance;

  void updateStatus() async {
    CollectionReference reportCollection = _firestore.collection('reports');

    /// Convert DateTime to Firestore Timestamp

    try {
      await reportCollection
          .doc(widget.report.docId)
          .update({'status': status});
      Navigator.popAndPushNamed(context, '/dashboard');
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    status = widget.status;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: primaryColor,
      content: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              widget.report.title,
              style: headerStyle(level: 2),
            ),
            const SizedBox(height: 20),
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dataStatus.length,
                itemBuilder: (context, index) {
                  return RadioListTile<String>(
                    title: Text(dataStatus[index]),
                    value: dataStatus[index],
                    groupValue: status,
                    onChanged: (value) {
                      setState(() {
                        status = value!;
                      });
                    },
                  );
                }),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  print(status);
                  updateStatus();
                },
                style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: Text('Save $status as status'))
          ],
        ),
      ),
    );
  }
}

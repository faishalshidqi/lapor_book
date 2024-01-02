import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lapor_book/components/status_dialog.dart';
import 'package:lapor_book/components/styles.dart';
import 'package:lapor_book/components/vars.dart';
import 'package:lapor_book/models/account.dart';
import 'package:lapor_book/models/report.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportDetailPage extends StatefulWidget {
  const ReportDetailPage({super.key});

  @override
  State<ReportDetailPage> createState() => _ReportDetailPageState();
}

class _ReportDetailPageState extends State<ReportDetailPage> {
  bool _isLoading = false;

  String? status;

  Future launch(String uri) async {
    if (uri == '') return;
    if (!await launchUrl(Uri.parse(uri))) {
      throw Exception('Can\'t call $uri');
    }
  }

  void statusDialog(Report report) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatusDialog(
          status: status!,
          onValueChanged: (value) {
            setState(() {
              status = value;
            });
          },
          report: report,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    Report report = arguments['report'];
    Account account = arguments['account'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Report Detail', style: headerStyle(level: 3, dark: false)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(report.title, style: headerStyle(level: 1)),
                      const SizedBox(height: 15),
                      report.imageUrl != ''
                          ? Image.network(report.imageUrl!)
                          : Image.asset('assets/istock-default.jpg'),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          report.status == 'Posted'
                              ? textStatus(
                                  text: 'Posted',
                                  bgColor: colorStatus[0],
                                  textColor: Colors.black,
                                )
                              : report.status == 'Processed'
                                  ? textStatus(
                                      text: 'Processed',
                                      bgColor: colorStatus[1],
                                      textColor: Colors.white,
                                    )
                                  : textStatus(
                                      text: 'Done',
                                      bgColor: colorStatus[2],
                                      textColor: Colors.white,
                                    ),
                          textStatus(
                            text: report.institute,
                            bgColor: Colors.white,
                            textColor: Colors.black,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: const Text('Reporter'),
                        subtitle: Text(report.name),
                        trailing: const SizedBox(width: 45),
                      ),
                      ListTile(
                        leading: const Icon(Icons.date_range),
                        title: const Text('Report Date'),
                        subtitle: Text(
                          DateFormat('dd MMMM yyyy').format(report.date),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.location_on),
                          onPressed: () {
                            launch(report.maps);
                          },
                        ),
                      ),
                      const SizedBox(height: 50),
                      Text(
                        'Report\'s Description',
                        style: headerStyle(level: 3),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Center(
                            child:
                                Text(report.description ?? 'No Description')),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      if (account.role == 'admin')
                        SizedBox(
                          width: 250,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                status = report.status;
                              });
                              statusDialog(report);
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Change Status'),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Container textStatus({
    required String text,
    required Color bgColor,
    required Color textColor,
  }) {
    return Container(
      width: 150,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(width: 1, color: primaryColor),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Text(
        text,
        style: TextStyle(color: textColor),
      ),
    );
  }
}

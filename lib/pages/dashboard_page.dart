import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lapor_book/components/styles.dart';
import 'package:lapor_book/models/account.dart';
import 'package:lapor_book/pages/add_report.dart';
import 'package:lapor_book/pages/my_reports_page.dart';
import 'package:lapor_book/pages/profile_page.dart';
import 'package:lapor_book/pages/report_list.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  List<Widget> pages = [];
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  Account account =
      Account(uid: '', docId: '', name: '', phone: '', email: '', role: '');

  void getAccount() async {
    setState(() {
      _isLoading = true;
    });

    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('account')
          .where('uid', isEqualTo: _auth.currentUser!.uid)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var userData = querySnapshot.docs.first.data();

        setState(() {
          account = Account(
              uid: userData['uid'],
              docId: userData['docId'],
              name: userData['name'],
              phone: userData['phone'],
              email: userData['email'],
              role: userData['role']);
        });
      }
    } catch (error) {
      final snackBar = SnackBar(content: Text(error.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print(error);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    getAccount();
  }

  @override
  Widget build(BuildContext context) {
    pages = <Widget>[
      ReportListPage(account: account),
      MyReportsPage(account: account),
      ProfilePage(account: account)
    ];
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        child: const Icon(Icons.add, size: 35),
        onPressed: () {
          Navigator.pushNamed(context, '/add', arguments: {'account': account});
        },
      ),
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Lapor Book', style: headerStyle(level: 2)),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: primaryColor,
          currentIndex: _selectedIndex,
          onTap: onItemTapped,
          selectedItemColor: Colors.white,
          selectedFontSize: 16,
          unselectedItemColor: Colors.grey[800],
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_outlined), label: 'All Report'),
            BottomNavigationBarItem(
                icon: Icon(Icons.book_outlined), label: 'My Reports'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outlined), label: 'Profile'),
          ]),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : pages.elementAt(_selectedIndex),
    );
  }
}

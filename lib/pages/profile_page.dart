import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lapor_book/components/styles.dart';
import 'package:lapor_book/models/account.dart';

class ProfilePage extends StatelessWidget {
  final Account account;
  ProfilePage({super.key, required this.account});

  final _auth = FirebaseAuth.instance;

  void logout(BuildContext context) async {
    await _auth.signOut();
    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(
        context, '/login', ModalRoute.withName('/login'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  Text(account.name == '' ? 'no name data' : 'Name: \t${account.name}',
                      style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 40)),
                  Text(account.role == '' ? 'no role data' : 'Role: \t${account.role}',
                      style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 40)),
                  const SizedBox(height: 40),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: primaryColor))),
                    child: Text(account.phone == '' ? 'no phone data' : account.phone,
                        style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: primaryColor))),
                    child: Text(account.email == '' ? 'no email data' : account.email,
                        style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                  ),
                  const SizedBox(height: 35),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: buttonStyle,
                      onPressed: () {
                        logout(context);
                        },
                      child: const Text('Logout',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                    ),
                  ),
                  const SizedBox(height: 35)
                ],
              ),
            )
        )
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lapor_book/components/input_widget.dart';
import 'package:lapor_book/components/styles.dart';
import 'package:lapor_book/components/validators.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? name;
  String? email;
  String? phone;

  final TextEditingController _password = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void register() async {
    setState(() {
      _isLoading = true;
    });
    try {
      CollectionReference akunCollection = _db.collection('account');
      final password = _password.text;
      await _auth.createUserWithEmailAndPassword(
          email: email!, password: password);

      final docId = akunCollection.doc().id;
      await akunCollection.doc(docId).set({
        'uid': _auth.currentUser!.uid,
        'name': name,
        'email': email,
        'phone': phone,
        'docId': docId,
        'role': 'user'
      });

      if (!context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(
          context, '/login', ModalRoute.withName('/login'));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),
                  Text('Register', style: headerStyle(level: 1)),
                  const Text('Create your profile to start your journey',
                      style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 50),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          InputLayout(
                              'Nama',
                              TextFormField(
                                onChanged: (String value) => setState(() {
                                  name = value;
                                }),
                                validator: notEmptyValidator,
                                decoration:
                                    customInputDecoration('Nama Lengkap'),
                              )),
                          InputLayout(
                              'Email',
                              TextFormField(
                                onChanged: (String value) => setState(() {
                                  email = value;
                                }),
                                validator: notEmptyValidator,
                                decoration:
                                    customInputDecoration('email@mail.com'),
                              )),
                          InputLayout(
                              'No. Handphone',
                              TextFormField(
                                onChanged: (String value) => setState(() {
                                  phone = value;
                                }),
                                validator: notEmptyValidator,
                                decoration:
                                    customInputDecoration('+62 800000000'),
                              )),
                          InputLayout(
                              'Password',
                              TextFormField(
                                controller: _password,
                                obscureText: true,
                                validator: notEmptyValidator,
                                decoration: customInputDecoration('Password'),
                              )),
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            width: double.infinity,
                            child: FilledButton(
                              style: buttonStyle,
                              child: Text('Register',
                                  style: headerStyle(level: 2)),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  /// Aksi registrasi
                                  register();
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account?'),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () => Navigator.pushNamed(context, '/login'),
                        child: const Text('Login here',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      )
                    ],
                  )
                ],
              ),
      ),
    ));
  }
}

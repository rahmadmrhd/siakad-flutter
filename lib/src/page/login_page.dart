/// Rahmad Maulana
/// 1462200017
///
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siakad/src/page/home_page.dart';
import 'package:siakad/src/utils/database.dart';

import '../components/loading_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const routeName = '/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool showPassword = false;

  void login(BuildContext context) async {
    try {
      //melakukan login
      final conn = MyDb.pool;
      final result = await conn.execute(
          'Select login(:nim, :password) as token;',
          {"nim": _nimController.text, "password": _passwordController.text});
      final token = result.rows.first.colByName('token');

      if (!mounted) return;
      if (token == null) {
        Navigator.pop(context); //close loading
        dialogResult(context, false, 'NIM atau Password salah!!!');
        return;
      }

      //menyimpan token
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      if (!mounted) return;
      Navigator.pop(context); //close loading
      Navigator.pushReplacementNamed(context, HomePage.routeName);
      return;
    } catch (e) {
      Navigator.pop(context);
      dialogResult(context, false, 'Terjadi Kesalahan, Silahkan coba lagi!');
    }
  }

  void dialogResult(BuildContext context, bool isSuccess, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isSuccess ? 'Berhasil' : 'Gagal'),
          icon: Icon(
            isSuccess ? Icons.check : Icons.cancel,
            color: isSuccess ? Colors.green : Colors.red,
          ),
          content: Text(
            msg,
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  //validasi textfield
  String? validatorNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tidak Boleh Kosong';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  scale: 17,
                ),
                const SizedBox(height: 18),
                const Text(
                  'SISTEM INFORMASI AKADEMIK',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                Text(
                  'Universitas 17 Agustus 1945 Surabaya',
                  style: TextStyle(fontSize: 24, color: Colors.grey[800]!),
                ),
                const SizedBox(height: 42),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 18),
                      Material(
                        elevation: 2,
                        shadowColor: Colors.grey,
                        borderRadius: BorderRadius.circular(12),
                        child: TextFormField(
                          controller: _nimController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            labelText: 'Masukkan NIM',
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 18,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: validatorNotEmpty,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Material(
                        elevation: 2,
                        shadowColor: Colors.grey,
                        borderRadius: BorderRadius.circular(12),
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          textInputAction: TextInputAction.go,
                          onFieldSubmitted: (value) {
                            final valid = _formKey.currentState!.validate();
                            if (!valid) return;
                            loadingDialog(context);
                            login(context);
                          },
                          decoration: InputDecoration(
                            labelText: 'Masukkan Password',
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 18),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: validatorNotEmpty,
                        ),
                      ),
                      const SizedBox(height: 36),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[600],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            minimumSize: const Size.fromHeight(50)),
                        onPressed: () {
                          final valid = _formKey.currentState!.validate();
                          if (!valid) return;
                          loadingDialog(context);
                          login(context);
                        },
                        child: const Text(
                          'Masuk',
                          style: TextStyle(
                            fontSize: 24,
                            letterSpacing: 5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

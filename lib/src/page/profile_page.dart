/// Rahmad Maulana
/// 1462200017
///
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siakad/src/page/login_page.dart';

import '../components/error_dialog.dart';
import '../utils/database.dart';
import '../components/loading_dialog.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.onBack});
  final Function() onBack;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<dynamic>? data;

  _ProfilePageState() {
    data = getUser();
  }

  Future<dynamic> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) return null;

    final result = await MyDb.pool.execute(
        'SELECT nim, nama, jenis_kelamin, tempat_Lahir, tanggal_Lahir, ipk, semester, jurusan FROM `user` WHERE token = :token',
        {"token": token});

    if (result.rows.isEmpty) {
      if (!mounted) return null;
      Navigator.pushReplacementNamed(context, LoginPage.routeName);
      await prefs.remove('token');
      return null;
    }

    return {
      "nim": result.rows.first.colByName('nim'),
      "nama": result.rows.first.colByName('nama'),
      "jenisKelamin": result.rows.first.colByName('jenis_kelamin'),
      "tempatLahir": result.rows.first.colByName('tempat_lahir'),
      "tanggalLahir": result.rows.first.colByName('tanggal_lahir'),
      "ipk": result.rows.first.colByName('ipk'),
      "semester": result.rows.first.colByName('semester'),
      "jurusan": result.rows.first.colByName('jurusan'),
    };
  }

  void logout(BuildContext context) async {
    // memverifikasi apakah user ingin keluar
    final result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(
            Icons.warning,
            color: Colors.amber,
          ),
          title: const Text(
            'Logout',
          ),
          content: const Text(
            'Apakah anda yakin ingin keluar?',
          ),
          actions: [
            TextButton(
              child: const Text('Tidak'),
              onPressed: () => Navigator.pop(context, false),
            ),
            TextButton(
              child: const Text('Ya'),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        );
      },
    );
    if (!result) return;

    if (!mounted) return;
    loadingDialog(context);
    //menghapus token dan mengarahkan ke halaman login
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    await MyDb.pool
        .execute('SELECT logout(:token) as result', {"token": token});

    await prefs.remove('token');

    if (!mounted) return;
    Navigator.pop(context);
    Navigator.pushReplacementNamed(
      context,
      LoginPage.routeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: data,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return ErrorDialog(
            onTry: () {
              setState(() {
                data = getUser();
              });
            },
            msgError: snapshot.error.toString(),
          );
        } else {
          final user = snapshot.data;
          return PopScope(
            canPop: false,
            onPopInvoked: (value) => widget.onBack(),
            child: RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  data = getUser();
                });
              },
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(
                        top: 50, left: 10, right: 10, bottom: 25),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/logo.png',
                              width: 60,
                            ),
                            const SizedBox(width: 10),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'SISTEM INFORMASI AKADEMIK',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                                ),
                                Text(
                                  'Universitas 17 Agustus 1945 Surabaya',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 18),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            fixedSize: const Size(150, 150),
                            shadowColor: Colors.black,
                          ),
                          onPressed: () {},
                          child: const Icon(
                            Icons.person,
                            size: 78,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          user['nama'] ?? '',
                          style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 24,
                              color: Colors.white),
                        ),
                        Text(
                          user['nim'] ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 36),
                      child: ListView(
                        children: [
                          ListTile(
                            tileColor: Colors.white,
                            leading: Icon(user['jenisKelamin'] == 'P'
                                ? Icons.female
                                : Icons.male),
                            title: const Text(
                              'Jenis Kelamin',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            subtitle: Text(
                              user['jenisKelamin'] == 'P'
                                  ? 'Perempuan'
                                  : 'Laki-laki',
                            ),
                          ),
                          const SizedBox(height: 8),
                          ListTile(
                            tileColor: Colors.white,
                            leading: const Icon(Icons.date_range_rounded),
                            title: const Text(
                              'Tempat, Tanggal Lahir',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            subtitle: Text(
                              '${user['tempatLahir'] ?? ''}, ${user['tanggalLahir'] ?? ''}',
                            ),
                          ),
                          const SizedBox(height: 8),
                          ListTile(
                            tileColor: Colors.white,
                            leading: const Icon(Icons.school_rounded),
                            title: const Text(
                              'Program Studi',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            subtitle: Text(
                              user['jurusan'] ?? '',
                            ),
                          ),
                          const SizedBox(height: 8),
                          ListTile(
                            tileColor: Colors.white,
                            leading: const Icon(Icons.bar_chart_rounded),
                            title: const Text(
                              'Semester',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            subtitle: Text(
                              user['semester'] ?? '',
                            ),
                          ),
                          const SizedBox(height: 8),
                          ListTile(
                            tileColor: Colors.white,
                            leading: const Icon(Icons.ballot_rounded),
                            title: const Text(
                              'IPK',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            subtitle: Text(
                              user['ipk'] ?? '',
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () => logout(context),
                            child: const ListTile(
                              tileColor: Colors.white,
                              iconColor: Colors.red,
                              textColor: Colors.red,
                              leading: Icon(Icons.logout),
                              title: Text(
                                'Logout',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

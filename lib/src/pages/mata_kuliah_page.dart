import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siakad/src/components/matkul_item_grid.dart';

import '../components/error_dialog.dart';
import '../utils/database.dart';
import 'login_page.dart';

class MataKuliahPage extends StatefulWidget {
  const MataKuliahPage({super.key});
  static const routeName = '/mata_kuliah';

  @override
  State<MataKuliahPage> createState() => _MataKuliahPageState();
}

class _MataKuliahPageState extends State<MataKuliahPage> {
  Future<List<dynamic>>? data;

  _MataKuliahPageState() {
    data = getMatkul();
  }

  //mengambil data dari database
  Future<List<dynamic>> getMatkul() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    //jika tidak ada token, maka akan diarahkan ke halaman login
    if (token == null) {
      if (!mounted) return [];
      Navigator.pushReplacementNamed(context, LoginPage.routeName);
      await prefs.remove('token');
      return [];
    }

    final result = await MyDb.pool.execute('''SELECT `matkul`.`kode`,
      `matkul`.`nama`,
      `matkul`.`kelas`,
      `n`.`progress`,
      `matkul`.`jadwal`
    FROM `user` AS u
        LEFT JOIN `matkul_mhs` AS `n` ON (`u`.`nim` = `n`.`nim` AND `u`.`semester` = `n`.`semester`)
        LEFT JOIN `mata_kuliah` AS `matkul` ON `n`.`kode` = `matkul`.`kode`
    WHERE
    token = :token''', {"token": token});

    if (result.rows.isEmpty) {
      return [];
    }

    List rows = [];
    for (var row in result.rows) {
      rows.add({
        "kode": row.colByName('kode'),
        "nama": row.colByName('nama'),
        "kelas": row.colByName('kelas'),
        "progress": row.colByName('progress'),
        "jadwal": row.colByName('jadwal')
      });
    }

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 18),
            // header
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
                      style: TextStyle(fontSize: 18, color: Colors.black87),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 18),
            const Text(
              'Mata Kuliah',
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 42, fontWeight: FontWeight.bold, letterSpacing: -2),
            ),
            Divider(thickness: 1, color: Colors.grey[300]),

            //menampilkan hasil data mata kuliah dari database
            Expanded(
              child: FutureBuilder(
                future: data,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    //menampilkan pesan error
                    return ErrorDialog(
                      onTry: () {
                        setState(() {
                          data = getMatkul();
                        });
                      },
                      msgError: snapshot.error.toString(),
                    );
                  } else {
                    //menampilkan data
                    final listMatkul = snapshot.data;
                    return RefreshIndicator(
                      onRefresh: () async {
                        setState(() {
                          data = getMatkul();
                        });
                      },
                      child: GridView(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 400,
                          mainAxisSpacing: 0,
                          crossAxisSpacing: 0,
                          mainAxisExtent: 300,
                        ),
                        children: listMatkul?.map((matkul) {
                              return MatkulItemGrid(matkul);
                            }).toList() ??
                            [],
                      ),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

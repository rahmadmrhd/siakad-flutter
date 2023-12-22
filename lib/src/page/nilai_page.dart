import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/error_dialog.dart';
import '../utils/database.dart';
import 'login_page.dart';

class NilaiPage extends StatefulWidget {
  const NilaiPage({super.key});

  @override
  State<NilaiPage> createState() => _NilaiPageState();
}

class _NilaiPageState extends State<NilaiPage> {
  Future<List<dynamic>>? data;

  _NilaiPageState() {
    data = getMatkul();
  }

  Future<List<dynamic>> getMatkul() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) return [];

    final result = await MyDb.pool.execute(
        'SELECT * FROM `nilai_mhs` WHERE token = :token ORDER BY `semester` DESC, `kode` ASC',
        {"token": token});

    if (result.rows.isEmpty) {
      if (!mounted) return [];
      Navigator.pushReplacementNamed(context, LoginPage.routeName);
      await prefs.remove('token');
      return [];
    }

    List rows = [];
    for (var row in result.rows) {
      rows.add({
        "kode": row.colByName('kode'),
        "nama": row.colByName('nama'),
        "semester": row.colByName('semester'),
        "nilai": row.colByName('nilai'),
        "predikat": row.colByName('predikat')
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
              'Laporan Nilai',
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 42, fontWeight: FontWeight.bold, letterSpacing: -2),
            ),
            Divider(thickness: 1, color: Colors.grey[300]),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    data = getMatkul();
                  });
                },
                child: FutureBuilder(
                  future: data,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return ErrorDialog(
                        onTry: () {
                          setState(() {
                            data = getMatkul();
                          });
                        },
                        msgError: snapshot.error.toString(),
                      );
                    } else {
                      final listMatkul = snapshot.data;

                      return SingleChildScrollView(
                        child: DataTable(
                          headingRowHeight: 40,
                          horizontalMargin: 5,
                          columnSpacing: 8,
                          headingRowColor:
                              MaterialStatePropertyAll(Colors.blue[500]),
                          dividerThickness: 0,
                          showBottomBorder: true,
                          border: TableBorder(
                            verticalInside:
                                BorderSide(color: Colors.grey[300]!),
                          ),
                          columns: const [
                            DataColumn(
                              label: Expanded(
                                child: Text(
                                  'No',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              numeric: true,
                            ),
                            DataColumn(
                              label: Expanded(
                                child: Text(
                                  'Kode',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Expanded(
                                child: Text(
                                  'Mata Kuliah',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Expanded(
                                child: Text(
                                  'Semester',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              numeric: true,
                            ),
                            DataColumn(
                              label: Expanded(
                                child: Text(
                                  'Nilai',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Expanded(
                                child: Text(
                                  'Predikat',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                          rows: List.generate(
                            listMatkul?.length ?? 0,
                            (index) {
                              final matkul = listMatkul![index];
                              return DataRow(
                                color: index % 2 == 0
                                    ? null
                                    : MaterialStatePropertyAll(Colors.blue[50]),
                                cells: [
                                  DataCell(Center(
                                      child: Text(
                                          '${listMatkul.indexOf(matkul) + 1}'))),
                                  DataCell(Center(child: Text(matkul['kode']))),
                                  DataCell(Text(matkul['nama'])),
                                  DataCell(
                                      Center(child: Text(matkul['semester']))),
                                  DataCell(
                                      Center(child: Text(matkul['nilai']))),
                                  DataCell(
                                      Center(child: Text(matkul['predikat']))),
                                ],
                              );
                            },
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

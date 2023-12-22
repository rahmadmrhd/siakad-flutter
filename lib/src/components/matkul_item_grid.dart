/// Rahmad Maulana
/// 1462200017

import 'package:flutter/material.dart';

class MatkulItemGrid extends StatefulWidget {
  const MatkulItemGrid(this.data, {super.key});
  final dynamic data;

  @override
  State<MatkulItemGrid> createState() => _MatkulItemGridState();
}

class _MatkulItemGridState extends State<MatkulItemGrid> {
  dynamic data;

  @override
  void initState() {
    super.initState();
    data = {
      "kode": widget.data['kode'],
      "nama": widget.data['nama'],
      "kelas": widget.data['kelas'],
      "progress": double.tryParse(widget.data['progress']) ?? 0,
      "jadwal": widget.data['jadwal'],
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.grey[500]!,
              blurRadius: 8,
              blurStyle: BlurStyle.normal,
              offset: const Offset(4, 4))
        ],
        color: Colors.white,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          //menampilkan gambar album setiap mata kuliah
          Expanded(
            flex: 4,
            child: Container(
              height: 100,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/img_cth.jpeg',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //menampilkan progress setiap mata kuliah yang diambil
                  Stack(
                    children: [
                      SizedBox(
                        height: 60,
                        width: 60,
                        child: CircularProgressIndicator(
                          color: Colors.orange,
                          value: data['progress'] as double?,
                          strokeWidth: 12,
                        ),
                      ),
                      Positioned.fill(
                        child: Center(
                          child: Text(
                            '${((data['progress'] as double? ?? 0) * 100).toStringAsFixed(0)}%',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(width: 20),
                  //menampilkan informasi mata kuliah
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${data['kode'] ?? ''} - ${data['nama'] ?? ''}',
                          softWrap: true,
                          maxLines: 2,
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.8,
                              height: 1),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          data['jadwal'] ?? '',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black87,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

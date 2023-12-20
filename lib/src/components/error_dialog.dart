import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({super.key, required this.onTry, required this.msgError});
  final void Function() onTry;
  final String msgError;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Gagal'),
      icon: const Icon(
        Icons.cancel,
        color: Colors.red,
      ),
      content: Text(
        'Terjadi kesalahan, silahkan coba lagi $msgError',
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          onPressed: onTry,
          child: const Text('Coba Lagi'),
        ),
      ],
    );
  }
}

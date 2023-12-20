import 'package:flutter/material.dart';

void loadingDialog(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return PopScope(
        canPop: false,
        onPopInvoked: (value) => false,
        child: const AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    },
  );
}

import 'package:flutter/material.dart';

class CustomAlertBox {
  static void showSuccess(BuildContext context, String title, String message) {
    _showAlert(
      context: context,
      title: title,
      message: message,
      icon: Icons.check_circle,
      iconColor: Colors.green,
      backgroundColor: Colors.green.shade50,
      titleColor: Colors.green.shade800,
      messageColor: Colors.green.shade700,
    );
  }

  static void showError(BuildContext context, String title, String message) {
    _showAlert(
      context: context,
      title: title,
      message: message,
      icon: Icons.error,
      iconColor: Colors.red,
      backgroundColor: Colors.red.shade50,
      titleColor: Colors.red.shade800,
      messageColor: Colors.red.shade700,
    );
  }

  static void showWarning(BuildContext context, String title, String message) {
    _showAlert(
      context: context,
      title: title,
      message: message,
      icon: Icons.warning,
      iconColor: Colors.orange,
      backgroundColor: Colors.orange.shade50,
      titleColor: Colors.orange.shade800,
      messageColor: Colors.orange.shade700,
    );
  }

  static void showInfo(BuildContext context, String title, String message) {
    _showAlert(
      context: context,
      title: title,
      message: message,
      icon: Icons.info,
      iconColor: Colors.blue,
      backgroundColor: Colors.blue.shade50,
      titleColor: Colors.blue.shade800,
      messageColor: Colors.blue.shade700,
    );
  }

  static void _showAlert({
    required BuildContext context,
    required String title,
    required String message,
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required Color titleColor,
    required Color messageColor,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: backgroundColor,
          contentPadding: const EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 50, color: iconColor),
              const SizedBox(height: 15),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                message,
                style: TextStyle(fontSize: 16, color: messageColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: iconColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 12,
                  ),
                ),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
    );
  }
}

// // toast_service.dart
// import 'package:flutter/material.dart';

// class ToastService {
//   static void showSuccess(String message, {BuildContext? context}) {
//     _showToast(
//       message,
//       backgroundColor: Colors.green,
//       textColor: Colors.white,
//       context: context,
//     );
//   }

//   static void showError(String message, {BuildContext? context}) {
//     _showToast(
//       message,
//       backgroundColor: Colors.red,
//       textColor: Colors.white,
//       context: context,
//     );
//   }

//   static void showWarning(String message, {BuildContext? context}) {
//     _showToast(
//       message,
//       backgroundColor: Colors.orange,
//       textColor: Colors.white,
//       context: context,
//     );
//   }

//   static void showInfo(String message, {BuildContext? context}) {
//     _showToast(
//       message,
//       backgroundColor: Colors.blue,
//       textColor: Colors.white,
//       context: context,
//     );
//   }

//   static void _showToast(
//     String message, {
//     Color? backgroundColor,
//     Color? textColor,
//     BuildContext? context,
//   }) {
//     Fluttertoast.cancel(); // Cancel any previous toasts

//     Fluttertoast.showToast(
//       msg: message,
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.BOTTOM,
//       backgroundColor: backgroundColor ?? Colors.grey[800],
//       textColor: textColor ?? Colors.white,
//       fontSize: 16.0,
//     );
//   }

//   // For showing toast with custom position
//   static void showCustomToast(
//     String message, {
//     Color? backgroundColor,
//     Color? textColor,
//     ToastGravity gravity = ToastGravity.BOTTOM,
//     Toast length = Toast.LENGTH_SHORT,
//     BuildContext? context,
//   }) {
//     Fluttertoast.cancel();

//     Fluttertoast.showToast(
//       msg: message,
//       toastLength: length,
//       gravity: gravity,
//       backgroundColor: backgroundColor ?? Colors.grey[800],
//       textColor: textColor ?? Colors.white,
//       fontSize: 16.0,
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../theme/app_colors.dart';

class SnackbarUtils {
  SnackbarUtils._();

  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  static void handleAuthError(BuildContext context, dynamic error) {
    String message = 'An unexpected error occurred';
    
    if (error is AuthException) {
      // Show the exact message returned by Supabase
      message = error.message;
      
      // If we receive "Invalid login credentials", append a hint about email confirmation
      if (message.toLowerCase() == 'invalid login credentials') {
        message = 'Invalid login credentials. (If correct, please verify your email)';
      }
    } else if (error is Exception) {
      message = error.toString().replaceFirst('Exception: ', '');
    } else {
      final errorStr = error.toString();
      if (errorStr.toLowerCase().contains('socket') || errorStr.toLowerCase().contains('network')) {
        message = 'No internet connection';
      } else {
        message = errorStr;
      }
    }

    showError(context, message);
  }
}

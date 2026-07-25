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
    
    // Log the exact error to the console for debugging
    debugPrint('=== AUTH ERROR ===');
    debugPrint(error.toString());
    if (error is AuthException) {
      debugPrint('AuthException Message: ${error.message}');
      debugPrint('AuthException StatusCode: ${error.statusCode}');
      
      // Use the exact message from Supabase as the actual reason
      message = error.message;
      
      // We don't append generic email verification hint unless it's specifically about email verification
      if (message.toLowerCase().contains('email not confirmed')) {
        message = 'Please confirm your email address before logging in.';
      } else if (message.toLowerCase().contains('invalid login credentials')) {
        message = 'Invalid email or password.';
      }
    } else if (error is Exception) {
      message = error.toString().replaceFirst('Exception: ', '');
    } else {
      final errorStr = error.toString();
      if (errorStr.toLowerCase().contains('socket') || errorStr.toLowerCase().contains('network')) {
        message = 'No internet connection. Please check your network and try again.';
      } else {
        message = errorStr;
      }
    }
    debugPrint('==================');

    showError(context, message);
  }
}

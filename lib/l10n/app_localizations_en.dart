// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get home => 'Home';

  @override
  String get favorites => 'Favorites';

  @override
  String get tickets => 'Tickets';

  @override
  String get profile => 'Profile';

  @override
  String get helloGuest => 'Hello, Guest 👋';

  @override
  String helloUser(String name) {
    return 'Hello, $name 👋';
  }

  @override
  String get findBusSubtitle => 'Find your bus across Tamil Nadu';

  @override
  String get findBuses => 'Find Buses';

  @override
  String get fromLocation => 'From';

  @override
  String get toLocation => 'To';

  @override
  String get recentSearches => 'Recent Searches';

  @override
  String get login => 'Login';

  @override
  String get logout => 'Logout';

  @override
  String get myProfile => 'My Profile';

  @override
  String get settings => 'Settings';

  @override
  String get enterDepartureStop => 'Enter departure stop';

  @override
  String get enterDestinationStop => 'Enter destination stop';

  @override
  String get noRecentSearches => 'No recent searches';

  @override
  String get pleaseEnterBothStops =>
      'Please enter both departure and destination stops';

  @override
  String get accountCreatedSuccessfully =>
      'Account created successfully! Please sign in.';

  @override
  String get emailNotConfirmed =>
      'Please confirm your email address before logging in.';

  @override
  String get invalidLoginCredentials => 'Invalid email or password.';

  @override
  String get noInternetConnection =>
      'No internet connection. Please check your network and try again.';

  @override
  String get youMustAgreeToTerms =>
      'You must agree to the Terms & Privacy Policy';

  @override
  String get createAccount => 'Create Account';

  @override
  String get alreadyHaveAnAccount => 'Already have an account? ';

  @override
  String get signIn => 'Sign In';

  @override
  String get fullName => 'Full Name';

  @override
  String get email => 'Email';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get gender => 'Gender (Optional)';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get iAgreeToTerms => 'I agree to Terms & Privacy Policy';

  @override
  String get dontHaveAnAccount => 'Don\'t have an account? ';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get notAdded => 'Not Added';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get city => 'City';

  @override
  String get state => 'State';

  @override
  String get address => 'Address';

  @override
  String get country => 'Country';

  @override
  String get dateOfBirth => 'Date of Birth';

  @override
  String get uploadProfilePhoto => 'Upload Profile Photo';

  @override
  String get gallery => 'Gallery';

  @override
  String get camera => 'Camera';

  @override
  String get cancel => 'Cancel';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get other => 'Other';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get noInternet => 'No internet connection';

  @override
  String get sessionExpired => 'Session expired. Please log in again.';

  @override
  String get unauthorized => 'Unauthorized access';

  @override
  String get databaseError => 'Database error occurred';

  @override
  String get imageUploadError => 'Failed to upload image';

  @override
  String get profileUpdated => 'Profile updated successfully';
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get home => 'முகப்பு';

  @override
  String get favorites => 'பிடித்தவை';

  @override
  String get tickets => 'டிக்கெட்டுகள்';

  @override
  String get profile => 'சுயவிவரம்';

  @override
  String get helloGuest => 'வணக்கம், Guest 👋';

  @override
  String helloUser(String name) {
    return 'வணக்கம், $name 👋';
  }

  @override
  String get findBusSubtitle => 'தமிழ்நாடு முழுவதும் பேருந்துகளை தேடுங்கள்';

  @override
  String get findBuses => 'பேருந்துகளை தேடு';

  @override
  String get fromLocation => 'புறப்படும் இடம்';

  @override
  String get toLocation => 'செல்லும் இடம்';

  @override
  String get recentSearches => 'சமீபத்திய தேடல்கள்';

  @override
  String get login => 'உள்நுழை';

  @override
  String get logout => 'வெளியேறு';

  @override
  String get myProfile => 'என் சுயவிவரம்';

  @override
  String get settings => 'அமைப்புகள்';

  @override
  String get enterDepartureStop => 'புறப்படும் இடத்தை உள்ளிடவும்';

  @override
  String get enterDestinationStop => 'செல்லும் இடத்தை உள்ளிடவும்';

  @override
  String get noRecentSearches => 'சமீபத்திய தேடல்கள் இல்லை';

  @override
  String get pleaseEnterBothStops =>
      'புறப்படும் மற்றும் செல்லும் இடங்களை உள்ளிடவும்';

  @override
  String get accountCreatedSuccessfully =>
      'கணக்கு வெற்றிகரமாக உருவாக்கப்பட்டது! உள்நுழையவும்.';

  @override
  String get emailNotConfirmed =>
      'உள்நுழையும் முன் உங்கள் மின்னஞ்சலை உறுதிப்படுத்தவும்.';

  @override
  String get invalidLoginCredentials => 'தவறான மின்னஞ்சல் அல்லது கடவுச்சொல்.';

  @override
  String get noInternetConnection =>
      'இணைய இணைப்பு இல்லை. உங்கள் நெட்வொர்க்கைச் சரிபார்த்து மீண்டும் முயற்சிக்கவும்.';

  @override
  String get youMustAgreeToTerms =>
      'விதிமுறைகள் மற்றும் தனியுரிமைக் கொள்கையை ஏற்க வேண்டும்';

  @override
  String get createAccount => 'கணக்கை உருவாக்கு';

  @override
  String get alreadyHaveAnAccount => 'ஏற்கனவே கணக்கு உள்ளதா? ';

  @override
  String get signIn => 'உள்நுழை';

  @override
  String get fullName => 'முழு பெயர்';

  @override
  String get email => 'மின்னஞ்சல்';

  @override
  String get phoneNumber => 'தொலைபேசி எண்';

  @override
  String get gender => 'பாலினம் (விருப்பத்தேர்வு)';

  @override
  String get password => 'கடவுச்சொல்';

  @override
  String get confirmPassword => 'கடவுச்சொல்லை உறுதிப்படுத்துக';

  @override
  String get iAgreeToTerms =>
      'விதிமுறைகள் மற்றும் தனியுரிமைக் கொள்கையை ஏற்கிறேன்';

  @override
  String get dontHaveAnAccount => 'கணக்கு இல்லையா? ';

  @override
  String get forgotPassword => 'கடவுச்சொல் மறந்துவிட்டதா?';

  @override
  String get notAdded => 'சேர்க்கப்படவில்லை';

  @override
  String get editProfile => 'சுயவிவரத்தை திருத்து';

  @override
  String get saveChanges => 'மாற்றங்களை சேமி';

  @override
  String get city => 'நகரம்';

  @override
  String get state => 'மாநிலம்';

  @override
  String get address => 'முகவரி';

  @override
  String get country => 'நாடு';

  @override
  String get dateOfBirth => 'பிறந்த தேதி';

  @override
  String get uploadProfilePhoto => 'சுயவிவரப் படத்தைப் பதிவேற்றவும்';

  @override
  String get gallery => 'புகைப்படத்தொகுப்பு';

  @override
  String get camera => 'புகைப்படக்கருவி';

  @override
  String get cancel => 'ரத்துசெய்';

  @override
  String get male => 'ஆண்';

  @override
  String get female => 'பெண்';

  @override
  String get other => 'மற்றவை';

  @override
  String get error => 'பிழை';

  @override
  String get success => 'வெற்றி';

  @override
  String get noInternet => 'இணைய இணைப்பு இல்லை';

  @override
  String get sessionExpired => 'அமர்வு காலாவதியானது. மீண்டும் உள்நுழையவும்.';

  @override
  String get unauthorized => 'அங்கீகரிக்கப்படாத அணுகல்';

  @override
  String get databaseError => 'தரவுத்தள பிழை ஏற்பட்டது';

  @override
  String get imageUploadError => 'படத்தைப் பதிவேற்ற முடியவில்லை';

  @override
  String get profileUpdated => 'சுயவிவரம் வெற்றிகரமாக புதுப்பிக்கப்பட்டது';
}

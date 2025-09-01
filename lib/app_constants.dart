/// App-wide constants for WordDefiner
class AppConstants {
  // App information
  static const String appInfo = "Results by Datamuse and Dictionary APIs";

  static final String appDisclaimer =
      "The developer disclaims all liability for any direct, indirect, incidental, consequential, or special damages arising from or related to your use of the app, including but not limited to, any errors or omissions in the content provided, any interruptions or malfunctions of the app's functionality, or any reliance on information displayed within the app.";

  // In-app review tracking keys
  static const String lastReviewDateKey = 'last_review_date';
  static const String appOpensSinceReviewKey = 'app_opens_since_review';
  static const String installDateKey = 'install_date';

  // Validation patterns
  static final RegExp validInputLetters = RegExp(r'^[a-zA-Z ]+$');

  // Platform-specific height multipliers
  static const double desktopHeightMultiplier = 0.9;
  static const double landscapeTabletHeightMultiplier = 0.86;
  static const double portraitTabletHeightMultiplier = 0.89;
  static const double largeIPhoneHeightMultiplier = 0.85;
  static const double smallIPhoneHeightMultiplier = 0.83;
  static const double largeAndroidHeightMultiplier = 0.90;
  static const double smallAndroidHeightMultiplier = 0.89;
  static const double defaultPhoneHeightMultiplier = 0.83;

  // Platform-specific width multipliers
  static const double smallIPadLandscapeWidthMultiplier = 0.87;
  static const double largeIPadLandscapeWidthMultiplier = 0.89;
  static const double portraitSmallWidthMultiplier = 0.77;
  static const double portraitLargeWidthMultiplier = 0.86;

  // Screen size thresholds
  static const double tabletHeightThreshold = 1100.0;
  static const double largePhoneHeightThreshold = 900.0;
  static const double iPadHeightThreshold = 1000.0;
}

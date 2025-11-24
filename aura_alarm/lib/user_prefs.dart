/// Temporary user preferences provider.
/// For now, this is hardcoded. Later, replace with persistent storage and onboarding.
class UserPrefs {
  // Example: User selected Kolkata, India
  static const String countryName = 'India';
  static const String countryFlag = '🇮🇳';
  static const String cityName = 'Kolkata';
  // IST is UTC+05:30
  static const Duration utcOffset = Duration(hours: 5, minutes: 30);
  static const String timeZoneAbbreviation = 'IST';
}

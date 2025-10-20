import 'package:flutter/material.dart';

class LanguageSelectionProvider extends ChangeNotifier {
  String _selectedLanguage = '';
  bool _isLoading = false;

  String get selectedLanguage => _selectedLanguage;
  bool get isLoading => _isLoading;

  void selectLanguage(String languageCode) {
    _selectedLanguage = languageCode;
    notifyListeners();
  }

  Future<void> saveLanguagePreference() async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Save language preference to local storage
      // await _storageService.setString('selected_language', _selectedLanguage);

      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      // Handle error
    }
  }

  Future<String> getSavedLanguage() async {
    try {
      // TODO: Get saved language from local storage
      // return await _storageService.getString('selected_language') ?? 'en';

      // Mock response
      await Future.delayed(const Duration(milliseconds: 200));
      return 'en'; // Default to English
    } catch (e) {
      return 'en'; // Default to English
    }
  }

  String getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'te':
        return 'Telugu';
      case 'hi':
        return 'Hindi';
      default:
        return 'English';
    }
  }

  String getLanguageCode(String languageName) {
    switch (languageName.toLowerCase()) {
      case 'english':
        return 'en';
      case 'telugu':
        return 'te';
      case 'hindi':
        return 'hi';
      default:
        return 'en';
    }
  }
}

import 'package:structure/utils/constants.dart';

class SettingsItem {

  String langCode;
  bool isDarkMode, isFirstUse;

  SettingsItem({this.langCode = langCodeDefault, this.isDarkMode = false, this.isFirstUse = true});

  Map<String, dynamic> toMap() {
    return {
      settingLanguage: langCode,
      settingIsDarkMode: isDarkMode,
      settingIsFirstUse: isFirstUse,
    };
  }

  static SettingsItem fromMap(Map<String, dynamic> map) {
    return SettingsItem(
      isDarkMode: map[settingIsDarkMode],
      langCode: map[settingLanguage],
      isFirstUse: map[settingIsFirstUse]?? true,
    );
  }

}
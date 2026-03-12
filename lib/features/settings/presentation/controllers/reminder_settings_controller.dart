import 'package:flutter/foundation.dart';
import 'package:goal_keeper_app/features/settings/domain/entities/reminder_settings.dart';


final class ReminderSettingsController extends ChangeNotifier {
  ReminderSettings _settings = const ReminderSettings();
  ReminderSettings get settings => _settings;

  void toggleWeeklyReports(bool v) {
    _settings = _settings.copyWith(weeklyReports: v);
    notifyListeners();
  }

  void toggleAchievementAlerts(bool v) {
    _settings = _settings.copyWith(achievementAlerts: v);
    notifyListeners();
  }

  void toggleDailyReminders(bool v) {
    _settings = _settings.copyWith(dailyReminders: v);
    notifyListeners();
  }

  void toggleAmPm() {
    _settings = _settings.copyWith(isAm: !_settings.isAm);
    notifyListeners();
  }

  void setFrequency(RepeatFrequency f) {
    _settings = _settings.copyWith(frequency: f);
    notifyListeners();
  }

  void setHour(int h) {
    _settings = _settings.copyWith(notificationHour: h);
    notifyListeners();
  }

  void setMinute(int m) {
    _settings = _settings.copyWith(notificationMinute: m);
    notifyListeners();
  }

  Future<void> save() async {
    // TODO: call SaveReminderSettingsUseCase
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
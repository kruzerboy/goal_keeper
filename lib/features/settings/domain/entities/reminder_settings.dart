enum RepeatFrequency { everyDay, weekdays }

final class ReminderSettings {
  final bool weeklyReports;
  final bool achievementAlerts;
  final bool dailyReminders;
  final int notificationHour;
  final int notificationMinute;
  final bool isAm;
  final RepeatFrequency frequency;

  const ReminderSettings({
    this.weeklyReports = true,
    this.achievementAlerts = true,
    this.dailyReminders = true,
    this.notificationHour = 8,
    this.notificationMinute = 30,
    this.isAm = true,
    this.frequency = RepeatFrequency.everyDay,
  });

  ReminderSettings copyWith({
    bool? weeklyReports,
    bool? achievementAlerts,
    bool? dailyReminders,
    int? notificationHour,
    int? notificationMinute,
    bool? isAm,
    RepeatFrequency? frequency,
  }) =>
      ReminderSettings(
        weeklyReports: weeklyReports ?? this.weeklyReports,
        achievementAlerts: achievementAlerts ?? this.achievementAlerts,
        dailyReminders: dailyReminders ?? this.dailyReminders,
        notificationHour: notificationHour ?? this.notificationHour,
        notificationMinute: notificationMinute ?? this.notificationMinute,
        isAm: isAm ?? this.isAm,
        frequency: frequency ?? this.frequency,
      );
}
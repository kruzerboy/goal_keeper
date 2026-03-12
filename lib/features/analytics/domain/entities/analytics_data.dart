import 'package:flutter/material.dart';

enum AnalyticsRange { week, month, year }

final class AnalyticsBadge {
  final String id;
  final String name;
  final String emoji;
  final Color color;

  const AnalyticsBadge({
    required this.id,
    required this.name,
    required this.emoji,
    required this.color,
  });
}



final class AnalyticsData {
  final double completionRate;
  final double completionDelta;
  final List<double> chartPoints;
  final int goalsCompleted;
  final int completedDelta;
  final int streakDays;
  final bool isNewPR;
  final List<AnalyticsBadge> badges;
  final String quickInsight;
  final AnalyticsRange range;

  const AnalyticsData({
    required this.completionRate,
    required this.completionDelta,
    required this.chartPoints,
    required this.goalsCompleted,
    required this.completedDelta,
    required this.streakDays,
    required this.isNewPR,
    required this.badges,
    required this.quickInsight,
    required this.range,
  });
}
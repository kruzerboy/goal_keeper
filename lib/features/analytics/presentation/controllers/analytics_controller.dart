import 'package:flutter/material.dart';
import 'package:goal_keeper_app/features/analytics/domain/entities/analytics_data.dart';
import '../../../../core/utils/screen_state.dart';


final class AnalyticsController extends ChangeNotifier {
  ScreenState<AnalyticsData> _state = const ScreenInitial();
  ScreenState<AnalyticsData> get state => _state;

  AnalyticsRange _range = AnalyticsRange.week;
  AnalyticsRange get range => _range;

  Future<void> load() async {
    _state = const ScreenLoading();
    notifyListeners();
    await _fetchForRange(_range);
  }

  Future<void> switchRange(AnalyticsRange r) async {
    _range = r;
    _state = const ScreenLoading();
    notifyListeners();
    await _fetchForRange(r);
  }

  Future<void> refresh() => load();

  Future<void> _fetchForRange(AnalyticsRange r) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final data = AnalyticsData(
      completionRate: r == AnalyticsRange.week ? 0.84 : 0.76,
      completionDelta: r == AnalyticsRange.week ? 0.12 : 0.08,
      chartPoints: r == AnalyticsRange.week
          ? [0.6, 0.75, 0.5, 0.9, 0.7, 0.55, 0.85]
          : [0.5, 0.6, 0.7, 0.8, 0.65, 0.72, 0.68,
              0.78, 0.82, 0.76, 0.84, 0.79],
      goalsCompleted: r == AnalyticsRange.week ? 24 : 96,
      completedDelta: 15,
      streakDays: 12,
      isNewPR: true,
      badges: _mockBadges,
      quickInsight:
          "You're most productive on Tuesdays. You complete 40% more goals compared to other days!",
      range: r,
    );

    _state = ScreenLoaded(data);
    notifyListeners();
  }

  static final _mockBadges = [
    const AnalyticsBadge(
        id: 'b1',
        name: '7 Day Streak',
        emoji: '🏅',
        color: Color(0xFFFBBF24)),
    const AnalyticsBadge(
        id: 'b2',
        name: 'Goal Crusher',
        emoji: '🚀',
        color: Color(0xFF60A5FA)),
    const AnalyticsBadge(
        id: 'b3',
        name: 'Early Bird',
        emoji: '🌿',
        color: Color(0xFF34D399)),
    const AnalyticsBadge(
        id: 'b4',
        name: 'Elite Tier',
        emoji: '🏆',
        color: Color(0xFFA78BFA)),
  ];
}
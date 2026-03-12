import 'package:flutter/foundation.dart';
import 'package:goal_keeper_app/core/utils/screen_state.dart';
import 'package:goal_keeper_app/features/add_goal/domain/entities/add_goal_form.dart';
import 'package:goal_keeper_app/features/goals/domain/entities/goal_item.dart';

final class AddGoalController extends ChangeNotifier {
  AddGoalForm _form = const AddGoalForm();
  AddGoalForm get form => _form;

  ScreenState<void> _submitState = const ScreenInitial();
  ScreenState<void> get submitState => _submitState;

  // Calendar state
  DateTime _calendarMonth = DateTime(2023, 10);
  DateTime get calendarMonth => _calendarMonth;

  void updateName(String name) {
    _form = _form.copyWith(name: name);
    notifyListeners();
  }

  void updateCategory(String? category) {
    _form = _form.copyWith(category: category);
    notifyListeners();
  }

  void updatePriority(PriorityLevel priority) {
    _form = _form.copyWith(priority: priority);
    notifyListeners();
  }

  void selectDeadline(DateTime date) {
    _form = _form.copyWith(deadline: date);
    notifyListeners();
  }

  void prevMonth() {
    _calendarMonth =
        DateTime(_calendarMonth.year, _calendarMonth.month - 1);
    notifyListeners();
  }

  void nextMonth() {
    _calendarMonth =
        DateTime(_calendarMonth.year, _calendarMonth.month + 1);
    notifyListeners();
  }

  Future<void> saveGoal({required void Function() onSuccess}) async {
    if (!_form.isValid) return;
    _submitState = const ScreenLoading();
    notifyListeners();

    // TODO: call CreateGoalUseCase
    await Future.delayed(const Duration(milliseconds: 800));

    _submitState = const ScreenLoaded(null);
    notifyListeners();
    onSuccess();
  }
}
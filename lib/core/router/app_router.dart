import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goal_keeper_app/core/theme/app_theme.dart';
import 'package:goal_keeper_app/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:goal_keeper_app/features/auth/presentation/screens/login_screen.dart';
//import 'package:goal_keeper_app/features/goals/presentation/screens/goal_detail_screen.dart';
import 'package:goal_keeper_app/features/goals/presentation/screens/goals_list_screen.dart';
import 'package:goal_keeper_app/features/splash/presentation/screens/splash_screen.dart';

import '../../features/add_goal/presentation/screens/add_goal_screen.dart';
// import 'package:goal_keeper_app/features/goals/presentation/screens/signup/signup_screen.dart';



/// Single source of truth for all route names.
/// Add new routes here — NEVER use raw strings in widgets.
abstract final class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const signup = '/signup';
  static const dashboard = '/dashboard';
  static const goalsList = '/goals';
  static const goalDetail = '/goals/:id';
  static const addGoal = '/goals/add';
  static const analytics = '/analytics';
  static const reminderSettings = '/settings/reminders';
  static const profile = '/profile';

  static String goalDetailPath(String id) => '/goals/$id';
}

/// All navigation logic lives here. Screens call
/// `context.go(AppRoutes.dashboard)` — zero coupling to Navigator.
final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (_, __) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (_, __) =>  const LoginScreen(),
    ),
    // GoRoute(
    //   path: AppRoutes.signup,
    //   builder: (_, __) => const SignupScreen(),
    // ),
    GoRoute(
      path: AppRoutes.dashboard,
      builder: (_, __) => const DashboardScreen(),
    ),
    GoRoute(
      path: AppRoutes.goalsList,
      builder: (_, __) => const GoalsListScreen(),
    ),
    // GoRoute(
    //   path: AppRoutes.goalDetail,
    //   builder: (context, state) {
    //     final id = state.pathParameters['id']!;
    //     return GoalDetailScreen(goalId: id);
    //   },
    // ),
    GoRoute(
      path: AppRoutes.addGoal,
      builder: (_, __) => const AddGoalScreen(),
    ),
    // GoRoute(
    //   path: AppRoutes.profile,
    //   builder: (_, __) => const ProfileScreen(),
    // ),
  ],
  // Global error page — swap with your branded error screen
  errorBuilder: (context, state) => PopScope(
    canPop: context.canPop(),
    onPopInvoked: (didPop) {
      if (!didPop && context.canPop()) {
        context.pop();
      } else if (!didPop) {
        // If can't pop, navigate to dashboard
        context.go(AppRoutes.dashboard);
      }
    },
    child: Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Try to pop if possible, otherwise navigate to dashboard
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.dashboard);
            }
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.error,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Route not found',
                style: AppTypography.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                state.uri.toString(),
                style: AppTypography.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              ElevatedButton(
                onPressed: () {
                  // Navigate to dashboard if can't go back
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go(AppRoutes.dashboard);
                  }
                },
                child: const Text('Go to Dashboard'),
              ),
            ],
          ),
        ),
      ),
    ),
  ),
);




//
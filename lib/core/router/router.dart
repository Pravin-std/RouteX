import 'package:go_router/go_router.dart';
import '../../features/authentication/presentation/pages/login_page.dart';
import '../../features/authentication/presentation/pages/signup_page.dart';
import '../../features/authentication/presentation/pages/forgot_password_page.dart';
import '../../features/authentication/presentation/pages/reset_password_page.dart';
import '../../features/authentication/presentation/pages/splash_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/buses/presentation/pages/available_buses_page.dart';
import '../../features/buses/presentation/pages/bus_details_page.dart';
import '../../features/tickets/presentation/pages/digital_ticket_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupPage(),
    ),
    GoRoute(
      path: '/forgot_password',
      builder: (context, state) => const ForgotPasswordPage(),
    ),
    GoRoute(
      path: '/reset_password',
      builder: (context, state) => const ResetPasswordPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const DashboardPage(),
    ),
    GoRoute(
      path: '/available_buses',
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>? ?? {};
        return AvailableBusesPage(
          from: extras['from'] ?? '',
          to: extras['to'] ?? '',
        );
      },
    ),
    GoRoute(
      path: '/bus_details',
      builder: (context, state) {
        final bus = state.extra as Map<String, dynamic>? ?? {};
        return BusDetailsPage(bus: bus);
      },
    ),
    GoRoute(
      path: '/digital_ticket',
      builder: (context, state) {
        final bus = state.extra as Map<String, dynamic>? ?? {};
        return DigitalTicketPage(bus: bus);
      },
    ),
  ],
);
import 'package:go_router/go_router.dart';
import '../../features/home_placeholder_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePlaceholderPage(),
    ),
  ],
);

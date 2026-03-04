import 'package:go_router/go_router.dart';
import 'package:student_assessment_fe/features/main/main_page.dart';
import 'package:student_assessment_fe/features/start/start_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/start',
  routes: [
    GoRoute(
      path: '/start',
      name: 'start',
      builder: (context, _) => const StartPage(),
    ),
    GoRoute(
      path: '/main',
      name: 'main',
      builder: (context, state) {
        final url =
            state.uri.queryParameters['url'] ??
            'https://assessment.smkswadaya.sch.id';
        return MainPage(initialUrl: url);
      },
    ),
  ],
);

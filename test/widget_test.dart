import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_authenticity_of_arts/core/storage/shared_preferences_provider.dart';
import 'package:the_authenticity_of_arts/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('shows login page on startup', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(preferences),
        ],
        child: const AuthenticityOfArtsApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('تسجيل الدخول'), findsOneWidget);
  });
}

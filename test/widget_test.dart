import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_auth_app/main.dart';
import 'package:flutter_auth_app/controllers/auth_controller.dart';

void main() {
  testWidgets('App loads login screen', (WidgetTester tester) async {
    final authController = AuthController();
    await tester.pumpWidget(MyApp(authController: authController));

    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Email Address'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
  });
}

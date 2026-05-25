import 'package:flutter_test/flutter_test.dart';
import 'package:tenantmatch_app/app.dart';
import 'package:tenantmatch_app/services/favorites_service.dart';
import 'package:tenantmatch_app/services/form_data_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App renders home screen', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final favService = FavoritesService();
    final formService = FormDataService();
    await favService.init();
    await formService.init();

    await tester.pumpWidget(const TenantMatchApp());
    await tester.pumpAndSettle();

    expect(find.text('TenantMatch'), findsWidgets);
    expect(find.text('Quick Actions'), findsOneWidget);
  });
}

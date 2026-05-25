import 'package:flutter/material.dart';
import 'app.dart';
import 'services/favorites_service.dart';
import 'services/form_data_service.dart';
import 'services/theme_service.dart';

final favoritesService = FavoritesService();
final formDataService = FormDataService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await favoritesService.init();
  await formDataService.init();
  await ThemeService.init();
  runApp(const TenantMatchApp());
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:subtrak/app/bindings/initial_binding.dart';
import 'package:subtrak/app/data/models/bill_model.dart';
import 'package:subtrak/app/services/notification_services.dart';
import 'package:subtrak/ui/screens/homescreen.dart';
import 'package:subtrak/ui/screens/welcome_screen.dart';
import 'package:subtrak/ui/pages/themes/app_themes.dart';
import 'package:subtrak/ui/widgets/main_nav.dart';
import 'package:timezone/data/latest.dart' as tzData;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDocDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocDir.path);

  Hive.registerAdapter(BillModelAdapter()); // 👈 required
  await Hive.openBox<BillModel>('bills');

  await GetStorage.init(); // for welcome screen logic
  final box = GetStorage();
  final isDarkMode = box.read('isDarkMode') ?? false;
  tzData.initializeTimeZones();
  await NotificationService.init();
  runApp(SubTrakApp(isDarkMode: isDarkMode));
}

class SubTrakApp extends StatelessWidget {
  final bool isDarkMode;
  const SubTrakApp({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final isFirstLaunch = box.read('firstLaunch') ?? true;

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SubTrak',
      initialBinding: InitialBinding(),
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: ThemeMode.system,
      home: isFirstLaunch ? const WelcomeScreen() : const MainNav(),
      // home: const WelcomeScreen(),
    );
  }
}

import 'package:edify/features/main/screens/shorts/add_short/add_short.dart';
import 'package:edify/features/main/screens/shorts/shorts.dart';
import 'package:edify/test.dart';
import 'package:edify/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'data/repositories/authentication/authentication_repository.dart';
import 'utils/constants/text_strings.dart';
import 'utils/theme/theme.dart';
import 'features/main/screens/home_page/home_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: TTexts.appName,
        themeMode: ThemeMode.system,
        theme: TAppTheme.lightTheme,
        darkTheme: TAppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        home:
            TestPage() /*Scaffold(
        backgroundColor: TColors.primary,
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      ),*/
        );
  }
}

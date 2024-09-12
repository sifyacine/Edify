import 'package:edify/features/authentication/screens/signin/widgets/login_header.dart';
import 'package:flutter/material.dart';
import '../../../../utils/constants/sizes.dart';
import 'widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              /// logo, title and subtitle
              TLoginHeader(),

              /// Form
              TLoginForm(),


              SizedBox(
                height: TSizes.spaceBtwSections,
              ),

              /// footer
            ],
          ),
        ),
      ),
    );
  }
}

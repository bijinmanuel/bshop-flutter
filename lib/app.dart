import 'package:bcom_app/core/configs/provider-configs/providers.dart';
import 'package:bcom_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/sign_in_screen.dart';
import 'screens/home/product_list_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: ProviderConfigs.providerDeclaration,
      child: GetMaterialApp(
        theme: ThemeData(primaryColor: AppColors.primaryColor),
        title: 'Product App',
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.fadeIn, // global transition
        transitionDuration: Duration(milliseconds: 400), // global duration
        home: AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.user != null) {
      return const ProductListScreen(); // your home screen
    } else {
      return LoginScreen();
    }
  }
}

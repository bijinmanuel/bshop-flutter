import 'package:bcom_app/providers/auth_provider.dart';
import 'package:bcom_app/screens/auth/sign_up_screen.dart';
import 'package:bcom_app/screens/home/product_list_screen.dart';
import 'package:bcom_app/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class LoginScreen extends HookWidget {
  const LoginScreen({super.key});
  @override
  

  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    final isPasswordVisible = useState(false);
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 1500),
    );
    final slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Curves.easeOutQuart,
          ),
        );
    final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOutQuart),
    );
    useEffect(() {
      animationController.forward();
      return null;
    }, []);
    String? validateEmail(String? value) {
      if (value == null || value.isEmpty) {
        return 'Email is required';
      }
      if (!value.contains('@') || !value.contains('.')) {
        return 'Please enter a valid email';
      }
      return null;
    }

    String? validatePassword(String? value) {
      if (value == null || value.isEmpty) {
        return 'Password is required';
      }
      if (value.length < 6) {
        return 'Password must be at least 6 characters';
      }
      return null;
    }

    Future<void> onLogIn() async {
      if (formKey.currentState?.validate() != true) return;
      final success = await authProvider.signIn(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      if (success && context.mounted) {
        Get.offAll(() => const ProductListScreen());
      } else if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Login failed")));
      }
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(
            position: slideAnimation,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isTablet = constraints.maxWidth > 600;
                final horizontalPadding = isTablet ? 48.0 : 24.0;
                final maxFormWidth = isTablet ? 500.0 : double.infinity;
                return Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxFormWidth),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: 24,
                      ),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 40),
                            Icon(
                              Icons.shopping_bag_outlined,
                              size: 80,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Welcome Back!',
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Sign in to start shopping your favorites',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 48),
                            TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                hintText: 'Enter your email',
                                prefixIcon: const Icon(Icons.email_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              validator: validateEmail,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: passwordController,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                hintText: 'Enter your password',
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    isPasswordVisible.value
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () => isPasswordVisible.value =
                                      !isPasswordVisible.value,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              obscureText: !isPasswordVisible.value,
                              textInputAction: TextInputAction.done,
                              validator: validatePassword,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              onFieldSubmitted: (_) => onLogIn(),
                            ),
                            const SizedBox(height: 24),
                            AppButton(onPressed: onLogIn, text: 'Sign In'),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SignUpScreen(),
                                ),
                              ),
                              child: Text.rich(
                                TextSpan(
                                  text: 'Don\'t have an account? ',
                                  children: [
                                    TextSpan(
                                      text: 'Sign Up',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

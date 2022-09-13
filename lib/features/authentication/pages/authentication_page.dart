import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/features/authentication/pages/sign_up_page.dart';
import 'package:shop_app/features/authentication/providers/auth_provider.dart';
import 'package:shop_app/features/home/pages/product_overview_page.dart';
import 'package:shop_app/features/manage_product/modals/http_exception.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});
  static const routeName = '/login-page';

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final bool _authModeLogIn = true;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  Future<void> _logInAndSignUp() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    _formKey.currentState?.save();
    final email = _emailController.text.trim();
    final passowrd = _passwordController.text.trim();
    try {
      await Provider.of<AuthProvider>(context, listen: false)
          .logIn(email, passowrd);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Log in successfully'),
        ),
      );

      if (!mounted) return;
      await Navigator.of(context).pushNamed(ProductOverviewPage.routeName);
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not valid email address.';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'Password is too week.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
    } catch (error) {
      const errorMessage = 'Could not authenticate you. Please try again later';
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(errorMessage),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(15) + const EdgeInsets.only(top: 130),
            children: [
              Text(
                'Shop App',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _emailController,
                textInputAction: TextInputAction.next,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  labelText: 'email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                validator: (value) {
                  final title = value?.trim() ?? '';
                  if (title.isEmpty) {
                    return 'Please enter a email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                textInputAction: _authModeLogIn
                    ? TextInputAction.done
                    : TextInputAction.next,
                keyboardType: TextInputType.visiblePassword,
                autofillHints: const [AutofillHints.password],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  labelText: 'password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded,
                    ),
                    onPressed: () => setState(
                      () => _isPasswordVisible = !_isPasswordVisible,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                validator: (value) {
                  final pass = value ?? '';
                  if (pass.isEmpty) {
                    return 'Please enter a password';
                  } else if (pass.length <= 8) {
                    return 'Password must be greater than 8 characters';
                  }
                  return null;
                },
              ),
              if (!_authModeLogIn) ...[
                const SizedBox(height: 15),
                TextFormField(
                  textInputAction: TextInputAction.done,
                  controller: _confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible,
                  keyboardType: TextInputType.visiblePassword,
                  autofillHints: const [AutofillHints.password],
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    labelText: 'confirm password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                      ),
                      onPressed: () => setState(
                        () => _isConfirmPasswordVisible =
                            !_isConfirmPasswordVisible,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  validator: (value) {
                    final pass = value ?? '';
                    if (_authModeLogIn) return null;
                    if (pass.isEmpty) {
                      return 'Please enter a confirm password';
                    } else if (pass.length <= 8) {
                      return 'Password must be greater than 8 characters';
                    } else if (pass != _passwordController.text) {
                      return 'Confirm password and Password are not same';
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 15),
              MaterialButton(
                height: 50,
                onPressed: _logInAndSignUp,
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Text(
                  'Log In',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Dont't have an account?",
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(SignUpPage.routeName);
                    },
                    child: const Text('Sign Up'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

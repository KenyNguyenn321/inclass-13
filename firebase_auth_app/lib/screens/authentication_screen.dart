import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'profile_screen.dart';

// authentication screen handles register and sign in
class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  // form key used for validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // text controllers for user input
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // auth service instance
  final AuthService _authService = AuthService();

  // tracks whether screen is in login or register mode
  bool _isLogin = true;

  // tracks loading state during auth call
  bool _isLoading = false;

  // validates email format
  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'email is required';
    }

    if (!value.contains('@')) {
      return 'enter a valid email like test@gsu.com';
    }

    return null;
  }

  // validates password length
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'password is required';
    }

    if (value.length < 6) {
      return 'password must be at least 6 characters';
    }

    return null;
  }

  // shows a snackbar message
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  // handles register or sign in action
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      if (_isLogin) {
        await _authService.signIn(email, password);
        _showMessage('sign in successful');
      } else {
        await _authService.register(email, password);
        _showMessage('registration successful');
      }

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ProfileScreen(),
          ),
        );
      }
    } on Exception catch (e) {
      _showMessage(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // toggles between register and sign in modes
  void _toggleMode() {
    setState(() {
      _isLogin = !_isLogin;
    });

    _emailController.clear();
    _passwordController.clear();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // builds the authentication screen ui
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Sign In' : 'Register'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // email field
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: 16),

                  // password field
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: _validatePassword,
                  ),
                  const SizedBox(height: 16),

                  // submit button for register or sign in
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submit,
                      child: Text(_isLogin ? 'Sign In' : 'Register'),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // loading indicator while request is running
                  if (_isLoading) const CircularProgressIndicator(),
                  if (_isLoading) const SizedBox(height: 12),

                  // toggle between register and sign in modes
                  TextButton(
                    onPressed: _toggleMode,
                    child: Text(
                      _isLogin
                          ? 'Need an account? Register'
                          : 'Already have an account? Sign In',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
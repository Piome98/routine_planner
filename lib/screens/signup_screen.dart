import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routine_planner/services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback showLoginPage;

  const SignUpScreen({super.key, required this.showLoginPage}); // Use super.key

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> signUp() async {
    if (_passwordController.text.trim() != _confirmPasswordController.text.trim()) {
      if (!mounted) return; // Add mounted check
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match!')),
      );
      return;
    }

    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      await authService.registerWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    } catch (e) {
      if (!mounted) return; // Add mounted check
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> signInWithGoogle() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      await authService.signInWithGoogle();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In failed: $e')),
      );
    }
  }

  Future<void> signInWithFacebook() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      await authService.signInWithFacebook();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Facebook Sign-In failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
            ),
            const SizedBox(height: 24.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: signUp,
                child: const Text('Register'),
              ),
            ),
            
            const SizedBox(height: 16.0),
            const Row(
              children: [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('OR'),
                ),
                Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 16.0),
            
            // Google Sign-In Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: signInWithGoogle,
                icon: const Icon(Icons.g_mobiledata, color: Colors.red),
                label: const Text('Continue with Google'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  side: const BorderSide(color: Colors.grey),
                ),
              ),
            ),
            
            const SizedBox(height: 12.0),
            
            // Facebook Sign-In Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: signInWithFacebook,
                icon: const Icon(Icons.facebook, color: Colors.blue),
                label: const Text('Continue with Facebook'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  side: const BorderSide(color: Colors.grey),
                ),
              ),
            ),
            
            const SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already a member?'),
                TextButton(
                  onPressed: widget.showLoginPage,
                  child: const Text('Login now'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

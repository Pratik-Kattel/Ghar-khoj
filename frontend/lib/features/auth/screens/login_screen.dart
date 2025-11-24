import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/login_state.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPasswordVisible = false;
  bool _isDialogOpen = false; // Track if loader is open

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            // Show loader only if submitting and dialog not open
            if (state.isSubmitting && !_isDialogOpen) {
              _isDialogOpen = true;
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const Center(child: CircularProgressIndicator()),
              );
            }

            // Close loader only if dialog was open
            if (!state.isSubmitting && _isDialogOpen) {
              _isDialogOpen = false;
              Navigator.pop(context); // close loader
            }

            // Show general error
            if (state.generalError != null) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.generalError!)));
            }

            // Navigate on success
            if (state.isSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Login Successful")),
              );
              Navigator.pushReplacementNamed(context, "/home");
            }
          },
          builder: (context, state) {
            return _buildUI(context, state);
          },
        ),
      ),
    );
  }

  Widget _buildUI(BuildContext context, LoginState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Login",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          // Email TextField
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: state.emailError != null ? Colors.red : Colors.grey.shade400,
              ),
            ),
            child: TextField(
              onChanged: (value) {
                context.read<LoginBloc>().add(EmailChanged(value));
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Enter Email",
                errorText: state.emailError,
              ),
            ),
          ),
          const SizedBox(height: 15),
          // Password TextField
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: state.passwordError != null
                    ? Colors.red
                    : Colors.grey.shade400,
              ),
            ),
            child: TextField(
              onChanged: (value) {
                context.read<LoginBloc>().add(PasswordChanged(value));
              },
              obscureText: !isPasswordVisible,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Enter Password",
                errorText: state.passwordError,
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 25),
          // Login Button
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                context.read<LoginBloc>().add(LoginSubmitted());
              },
              child: const Text(
                "Login",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Signup Navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have an account? "),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "/signup");
                },
                child: const Text(
                  "Sign Up",
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

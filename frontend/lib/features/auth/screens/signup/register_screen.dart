import 'package:flutter/material.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_textfield.dart';
import 'package:frontend/themes/app_themes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final FocusNode nameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode confirmPasswordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text("Register Now"),
        elevation: 0,
        toolbarHeight: 70,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: const Color(0xFFF3E8FF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  "Register with name, email and password now to explore the app",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 30),

              // Name field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: CustomTextField.textField(
                  containerMargin: 10,
                  contentPadding: 20,
                  iconPadding: 17,
                  hintText: "Enter Name",
                  borderColor: Colors.grey.shade400,
                  focus: nameFocus,
                  controller: nameController,
                  iconData: const Icon(Icons.person), Validator: (value) {  },
                ),
              ),
              const SizedBox(height: 20),

              // Email field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: CustomTextField.textField(
                  containerMargin: 10,
                  contentPadding: 20,
                  iconPadding: 17,
                  hintText: "Enter Email",
                  borderColor: Colors.grey.shade400,
                  focus: emailFocus,
                  controller: emailController,
                  iconData: const Icon(Icons.email), Validator: (value) {  },
                ),
              ),
              const SizedBox(height: 20),

              // Password field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: CustomTextField.textField(
                  containerMargin: 10,
                  contentPadding: 20,
                  iconPadding: 10,
                  hintText: "Enter Password",
                  borderColor: Colors.grey.shade400,
                  focus: passwordFocus,
                  controller: passwordController,
                  iconData: IconButton(
                    icon: Icon(isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  ),
                  obSecureText: !isPasswordVisible, Validator: (value) {  },
                ),
              ),
              const SizedBox(height: 20),

              // Confirm Password field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: CustomTextField.textField(
                  containerMargin: 10,
                  contentPadding: 20,
                  iconPadding: 10,
                  hintText: "Confirm Password",
                  borderColor: Colors.grey.shade400,
                  focus: confirmPasswordFocus,
                  controller: confirmPasswordController,
                  iconData: IconButton(
                    icon: Icon(isConfirmPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        isConfirmPasswordVisible = !isConfirmPasswordVisible;
                      });
                    },
                  ),
                  obSecureText: !isConfirmPasswordVisible, Validator: (value) {  },
                ),
              ),
              const SizedBox(height: 50),

              // Register Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:5),
                child: CustomButton.button(
                  texts: "Sign Up",
                  context: context,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User registered sucessfully")));
                  },
                ),
              ),
              const SizedBox(height: 30),

              // Login Navigation
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, "/login");
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

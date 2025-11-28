import 'package:flutter/material.dart';
import '../../../../widgets/custom_snackbar.dart';
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
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final FocusNode nameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode confirmPasswordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text("Register Now 👋"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xFFF8F0FF),
        toolbarHeight: 70,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF8F0FF), Color(0xFFF3E8FF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    gradient: LinearGradient(
                      colors: [Color(0xFFF3E8FF), Color(0xFFE9D5FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 35,
                        spreadRadius: 3,
                        offset: Offset(0, 15),
                      ),
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(35)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          "Register with name, email and password now to explore the app.",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Name field
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: CustomTextField.textField(
                          containerMargin: 10,
                          contentPadding: 20,
                          iconPadding: 17,
                          hintText: "Enter Name",
                          borderColor: Colors.grey,
                          focus: nameFocus,
                          controller: nameController,
                          prefixIcon: const Icon(
                            Icons.person,
                            color: AppColors.primary,
                          ),
                          Validator: (value) {},
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
                          borderColor: Colors.grey,
                          focus: emailFocus,
                          controller: emailController,
                          prefixIcon: const Icon(
                            Icons.email,
                            color: AppColors.primary,
                          ),
                          Validator: (value) {},
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Password field
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: CustomTextField.textField(
                          containerMargin: 10,
                          contentPadding: 20,
                          iconPadding: 15,
                          hintText: "Enter Password",
                          borderColor: Colors.grey,
                          focus: passwordFocus,
                          controller: passwordController,
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: AppColors.primary,
                          ),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(top: 7),
                            child: IconButton(
                              icon: Icon(
                                isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  isPasswordVisible = !isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          obSecureText: !isPasswordVisible,
                          Validator: (value) {},
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Confirm Password field
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: CustomTextField.textField(
                          containerMargin: 10,
                          contentPadding: 20,
                          iconPadding: 15,
                          hintText: "Confirm Password",
                          borderColor: Colors.grey,
                          focus: confirmPasswordFocus,
                          controller: confirmPasswordController,
                          prefixIcon: const Icon(
                            Icons.lock_open,
                            color: AppColors.primary,
                          ),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(top: 7),
                            child: IconButton(
                              icon: Icon(
                                isConfirmPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  isConfirmPasswordVisible =
                                      !isConfirmPasswordVisible;
                                });
                              },
                            ),
                          ),
                          obSecureText: !isConfirmPasswordVisible,
                          Validator: (value) {},
                        ),
                      ),
                      const SizedBox(height: 50),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Container(
                          height: 55,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: const LinearGradient(
                              colors: [Color(0xFFC084FC), Color(0xFF9333EA)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purpleAccent.withOpacity(0.25),
                                blurRadius: 18,
                                spreadRadius: 1,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                CustomSnackBar.buildSnackBar(
                                  bgColor: Colors.white,
                                  messageColor: AppColors.primary,
                                  iconColor:  Colors.green,
                                  icon: Icons.verified_user_outlined,
                                  message: "User registered successfully",
                                  context: context,
                                ),
                              );
                            },
                            child: const Center(
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Login Navigation
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, "/login");
                              },
                              child: const Text(
                                "Sign in",
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

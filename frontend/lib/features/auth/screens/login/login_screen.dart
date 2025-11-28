import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/login/login_state.dart';
import '../../bloc/login/login_bloc.dart';
import '../../bloc/login/login_event.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_textfield.dart';
import 'package:frontend/themes/app_themes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPasswordVisible = false;
  bool _isDialogOpen = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final formKey=GlobalKey<FormState>();

  void initState() {
    super.initState();
    emailFocus.addListener(() => setState(() {}));
    passwordFocus.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final height=MediaQuery.of(context).size.height;
    final width=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Welcome Back 👋"),
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 75,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: const Color(0xFFF3E8FF),
      body: SafeArea(
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.isSubmitting && !_isDialogOpen) {
              _isDialogOpen = true;
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) =>
                    const Center(child: CircularProgressIndicator()),
              );
            }

            if (!state.isSubmitting && _isDialogOpen) {
              _isDialogOpen = false;
              Navigator.pop(context);
            }

            if (state.generalError != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.generalError!)));
            }

            if (state.isSuccess) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Login Successful")));
              Navigator.pushReplacementNamed(context, "/home");
            }
          },
          builder: (context, state) {
            return Form(
              key: formKey,
              child:
              SingleChildScrollView(
                child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                 SizedBox(height: height*0.002),
                   Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "Sign in with your email and password to continue",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 35),

                  // Email field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: CustomTextField.textField(
                      containerMargin: 10,
                      contentPadding: 20,
                      iconPadding: 17,
                      hintText: "Enter Email",
                      borderColor: emailFocus.hasFocus
                          ? AppColors.primary
                          : (state.emailError != null
                                ? AppColors.redColor
                                : AppColors.grey),
                      focus: emailFocus,
                      controller: emailController,
                      prefixIcon: const Icon(Icons.email_outlined,color:AppColors.primary,size: 25,),
                      errorMessage: state.emailError, Validator: (value) {
                        if(value==null || value.isEmpty){
                          return "Email should not be empty";
                        }
                        else if(!value.endsWith('@gmail.com')){
                          return "Please enter a valid email address";
                        }
                    },
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Password field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: CustomTextField.textField(
                      containerMargin: 10,
                      iconPadding: 10,
                      contentPadding: 20,
                      hintText: "Enter Password",
                      borderColor: passwordFocus.hasFocus
                          ? AppColors.primary
                          : (state.passwordError != null
                                ? AppColors.redColor
                                : AppColors.grey),
                      focus: passwordFocus,
                      controller: passwordController,
                      prefixIcon: Icon(Icons.lock_outline,color: AppColors.primary,size: 25,),
                      errorMessage: state.passwordError,
                      suffixIcon: Padding(padding: EdgeInsetsGeometry.only(top: 5),child:
                        IconButton(
                          color: AppColors.primary,
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                        icon: isPasswordVisible
                            ? Icon(Icons.visibility)
                            : Icon(Icons.visibility_off),
                      ),
                      ),
                      obSecureText: !isPasswordVisible,
                      Validator: (value){
                        if(value.isEmpty || value==null){
                          return "Password cannot be empty";
                        }
                        else if(value.length <5){
                          return "Password must be 5 digit long";
                        }
                        else if(!RegExp(r'[A-Z]').hasMatch(value)){
                          return "Password must contain at least one capital letter";
                        }
                        else if(!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)){
                          return "Password must contain at least one special character";
                        }
                      }

                    ),
                  ),

                   SizedBox(height: height*0.05),

                    CustomButton.button(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: width*0.4),
                      texts: "Login",
                      context: context,
                      onPressed: () {
                        if(formKey.currentState!.validate()) {
                          context.read<LoginBloc>().add(
                            EmailChanged(emailController.text),
                          );
                          context.read<LoginBloc>().add(
                            PasswordChanged(passwordController.text),
                          );
                          context.read<LoginBloc>().add(LoginSubmitted());
                        }
                      },
                    ),

                  const SizedBox(height: 30),

                  // Signup Navigation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, "/register");
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height*0.3),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "© 2025 Ghar Khoj®. All rights reserved.",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
              )
            );
          },
        ),
      ),
    );
  }
}

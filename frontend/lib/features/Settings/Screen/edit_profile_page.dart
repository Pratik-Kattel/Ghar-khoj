import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/features/Settings/Bloc/profile_page/profile_page_bloc.dart';
import 'package:frontend/features/Settings/Bloc/profile_page/profile_page_event.dart';
import 'package:frontend/themes/app_themes.dart';
import 'package:frontend/widgets/custom_button.dart';
import 'package:frontend/widgets/custom_textfield.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../Home/Bloc/home_screen/home_screen_bloc.dart';
import '../Bloc/profile_page/profile_page_state.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  EditProfilePageState createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController username = TextEditingController();
  final FocusNode usernameFocus = FocusNode();
  final TextEditingController email = TextEditingController();
  final FocusNode emailFocus = FocusNode();
  final formKey = GlobalKey<FormState>();
  bool _isDialogOpen = false;

  void initState() {
    super.initState();
    super.initState();
    final homeState = context.read<HomeScreenBloc>().state;
    setState(() {
      username.text = homeState.name ?? "";
      email.text = homeState.email ?? "";
    });
    usernameFocus.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<ProfilePageBloc, ProfilePageState>(
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
              ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackBar.buildSnackBar(
                  message: state.generalError,
                  context: context,
                  bgColor: Colors.white,
                  messageColor: Colors.red,
                ),
              );
            }

            if (state.isSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackBar.buildSnackBar(
                  message: "Name changed Successfully",
                  context: context,
                  bgColor: Colors.white,
                  messageColor: Colors.green,
                  icon: Icons.verified,
                  iconColor: Colors.green,
                ),
              );
              Navigator.pushReplacementNamed(context, '/bottomNavigator');
            }
          },
          builder: (context, state) {
            return Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  Center(
                    child: Text(
                      "Edit profile",
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsetsGeometry.only(left: 15.w),
                    child: Text(
                      "Username:",
                      style: TextStyle(fontSize: 17.sp, color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  CustomTextField.textField(
                    hintText: state.name,
                    borderColor: usernameFocus.hasFocus
                        ? AppColors.primary
                        : Colors.grey,
                    focus: usernameFocus,
                    controller: username,
                    prefixIcon: Icon(Icons.person, color: AppColors.primary),
                    contentPadding: 20,
                    iconPadding: 20,
                    Validator: (value) {
                      if(value==null|| value.isEmpty){
                        return "Name must not be empty";
                      }
                    },
                    width: 2,
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsetsGeometry.only(left: 15.w),
                    child: Text(
                      "Email:",
                      style: TextStyle(fontSize: 17.sp, color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  CustomTextField.textField(
                    hintText: "Email",
                    readonly: true,
                    borderColor: emailFocus.hasFocus
                        ? AppColors.primary
                        : Colors.grey,
                    focus: emailFocus,
                    controller: email,
                    prefixIcon: Icon(Icons.email, color: AppColors.primary),
                    contentPadding: 20,
                    iconPadding: 20,
                    Validator: (value) {
                    },
                    width: 2,
                  ),
                  SizedBox(height: 75.h),
                  Center(
                    child:
                  CustomButton.button(
                    texts: "Submit",
                    onPressed: (){
                      if(formKey.currentState!.validate()){
                        context.read<ProfilePageBloc>().add(NameChangedEvent(name: username.text));
                        context.read<ProfilePageBloc>().add(EmailChangedEvent(email: email.text.trim()));
                        context.read<ProfilePageBloc>().add(NameSubmittedEvent());
                      }
                    },
                    context: context,
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 0.4.sw),
                  )
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

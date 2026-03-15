import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../Repository/upload_house-repo.dart';
import '../bloc/add_house_bloc.dart';
import '../bloc/add_house_event.dart';
import '../bloc/add_house_state.dart';

class UploadHouseScreen extends StatefulWidget {
  const UploadHouseScreen({super.key});

  @override
  State<UploadHouseScreen> createState() => _UploadHouseScreenState();
}

class _UploadHouseScreenState extends State<UploadHouseScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final picker = ImagePicker();
  bool _isDialogOpen = false;

  Future pickImage(BuildContext context) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      context.read<HouseUploadBloc>().add(HouseImagePicked(File(pickedFile.path)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HouseUploadBloc(repository: HouseRepository(dio: Dio())),
      child: Scaffold(
        appBar: AppBar(title: const Text("Upload House")),
        body: BlocConsumer<HouseUploadBloc, HouseUploadState>(
          listener: (context, state) {
            if (state!.isSubmitting && !_isDialogOpen) {
              _isDialogOpen = true;
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const Center(child: CircularProgressIndicator()),
              );
            }

            if (!state.isSubmitting && _isDialogOpen) {
              _isDialogOpen = false;
              Navigator.pop(context);
            }

            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage!)),
              );
            }

            if (state.isSuccess && state.message != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message!)),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.all(16.w),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: "Title"),
                      onChanged: (val) => context.read<HouseUploadBloc>().add(HouseTitleChanged(val)),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(labelText: "Description"),
                      onChanged: (val) => context.read<HouseUploadBloc>().add(HouseDescriptionChanged(val)),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Price"),
                      onChanged: (val) => context.read<HouseUploadBloc>().add(HousePriceChanged(double.tryParse(val) ?? 0)),
                    ),
                    const SizedBox(height: 10),
                    state.imageFile != null
                        ? Image.file(state.imageFile!, height: 150)
                        : Container(height: 150, color: Colors.grey[300]),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => pickImage(context),
                      child: const Text("Pick Image"),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        context.read<HouseUploadBloc>().add(HouseUploadSubmitted());
                      },
                      child: const Text("Upload House"),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
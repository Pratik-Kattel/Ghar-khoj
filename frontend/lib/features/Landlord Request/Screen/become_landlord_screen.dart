import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontend/services/get_user_data.dart';
import '../../../widgets/custom_snackbar.dart';
import '../bloc/landlord_request_bloc.dart';
import '../bloc/landlord_request_event.dart';
import '../bloc/landlord_request_state.dart';

class BecomeLandlordScreen extends StatefulWidget {
  const BecomeLandlordScreen({super.key});

  @override
  State<BecomeLandlordScreen> createState() => _BecomeLandlordScreenState();
}

class _BecomeLandlordScreenState extends State<BecomeLandlordScreen> {
  File? _citizenshipImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked != null) {
      setState(() => _citizenshipImage = File(picked.path));
    }
  }

  Future<void> _submit() async {
    if (_citizenshipImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar.buildSnackBar(
          message: 'Please upload your citizenship image',
          context: context,
          bgColor: Colors.red,
        ),
      );
      return;
    }
    final email = await GetUserDataRepo.getUserEmail();
    if (email == null) return;
    if (!mounted) return;
    context.read<LandlordRequestBloc>().add(
      SubmitLandlordRequestEvent(
        email: email,
        citizenshipFile: _citizenshipImage!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Become a Landlord',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Color(0xFF1A1A2E),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF1A1A2E)),
          onPressed: () =>
              Navigator.pushReplacementNamed(context, '/bottomNavigator'),
        ),
      ),
      body: BlocConsumer<LandlordRequestBloc, LandlordRequestState>(
        listener: (context, state) {
          if (state is LandlordRequestError) {
            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackBar.buildSnackBar(
                message:state.message,
                bgColor: Colors.redAccent,
                context: context
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is LandlordRequestSuccess) return _buildSuccess();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildSteps(),
                const SizedBox(height: 24),
                _buildUpload(),
                const SizedBox(height: 32),
                _buildSubmitButton(state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.home_work_outlined,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'List Your Property\non Ghar Khoj',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Earn rental income by listing your property to thousands of tenants.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.75),
              fontSize: 13.5,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSteps() {
    final steps = [
      ('1', 'Upload your citizenship document', Icons.upload_file_outlined),
      ('2', 'Admin reviews your request', Icons.admin_panel_settings_outlined),
      ('3', 'Get approved & start listing', Icons.check_circle_outline),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'How it works',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 16),
          ...steps.map(
            (step) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A2E),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        step.$1,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Icon(step.$3, size: 18, color: const Color(0xFF6B7280)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      step.$2,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF374151),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpload() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upload Citizenship Document',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            color: Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Please upload a clear photo of your citizenship certificate.',
          style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
        ),
        const SizedBox(height: 14),
        GestureDetector(
          onTap: _pickImage,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: double.infinity,
            height: _citizenshipImage != null ? 220 : 150,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _citizenshipImage != null
                    ? const Color(0xFF1A1A2E)
                    : const Color(0xFFD1D5DB),
                width: _citizenshipImage != null ? 2 : 1.5,
              ),
            ),
            child: _citizenshipImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.file(_citizenshipImage!, fit: BoxFit.cover),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _citizenshipImage = null),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.cloud_upload_outlined,
                        size: 36,
                        color: Color(0xFF9CA3AF),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Tap to upload citizenship',
                        style: TextStyle(
                          color: Color(0xFF6B7280),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'JPG, PNG supported',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(LandlordRequestState state) {
    final isLoading = state is LandlordRequestLoading;
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: isLoading ? null : _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1A1A2E),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : const Text(
                'Submit Request',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
      ),
    );
  }

  Widget _buildSuccess() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: const BoxDecoration(
                color: Color(0xFFD1FAE5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_outline,
                color: Color(0xFF059669),
                size: 48,
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Request Submitted!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Your request has been submitted for review. You will receive an email once the admin reviews your documents.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 36),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/bottomNavigator'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A1A2E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Back to Home',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

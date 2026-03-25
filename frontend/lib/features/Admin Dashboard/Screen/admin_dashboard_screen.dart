import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/constants/api_endpoints.dart';
import '../Model/admin_dashboard_model.dart';
import '../bloc/admin_dashboard_bloc.dart';
import '../bloc/admin_dashboard_event.dart';
import '../bloc/admin_dashboard_state.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<AdminDashboardBloc>().add(LoadAllRequestsEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        backgroundColor: Colors.black54,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Admin Dashboard',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Ghar Khoj',
              style: TextStyle(color: Colors.white38, fontSize: 11),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: () =>
                context.read<AdminDashboardBloc>().add(LoadAllRequestsEvent()),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white38,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Approved'),
            Tab(text: 'Rejected'),
          ],
        ),
      ),
      body: BlocConsumer<AdminDashboardBloc, AdminDashboardState>(
        listener: (context, state) {
          if (state is AdminDashboardActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: const Color(0xFF059669),
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          } else if (state is AdminDashboardError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AdminDashboardLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF1A1A2E)),
            );
          }
          if (state is AdminDashboardLoaded) {
            final pending = state.requests
                .where((r) => r.status == 'PENDING')
                .toList();
            final approved = state.requests
                .where((r) => r.status == 'APPROVED')
                .toList();
            final rejected = state.requests
                .where((r) => r.status == 'REJECTED')
                .toList();

            return Column(
              children: [
                _buildSummaryBar(
                  pending.length,
                  approved.length,
                  rejected.length,
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildList(pending, showActions: true),
                      _buildList(approved, showActions: false),
                      _buildList(rejected, showActions: false),
                    ],
                  ),
                ),
              ],
            );
          }
          if (state is AdminDashboardError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.redAccent,
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    state.message,
                    style: const TextStyle(color: Color(0xFF6B7280)),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<AdminDashboardBloc>().add(
                      LoadAllRequestsEvent(),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A1A2E),
                    ),
                    child: const Text(
                      'Retry',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSummaryBar(int pending, int approved, int rejected) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          _chip(
            'Pending',
            pending,
            const Color(0xFFFEF3C7),
            const Color(0xFFD97706),
          ),
          const SizedBox(width: 10),
          _chip(
            'Approved',
            approved,
            const Color(0xFFD1FAE5),
            const Color(0xFF059669),
          ),
          const SizedBox(width: 10),
          _chip(
            'Rejected',
            rejected,
            const Color(0xFFFEE2E2),
            Colors.redAccent,
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, int count, Color bg, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              '$count',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(
    List<AdminLandlordRequestModel> requests, {
    required bool showActions,
  }) {
    if (requests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 52, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(
              'No requests here',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 15),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: requests.length,
      itemBuilder: (_, i) => _buildCard(requests[i], showActions: showActions),
    );
  }

  Widget _buildCard(
    AdminLandlordRequestModel request, {
    required bool showActions,
  }) {
    final date = DateTime.tryParse(request.createdAt);
    final formatted = date != null
        ? '${date.day}/${date.month}/${date.year}'
        : 'N/A';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: const Color(0xFF1A1A2E),
                      child: Text(
                        request.name[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            request.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: Color(0xFF1A1A2E),
                            ),
                          ),
                          Text(
                            request.email,
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _statusBadge(request.status),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 13,
                      color: Color(0xFF9CA3AF),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Submitted: $formatted',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
                if (request.docPath != null) ...[
                  const SizedBox(height: 12),
                  _docPreview(request.docPath!),
                ],
              ],
            ),
          ),
          if (showActions) ...[
            const Divider(height: 1, color: Color(0xFFF3F4F6)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () =>
                          _confirm(context, request.id, isApprove: false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.redAccent,
                        side: const BorderSide(color: Colors.redAccent),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: const Text(
                        'Reject',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () =>
                          _confirm(context, request.id, isApprove: true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF059669),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: const Text(
                        'Approve',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color bg, text;
    String label;
    switch (status) {
      case 'APPROVED':
        bg = const Color(0xFFD1FAE5);
        text = const Color(0xFF059669);
        label = 'Approved';
        break;
      case 'REJECTED':
        bg = const Color(0xFFFEE2E2);
        text = Colors.redAccent;
        label = 'Rejected';
        break;
      default:
        bg = const Color(0xFFFEF3C7);
        text = const Color(0xFFD97706);
        label = 'Pending';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: text,
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _docPreview(String docPath) {
    String baseUrl = ApiEndpoints.imageBaseUrl;
    final url = '$baseUrl$docPath';

    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (_) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              url,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Padding(
                padding: EdgeInsets.all(24),
                child: Text('Could not load document'),
              ),
            ),
          ),
        ),
      ),
      child: Container(
        height: 130,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFFF3F4F6),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Center(
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: Color(0xFF9CA3AF),
                    size: 36,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 10,
                  ),
                  color: Colors.black.withOpacity(0.45),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.zoom_in, color: Colors.white, size: 15),
                      SizedBox(width: 4),
                      Text(
                        'Tap to view full document',
                        style: TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirm(
    BuildContext context,
    String requestId, {
    required bool isApprove,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          isApprove ? 'Approve Request?' : 'Reject Request?',
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        content: Text(
          isApprove
              ? 'This user will be promoted to Landlord and notified via email.'
              : 'This request will be rejected and the user will be notified via email.',
          style: const TextStyle(fontSize: 13.5, color: Color(0xFF6B7280)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF6B7280)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (isApprove) {
                context.read<AdminDashboardBloc>().add(
                  ApproveRequestEvent(requestId),
                );
              } else {
                context.read<AdminDashboardBloc>().add(
                  RejectRequestEvent(requestId),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isApprove
                  ? const Color(0xFF059669)
                  : Colors.redAccent,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(isApprove ? 'Approve' : 'Reject'),
          ),
        ],
      ),
    );
  }
}

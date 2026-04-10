import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/constants/api_endpoints.dart';
import '../bloc/admin_houses_bloc.dart';
import '../bloc/admin_houses_event.dart';
import '../bloc/admin_houses_state.dart';
import '../Model/admin_house_model.dart';

class AdminHousesScreen extends StatefulWidget {
  const AdminHousesScreen({super.key});

  @override
  State<AdminHousesScreen> createState() => _AdminHousesScreenState();
}

class _AdminHousesScreenState extends State<AdminHousesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AdminHousesBloc>().add(FetchAdminHousesEvent());
  }

  void _confirmDelete(BuildContext context, AdminHouseModel house) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete House',
            style: TextStyle(fontWeight: FontWeight.w700)),
        content: Text('Are you sure you want to delete "${house.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context
                  .read<AdminHousesBloc>()
                  .add(DeleteAdminHouseEvent(houseId: house.houseId));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Delete',
                style: TextStyle(color: Colors.white)),
          ),
        ],
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
          'All Houses',
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: Color(0xFF1A1A2E)),
        ),
      ),
      body: BlocConsumer<AdminHousesBloc, AdminHousesState>(
        listener: (context, state) {
          if (state is AdminHousesError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.redAccent),
            );
          }
          if (state is AdminHouseDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('House deleted successfully'),
                  backgroundColor: Colors.green),
            );
          }
        },
        builder: (context, state) {
          if (state is AdminHousesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final houses = (state is AdminHousesLoaded)
              ? state.houses
              : (state is AdminHouseDeleted)
              ? state.houses
              : <AdminHouseModel>[];

          if (houses.isEmpty) {
            return const Center(
              child: Text('No houses found',
                  style: TextStyle(color: Colors.grey, fontSize: 16)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: houses.length,
            itemBuilder: (context, index) {
              final house = houses[index];
              return _buildHouseCard(context, house);
            },
          );
        },
      ),
    );
  }

  Widget _buildHouseCard(BuildContext context, AdminHouseModel house) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              '${ApiEndpoints.imageBaseUrl}${house.imageUrl}',
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 180,
                color: Colors.grey.shade200,
                child: const Icon(Icons.home, size: 48, color: Colors.grey),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(house.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Color(0xFF1A1A2E))),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDE9FE),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('\$${house.price}',
                          style: const TextStyle(
                              color: Color(0xFF7C3AED),
                              fontWeight: FontWeight.w700,
                              fontSize: 13)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Description
                Text(house.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 13, color: Color(0xFF6B7280))),
                const SizedBox(height: 10),

                // Landlord info
                Row(
                  children: [
                    const Icon(Icons.person_outline,
                        size: 15, color: Color(0xFF9CA3AF)),
                    const SizedBox(width: 4),
                    Text(house.landlordName,
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF6B7280))),
                    const SizedBox(width: 4),
                    Text('• ${house.landlordEmail}',
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF9CA3AF))),
                  ],
                ),
                const SizedBox(height: 12),

                // Delete button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _confirmDelete(context, house),
                    icon: const Icon(Icons.delete_outline,
                        size: 18, color: Colors.white),
                    label: const Text('Delete House',
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
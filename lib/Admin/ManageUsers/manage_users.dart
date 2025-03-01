import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:layout/api/user.dart';

class AdminUsersPage extends StatefulWidget {
  const AdminUsersPage({super.key});

  @override
  State<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends State<AdminUsersPage> {
  final UserApi _userApi = UserApi();
  String _searchQuery = '';
  String _filterStatus = 'All';
  final TextEditingController _searchController = TextEditingController();

  Map<String, dynamic> _convertDocToUser(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return {
      'user_id': doc.id,
      'name': data['user_name'] ?? 'Unknown',
      'email': data['user_email'] ?? 'No email',
      'role': data['user_role'] ?? 'user',
      'status': data['user_status'] ?? 'Active',
      'image': data['user_image'] ?? '',
    };
  }

  Future<void> _updateUserStatus(String docId, String status) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(docId).update({
        'user_status': status,
      });
      _showSnackBar('User status updated to $status');
    } catch (e) {
      _showSnackBar('Error updating user status: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showUserDetailsDialog(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('User Details'),
            content: _userDetailsContent(user),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  Widget _userDetailsContent(Map<String, dynamic> user) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              backgroundImage:
                  user['image'] != ''
                      ? NetworkImage(user['image'])
                      : const AssetImage('assets/default_avatar.png')
                          as ImageProvider,
              radius: 40,
            ),
          ),
          const SizedBox(height: 16),
          _buildUserDetailTile('ID', user['user_id']),
          _buildUserDetailTile('Name', user['name']),
          _buildUserDetailTile('Email', user['email']),
          _buildUserDetailTile('Role', user['role']),
          _buildUserDetailTile('Status', user['status']),
        ],
      ),
    );
  }

  Widget _buildUserDetailTile(String title, String subtitle) {
    return ListTile(title: Text(title), subtitle: Text(subtitle));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Management"),
        backgroundColor: Colors.blue,
        elevation: 2,
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: _userApi.getUsersStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No users found'));
            }

            List<Map<String, dynamic>> allUsers =
                snapshot.data!.docs
                    .where((doc) => _convertDocToUser(doc)['role'] == 'user')
                    .map((doc) => _convertDocToUser(doc))
                    .toList();

            List<Map<String, dynamic>> filteredUsers = _filterUsers(allUsers);

            return _buildUserManagementContent(filteredUsers, allUsers);
          },
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _filterUsers(List<Map<String, dynamic>> allUsers) {
    final regex = RegExp(_searchQuery);

    return allUsers.where((user) {
      final matchesSearch =
          regex.hasMatch(user['name'].toString()) ||
          regex.hasMatch(user['email'].toString());

      final matchesFilter =
          _filterStatus == 'All' || user['status'] == _filterStatus;

      return matchesSearch && matchesFilter;
    }).toList();
  }

  Widget _buildUserManagementContent(
    List<Map<String, dynamic>> filteredUsers,
    List<Map<String, dynamic>> allUsers,
  ) {
    int activeCount = allUsers.where((u) => u['status'] == 'Active').length;
    int bannedCount = allUsers.where((u) => u['status'] == 'Banned').length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatisticsCard(allUsers.length, activeCount, bannedCount),
        _buildSearchAndFilterRow(),
        _buildUserListTitle(filteredUsers.length),
        _buildUserList(filteredUsers),
      ],
    );
  }

  Widget _buildStatisticsCard(
    int totalUsers,
    int activeCount,
    int bannedCount,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatCard(
            'Total Users',
            totalUsers.toString(),
            Icons.people,
            Colors.blue,
          ),
          _buildStatCard(
            'Active Users',
            activeCount.toString(),
            Icons.check_circle,
            Colors.green,
          ),
          _buildStatCard(
            'Banned Users',
            bannedCount.toString(),
            Icons.block,
            Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilterRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search users',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              value: _filterStatus,
              items:
                  ['All', 'Active', 'Banned'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _filterStatus = newValue!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserListTitle(int userCount) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        'User List ($userCount users)',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildUserList(List<Map<String, dynamic>> filteredUsers) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child:
            filteredUsers.isEmpty
                ? const Center(child: Text('No users found'))
                : ListView.separated(
                  itemCount: filteredUsers.length,
                  separatorBuilder:
                      (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final user = filteredUsers[index];
                    return _buildUserListTile(user);
                  },
                ),
      ),
    );
  }

  Widget _buildUserListTile(Map<String, dynamic> user) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user['image']),
        backgroundColor: _getStatusColor(user['status']),
      ),
      title: Text(user['name']),
      subtitle: Text('${user['email']} • ${user['role']}'),
      trailing: _buildUserActions(user),
      onTap: () => _showUserDetailsDialog(user),
    );
  }

  Widget _buildUserActions(Map<String, dynamic> user) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [_buildStatusBadge(user['status']), _buildUserPopupMenu(user)],
    );
  }

  Widget _buildUserPopupMenu(Map<String, dynamic> user) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        switch (value) {
          case 'details':
            _showUserDetailsDialog(user);
            break;
          case 'ban':
            _updateUserStatus(user['user_id'], 'Banned');
            break;
          case 'activate':
            _updateUserStatus(user['user_id'], 'Active');
            break;
        }
      },
      itemBuilder:
          (BuildContext context) => [
            const PopupMenuItem(value: 'details', child: Text('View Details')),
            if (user['status'] != 'Banned')
              const PopupMenuItem(value: 'ban', child: Text('Ban User')),
            if (user['status'] != 'Active')
              const PopupMenuItem(
                value: 'activate',
                child: Text('Activate User'),
              ),
          ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.145,
        width: MediaQuery.of(context).size.width * 0.25,
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.01,
          vertical: MediaQuery.of(context).size.height * 0.02,
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(title, style: TextStyle(color: Colors.grey.shade700)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status) {
      case 'Active':
        color = Colors.green;
        break;
      case 'Banned':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(status, style: TextStyle(color: color, fontSize: 12)),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Active':
        return Colors.green;
      case 'Banned':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

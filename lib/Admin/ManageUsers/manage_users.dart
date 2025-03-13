import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:layout/api/user.dart';
import 'dart:async'; // เพิ่มสำหรับ Timer

class AdminUsersPage extends StatefulWidget {
  const AdminUsersPage({super.key});

  @override
  State<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends State<AdminUsersPage> {
  final UserApi _userApi = UserApi();
  String _searchQuery = '';
  String _filterStatus = 'All';
  List<Map<String, dynamic>> _allUsers = [];
  List<Map<String, dynamic>> _filteredUsers = [];
  bool _isLoading = true;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  // ฟังก์ชันโหลดข้อมูลผู้ใช้
  void _loadUsers() {
    _userApi.getUsersStream().listen((snapshot) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _allUsers = snapshot.docs
              .where((doc) => (doc.data() as Map<String, dynamic>)['user_role'] == 'user')
              .map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return {
                  'user_id': doc.id,
                  'name': data['user_name'] ?? 'Unknown',
                  'email': data['user_email'] ?? 'No email',
                  'role': data['user_role'] ?? 'user',
                  'status': data['user_status'] ?? 'Active',
                  'image': data['user_image'] ?? '',
                };
              })
              .toList();
          
          // กรองข้อมูลหลังจากได้รับข้อมูลใหม่
          _filterUsers();
        });
      }
    }, onError: (error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading users: $error')),
        );
      }
    });
  }

  // กรองข้อมูลผู้ใช้โดยไม่ต้องดึงข้อมูลใหม่จาก Firestore
  void _filterUsers() {
    _filteredUsers = _allUsers.where((user) {
      final matchesSearch = _searchQuery.isEmpty || 
          user['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          user['email'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      
      final matchesFilter = _filterStatus == 'All' || user['status'] == _filterStatus;
      
      return matchesSearch && matchesFilter;
    }).toList();
  }

  // ฟังก์ชัน debounce สำหรับการค้นหา
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _searchQuery = query;
        _filterUsers();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Management"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildStats(),
                _buildSearchBar(),
                Expanded(child: _buildUserList()),
              ],
            ),
    );
  }

  // แสดงสถิติผู้ใช้
  Widget _buildStats() {
    final totalUsers = _allUsers.length;
    final activeUsers = _allUsers.where((u) => u['status'] == 'Active').length;
    final bannedUsers = _allUsers.where((u) => u['status'] == 'Banned').length;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _buildStatCard('Total', totalUsers, Icons.people, Colors.blue),
          const SizedBox(width: 8),
          _buildStatCard('Active', activeUsers, Icons.check_circle, Colors.green),
          const SizedBox(width: 8),
          _buildStatCard('Banned', bannedUsers, Icons.block, Colors.red),
        ],
      ),
    );
  }

  // การ์ดแสดงสถิติ
  Widget _buildStatCard(String title, int count, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: color.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // แถบค้นหาและตัวกรอง
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        children: [
          // ช่องค้นหา
          Expanded(
            flex: 2,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search users',
                prefixIcon: const Icon(Icons.search, size: 20),
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              onChanged: _onSearchChanged, // ใช้ debounce function
            ),
          ),
          const SizedBox(width: 8),
          // ตัวกรองสถานะ
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _filterStatus,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down, size: 20),
                  items: ['All', 'Active', 'Banned'].map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(status, style: const TextStyle(fontSize: 14)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _filterStatus = value!;
                      _filterUsers(); // กรองข้อมูลเมื่อเปลี่ยนตัวกรอง
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // รายการผู้ใช้
  Widget _buildUserList() {
    if (_filteredUsers.isEmpty) {
      return const Center(child: Text('No users found'));
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _filteredUsers.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final user = _filteredUsers[index];
        return _buildUserTile(user);
      },
    );
  }

  // รายการผู้ใช้แต่ละคน
  Widget _buildUserTile(Map<String, dynamic> user) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      leading: CircleAvatar(
        backgroundImage: user['image'].isNotEmpty
            ? NetworkImage(user['image'])
            : null,
        backgroundColor: user['image'].isEmpty
            ? _getStatusColor(user['status'])
            : null,
        child: user['image'].isEmpty
            ? Text(user['name'][0].toUpperCase())
            : null,
      ),
      title: Text(user['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(user['email']),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildStatusBadge(user['status']),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'details') {
                _showUserDetails(user);
              } else if (value == 'ban') {
                _updateUserStatus(user['user_id'], 'Banned');
              } else if (value == 'activate') {
                _updateUserStatus(user['user_id'], 'Active');
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'details', child: Text('Details')),
              if (user['status'] != 'Banned')
                const PopupMenuItem(value: 'ban', child: Text('Ban')),
              if (user['status'] != 'Active')
                const PopupMenuItem(value: 'activate', child: Text('Activate')),
            ],
          ),
        ],
      ),
      onTap: () => _showUserDetails(user),
    );
  }

  // แสดงแบดจ์สถานะ
  Widget _buildStatusBadge(String status) {
    Color color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontSize: 12),
      ),
    );
  }

  // สีตามสถานะ
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Active': return Colors.green;
      case 'Banned': return Colors.red;
      default: return Colors.grey;
    }
  }

  // แสดงรายละเอียดผู้ใช้
  void _showUserDetails(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('User Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundImage: user['image'].isNotEmpty
                  ? NetworkImage(user['image'])
                  : null,
              radius: 40,
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Name', user['name']),
            _buildDetailRow('Email', user['email']),
            _buildDetailRow('Status', user['status']),
            _buildDetailRow('Role', user['role']),
            _buildDetailRow('ID', user['user_id']),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // แถวข้อมูลในหน้ารายละเอียด
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  // อัปเดตสถานะผู้ใช้
  Future<void> _updateUserStatus(String userId, String status) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'user_status': status,
      });
      
      // อัปเดตข้อมูลในหน่วยความจำ
      setState(() {
        for (var user in _allUsers) {
          if (user['user_id'] == userId) {
            user['status'] = status;
            break;
          }
        }
        // กรองข้อมูลใหม่หลังจากอัปเดตสถานะ
        _filterUsers();
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User status updated to $status')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}

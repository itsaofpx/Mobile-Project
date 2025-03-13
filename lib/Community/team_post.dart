import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class PostFeed extends StatefulWidget {
  const PostFeed({super.key});

  @override
  State<PostFeed> createState() => _PostFeedState();
}

class _PostFeedState extends State<PostFeed> {
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _args;
  List<QueryDocumentSnapshot<Map<String, dynamic>>>? _posts;
  final _postController = TextEditingController();
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Get arguments from route
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      _args = args;

      // Only fetch posts the first time or when args change
      if (!_initialized) {
        _fetchPosts();
        _initialized = true;
      }
    }
  }

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${_args?['team_name'] ?? 'Team'} Posts"),
        backgroundColor: Colors.white,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_errorMessage!),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _fetchPosts,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
              : Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        controller: _postController,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: 'Write a new post...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: _createPost,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child:
                          _posts != null && _posts!.isNotEmpty
                              ? ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16.0,
                                ),
                                itemCount: _posts!.length,
                                itemBuilder: (context, index) {
                                  var post = _posts![index].data();
                                  return PostCard(
                                    userName: post['user_name'] ?? 'Admin',
                                    isAdmin: post['user_role'] == 'Admin',
                                    content: post['content'],
                                    timestamp: _formatTimestamp(
                                      post['timestamp'],
                                    ),
                                    isCurrentUser:
                                        post['user_id'] ==
                                        _args?['user_id'], // Check if the post belongs to the current user
                                  );
                                },
                              )
                              : const Center(child: Text("No posts available")),
                    ),
                  ],
                ),
              ),
    );
  }

  Future<QuerySnapshot<Map<String, dynamic>>> _getPostsQuery() async {
    if (_args == null || _args?['team_id'] == null) {
      throw Exception('Team ID is not available');
    }

    return FirebaseFirestore.instance
        .collection('posts')
        .where('team_id', isEqualTo: _args!['team_id'])
        .orderBy('timestamp', descending: true)
        .get();
  }

  void _fetchPosts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _posts = null;
    });

    try {
      final querySnapshot = await _getPostsQuery();
      setState(() {
        _isLoading = false;
        _posts = querySnapshot.docs;
      });
    } catch (err) {
      _setErrorState('Error fetching posts: $err');
    }
  }

  void _createPost() async {
    if (_postController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      try {
        final newPostId = const Uuid().v4();
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(newPostId)
            .set({
              'id': newPostId,
              'team_id': _args?['team_id'],
              'user_name': _args?['user_name'],
              'user_id': _args?['user_id'],
              'user_role': _args?['user_role'],
              'user_image': _args?['user_image'],
              'content': _postController.text,
              'timestamp': FieldValue.serverTimestamp(),
            });

        _postController.clear();
        _fetchPosts();
      } catch (err) {
        _setErrorState(err.toString());
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _setErrorState(String errorMessage) {
    setState(() {
      _isLoading = false;
      _errorMessage = errorMessage;
      _posts = null;
    });
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) {
      return 'Just now';
    }

    if (timestamp is Timestamp) {
      return DateFormat('MMM d, yyyy - h:mm a').format(timestamp.toDate());
    }

    return 'Unknown time';
  }
}

class PostCard extends StatelessWidget {
  final String userName;
  final bool isAdmin;
  final String content;
  final String timestamp;
  final bool isCurrentUser; // New parameter

  const PostCard({
    super.key,
    required this.userName,
    required this.isAdmin,
    required this.content,
    required this.timestamp,
    required this.isCurrentUser, // Include the new parameter in the constructor
  });

  @override
  Widget build(BuildContext context) {
    // Set admin and user images
    final String userImage =
        isAdmin
            ? 'https://static.vecteezy.com/system/resources/thumbnails/019/194/935/small_2x/global-admin-icon-color-outline-vector.jpg'
            : 'https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png';

    return Container(
      color:
          isCurrentUser
              ? Colors.blue[50]
              : Colors.white, // Change background color if current user
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(userImage),
                    radius: 20,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      isAdmin
                          ? const Text(
                            'Admin',
                            style: TextStyle(fontSize: 12, color: Colors.green),
                          )
                          : const Text(
                            'User',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(content),
              const SizedBox(height: 8),
              Text(
                timestamp,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

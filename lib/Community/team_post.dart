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
      appBar: AppBar(title: Text("${_args?['team_name'] ?? 'Team'} Posts"),backgroundColor: Colors.white,),
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
                                    userName: post['user_name'] ?? 'Anonymous',
                                    userImage:
                                        post['user_image'] ??
                                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS6LXNJFTmLzCoExghcATlCWG85kI8dsnhJng&s',
                                    content: post['content'],
                                    timestamp: _formatTimestamp(
                                      post['timestamp'],
                                    ),
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
  final String userImage;
  final String content;
  final String timestamp;

  const PostCard({
    super.key,
    required this.userName,
    required this.userImage,
    required this.content,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
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
                  Text(
                    userName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
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

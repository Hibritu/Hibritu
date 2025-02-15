
import 'package:flutter/foundation.dart' show kIsWeb; // Add this import
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'friend.dart';
import 'friends_page.dart';

class FriendsListScreen extends StatelessWidget {
  final Box<Friend> friendsBox;

  const FriendsListScreen({super.key, required this.friendsBox});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends List'),
        backgroundColor: Colors.blueAccent,
        elevation: 5,
      ),
      body: ValueListenableBuilder<Box<Friend>>(
        valueListenable: friendsBox.listenable(),
        builder: (context, box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('No friends added yet.'));
          }
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final friend = box.getAt(index);
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                elevation: 3,
                child: ListTile(
                  title: Text(friend!.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  leading: _buildFriendImage(friend.imagePath),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Age: ${friend.age}'),
                      Text('Vision: ${friend.vision}'),
                      Text('Activities: ${friend.activities.join(', ')}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteFriend(context, index),
                  ),
                  onTap: () => _navigateToUpdateFriend(context, index, friend),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FriendsPage()),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFriendImage(String imagePath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: imagePath.startsWith('assets/')
          ? Image.asset(imagePath, height: 60, width: 60, fit: BoxFit.cover)
          : kIsWeb
              ? Image.network(imagePath, height: 60, width: 60, fit: BoxFit.cover) // For web
              : Image.asset(imagePath, height: 60, width: 60, fit: BoxFit.cover)
// For mobile/desktop
    );
  }

  void _deleteFriend(BuildContext context, int index) {
    friendsBox.deleteAt(index);
  }

  void _navigateToUpdateFriend(BuildContext context, int index, Friend friend) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FriendsPage(friend: friend, index: index),
      ),
    );
  }
}
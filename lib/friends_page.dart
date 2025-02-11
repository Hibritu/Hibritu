import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'friend.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController visionController = TextEditingController();
  final TextEditingController activityController = TextEditingController();

  File? _imageFile;
  List<String> activities = [];
  late Box<Friend> friendsBox;

  @override
  void initState() {
    super.initState();
    friendsBox = Hive.box<Friend>('friendsBox');
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void addFriend() {
    final name = nameController.text.trim();
    final age = int.tryParse(ageController.text);
    final vision = visionController.text.trim();
    final imagePath = _imageFile?.path ?? 'assets/images/B.png';
                                         'assets/images/Ts.png';
    final friendActivities = List<String>.from(activities);

    if (name.isNotEmpty && age != null && vision.isNotEmpty) {
      final friend = Friend(name, age, vision, imagePath, friendActivities);
      friendsBox.add(friend).then((_) {
        clearInputFields();
      });
    }
  }

  void clearInputFields() {
    nameController.clear();
    ageController.clear();
    visionController.clear();
    activityController.clear();
    _imageFile = null;
    activities.clear();
    setState(() {});
  }

  void addActivity() {
    final activity = activityController.text.trim();
    if (activity.isNotEmpty) {
      setState(() {
        activities.add(activity);
        activityController.clear();
      });
    }
  }

  void deleteFriend(int index) {
    friendsBox.deleteAt(index);
    setState(() {});
  }

  Widget _buildFriendImage(String imagePath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: imagePath.startsWith('assets/')
          ? Image.asset(imagePath, height: 60, width: 60, fit: BoxFit.cover)
          : Image.file(File(imagePath), height: 60, width: 60, fit: BoxFit.cover),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends'),
        backgroundColor: Colors.blueAccent,
        elevation: 5,
      ),
      drawer: Drawer(
        child: Column(
          children: [
           const  DrawerHeader (
              decoration: BoxDecoration(color: Colors.blueAccent),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  Icon(Icons.people, color: Colors.white, size: 50),
                  SizedBox(height: 10),
                  Text("Friends App", style: TextStyle(color: Colors.white, fontSize: 22)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text("Friends List"),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration:const  InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: ageController,
              decoration: const InputDecoration(labelText: 'Age', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: visionController,
              decoration: const InputDecoration(labelText: 'Vision', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Select Image'),
            ),
           const  SizedBox (height:10),
            _imageFile != null
                ? Image.file(_imageFile!, height: 50)
                : Image.asset('assets/images/B.png', height: 80),
                Image.asset('assets/images/Ts.png', height: 80),
                
            const SizedBox(height: 10),
            TextField(
              controller: activityController,
              decoration: const  InputDecoration(labelText: 'Daily Activity', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: addActivity,
              icon: const Icon(Icons.add),
              label: const Text('Add Activity'),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: addFriend,
              icon: const Icon(Icons.person_add),
              label: const Text('Add Friend'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ValueListenableBuilder<Box<Friend>>(
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
                          title: Text(friend!.name, style:const  TextStyle(fontWeight: FontWeight.bold)),
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
                            onPressed: () => deleteFriend(index),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addFriend,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}

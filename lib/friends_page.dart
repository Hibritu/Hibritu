import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'friend.dart';
import 'friends_list_screen.dart';

class FriendsPage extends StatefulWidget {
  final Friend? friend;
  final int? index;
  const FriendsPage({super.key, this.friend, this.index});

  @override
  FriendsPageState createState() => FriendsPageState();
}

class FriendsPageState extends State<FriendsPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController visionController = TextEditingController();
  final TextEditingController activityController = TextEditingController();

  dynamic _imageFile; // Dynamic type to support image handling
  List<String> activities = [];
  late Box<Friend> friendsBox;

  // List of available assets for selection
  final List<String> assetImages = [
    'assets/images/Half.png',  
    'assets/images/A.png', 
    'assets/images/T.png', 
    'assets/images/B.png', 
    'assets/images/Ts.png', 
    'assets/images/bet.png', 
    'assets/images/M.png', 
    'assets/images/Me.png',
    'assets/images/Tg.png',  
    'assets/images/H.png', 
    
    'assets/images/.png'
  ];

  @override
  void initState() {
    super.initState();
    friendsBox = Hive.box<Friend>('friendsBox');

    if (widget.friend != null) {
      nameController.text = widget.friend!.name;
      ageController.text = widget.friend!.age.toString();
      visionController.text = widget.friend!.vision;
      activities = List<String>.from(widget.friend!.activities);
      _imageFile = widget.friend!.imagePath.startsWith('assets/') ? widget.friend!.imagePath : null;
    }
  }

  void saveFriend() {
    final name = nameController.text.trim();
    final age = int.tryParse(ageController.text);
    final vision = visionController.text.trim();
    final imagePath = _imageFile ?? widget.friend?.imagePath ?? 'assets/images/B.png';
    final friendActivities = List<String>.from(activities);

    if (name.isNotEmpty && age != null && vision.isNotEmpty) {
      final friend = Friend(name, age, vision, imagePath, friendActivities);
      if (widget.index != null) {
        friendsBox.putAt(widget.index!, friend);
      } else {
        friendsBox.add(friend);
      }
      clearInputFields();
      Navigator.pop(context);
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

  // Builds the correct image widget based on the image file
  Widget _buildImageWidget() {
    if (_imageFile != null) {
      return Image.asset(_imageFile, height: 80); // General solution for mobile/web
    } else {
      return Image.asset('assets/images/B.png', height: 80); // Default image
    }
  }

  // Show image selection dialog from asset list
  void _selectImageFromAssets() async {
    final selectedImage = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image'),
          content: SingleChildScrollView(
            child: Column(
              children: assetImages.map((image) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(image);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(image, width: 60, height: 60),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );

    if (selectedImage != null) {
      setState(() {
        _imageFile = selectedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.friend == null ? 'Add Friend' : 'Update Friend'),
        backgroundColor: Colors.blueAccent,
        elevation: 5,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration:const  BoxDecoration(color: Colors.blueAccent),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50), // Optional: for rounded corners
                    child: _imageFile == null
                        ? Image.asset('assets/images/Half.png', width: 60, height: 60, fit: BoxFit.cover)// Placeholder image
                        : Image.asset(_imageFile!, width: 60, height: 60, fit: BoxFit.cover), // Show selected image
                  ),
                  const SizedBox(width: 10), // Space between image and text
                  const Text(
                    'Menu', 
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Friends List'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FriendsListScreen(friendsBox: friendsBox)),
                );
              },
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
              decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
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
              onPressed: _selectImageFromAssets, // Select image from assets
              child: const Text('Select Image from Assets'),
            ),
            const SizedBox(height: 10),
            _buildImageWidget(),
            const SizedBox(height: 10),
            TextField(
              controller: activityController,
              decoration: const InputDecoration(labelText: 'Daily Activity', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: addActivity,
              icon: const Icon(Icons.add),
              label: const Text('Add Activity'),
            ),
            const SizedBox(height: 10),
            Text("Activities: ${activities.join(', ')}", style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: saveFriend,
              icon: const Icon(Icons.save),
              label: Text(widget.friend == null ? 'Add Friend' : 'Update Friend'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}

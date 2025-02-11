import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'friends_page.dart';
import 'friend.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register Hive Adapter after initialization
  Hive.registerAdapter(FriendAdapter());

  // Open the Hive Box before running the app
  await Hive.openBox<Friend>('friendsBox');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Friends App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const FriendsPage(),
    );
  }
}

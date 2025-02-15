import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'friend.dart';
import 'friends_list_screen.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(FriendAdapter());
  await Hive.openBox<Friend>('friendsBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Friends App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  FriendsListScreen(friendsBox: Hive.box<Friend>('friendsBox')),
    );
  }
}
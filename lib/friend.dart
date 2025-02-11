import 'package:hive/hive.dart';

part 'friend.g.dart';

@HiveType(typeId: 0)
class Friend extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int age;

  @HiveField(2)
  String vision;

  @HiveField(3)
  String imagePath;

  @HiveField(4)
  List<String> activities;

  Friend(this.name, this.age, this.vision, this.imagePath, this.activities);
}

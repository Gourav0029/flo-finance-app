import 'package:hive/hive.dart';

part 'user_profile_model.g.dart';

@HiveType(typeId: 1)
class UserProfile extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String? profileImagePath;

  UserProfile({
    required this.name,
    this.profileImagePath,
  });

  UserProfile copyWith({
    String? name,
    String? profileImagePath,
  }) {
    return UserProfile(
      name: name ?? this.name,
      profileImagePath: profileImagePath ?? this.profileImagePath,
    );
  }
}

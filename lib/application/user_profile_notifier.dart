import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/models/user_profile_model.dart';

part 'user_profile_notifier.g.dart';

@riverpod
class UserProfileNotifier extends _$UserProfileNotifier {
  @override
  UserProfile? build() {
    final box = Hive.box<UserProfile>('userProfileBox');
    return box.get('currentUser');
  }

  Future<void> updateProfile(String name, String? imagePath) async {
    final box = Hive.box<UserProfile>('userProfileBox');
    final updated = UserProfile(
      name: name,
      profileImagePath: imagePath,
    );
    await box.put('currentUser', updated);
    state = updated;
  }
}

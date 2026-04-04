import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Result from the profile picture picker bottom sheet.
/// - [path] is the new image path (non-null = picked from camera/gallery)
/// - [removed] is true if user chose "Remove Photo"
/// - Both null if user cancelled
class ProfilePictureResult {
  final String? path;
  final bool removed;
  const ProfilePictureResult({this.path, this.removed = false});
}

/// Shows a styled bottom sheet with Camera / Gallery / Remove options.
/// Returns [ProfilePictureResult] or null if cancelled.
Future<ProfilePictureResult?> showProfilePictureSheet(
  BuildContext context, {
  bool hasExistingPhoto = false,
}) async {
  return showModalBottomSheet<ProfilePictureResult>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      final colorScheme = Theme.of(ctx).colorScheme;
      return Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Profile Picture',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Divider(color: colorScheme.outlineVariant),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: colorScheme.primaryContainer,
                  child: Icon(Icons.camera_alt, color: colorScheme.onPrimaryContainer),
                ),
                title: Text('Take Photo', style: TextStyle(color: colorScheme.onSurface)),
                onTap: () async {
                  final picked = await ImagePicker().pickImage(
                    source: ImageSource.camera,
                    imageQuality: 80,
                    maxWidth: 512,
                    maxHeight: 512,
                  );
                  if (ctx.mounted) {
                    Navigator.pop(ctx, picked != null ? ProfilePictureResult(path: picked.path) : null);
                  }
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: colorScheme.primaryContainer,
                  child: Icon(Icons.photo_library, color: colorScheme.onPrimaryContainer),
                ),
                title: Text('Choose from Gallery', style: TextStyle(color: colorScheme.onSurface)),
                onTap: () async {
                  final picked = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 80,
                    maxWidth: 512,
                    maxHeight: 512,
                  );
                  if (ctx.mounted) {
                    Navigator.pop(ctx, picked != null ? ProfilePictureResult(path: picked.path) : null);
                  }
                },
              ),
              if (hasExistingPhoto) ...[
                Divider(color: colorScheme.outlineVariant),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0x1AFF0000),
                    child: Icon(Icons.delete, color: Colors.red),
                  ),
                  title: const Text('Remove Photo', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(ctx, const ProfilePictureResult(removed: true));
                  },
                ),
              ],
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text('Cancel', style: TextStyle(color: colorScheme.onSurfaceVariant)),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      );
    },
  );
}

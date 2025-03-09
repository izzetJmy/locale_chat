import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:locale_chat/comopnents/my_circular_progress_Indicator.dart';
import 'package:locale_chat/comopnents/my_snackbar.dart';
import 'package:locale_chat/constants/colors.dart';
import 'package:locale_chat/provider/auth_change_notifier/auth_change_notifier.dart';
import 'package:provider/provider.dart';

class ImagePickerHelper {
  /// Resim seçme diyaloğunu gösterir (Galeri veya Kamera)
  static Future<void> showImageSourceSelectionDialog({
    required BuildContext context,
    required Function(ImageSource) onImageSourceSelected,
  }) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            'Profil Resmi Seç',
            style: TextStyle(
              color: backgroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library, color: backgroundColor),
                title: const Text('Galeriden Seç'),
                onTap: () {
                  Navigator.pop(context);
                  onImageSourceSelected(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt, color: backgroundColor),
                title: const Text('Kamera ile Çek'),
                onTap: () {
                  Navigator.pop(context);
                  onImageSourceSelected(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Resim seçme ve yükleme işlemini gerçekleştirir
  static Future<void> pickAndUploadProfileImage({
    required BuildContext context,
    required ImageSource source,
    String successMessage = 'Profil resmi başarıyla güncellendi',
    String errorMessage = 'Profil resmi yüklenirken hata oluştu',
  }) async {
    final authChangeNotifier =
        Provider.of<AuthChangeNotifier>(context, listen: false);

    final File? selectedImagePath = await authChangeNotifier.getImage(source);
    debugPrint('selectedImagePath: ${selectedImagePath?.path ?? 'null'}');
    if (selectedImagePath == null) {
      debugPrint("🚨 Kullanıcı resim seçmedi.");
      return;
    }

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: MyCircularProgressIndicator(),
        );
      },
    );

    try {
      // Upload the image to Firebase
      File imageFile = File(selectedImagePath.path);
      await authChangeNotifier.uploadImage(imageFile);

      // Refresh user data to get updated profile picture
      await authChangeNotifier.authStateChanges();

      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Show success message
      if (context.mounted) {
        MySanckbar.mySnackbar(context, successMessage, 2);
      }
    } catch (e) {
      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Show error message
      if (context.mounted) {
        MySanckbar.mySnackbar(context, errorMessage, 2);
      }
      debugPrint('Error uploading profile image: $e');
    }
  }
}

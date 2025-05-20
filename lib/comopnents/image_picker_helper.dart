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
    String dialogTitle = 'Profil Resmi Seç',
    String galleryOptionText = 'Galeriden Seç',
    String cameraOptionText = 'Kamera ile Çek',
    Color? iconColor,
    Color? titleColor,
    double borderRadius = 15,
  }) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          title: Text(
            dialogTitle,
            style: TextStyle(
              color: titleColor ?? backgroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library,
                    color: iconColor ?? backgroundColor),
                title: Text(galleryOptionText),
                onTap: () {
                  Navigator.pop(context);
                  onImageSourceSelected(ImageSource.gallery);
                },
              ),
              ListTile(
                leading:
                    Icon(Icons.camera_alt, color: iconColor ?? backgroundColor),
                title: Text(cameraOptionText),
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
  static Future<void> pickAndUploadImage({
    required BuildContext context,
    required ImageSource source,
    String successMessage = 'Resim başarıyla yüklendi',
    String errorMessage = 'Resim yüklenirken hata oluştu',
    String? loadingMessage,
    bool showLoadingIndicator = true,
    bool showSnackbar = true,
  }) async {
    final authChangeNotifier =
        Provider.of<AuthChangeNotifier>(context, listen: false);

    final File? selectedImagePath = await authChangeNotifier.getImage(source);
    debugPrint('selectedImagePath: ${selectedImagePath?.path ?? 'null'}');
    if (selectedImagePath == null) {
      debugPrint("🚨 Kullanıcı resim seçmedi.");
      return;
    }

    // Show loading indicator if enabled
    if (showLoadingIndicator) {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MyCircularProgressIndicator(),
                if (loadingMessage != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    loadingMessage,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ],
            ),
          );
        },
      );
    }

    try {
      // Upload the image to Firebase
      File imageFile = File(selectedImagePath.path);
      await authChangeNotifier.uploadImage(imageFile);

      // Refresh user data to get updated profile picture
      await authChangeNotifier.authStateChanges();

      // Close loading dialog if it was shown
      if (showLoadingIndicator && context.mounted) {
        Navigator.of(context).pop();
      }

      // Show success message if enabled
      if (showSnackbar && context.mounted) {
        MySanckbar.mySnackbar(context, successMessage, 2);
      }
    } catch (e) {
      // Close loading dialog if it was shown
      if (showLoadingIndicator && context.mounted) {
        Navigator.of(context).pop();
      }

      // Show error message if enabled
      if (showSnackbar && context.mounted) {
        MySanckbar.mySnackbar(context, errorMessage, 2);
      }
      debugPrint('Error uploading image: $e');
    }
  }

  static pickAndUploadProfileImage(
      {required BuildContext context, required ImageSource source}) {}
}

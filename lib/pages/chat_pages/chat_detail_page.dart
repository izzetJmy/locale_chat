// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:locale_chat/comopnents/my_grid_images.dart';
import 'package:locale_chat/constants/languages_keys.dart';
import 'package:locale_chat/helper/localization_extention.dart';
import 'package:locale_chat/pages/chat_pages/chat_page.dart';
import 'package:locale_chat/provider/auth_change_notifier/auth_change_notifier.dart';
import 'package:provider/provider.dart';
import 'package:locale_chat/comopnents/my_appbar.dart';
import 'package:locale_chat/comopnents/profile_info.dart';
import 'package:locale_chat/constants/colors.dart';
import 'package:locale_chat/constants/text_style.dart';
import 'package:locale_chat/provider/chat_change_notifier/chat_change_notifier.dart';

class ChatDetailPage extends StatefulWidget {
  final String? chatId;
  final String? receiverId;
  const ChatDetailPage({
    Key? key,
    this.chatId,
    this.receiverId,
  }) : super(key: key);

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage>
    with SingleTickerProviderStateMixin {
  bool isLoading = true;
  List<String> images = [];
  late ChatChangeNotifier chatChangeNotifier;
  late AuthChangeNotifier authChangeNotifier;
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    chatChangeNotifier =
        Provider.of<ChatChangeNotifier>(context, listen: false);
    authChangeNotifier =
        Provider.of<AuthChangeNotifier>(context, listen: false);
    tabController = TabController(length: 1, vsync: this);
    loadReceiverInfo();
    loadImages();
  }

  Future<void> loadReceiverInfo() async {
    await authChangeNotifier.getUserInfo(widget.receiverId!);
  }

  Future<void> loadImages() async {
    setState(() {
      isLoading = true;
    });
    try {
      images = await chatChangeNotifier
          .getAllImagesFromFolder('chats/${widget.chatId}/images/');
      debugPrint('images: $images');
    } catch (e) {
      debugPrint('Resimler yüklenirken hata: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = authChangeNotifier.user;
    return Scaffold(
      appBar: MyAppBar(
        title: Text(LocaleKeys.chatDetails.locale(context),
            style: homePageTitleTextStyle),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: iconColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.message, color: iconColor),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  title: currentUser?.userName ?? 'Anonymus',
                  image_path: currentUser?.profilePhoto ??
                      'assets/images/group_avatar.png',
                  chatId: widget.chatId,
                  receiverId: widget.receiverId,
                  drop_down_menu_list: const [],
                ),
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          ProfileInfo(
                            image_path: currentUser?.profilePhoto ??
                                'assets/images/group_avatar.png',
                            image_radius: 60,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        currentUser?.userName ?? 'Anonymus',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        formatDate(currentUser?.createdAt.toString()),
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                TabBar(
                  tabAlignment: TabAlignment.start,
                  isScrollable: true,
                  controller: tabController,
                  tabs: [
                    Tab(text: LocaleKeys.chatImages.locale(context)),
                  ],
                  labelColor: iconColor,
                  labelStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  indicatorColor: iconColor,
                ),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      ImagesTab(
                        tabController: tabController,
                        images: images,
                        isLoading: isLoading,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

// ImagesTab widget'ı
class ImagesTab extends StatelessWidget {
  final TabController tabController;
  final List<String> images;
  final bool isLoading;

  const ImagesTab({
    super.key,
    required this.tabController,
    required this.images,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
      child: images.isNotEmpty
          ? MyGridImages(images: images)
          : Center(
              child:
                  Text(LocaleKeys.errorsChatNoImagesUploaded.locale(context)),
            ),
    );
  }
}

// Firebase timestamp'inden sadece gün.ay.yıl formatını çıkaran fonksiyon
String formatDate(String? timestamp) {
  if (timestamp == null || timestamp.isEmpty) return '12.12.2032';

  try {
    final date = DateTime.parse(timestamp);
    return '${date.day < 10 ? '0' : ''}${date.day}.${date.month < 10 ? '0' : ''}${date.month}.${date.year}';
  } catch (_) {
    return '12.12.2032';
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:locale_chat/comopnents/my_grid_images.dart';
import 'package:locale_chat/comopnents/my_marquee.dart';
import 'package:locale_chat/constants/languages_keys.dart';
import 'package:locale_chat/helper/localization_extention.dart';
import 'package:locale_chat/helper/ui_helper.dart';
import 'package:locale_chat/model/messages_models/group_chat_model.dart';
import 'package:locale_chat/comopnents/my_appbar.dart';
import 'package:locale_chat/comopnents/profile_info.dart';
import 'package:locale_chat/comopnents/my_profile_card.dart';
import 'package:locale_chat/comopnents/my_button.dart';
import 'package:locale_chat/comopnents/my_snackbar.dart';
import 'package:locale_chat/constants/colors.dart';
import 'package:locale_chat/constants/text_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:locale_chat/model/messages_models/single_chat_model.dart';
import 'package:locale_chat/model/user_model.dart';
import 'package:locale_chat/pages/chat_pages/chat_detail_page.dart';
import 'package:locale_chat/pages/group_pages/edit_gorup_detail_page.dart';
import 'package:locale_chat/provider/auth_change_notifier/auth_change_notifier.dart';
import 'package:locale_chat/provider/chat_change_notifier/chat_change_notifier.dart';
import 'package:locale_chat/provider/group_change_notifier/group_change_notifier.dart';
import 'package:provider/provider.dart';

class GroupDetailPage extends StatefulWidget {
  final GroupChatModel group;
  const GroupDetailPage({super.key, required this.group});

  @override
  State<GroupDetailPage> createState() => _GroupDetailPageState();
}

class _GroupDetailPageState extends State<GroupDetailPage>
    with SingleTickerProviderStateMixin {
  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
  final String? currentUserEmail = FirebaseAuth.instance.currentUser?.email;
  bool isAdmin = false;
  List<UserModel> members = [];
  List<String> images = [];
  bool isLoading = false;
  bool isImagesLoading = false;
  bool isSelected = false;
  List<UserModel> selectedMembers = [];

  late TextEditingController controller;
  late GroupChangeNotifier groupChangeNotifier;
  late AuthChangeNotifier authChangeNotifier;
  late ChatChangeNotifier chatNotifier;
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    groupChangeNotifier =
        Provider.of<GroupChangeNotifier>(context, listen: false);
    authChangeNotifier =
        Provider.of<AuthChangeNotifier>(context, listen: false);
    chatNotifier = Provider.of<ChatChangeNotifier>(context, listen: false);
    isAdmin = widget.group.adminEmail == currentUserEmail;
    controller = TextEditingController(text: widget.group.groupName);
    tabController = TabController(length: 2, vsync: this);
    _loadMembers();
    _loadImages();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Future<void> _loadMembers() async {
    setState(() {
      isLoading = true;
    });
    try {
      await groupChangeNotifier.getGroup(widget.group.groupId);
      if (groupChangeNotifier.group != null) {
        setState(() {
          members.clear(); // Clear the list before adding new members
        });
        for (String memberId in groupChangeNotifier.group!.members) {
          await authChangeNotifier.getUserInfo(memberId);
          if (authChangeNotifier.user != null) {
            setState(() {
              members.add(authChangeNotifier.user!);
            });
          }
        }
      }
    } catch (e) {
      debugPrint('Üyeler yüklenirken hata: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _removeMember(UserModel user) async {
    if (!isAdmin) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(LocaleKeys.groupRemoveMember.locale(context)),
        content: Text(LocaleKeys.groupRemoveMemberConfirmation.locale(context)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(LocaleKeys.groupCancel.locale(context)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(LocaleKeys.groupDelete.locale(context)),
          ),
        ],
      ),
    );
    if (widget.group.adminEmail == user.email) {
      // ignore: use_build_context_synchronously
      MySanckbar.mySnackbar(
          context, LocaleKeys.groupAdminCannotBeRemoved.locale(context), 2);
      return;
    }
    if (confirmed == true) {
      try {
        await groupChangeNotifier.removeUserFromGroup(
            widget.group.groupId, user);
        setState(() {
          members.removeWhere((member) => member.id == user.id);
        });
      } catch (e) {
        // ignore: use_build_context_synchronously
        MySanckbar.mySnackbar(context, 'Üye çıkarılırken hata: $e', 2);
      }
    }
  }

  Future<void> _deleteGroup() async {
    if (!isAdmin) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(LocaleKeys.groupDeleteGroup.locale(context)),
        content: Text(LocaleKeys.groupDeleteGroupConfirmation.locale(context)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(LocaleKeys.groupCancel.locale(context)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(LocaleKeys.groupDelete.locale(context)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await groupChangeNotifier.exitGroup(widget.group.groupId);
        if (mounted) {
          Navigator.pop(context);
          Navigator.pop(context);
        }
      } catch (e) {
        // ignore: use_build_context_synchronously
        MySanckbar.mySnackbar(context,
            LocaleKeys.errorsGroupErrorCreatingGroup.locale(context), 2);
      }
    }
  }

  void _toggleUserSelection(UserModel user, int index) {
    setState(() {
      if (isSelected) {
        selectedMembers.removeAt(index);
      } else {
        selectedMembers.add(user);
      }
      isSelected = !isSelected;
      debugPrint('selectedMembers: $isSelected');
    });
  }

  void _addMemberToGroup() {
    if (selectedMembers.isNotEmpty) {
      List<String> membersId = selectedMembers.map((e) => e.id).toList();

      groupChangeNotifier.addMemberToGroup(widget.group.groupId, membersId);
      Navigator.pop(context);
      _loadMembers(); // Refresh members list
    }
  }

  Future<void> _addMember() async {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title:
                Center(child: Text(LocaleKeys.groupAddMember.locale(context))),
            content: SizedBox(
              width: double.maxFinite,
              height: double.maxFinite,
              child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('Users').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                        child: Text(LocaleKeys.errorsGroupNoUsersFound
                            .locale(context)));
                  }
                  List<String> memberIds = members.map((e) => e.id).toList();
                  List<UserModel?> availableUsers = snapshot.data!.docs
                      .where((doc) => !memberIds.contains(doc.data()['id']))
                      .map((doc) => UserModel.fromJson(doc.data()))
                      .toList();
                  if (availableUsers.isEmpty) {
                    return Center(
                        child: Text(LocaleKeys.errorsGroupNoAvailableUsersToAdd
                            .locale(context)));
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: availableUsers.length,
                    itemBuilder: (context, index) {
                      final userData = availableUsers[index];

                      return MyProfileCard(
                        leading: ProfileInfo(
                            image_path: userData?.profilePhoto ??
                                'assets/images/user_avatar.png',
                            image_radius: 18),
                        tittleText: Text(userData?.userName ?? 'Anonymous'),
                        trailing: Icon(
                          isSelected
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: backgroundColor,
                        ),
                        height: 60,
                        onTap: () {
                          setDialogState(() {
                            _toggleUserSelection(userData!, index);
                          });
                        },
                      );
                    },
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: _addMemberToGroup,
                child: Text(LocaleKeys.groupAdd.locale(context)),
              ),
              TextButton(
                child: Text(LocaleKeys.groupCancel.locale(context)),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        },
      ),
    );
  }

  // Edit profil bottom sheet'i gösterme metodu
  void _showEditProfileBottomSheet() {
    showModalBottomSheet(
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return EditGroupDetailPage(
          editController: controller,
          group: groupChangeNotifier.group ?? widget.group,
        );
      },
    );
  }

  Future<void> _loadImages() async {
    setState(() {
      isImagesLoading = true;
    });

    try {
      images = await groupChangeNotifier.getAllImagesFromFolder(
          'groupImage/${widget.group.groupId}/groupImages/');
      debugPrint('images: $images');
    } catch (e) {
      debugPrint('Resimler yüklenirken hata: $e');
    } finally {
      if (mounted) {
        setState(() {
          isImagesLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: Text(LocaleKeys.groupGroupDetails.locale(context),
            style: homePageTitleTextStyle),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: iconColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (isAdmin)
            IconButton(
              icon: Icon(Icons.person_add_alt, color: iconColor),
              onPressed: _addMember,
            ),
          if (isAdmin)
            IconButton(
              icon: Icon(Icons.edit, color: iconColor),
              onPressed: () {
                _showEditProfileBottomSheet();
              },
            ),
        ],
      ),
      body: Consumer<GroupChangeNotifier>(
        builder: (context, groupChangeNotifier, child) {
          final groupData = groupChangeNotifier.group ?? widget.group;

          return isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    // Grup Profil Bölümü
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              ProfileInfo(
                                image_path: groupData.groupProfilePhoto ??
                                    'assets/images/user_avatar.png',
                                image_radius: 60,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                groupData.groupName,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${members.length} ${LocaleKeys.groupMembers.locale(context)}',
                            style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),

                    // TabBar ve TabBarView
                    TabBar(
                      controller: tabController,
                      tabs: [
                        Tab(text: LocaleKeys.groupMembers.locale(context)),
                        Tab(text: LocaleKeys.groupImages.locale(context)),
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
                          MembersTab(
                            tabController: tabController,
                            members: members,
                            isAdminEmail: widget.group.adminEmail,
                            onRemoveMember: _removeMember,
                            chatNotifier: chatNotifier,
                            currentUserID: currentUserId ?? '',
                          ),
                          ImagesTab(
                            tabController: tabController,
                            images: images,
                            isLoading: isImagesLoading,
                          ),
                        ],
                      ),
                    ),

                    // Grubu Sil Butonu
                    if (isAdmin) ...[
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: MyButton(
                          height: 50,
                          width: double.infinity,
                          buttonColor: Colors.red,
                          buttonText:
                              LocaleKeys.groupDeleteGroup.locale(context),
                          textStyle: const TextStyle(color: Colors.white),
                          onPressed: _deleteGroup,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ],
                );
        },
      ),
    );
  }
}

// MembersTab widget'ı
// ignore: must_be_immutable
class MembersTab extends StatelessWidget {
  final TabController tabController;
  final List<UserModel> members;
  final String isAdminEmail;
  final Function(UserModel user) onRemoveMember;
  final ChatChangeNotifier chatNotifier;
  final String currentUserID;
  MembersTab({
    super.key,
    required this.tabController,
    required this.members,
    required this.isAdminEmail,
    required this.onRemoveMember,
    required this.chatNotifier,
    required this.currentUserID,
  });
  bool isAdmin = false;
  String createChatId(String userId1, String userId2) {
    List<String> ids = [userId1, userId2];
    ids.sort();
    return "${ids[0]}_${ids[1]}_${DateTime.now().millisecondsSinceEpoch}";
  }

  @override
  Widget build(BuildContext context) {
    double width = UIHelper.getDeviceWith(context);
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: members.length,
      itemBuilder: (context, index) {
        final member = members[index];
        final userData = member.toJson();
        isAdmin = member.email == isAdminEmail;
        return Padding(
          padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
          child: MyProfileCard(
              leading: ProfileInfo(
                  image_path: member.profilePhoto, image_radius: 18),
              tittleText: MyMarquee(
                textToMeasure: member.userName,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(member.userName),
                    if (isAdmin)
                      Text(
                        LocaleKeys.groupAdmin.locale(context),
                        style: TextStyle(
                          color: backgroundColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: backgroundColor,
              ),
              height: 60,
              onLongPress: () => onRemoveMember(member),
              onTap: () async {
                if (member.id == currentUserID) {
                  MySanckbar.mySnackbar(
                      context,
                      LocaleKeys.errorsGroupYouCannotChatWithYourself
                          .locale(context),
                      2);
                  return;
                }
                final String chatId;
                final existingChat = await FirebaseFirestore.instance
                    .collection("chat_rooms")
                    .where("members", arrayContains: member.id)
                    .get();
                final exitingChatDoc = existingChat.docs
                    .where((doc) => (doc.data()['members'] as List)
                        .contains(userData['id']))
                    .firstOrNull;
                if (exitingChatDoc != null) {
                  chatId = exitingChatDoc.id;
                } else {
                  chatId = createChatId(member.id, userData['id']);
                  final SingleChatModel chatModel = SingleChatModel(
                      chatId: chatId, members: [currentUserID, userData['id']]);
                  chatNotifier.createChat(chatModel, chatId);
                }

                Navigator.push(
                  // ignore: use_build_context_synchronously
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatDetailPage(
                            chatId: chatId,
                            receiverId: member.id,
                          )),
                );
              }),
        );
      },
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

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_hr_management/core/firestore_provider.dart';
import 'package:web_hr_management/model/user_model.dart';
import 'package:web_hr_management/screen/dialog_add_user.dart';

class ListUserScreen extends ConsumerStatefulWidget {
  const ListUserScreen({super.key, required this.type});

  final String type;

  @override
  ConsumerState<ListUserScreen> createState() => _ListUserScreenState();
}

class _ListUserScreenState extends ConsumerState<ListUserScreen> {
  String userType = UserModel.TYPE_GIAO_VIEN;

  @override
  void initState() {
    super.initState();
    userType = widget.type;
    final firestore = ref.read(pFireStore);
    firestore.loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    final firestore = ref.watch(pFireStore);
    final users = firestore.users.where((item) {
      return item.type == userType;
    }).toList();
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Column(
        children: [
          PhysicalModel(
            color: Colors.white,
            elevation: 2,
            child: Container(
              padding: const EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 20),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    getListName(),
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: Colors.blueAccent.shade700),
                  ),
                  const Spacer(),
                  Material(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(40),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return DialogAddUser(
                                type: userType,
                              );
                            });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(color: Colors.blueAccent.shade700, width: 2),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Text(
                                'THÊM MỚI',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blueAccent.shade700,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.add,
                              size: 20,
                              color: Colors.blueAccent.shade700,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 32),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 450,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                mainAxisExtent: 150,
              ),
              itemBuilder: (context, index) {
                final curr = users[index];
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: UserGridItem(
                    onClick: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return DialogAddUser(
                              type: userType,
                              model: curr,
                            );
                          });
                    },
                    user: curr,
                  ),
                );
              },
              itemCount: users.length,
            ),
          )),
        ],
      ),
    );
  }

  String getListName() {
    switch (widget.type) {
      case UserModel.TYPE_GIAO_VIEN:
        return 'Danh sách giáo viên';
      case UserModel.TYPE_NHAN_VIEN:
        return 'Danh sách nhân viên';
      case UserModel.TYPE_GIAM_HIEU:
        return 'Danh sách ban giám hiệu';
    }
    return 'Danh sách giáo viên';
  }
}

class UserGridItem extends StatelessWidget {
  const UserGridItem({
    super.key,
    required this.onClick,
    required this.user,
  });

  final VoidCallback onClick;
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 4,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onClick,
          borderRadius: BorderRadius.circular(12),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: UserAvatarWidget(
                  url: user.image ?? '',
                ),
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    user.name ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: Colors.black54,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(
                      user.address ?? '',
                      maxLines: 1,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Colors.black38,
                      ),
                    ),
                  ),
                  Text(
                    user.position ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class UserAvatarWidget extends StatelessWidget {
  const UserAvatarWidget({
    super.key,
    required this.url,
  });

  final String url;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(80),
      child: SizedBox(
        width: 80,
        height: 80,
        child: url.isNotEmpty
            ? ExtendedImage.network(
                url,
                shape: BoxShape.circle,
                fit: BoxFit.cover,
              )
            : Image.asset(
                'assets/images/avatar.png',
                fit: BoxFit.cover,
                width: 80,
                height: 80,
                isAntiAlias: true,
              ),
      ),
    );
  }
}

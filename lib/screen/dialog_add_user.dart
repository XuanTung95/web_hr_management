import 'dart:io';
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:web_hr_management/core/firestore_provider.dart';
import 'package:web_hr_management/core/image_util.dart';
import 'package:web_hr_management/model/user_model.dart';

class DialogAddUser extends ConsumerStatefulWidget {
  const DialogAddUser({
    super.key,
    this.model,
    this.type,
  });

  final UserModel? model;
  final String? type;

  @override
  ConsumerState<DialogAddUser> createState() => _DialogAddUserState();
}

class _DialogAddUserState extends ConsumerState<DialogAddUser> {
  bool isLoading = false;
  UserModel editModel = UserModel();
  Uint8List? avatar;
  XFile? file;
  bool isEdit = false;
  bool isEnableEdit = true;

  @override
  void initState() {
    super.initState();
    if (widget.model != null) {
      isEdit = true;
      isEnableEdit = false;
      editModel = UserModel.fromJson(widget.model!.toJson());
    }
  }

  @override
  Widget build(BuildContext context) {
    final fireStore = ref.watch(pFireStore);
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: SingleChildScrollView(
              child: PhysicalModel(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                elevation: 5,
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Ảnh
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                      width: 150,
                                      height: 200,
                                      child: avatar != null
                                          ? ExtendedImage.memory(
                                              avatar!,
                                              fit: BoxFit.cover,
                                            )
                                          : ((editModel.image?.isNotEmpty ?? false)
                                              ? ExtendedImage.network(
                                                  editModel.image!,
                                                  fit: BoxFit.cover,
                                                )
                                              : Padding(
                                                  padding: const EdgeInsets.all(2.0),
                                                  child: DottedBorder(
                                                    color: Colors.black,
                                                    strokeWidth: 1,
                                                    dashPattern: const <double>[8, 4],
                                                    child: const Center(
                                                      child: Icon(
                                                        Icons.person_pin_outlined,
                                                        size: 40,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ),
                                                ))),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  if (isEnableEdit)
                                    Material(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(8),
                                      child: InkWell(
                                        onTap: () async {
                                          final file = await ImageUtil.pickImage();
                                          if (file != null) {
                                            avatar = await file.readAsBytes();
                                            this.file = file;
                                            setState(() {});
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Colors.blueAccent.shade700, width: 2),
                                          ),
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.photo_library_outlined,
                                                size: 25,
                                                color: Colors.blueAccent.shade700,
                                              ),
                                              const Text(
                                                'Tải ảnh lên',
                                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                ],
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              // Nhập thông tin
                              Container(
                                constraints: const BoxConstraints(maxWidth: 400, minWidth: 100),
                                margin: const EdgeInsets.only(left: 16),
                                child: Column(
                                  children: [
                                    BaseTextInput(
                                      title: 'Họ và tên',
                                      initMessage: editModel.name ?? '',
                                      onChanged: (text) {
                                        editModel.name = text ?? '';
                                      },
                                      enable: isEnableEdit,
                                    ),
                                    BaseTextInput(
                                      title: 'Ngày tháng năm sinh',
                                      key: ValueKey("date ${editModel.birth}"),
                                      initMessage: editModel.birth ?? '',
                                      onChanged: (text) {
                                        // editModel.birth = text ?? '';
                                      },
                                      enable: isEnableEdit,
                                      onClick: () async {
                                        DateTime? selectedDate = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1950),
                                          lastDate: DateTime(2100),
                                        );

                                        if (selectedDate != null) {
                                          editModel.birth = DateFormat('dd/MM/yyyy').format(selectedDate);
                                          setState(() {});
                                        }
                                      },
                                    ),
                                    BaseTextInput(
                                      title: 'Quê quán',
                                      initMessage: editModel.address ?? '',
                                      onChanged: (text) {
                                        editModel.address = text ?? '';
                                      },
                                      enable: isEnableEdit,
                                    ),
                                    BaseTextInput(
                                      title: 'Trình đô đào tạo',
                                      initMessage: editModel.education ?? '',
                                      onChanged: (text) {
                                        editModel.education = text ?? '';
                                      },
                                      enable: isEnableEdit,
                                    ),
                                    BaseTextInput(
                                      title: 'Chức vụ',
                                      initMessage: editModel.position ?? '',
                                      onChanged: (text) {
                                        editModel.position = text ?? '';
                                      },
                                      enable: isEnableEdit,
                                    ),
                                    BaseTextInput(
                                      title: 'Thành tích cao nhất năm học trước',
                                      initMessage: editModel.achievements ?? '',
                                      onChanged: (text) {
                                        editModel.achievements = text ?? '';
                                      },
                                      enable: isEnableEdit,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: isEdit
                                ? [
                                    BaseButton(
                                      onClick: () {
                                        setState(() {
                                          isEnableEdit = !isEnableEdit;
                                        });
                                        if (!isEnableEdit) {
                                          updateUser();
                                        }
                                      },
                                      icon: Icons.edit,
                                      text: isEnableEdit ? 'Lưu thông tin' : 'Chỉnh sửa',
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    BaseButton(
                                      onClick: () async {
                                        final res = await showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text('Xác nhận'),
                                                content: const Text('Bạn có chắc muốn xoá người dùng?'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text('Xác nhận'),
                                                    onPressed: () {
                                                      Navigator.of(context).pop(true);
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: const Text('Đóng'),
                                                    onPressed: () {
                                                      Navigator.of(context).pop(false);
                                                    },
                                                  ),
                                                ],
                                              );
                                            });
                                        if (res == true) {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          final fireStore = ref.read(pFireStore);
                                          await fireStore.deleteUser(editModel);
                                          await fireStore.loadUsers();
                                          setState(() {
                                            isLoading = false;
                                          });
                                          if (mounted) {
                                            Navigator.of(context).pop();
                                          }
                                        }
                                      },
                                      icon: Icons.delete_forever_outlined,
                                      text: 'Xoá',
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    BaseButton(
                                      onClick: () {
                                        Navigator.pop(context);
                                      },
                                      icon: Icons.close,
                                      text: 'Đóng',
                                    ),
                                  ]
                                : [
                                    BaseButton(
                                      onClick: () async {
                                        updateUser();
                                      },
                                      icon: Icons.add,
                                      text: 'Thêm mới',
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    BaseButton(
                                      onClick: () {
                                        Navigator.pop(context);
                                      },
                                      icon: Icons.close,
                                      text: 'Đóng',
                                    ),
                                  ],
                          ),
                        ],
                      ),
                    ),
                    if (isLoading)
                      const Positioned.fill(
                          child: Center(
                        child: CircularProgressIndicator(),
                      ))
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future updateUser() async {
    final fireStore = ref.read(pFireStore);
    setState(() {
      isLoading = true;
    });
    if (avatar != null) {
      final url = await fireStore.uploadImage(avatar!, file!.name);
      editModel.image = url;
    }
    editModel.type ??= widget.type;
    await fireStore.updateUser(editModel);
    await fireStore.loadUsers();
    setState(() {
      isLoading = false;
    });
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Cập nhật thành công'),
            content: const Text('Thông tin đã được cập nhật thành công.'),
            actions: <Widget>[
              TextButton(
                child: const Text('Đóng'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
    if (widget.model == null && context.mounted) {
      Navigator.of(context).pop();
    }
  }
}

class BaseButton extends StatelessWidget {
  const BaseButton({super.key, required this.onClick, required this.icon, required this.text});

  final VoidCallback onClick;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: onClick,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          constraints: const BoxConstraints(
            minWidth: 150,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.blueAccent.shade700, width: 2),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 25,
                color: Colors.blueAccent.shade700,
              ),
              Text(
                text,
                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class BaseTextInput extends StatefulWidget {
  const BaseTextInput({super.key, required this.title, required this.initMessage, this.onChanged, this.enable = true, this.onClick});

  final String title;
  final String initMessage;
  final ValueChanged<String>? onChanged;
  final bool enable;
  final VoidCallback? onClick;

  @override
  State<BaseTextInput> createState() => _BaseTextInputState();
}

class _BaseTextInputState extends State<BaseTextInput> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = widget.initMessage;
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8, top: 10),
          child: Text(
            widget.title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black.withOpacity(0.9),
            ),
          ),
        ),
        TextField(
          controller: controller,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
          enabled: widget.onClick != null ? true : widget.enable,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            hintText: widget.title,
            // Tạo border cho TextField
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade300,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.blue, // Màu của border khi focused
                width: 2.0, // Độ rộng của border khi focused
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            // Tạo border khi TextField không được chọn (unfocused)
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.grey,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ],
    );
    if (widget.onClick != null) {
      return GestureDetector(
        onTap: widget.onClick!,
        behavior: HitTestBehavior.opaque,
        child: IgnorePointer(ignoring: true, child: child),
      );
    }
    return child;
  }
}

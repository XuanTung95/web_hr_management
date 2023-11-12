import 'package:flutter/material.dart';
import 'package:web_hr_management/core/app_colors.dart';
import 'package:web_hr_management/model/user_model.dart';
import 'package:web_hr_management/screen/list_user_screen.dart';

class SelectionScreen extends StatefulWidget {
  const SelectionScreen({super.key});

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Center(
        child: Column(
          children: [
            Container(
              height: 100,
              decoration: const BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(blurRadius: 0.5, spreadRadius: 0),
              ]),
              alignment: Alignment.center,
              child: const Text(
                'Phần mềm quản lý giáo viên, công nhân viên trường tiểu học Phù Linh- Sóc Sơn – Hà Nội.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                  fontSize: 18,
                ),
              ),
            ),
            Flexible(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  constraints: const BoxConstraints(
                    maxWidth: 500,
                  ),
                  margin: const EdgeInsets.only(top: 60),
                  child: PhysicalModel(
                    borderRadius: BorderRadius.circular(8),
                    elevation: 2,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SelectButton(
                            text: 'Danh sách giáo viên',
                            onClick: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return const ListUserScreen(
                                  type: UserModel.TYPE_GIAO_VIEN,
                                );
                              }));
                            },
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          SelectButton(
                            text: 'Danh sách nhân viên',
                            onClick: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return const ListUserScreen(
                                  type: UserModel.TYPE_NHAN_VIEN,
                                );
                              }));
                            },
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          SelectButton(
                            text: 'Danh sách ban giám hiệu',
                            onClick: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return const ListUserScreen(
                                  type: UserModel.TYPE_GIAM_HIEU,
                                );
                              }));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}

class SelectButton extends StatelessWidget {
  const SelectButton({super.key, required this.text, required this.onClick});

  final String text;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      color: Colors.white,
      elevation: 4,
      borderRadius: BorderRadius.circular(8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onClick,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 100,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Icon(
                  Icons.list_alt_rounded,
                  size: 50,
                ),
                const SizedBox(
                  width: 16,
                ),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

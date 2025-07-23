import 'package:applus_market/data/model_view/user/my_info_vm.dart';
import 'package:applus_market/ui/pages/my/widgets/profile_image_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../_core/utils/logger.dart';
import '../../../../data/model/auth/user.dart';
import 'custom_info_textField.dart';

class MyInfoBody extends ConsumerStatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController nicknameController;
  final TextEditingController birthDateController;
  final TextEditingController phoneNumberController;
  final TextEditingController emailController;
  MyInfoBody(
      {required this.formKey,
      required this.nameController,
      required this.birthDateController,
      required this.emailController,
      required this.nicknameController,
      required this.phoneNumberController,
      super.key});

  @override
  ConsumerState<MyInfoBody> createState() => _MyInfoBodyState();
}

class _MyInfoBodyState extends ConsumerState<MyInfoBody> {
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _fetchUserInfo(); // ✅ 사용자 정보 가져오기
  }

  Future<void> _fetchUserInfo() async {
    setState(() {
      isLoading = true; // 로딩 시작
    });

    try {
      await ref.read(myInfoProvider.notifier).getMyInfo();
      setState(() {
        isLoading = false; // 로딩 완료
      });
    } catch (e) {
      setState(() {
        isLoading = false; // 에러 발생 시에도 로딩 종료
      });
      // 에러 처리 (예: AlertDialog 표시)
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('에러'),
          content: const Text('사용자 정보를 가져오는 중 에러가 발생했습니다.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('확인'),
            ),
          ],
        ),
      );
    }
  }

  String _formattedDate(DateTime picked) {
    String formattedDate =
        "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";

    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    MyInfoVM myInfoVM = ref.read(myInfoProvider.notifier);
    User user = ref.watch(myInfoProvider)!;
    widget.nameController.text = user?.name ?? '';
    widget.birthDateController.text =
        user?.birthday != null ? _formattedDate(user!.birthday!) : '';
    widget.emailController.text = user?.email ?? '';
    widget.nicknameController.text = user?.nickName ?? '';
    widget.phoneNumberController.text = user?.hp ?? '';

    return (isLoading)
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Form(
            key: widget.formKey,
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                Center(
                  child: ProfileImageContainer(
                    width: 100,
                    height: 100,
                  ),
                ),
                SizedBox(height: 24),
                CustomInfoTextfield(
                    label: '이름',
                    controller: widget.nameController,
                    onChanged: (value) {}
                    //ref.read(userProfileProvider.notifier).updateName(value),
                    ,
                    readOnly: true),
                SizedBox(height: 16),
                CustomInfoTextfield(
                    label: '닉네임',
                    controller: widget.nicknameController,
                    onChanged: (value) {
                      logger.i(value);
                      myInfoVM.updateNickName(value);
                    }),
                SizedBox(height: 16),
                CustomInfoTextfield(
                    label: '생년월일',
                    controller: widget.birthDateController,
                    readOnly: true,
                    onChanged: (value) {}
                    // _selectDate(context),
                    ),
                SizedBox(height: 16),
                CustomInfoTextfield(
                  label: '휴대폰 번호',
                  controller: widget.phoneNumberController,
                  onChanged: (value) {
                    myInfoVM.updateHp(value);
                  },
                  //  ref.read(userProfileProvider.notifier).updatePhoneNumber(value),
                ),
                SizedBox(height: 16),
                CustomInfoTextfield(
                  label: '이메일', controller: widget.emailController,
                  onChanged: (value) {
                    myInfoVM.updateEmail(value);
                  },
                  //      ref.read(userProfileProvider.notifier).updateEmail(value),
                ),
              ],
            ),
          );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      String formattedDate = _formattedDate(picked);
      widget.birthDateController.text = formattedDate;
      //  ref.read(userProfileProvider.notifier).updateBirthDate(formattedDate);
    }
  }
}

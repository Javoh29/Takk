import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:takk/config/constants/app_colors.dart';
import 'package:takk/config/constants/app_text_styles.dart';
import 'package:takk/data/models/user_model.dart';

import '../../../widgets/cache_image.dart';

class EditProfileSheet extends StatefulWidget {
  const EditProfileSheet(this.model);

  final UserModel model;

  @override
  _EditProfileSheetState createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<EditProfileSheet> {
  final String tag = 'EditProfileSheet';
  TextEditingController controller = TextEditingController();
  DateTime? _selectDate;
  File? _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    print('getImage');

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    controller.text = widget.model.username ?? 'Name';
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _showDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900, 8),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != DateTime.now())
      setState(() {
        _selectDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.scaffoldColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: ButtonStyle(
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent)),
                    child: Text(
                      'Cancel',
                      style: AppTextStyles.body16w5
                          .copyWith(color: AppColors.textColor.shade2),
                    )),
                TextButton(
                  onPressed: () {
                    // Future.delayed(Duration.zero, () async {
                    //   showLoadingDialog(context);
                    //   context
                    //       .read<UserProvider>()
                    //       .setUserData(tag,
                    //           name: _controller.text,
                    //           date: _selectDate != null
                    //               ? DateFormat('yyyy-MM-dd')
                    //                   .format(_selectDate!)
                    //               : widget.model.dateOfBirthday!,
                    //           imgPath: _image != null ? _image!.path : null)
                    //       .then((value) {
                    //     Navigator.pop(context);
                    //     if (context.read<UserProvider>().getState(tag) ==
                    //         'success') {
                    //       Navigator.pop(context, true);
                    //     } else
                    //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    //         content: Text(value),
                    //         backgroundColor: Colors.redAccent,
                    //       ));
                    //   });
                    // });
                  },
                  style: ButtonStyle(
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent)),
                  child: Text(
                    'Save',
                    style: AppTextStyles.body16w5
                        .copyWith(color: AppColors.textColor.shade2),
                  ),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: getImage,
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 5)
                  ]),
              child: Stack(
                children: [
                  _image == null
                      ? CacheImage(widget.model.avatar ?? '',
                          fit: BoxFit.cover,
                          height: 100,
                          width: 100,
                          borderRadius: 50,
                          placeholder: Image.asset(
                            'assets/icons/ic_user.png',
                            fit: BoxFit.cover,
                            height: 100,
                            width: 100,
                          ),)
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.file(
                            _image!,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                  Container(
                    height: 100,
                    width: 100,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(50)),
                    child: const Icon(
                      Ionicons.camera_outline,
                      size: 30,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            height: 55,
            width: double.infinity,
            margin:
                const EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 5),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Color(0xffF4F4F4), blurRadius: 5)
                ]),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    'Phone number:',
                    style: AppTextStyles.body16w5
                        .copyWith(color: AppColors.textColor.shade2),
                  ),
                ),
                Text(
                  widget.model.phone ?? '',
                  style: AppTextStyles.body16w5,
                )
              ],
            ),
          ),
          Container(
            height: 55,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Color(0xffF4F4F4), blurRadius: 5)
                ],),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    'Name:',
                    style: AppTextStyles.body16w5
                        .copyWith(color: AppColors.textColor.shade2),
                  ),
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      suffixIcon: Icon(
                        Icons.edit,
                        size: 20,
                        color: AppColors.textColor.shade2,
                      ),
                    ),
                    controller: controller,
                    textAlignVertical: TextAlignVertical.center,
                    style: AppTextStyles.body16w5,
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 55,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Color(0xffF4F4F4), blurRadius: 5)
                ]),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    'Birth date:',
                    style: AppTextStyles.body16w5
                        .copyWith(color: AppColors.textColor.shade2),
                  ),
                ),
                IconButton(
                    splashRadius: 25,
                    onPressed: () {
                      if (Platform.isIOS || Platform.isMacOS) {
                        showCupertinoDialog(
                            context: context,
                            builder: (context) => CupertinoAlertDialog(
                                  title: const Text('Info'),
                                  content: const Text(
                                      'You will get a free drink on your birthday, which can be redeemed at one of the participating coffeeshops'),
                                  actions: [
                                    CupertinoButton(
                                        child: Text(
                                          'OK',
                                          style: AppTextStyles.head15w4,
                                        ),
                                        onPressed: () => Navigator.pop(context))
                                  ],
                                ));
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: const Text('Info'),
                                  content: const Text(
                                      'You will get a free drink on your birthday, which can be redeemed at one of the participating coffeeshops'),
                                  actions: [
                                    TextButton(
                                        child: Text(
                                          'OK',
                                          style: AppTextStyles.head15w4,
                                        ),
                                        onPressed: () => Navigator.pop(context))
                                  ],
                                ));
                      }
                    },
                    icon: Icon(
                      Ionicons.information_circle,
                      size: 20,
                      color: AppColors.textColor.shade2,
                    )),
                Expanded(
                  child: Text(
                    widget.model.dateOfBirthday != null
                        ? widget.model.dateOfBirthday!
                        : _selectDate == null
                            ? 'Select'
                            : DateFormat.yMMMd().format(_selectDate!),
                    style: AppTextStyles.body16w5,
                  ),
                ),
                IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onPressed: () => _showDate(),
                    icon: Icon(
                      Ionicons.chevron_down_outline,
                      color: AppColors.textColor.shade2,
                      size: 20,
                    ))
              ],
            ),
          ),
          Container(
            height: 55,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Color(0xffF4F4F4), blurRadius: 5)
                ]),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    'Email:',
                    style: AppTextStyles.body16w5
                        .copyWith(color: AppColors.textColor.shade2),
                  ),
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      suffixIcon: Icon(
                        Icons.edit,
                        size: 20,
                        color: AppColors.textColor.shade2,
                      ),
                    ),
                    // controller: _controller,
                    textAlignVertical: TextAlignVertical.center,
                    style: AppTextStyles.body16w5,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

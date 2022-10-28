import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:jbaza/jbaza.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../core/di/app_locator.dart';
import '../../../../domain/repositories/user_repository.dart';
import '../../../widgets/edit_profile_sheet.dart';
import '../../../widgets/loading_dialog.dart';

class SettingPageViewModel extends BaseViewModel {
  SettingPageViewModel({required super.context});

  var userModel = locator<UserRepository>().userModel;
  final picker = ImagePicker();
  DateTime? selectDate;
  File? image;
  Future? dialog;

  // Edit profile save button is pressed
  setUserData(
    String tag,
    String name,
  ) {
    safeBlock(() {
      Future.delayed(Duration.zero, () async {
        locator<UserRepository>()
            .setUserData(
                name: name,
                date: selectDate != null
                    ? DateFormat('yyyy-MM-dd').format(selectDate!)
                    : userModel!.dateOfBirthday!,
                imgPath: image != null ? image!.path : null)
            .then((value) {
          setSuccess(tag: tag);
          pop();
        });
      });
    }, callFuncName: '', tag: tag);
  }

  Future editProfile() async {
    showCupertinoModalBottomSheet(
      context: context!,
      expand: true,
      builder: (context) => EditProfileSheet(),
    ).then((value) {
      if (value is bool) {
        notifyListeners();
      }
    });
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = File(pickedFile.path);
    } else {
      debugPrint('No image selected.');
    }
    notifyListeners();
  }

  Future<void> showDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: userModel!.dateOfBirthday!.isNotEmpty && selectDate == null
          ? DateTime.parse(userModel!.dateOfBirthday!)
          : selectDate != null
              ? selectDate!
              : DateTime.now(),
      firstDate: DateTime(1900, 8),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != DateTime.now()) {
      selectDate = picked;
      notifyListeners();
    }
  }

  @override
  callBackBusy(bool value, String? tag) {
    if (isBusy(tag: tag)) {
      Future.delayed(Duration.zero, () {
        dialog = showLoadingDialog(context!);
      });
    } else {
      if (dialog != null) {
        pop();
        dialog = null;
      }
    }
  }

  @override
  callBackSuccess(value, String? tag) {
    if (dialog != null) {
      pop();
      dialog = null;
    }
  }

  @override
  callBackError(String text) {
    if (dialog != null) pop();
    showTopSnackBar(
      context!,
      CustomSnackBar.error(
        message: text,
      ),
    );
  }
}

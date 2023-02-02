import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:jbaza/jbaza.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:takk/config/constants/hive_box_names.dart';
import 'package:takk/core/services/custom_client.dart';
import 'package:takk/data/models/user_model.dart';
import 'package:takk/presentation/routes/routes.dart';
import 'package:timezone/timezone.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../core/di/app_locator.dart';
import '../../../../data/models/token_model.dart';
import '../../../../data/viewmodel/local_viewmodel.dart';
import '../../../../domain/repositories/user_repository.dart';
import '../../../widgets/edit_profile_sheet.dart';
import '../../../widgets/loading_dialog.dart';

class SettingPageViewModel extends BaseViewModel {
  SettingPageViewModel({required super.context, required this.userModel});

  UserModel? userModel;
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
        userModel = await locator<UserRepository>().setUserData(
            name: name,
            date: selectDate != null ? DateFormat('yyyy-MM-dd').format(selectDate!) : userModel!.dateOfBirthday!,
            imgPath: image != null ? image!.path : null);
        setSuccess(tag: tag);
        pop();
      });
    }, callFuncName: 'setUserData', tag: tag);
  }

  Future changeCashier(bool? value) async {
    locator<LocalViewModel>().isCashier = value ?? !locator<LocalViewModel>().isCashier;
    notifyListeners();
  }

  Future editProfile() async {
    showCupertinoModalBottomSheet(
      context: context!,
      expand: true,
      builder: (context) => EditProfileSheet(mViewModel: this),
    );
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
    if (dialog == null && isBusy(tag: tag)) {
      Future.delayed(Duration.zero, () {
        dialog = showLoadingDialog(context!);
      });
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
    Future.delayed(Duration.zero, () {
      if (dialog != null) pop();
    });
    showTopSnackBar(
      context!,
      CustomSnackBar.error(
        message: text,
      ),
    );
  }

  logOut() async {
    await safeBlock(() async {
      final result = await locator<UserRepository>().deleteDeviceInfo();
      if (result) {
        await deleteBox<TokenModel>(BoxNames.tokenBox);
        locator<UserRepository>().userModel = null;
        locator<CustomClient>().tokenModel = null;
        navigateTo(Routes.authPage, isRemoveStack: true);
      }
    });
  }
}

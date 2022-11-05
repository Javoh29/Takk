import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/presentation/routes/routes.dart';
import 'package:takk/presentation/widgets/loading_dialog.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../domain/repositories/user_repository.dart';

class CreateUserViewModel extends BaseViewModel {
  CreateUserViewModel({required super.context, required this.createUserRepository});

  final UserRepository createUserRepository;
  final String tag = 'CreateUserViewModel';

  File? image;
  final picker = ImagePicker();
  DateTime? selectDate;
  String name = '';
  Future? dialog;

  Future<void> setUserDate() async {
    if (name.isNotEmpty && selectDate != null) {
      safeBlock(() async {
        await createUserRepository.setUserData(
            name: name,
            date: DateFormat('yyyy-MM-dd').format(selectDate!),
            imgPath: image != null ? image!.path : null);
        if (dialog != null) pop();
        navigateTo(Routes.homePage, isRemoveStack: true);
      }, callFuncName: "setUserDate");
    } else if (name.isEmpty) {
      callBackError("Please enter your name!");
    } else if (selectDate == null) {
      callBackError("Please enter your birth date!");
    }
  }

  Future<void> showDate() async {
    final DateTime? picked = await showDatePicker(
      context: context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900, 8),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != DateTime.now()) {
      selectDate = picked;
    }
    notifyListeners();
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
    if (dialog != null) pop();
    showTopSnackBar(
      context!,
      CustomSnackBar.error(
        message: text,
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/domain/repositories/create_user_repository.dart';
import 'package:takk/presentation/routes/routes.dart';
import 'package:takk/presentation/widgets/loading_dialog.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class CreateUserViewModel extends BaseViewModel {
  CreateUserViewModel(
      {required super.context, required this.createUserRepository});

  final CreateUserRepository createUserRepository;
  final String tag = 'CreateUserViewModel';

  File? image;
  final picker = ImagePicker();
  DateTime? selectDate;
  String name = '';

  Future<void> setUserDate() async {
    if (name.isNotEmpty && selectDate != null) {
      showLoadingDialog(context!);
      safeBlock(() async {
        await locator<CreateUserRepository>()
            .setUserData(
                name: name,
                date: DateFormat('yyyy-MM-dd').format(selectDate!),
                imgPath: image != null ? image!.path : null)
            .then((value) {
          pop();
          if (value == 'success') {
            navigateTo(Routes.homePage, isRemoveStack: true);
          } else {
            ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
              content: Text(value),
              backgroundColor: Colors.redAccent,
            ));
          }
        });
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
      print('No image selected.');
    }
    notifyListeners();
  }

  @override
  callBackError(String text) {
    showTopSnackBar(
      context!,
      CustomSnackBar.error(
        message: Text(text),
      ),
    );
  }
}

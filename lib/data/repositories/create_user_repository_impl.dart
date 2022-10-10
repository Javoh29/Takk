import 'dart:convert';

import 'package:http/http.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/core/domain/detail_parse.dart';
import 'package:takk/data/viewmodel/local_viewmodel.dart';
import 'package:takk/domain/repositories/create_user_repository.dart';
import 'package:http_parser/http_parser.dart';

import '../../config/constants/urls.dart';
import '../../core/di/app_locator.dart';
import '../../core/services/custom_client.dart';
import '../models/user_model.dart';

class CreateUserRepositoryImpl extends CreateUserRepository {
  @override
  Future<String> setUserData(
      {required String name, required String date, String? imgPath}) async {
    // setState(tag, 'send');
    var request = MultipartRequest("PUT", Url.getUser);
    request.fields['username'] = name;
    request.fields['date_of_birthday'] = date;
    request.headers['Authorization'] =
        'JWT ${locator<CustomClient>().tokenModel!.access}';
    if (imgPath != null) {
      request.files.add(await MultipartFile.fromPath('avatar', imgPath,
          contentType: MediaType('image', 'jpeg')));
    }
    var ans = await request.send();
    final response = await Response.fromStream(ans);
    if (response.statusCode == 200 || response.statusCode == 201) {
      locator<LocalViewModel>().userModel =
          UserModel.fromJson(jsonDecode(response.body));
      // setState(tag, 'success');
      return 'success';
    }
    throw VMException(response.body.parseError(),
        callFuncName: 'setUserData', response: response);
  }
}

abstract class CreateUserRepository {
  Future<String> setUserData(
      {required String name, required String date, String? imgPath});
}

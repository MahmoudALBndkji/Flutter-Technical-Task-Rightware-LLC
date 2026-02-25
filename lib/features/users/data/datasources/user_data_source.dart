import 'package:flutter_technical_task_rightware_llc/features/users/data/models/user_model.dart';

abstract class UserDataSource {
  Future<List<DataModel>> getAllUsers(int pageId);
  Future<DataModel> getUserDetails(int userId);
}

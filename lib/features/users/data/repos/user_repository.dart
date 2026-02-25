import 'package:flutter_technical_task_rightware_llc/core/utils/typedef.dart';
import 'package:flutter_technical_task_rightware_llc/features/users/data/datasources/user_data_source.dart';
import 'package:flutter_technical_task_rightware_llc/features/users/data/models/user_model.dart';

class UserRepository  {
  final UserDataSource _datasource;
  const UserRepository(this._datasource);

  FutureResult<List<DataModel>> getAllUsers(int pageId) async {
    final result = await _datasource.getAllUsers(pageId);
    return result;
  }

  FutureResult<DataModel> getUserDetails(int userId) async {
    final result = await _datasource.getUserDetails(userId);
    return result;
  }
}

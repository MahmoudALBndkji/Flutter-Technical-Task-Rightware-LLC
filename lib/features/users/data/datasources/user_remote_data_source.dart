import 'dart:convert';
import 'package:flutter_technical_task_rightware_llc/core/services/api/api_consumer.dart';
import 'package:flutter_technical_task_rightware_llc/core/services/api/end_points.dart';
import 'package:flutter_technical_task_rightware_llc/core/utils/typedef.dart';
import 'package:flutter_technical_task_rightware_llc/features/users/data/datasources/user_data_source.dart';
import 'package:flutter_technical_task_rightware_llc/features/users/data/models/user_model.dart';

class UserRemoteDataSource implements UserDataSource {
  final ApiConsumer _apiService;
  const UserRemoteDataSource(this._apiService);

  @override
  Future<List<DataModel>> getAllUsers(int pageId) async {
    final response = await _apiService.get("${EndPoints.users}?page=$pageId");
    final responseBody = response.data;
    final responseObjs = jsonDecode(responseBody)['data'] as List<dynamic>;
    final result = responseObjs
        .map((obj) => DataModel.fromJson(obj as DataMap))
        .toList();
    return result;
  }

  @override
  Future<DataModel> getUserDetails(int userId) async {
    final response = await _apiService.get("${EndPoints.userDetails}/$userId");
    final responseBody = response.data;
    final responseObj = jsonDecode(responseBody) as Map<String, dynamic>;
    final result = DataModel.fromJson(responseObj);
    return result;
  }
}

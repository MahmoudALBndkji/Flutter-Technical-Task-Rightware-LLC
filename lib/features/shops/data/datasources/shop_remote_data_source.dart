import 'dart:convert';
import 'package:flutter_technical_task_rightware_llc/core/env/init_env.dart';
import 'package:flutter_technical_task_rightware_llc/core/services/api/api_consumer.dart';
import 'package:flutter_technical_task_rightware_llc/core/services/api/end_points.dart';
import 'package:flutter_technical_task_rightware_llc/features/shops/data/datasources/shop_data_source.dart';
import 'package:flutter_technical_task_rightware_llc/features/shops/data/models/shop_model.dart';

class ShopRemoteDataSource implements ShopDataSource {
  final ApiConsumer _apiConsumer;
  const ShopRemoteDataSource(this._apiConsumer);

  @override
  Future<List<ShopModel>> getAllShops() async {
    final response = await _apiConsumer.get(
      EndPoints.getAllShops,
      queryParameters: {'deviceKind': env.deviceKind},
      headers: {'secretKey': env.secretKey},
    );
    final body = response.data;
    final decoded = body is String ? jsonDecode(body) : body;
    final list = _extractItemsList(decoded);
    return list
        .map((e) => ShopModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static List<dynamic> _extractItemsList(dynamic decoded) {
    if (decoded is List) return decoded;
    if (decoded is! Map) return <dynamic>[];
    final map = decoded as Map<String, dynamic>;
    final result = map['result'];
    if (result is List) return result;
    return <dynamic>[];
  }
}

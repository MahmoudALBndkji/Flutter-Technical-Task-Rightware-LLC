import 'package:flutter_technical_task_rightware_llc/core/utils/typedef.dart';
import 'package:flutter_technical_task_rightware_llc/features/shops/data/datasources/shop_data_source.dart';
import 'package:flutter_technical_task_rightware_llc/features/shops/data/models/shop_model.dart';

class ShopRepository {
  final ShopDataSource _dataSource;
  const ShopRepository(this._dataSource);

  FutureResult<List<ShopModel>> getAllShops() async {
    final result = await _dataSource.getAllShops();
    return result;
  }
}

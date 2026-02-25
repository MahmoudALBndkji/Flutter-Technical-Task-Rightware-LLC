import 'package:flutter_technical_task_rightware_llc/features/shops/data/models/shop_model.dart';

abstract class ShopDataSource {
  Future<List<ShopModel>> getAllShops();
}

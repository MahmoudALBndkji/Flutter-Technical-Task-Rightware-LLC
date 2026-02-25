// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShopModel _$ShopModelFromJson(Map<String, dynamic> json) => ShopModel(
  id: json['_id'] as String?,
  shopName: json['shopName'] == null
      ? null
      : LocalizedText.fromJson(json['shopName'] as Map<String, dynamic>),
  description: json['description'] == null
      ? null
      : LocalizedText.fromJson(json['description'] as Map<String, dynamic>),
  minimumOrder: json['minimumOrder'] == null
      ? null
      : MinimumOrder.fromJson(json['minimumOrder'] as Map<String, dynamic>),
  address: json['address'] == null
      ? null
      : ShopAddress.fromJson(json['address'] as Map<String, dynamic>),
  estimatedDeliveryTime: json['estimatedDeliveryTime'] as String?,
  coverPhoto: json['coverPhoto'] as String?,
  profilePhoto: json['profilePhoto'] as String?,
  availability: json['availability'] as bool?,
  categoryType: json['categoryType'] as String?,
  ownerFullName: json['ownerFullName'] as String?,
  enable: json['enable'] as bool?,
  badgeTag: json['badgeTag'] as String?,
);

Map<String, dynamic> _$ShopModelToJson(ShopModel instance) => <String, dynamic>{
  '_id': instance.id,
  'shopName': instance.shopName?.toJson(),
  'description': instance.description?.toJson(),
  'minimumOrder': instance.minimumOrder?.toJson(),
  'address': instance.address?.toJson(),
  'estimatedDeliveryTime': instance.estimatedDeliveryTime,
  'coverPhoto': instance.coverPhoto,
  'profilePhoto': instance.profilePhoto,
  'availability': instance.availability,
  'categoryType': instance.categoryType,
  'ownerFullName': instance.ownerFullName,
  'enable': instance.enable,
  'badgeTag': instance.badgeTag,
};

LocalizedText _$LocalizedTextFromJson(Map<String, dynamic> json) =>
    LocalizedText(en: json['en'] as String?, ar: json['ar'] as String?);

Map<String, dynamic> _$LocalizedTextToJson(LocalizedText instance) =>
    <String, dynamic>{'en': instance.en, 'ar': instance.ar};

MinimumOrder _$MinimumOrderFromJson(Map<String, dynamic> json) => MinimumOrder(
  amount: json['amount'] as num?,
  currency: json['currency'] as String?,
);

Map<String, dynamic> _$MinimumOrderToJson(MinimumOrder instance) =>
    <String, dynamic>{'amount': instance.amount, 'currency': instance.currency};

ShopAddress _$ShopAddressFromJson(Map<String, dynamic> json) => ShopAddress(
  city: json['city'] as String?,
  country: json['country'] as String?,
  otherDetails: json['otherDetails'] as String?,
  state: json['state'] as String?,
  street: json['street'] as String?,
);

Map<String, dynamic> _$ShopAddressToJson(ShopAddress instance) =>
    <String, dynamic>{
      'city': instance.city,
      'country': instance.country,
      'otherDetails': instance.otherDetails,
      'state': instance.state,
      'street': instance.street,
    };

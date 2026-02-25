import 'package:json_annotation/json_annotation.dart';

part 'shop_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ShopModel {
  @JsonKey(name: '_id')
  final String? id;

  @JsonKey(name: 'shopName')
  final LocalizedText? shopName;

  @JsonKey(name: 'description')
  final LocalizedText? description;

  @JsonKey(name: 'minimumOrder')
  final MinimumOrder? minimumOrder;

  @JsonKey(name: 'address')
  final ShopAddress? address;

  @JsonKey(name: 'estimatedDeliveryTime')
  final String? estimatedDeliveryTime;

  @JsonKey(name: 'coverPhoto')
  final String? coverPhoto;

  @JsonKey(name: 'profilePhoto')
  final String? profilePhoto;

  @JsonKey(name: 'availability')
  final bool? availability;

  @JsonKey(name: 'categoryType')
  final String? categoryType;

  @JsonKey(name: 'ownerFullName')
  final String? ownerFullName;

  @JsonKey(name: 'enable')
  final bool? enable;

  @JsonKey(name: 'badgeTag')
  final String? badgeTag;

  const ShopModel({
    this.id,
    this.shopName,
    this.description,
    this.minimumOrder,
    this.address,
    this.estimatedDeliveryTime,
    this.coverPhoto,
    this.profilePhoto,
    this.availability,
    this.categoryType,
    this.ownerFullName,
    this.enable,
    this.badgeTag,
  });

  factory ShopModel.fromJson(Map<String, dynamic> json) =>
      _$ShopModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShopModelToJson(this);

  /// Display name (prefer en, fallback to ar).
  String get name => shopName?.en ?? shopName?.ar ?? '—';

  /// Display description (prefer en, fallback to ar).
  String get descriptionText =>
      description?.en ?? description?.ar ?? '';

  /// Minimum order amount for display and sort (num).
  num? get minimumOrderAmount => minimumOrder?.amount;

  /// Formatted location from address.
  String get location {
    final a = address;
    if (a == null) return '';
    final parts = [
      if (a.street?.isNotEmpty == true) a.street,
      if (a.city?.isNotEmpty == true) a.city,
      if (a.state?.isNotEmpty == true) a.state,
      if (a.country?.isNotEmpty == true) a.country,
    ];
    return parts.join(', ');
  }

  /// Open/closed from availability.
  bool get isOpen => availability == true;

  /// ETA in minutes for sorting (parsed from "30 minutes" etc.).
  int? get estimatedDeliveryTimeMinutes => _parseEtaMinutes(estimatedDeliveryTime);

  /// ETA as display string (use API value or formatted).
  String get estimatedDeliveryTimeDisplay =>
      estimatedDeliveryTime?.trim().isNotEmpty == true
          ? estimatedDeliveryTime!
          : '—';

  static int? _parseEtaMinutes(String? value) {
    if (value == null || value.isEmpty) return null;
    final match = RegExp(r'(\d+)').firstMatch(value);
    if (match == null) return null;
    final n = int.tryParse(match.group(1)!);
    if (n == null) return null;
    if (value.toLowerCase().contains('hour') || value.toLowerCase().contains('h')) {
      return n * 60;
    }
    return n;
  }

  ShopModel copyWith({
    String? id,
    LocalizedText? shopName,
    LocalizedText? description,
    MinimumOrder? minimumOrder,
    ShopAddress? address,
    String? estimatedDeliveryTime,
    String? coverPhoto,
    String? profilePhoto,
    bool? availability,
    String? categoryType,
    String? ownerFullName,
    bool? enable,
    String? badgeTag,
  }) {
    return ShopModel(
      id: id ?? this.id,
      shopName: shopName ?? this.shopName,
      description: description ?? this.description,
      minimumOrder: minimumOrder ?? this.minimumOrder,
      address: address ?? this.address,
      estimatedDeliveryTime:
          estimatedDeliveryTime ?? this.estimatedDeliveryTime,
      coverPhoto: coverPhoto ?? this.coverPhoto,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      availability: availability ?? this.availability,
      categoryType: categoryType ?? this.categoryType,
      ownerFullName: ownerFullName ?? this.ownerFullName,
      enable: enable ?? this.enable,
      badgeTag: badgeTag ?? this.badgeTag,
    );
  }
}

@JsonSerializable()
class LocalizedText {
  final String? en;
  final String? ar;

  const LocalizedText({this.en, this.ar});

  factory LocalizedText.fromJson(Map<String, dynamic> json) =>
      _$LocalizedTextFromJson(json);

  Map<String, dynamic> toJson() => _$LocalizedTextToJson(this);
}

@JsonSerializable()
class MinimumOrder {
  final num? amount;
  final String? currency;

  const MinimumOrder({this.amount, this.currency});

  factory MinimumOrder.fromJson(Map<String, dynamic> json) =>
      _$MinimumOrderFromJson(json);

  Map<String, dynamic> toJson() => _$MinimumOrderToJson(this);
}

@JsonSerializable()
class ShopAddress {
  final String? city;
  final String? country;
  final String? otherDetails;
  final String? state;
  final String? street;

  const ShopAddress({
    this.city,
    this.country,
    this.otherDetails,
    this.state,
    this.street,
  });

  factory ShopAddress.fromJson(Map<String, dynamic> json) =>
      _$ShopAddressFromJson(json);

  Map<String, dynamic> toJson() => _$ShopAddressToJson(this);
}

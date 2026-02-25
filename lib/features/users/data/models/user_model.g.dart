// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => DataModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  pagination: json['pagination'] == null
      ? null
      : PaginationModel.fromJson(json['pagination'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'data': instance.data?.map((e) => e.toJson()).toList(),
  'pagination': instance.pagination?.toJson(),
};

DataModel _$DataModelFromJson(Map<String, dynamic> json) => DataModel(
  id: (json['id'] as num?)?.toInt(),
  email: json['email'] as String?,
  username: json['username'] as String?,
  name: json['name'] == null
      ? null
      : NameModel.fromJson(json['name'] as Map<String, dynamic>),
  address: json['address'] == null
      ? null
      : AddressModel.fromJson(json['address'] as Map<String, dynamic>),
  phone: json['phone'] as String?,
  orders: (json['orders'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
);

Map<String, dynamic> _$DataModelToJson(DataModel instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'username': instance.username,
  'name': instance.name?.toJson(),
  'address': instance.address?.toJson(),
  'phone': instance.phone,
  'orders': instance.orders,
};

NameModel _$NameModelFromJson(Map<String, dynamic> json) => NameModel(
  firstname: json['firstname'] as String?,
  lastname: json['lastname'] as String?,
);

Map<String, dynamic> _$NameModelToJson(NameModel instance) => <String, dynamic>{
  'firstname': instance.firstname,
  'lastname': instance.lastname,
};

AddressModel _$AddressModelFromJson(Map<String, dynamic> json) => AddressModel(
  street: json['street'] as String?,
  city: json['city'] as String?,
  zipcode: json['zipcode'] as String?,
  country: json['country'] as String?,
);

Map<String, dynamic> _$AddressModelToJson(AddressModel instance) =>
    <String, dynamic>{
      'street': instance.street,
      'city': instance.city,
      'zipcode': instance.zipcode,
      'country': instance.country,
    };

PaginationModel _$PaginationModelFromJson(Map<String, dynamic> json) =>
    PaginationModel(
      page: (json['page'] as num?)?.toInt(),
      limit: (json['limit'] as num?)?.toInt(),
      total: (json['total'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PaginationModelToJson(PaginationModel instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      'total': instance.total,
    };

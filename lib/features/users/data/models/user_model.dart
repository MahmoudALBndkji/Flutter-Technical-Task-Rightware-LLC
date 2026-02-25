import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserModel {
  final List<DataModel>? data;
  final PaginationModel? pagination;

  const UserModel({
    this.data,
    this.pagination,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    List<DataModel>? data,
    PaginationModel? pagination,
  }) {
    return UserModel(
      data: data ?? this.data,
      pagination: pagination ?? this.pagination,
    );
  }
}


@JsonSerializable(explicitToJson: true)
class DataModel {
  final int? id;
  final String? email;
  final String? username;
  final NameModel? name;
  final AddressModel? address;
  final String? phone;
  final List<int>? orders;

  const DataModel({
    this.id,
    this.email,
    this.username,
    this.name,
    this.address,
    this.phone,
    this.orders,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) =>
      _$DataModelFromJson(json);

  Map<String, dynamic> toJson() => _$DataModelToJson(this);

  DataModel copyWith({
    int? id,
    String? email,
    String? username,
    NameModel? name,
    AddressModel? address,
    String? phone,
    List<int>? orders,
  }) {
    return DataModel(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      orders: orders ?? this.orders,
    );
  }
}


@JsonSerializable()
class NameModel {
  final String? firstname;
  final String? lastname;

  const NameModel({
    this.firstname,
    this.lastname,
  });

  factory NameModel.fromJson(Map<String, dynamic> json) =>
      _$NameModelFromJson(json);

  Map<String, dynamic> toJson() => _$NameModelToJson(this);

  NameModel copyWith({
    String? firstname,
    String? lastname,
  }) {
    return NameModel(
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
    );
  }
}


@JsonSerializable()
class AddressModel {
  final String? street;
  final String? city;
  final String? zipcode;
  final String? country;

  const AddressModel({
    this.street,
    this.city,
    this.zipcode,
    this.country,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddressModelToJson(this);

  AddressModel copyWith({
    String? street,
    String? city,
    String? zipcode,
    String? country,
  }) {
    return AddressModel(
      street: street ?? this.street,
      city: city ?? this.city,
      zipcode: zipcode ?? this.zipcode,
      country: country ?? this.country,
    );
  }
}


@JsonSerializable()
class PaginationModel {
  final int? page;
  final int? limit;
  final int? total;

  const PaginationModel({
    this.page,
    this.limit,
    this.total,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) =>
      _$PaginationModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationModelToJson(this);

  PaginationModel copyWith({
    int? page,
    int? limit,
    int? total,
  }) {
    return PaginationModel(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      total: total ?? this.total,
    );
  }
}
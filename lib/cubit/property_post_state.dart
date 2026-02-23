import 'package:equatable/equatable.dart';

enum PropertyPostStatus { initial, loading, success, error }

class PropertyPostState extends Equatable {
  final PropertyPostStatus status;
  final String title;
  final String? propertyType;
  final String location;
  final String district;
  final String price;
  final String? bedrooms;
  final String? bathrooms;
  final String areaSqm;
  final String floor;
  final bool isFurnished;
  final String description;
  final String contactName;
  final String? errorMessage;

  const PropertyPostState({
    this.status = PropertyPostStatus.initial,
    this.title = '',
    this.propertyType,
    this.location = '',
    this.district = '',
    this.price = '',
    this.bedrooms,
    this.bathrooms,
    this.areaSqm = '',
    this.floor = '',
    this.isFurnished = false,
    this.description = '',
    this.contactName = '',
    this.errorMessage,
  });

  PropertyPostState copyWith({
    PropertyPostStatus? status,
    String? title,
    String? propertyType,
    String? location,
    String? district,
    String? price,
    String? bedrooms,
    String? bathrooms,
    String? areaSqm,
    String? floor,
    bool? isFurnished,
    String? description,
    String? contactName,
    String? errorMessage,
  }) {
    return PropertyPostState(
      status: status ?? this.status,
      title: title ?? this.title,
      propertyType: propertyType ?? this.propertyType,
      location: location ?? this.location,
      district: district ?? this.district,
      price: price ?? this.price,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      areaSqm: areaSqm ?? this.areaSqm,
      floor: floor ?? this.floor,
      isFurnished: isFurnished ?? this.isFurnished,
      description: description ?? this.description,
      contactName: contactName ?? this.contactName,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status, title, propertyType, location, district, price,
        bedrooms, bathrooms, areaSqm, floor, isFurnished,
        description, contactName, errorMessage,
      ];
}

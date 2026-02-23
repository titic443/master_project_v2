import 'package:equatable/equatable.dart';

enum PropertySearchStatus { initial, loading, success, empty, error }

class PropertySearchState extends Equatable {
  final PropertySearchStatus status;
  final String location;
  final String? propertyType;
  final String? bedrooms;
  final String minPrice;
  final String maxPrice;
  final String minArea;
  final bool furnishedOnly;
  final List<Map<String, dynamic>> properties;
  final String? errorMessage;

  const PropertySearchState({
    this.status = PropertySearchStatus.initial,
    this.location = '',
    this.propertyType,
    this.bedrooms,
    this.minPrice = '',
    this.maxPrice = '',
    this.minArea = '',
    this.furnishedOnly = false,
    this.properties = const [],
    this.errorMessage,
  });

  PropertySearchState copyWith({
    PropertySearchStatus? status,
    String? location,
    String? propertyType,
    String? bedrooms,
    String? minPrice,
    String? maxPrice,
    String? minArea,
    bool? furnishedOnly,
    List<Map<String, dynamic>>? properties,
    String? errorMessage,
  }) {
    return PropertySearchState(
      status: status ?? this.status,
      location: location ?? this.location,
      propertyType: propertyType ?? this.propertyType,
      bedrooms: bedrooms ?? this.bedrooms,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minArea: minArea ?? this.minArea,
      furnishedOnly: furnishedOnly ?? this.furnishedOnly,
      properties: properties ?? this.properties,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status, location, propertyType, bedrooms,
        minPrice, maxPrice, minArea, furnishedOnly,
        properties, errorMessage,
      ];
}

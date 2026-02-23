import 'dart:convert';
import 'dart:io' show Platform;

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;

import 'property_post_state.dart';

class PropertyPostCubit extends Cubit<PropertyPostState> {
  final String? baseUrl;

  PropertyPostCubit({this.baseUrl}) : super(const PropertyPostState());

  String get _baseUrl {
    if (baseUrl != null) return baseUrl!;
    if (Platform.isAndroid) return 'http://10.0.2.2:8000';
    return 'http://localhost:8000';
  }

  void onTitleChanged(String v) => emit(state.copyWith(title: v));
  void onPropertyTypeChanged(String? v) => emit(state.copyWith(propertyType: v));
  void onLocationChanged(String v) => emit(state.copyWith(location: v));
  void onDistrictChanged(String v) => emit(state.copyWith(district: v));
  void onPriceChanged(String v) => emit(state.copyWith(price: v));
  void onBedroomsChanged(String? v) => emit(state.copyWith(bedrooms: v));
  void onBathroomsChanged(String? v) => emit(state.copyWith(bathrooms: v));
  void onAreaSqmChanged(String v) => emit(state.copyWith(areaSqm: v));
  void onFloorChanged(String v) => emit(state.copyWith(floor: v));
  void onIsFurnishedChanged(bool v) => emit(state.copyWith(isFurnished: v));
  void onDescriptionChanged(String v) => emit(state.copyWith(description: v));
  void onContactNameChanged(String v) => emit(state.copyWith(contactName: v));

  Future<void> submit() async {
    emit(state.copyWith(status: PropertyPostStatus.loading));
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/demo/properties'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': state.title,
          'propertyType': state.propertyType,
          'location': state.location,
          'district': state.district,
          'price': int.tryParse(state.price) ?? 0,
          'bedrooms': state.bedrooms,
          'bathrooms': state.bathrooms,
          'areaSqm': double.tryParse(state.areaSqm) ?? 0.0,
          'floor': state.floor,
          'isFurnished': state.isFurnished,
          'description': state.description,
          'contactName': state.contactName,
        }),
      );

      if (response.statusCode == 200) {
        emit(state.copyWith(status: PropertyPostStatus.success));
      } else {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        emit(state.copyWith(
          status: PropertyPostStatus.error,
          errorMessage: data['message']?.toString() ?? 'Failed to list property',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: PropertyPostStatus.error,
        errorMessage: 'Connection error: $e',
      ));
    }
  }
}

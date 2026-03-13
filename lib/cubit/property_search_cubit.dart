import 'dart:convert';
import 'dart:io' show Platform;

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;

import 'property_search_state.dart';

class PropertySearchCubit extends Cubit<PropertySearchState> {
  final String? baseUrl;

  PropertySearchCubit({this.baseUrl}) : super(const PropertySearchState());

  String get _baseUrl {
    if (baseUrl != null) return baseUrl!;
    if (Platform.isAndroid) return 'http://10.0.2.2:8000';
    return 'http://localhost:8000';
  }

  void onLocationChanged(String v) => emit(state.copyWith(location: v));
  void onPropertyTypeChanged(String? v) => emit(state.copyWith(propertyType: v));
  void onBedroomsChanged(String? v) => emit(state.copyWith(bedrooms: v));
  void onMinPriceChanged(String v) => emit(state.copyWith(minPrice: v));
  void onMaxPriceChanged(String v) => emit(state.copyWith(maxPrice: v));
  void onMinAreaChanged(String v) => emit(state.copyWith(minArea: v));
  void onFurnishedOnlyChanged(bool v) => emit(state.copyWith(furnishedOnly: v));

  Future<void> search() async {
    emit(state.copyWith(status: PropertySearchStatus.loading, properties: []));
    try {
      final params = <String, String>{};
      if (state.location.trim().isNotEmpty) {
        params['location'] = state.location.trim();
      }
      if (state.propertyType != null) {
        params['property_type'] = state.propertyType!;
      }
      if (state.bedrooms != null) params['bedrooms'] = state.bedrooms!;
      if (state.minPrice.trim().isNotEmpty) {
        params['min_price'] = state.minPrice.trim();
      }
      if (state.maxPrice.trim().isNotEmpty) {
        params['max_price'] = state.maxPrice.trim();
      }
      if (state.minArea.trim().isNotEmpty) {
        params['min_area'] = state.minArea.trim();
      }
      if (state.furnishedOnly) params['is_furnished'] = 'true';

      final uri = Uri.parse('$_baseUrl/api/demo/properties/search')
          .replace(queryParameters: params);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final props =
            List<Map<String, dynamic>>.from(data['properties'] as List);
        emit(state.copyWith(
          status: props.isEmpty
              ? PropertySearchStatus.empty
              : PropertySearchStatus.success,
          properties: props,
        ));
      } else {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        emit(state.copyWith(
          status: PropertySearchStatus.error,
          errorMessage: data['message']?.toString() ?? 'Search failed',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: PropertySearchStatus.error,
        errorMessage: 'Connection error: $e',
      ));
    }
  }
}

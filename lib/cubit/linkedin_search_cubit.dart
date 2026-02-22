import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io' show Platform;
import 'linkedin_search_state.dart';

class LinkedinSearchCubit extends Cubit<LinkedinSearchState> {
  final String? baseUrl;

  LinkedinSearchCubit({this.baseUrl}) : super(const LinkedinSearchState());

  String get _baseUrl {
    if (baseUrl != null) return baseUrl!;
    if (Platform.isAndroid) return 'http://10.0.2.2:8000';
    return 'http://localhost:8000';
  }

  void onEmailChanged(String value) => emit(state.copyWith(email: value));
  void onNameChanged(String value) => emit(state.copyWith(name: value));

  Future<void> search() async {
    if (state.email.trim().isEmpty && state.name.trim().isEmpty) return;

    emit(state.copyWith(status: LinkedinSearchStatus.loading, profiles: []));

    try {
      final params = <String, String>{};
      if (state.email.trim().isNotEmpty) params['email'] = state.email.trim();
      if (state.name.trim().isNotEmpty) params['name'] = state.name.trim();

      final uri = Uri.parse('$_baseUrl/api/demo/linkedin/search')
          .replace(queryParameters: params);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final profiles =
            List<Map<String, dynamic>>.from(data['profiles'] as List);
        emit(state.copyWith(
          status: profiles.isEmpty
              ? LinkedinSearchStatus.empty
              : LinkedinSearchStatus.success,
          profiles: profiles,
        ));
      } else {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        emit(state.copyWith(
          status: LinkedinSearchStatus.error,
          errorMessage: data['message']?.toString() ?? 'Search failed',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: LinkedinSearchStatus.error,
        errorMessage: 'Failed to connect: $e',
      ));
    }
  }
}

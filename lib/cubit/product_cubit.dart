import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final bool shouldSucceed;

  ProductCubit({this.shouldSucceed = false}) : super(const ProductState());

  void onProductNameChanged(String value) {
    emit(state.copyWith(productName: value));
  }

  void onCategoryChanged(String? value) {
    emit(state.copyWith(category: value));
  }

  void onSkuChanged(String value) {
    emit(state.copyWith(sku: value));
  }

  void onQuantityChanged(String value) {
    final qty = int.tryParse(value);
    emit(state.copyWith(quantity: qty));
  }

  void onPriceRangeSelected(int value) {
    emit(state.copyWith(priceRange: value));
  }

  void onInStockChanged(bool value) {
    emit(state.copyWith(inStock: value));
  }

  void onFeaturedChanged(bool value) {
    emit(state.copyWith(featured: value));
  }

  Future<void> submitProductDetails() async {
    emit(state.copyWith(status: ProductStatus.loading));

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8000/api/demo/product'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'productName': state.productName,
          'category': state.category,
          'sku': state.sku,
          'quantity': state.quantity,
          'priceRange': state.priceRange,
          'inStock': state.inStock,
          'featured': state.featured,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final apiResponse = ApiResponse.fromJson(data);
        emit(state.copyWith(
          status: ProductStatus.success,
          response: apiResponse,
        ));
      } else {
        final data = jsonDecode(response.body);
        emit(state.copyWith(
          status: ProductStatus.error,
          errorMessage: data['message'] ?? 'Unknown error',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: ProductStatus.error,
        errorMessage: 'Failed to submit: $e',
      ));
    }
  }

  Future<void> callApi() async {
    await submitProductDetails();
  }

  Future<void> onEndButton() async {
    await submitProductDetails();
  }
}

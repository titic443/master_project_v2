import 'package:equatable/equatable.dart';

enum ProductStatus { initial, loading, success, error }

class ApiResponse {
  final String message;
  final int code;

  const ApiResponse({required this.message, required this.code});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      message: json['message'] as String,
      code: json['code'] as int,
    );
  }
}

class ProductException implements Exception {
  final String message;
  final int code;

  const ProductException({required this.message, required this.code});
}

class ProductState extends Equatable {
  final ProductStatus status;
  final String? productName;
  final String? category;
  final String? sku;
  final int? quantity;
  final int? priceRange;
  final bool inStock;
  final bool featured;
  final String? errorMessage;
  final ApiResponse? response;
  final ProductException? exception;

  const ProductState({
    this.status = ProductStatus.initial,
    this.productName,
    this.category,
    this.sku,
    this.quantity,
    this.priceRange,
    this.inStock = false,
    this.featured = false,
    this.errorMessage,
    this.response,
    this.exception,
  });

  ProductState copyWith({
    ProductStatus? status,
    String? productName,
    String? category,
    String? sku,
    int? quantity,
    int? priceRange,
    bool? inStock,
    bool? featured,
    String? errorMessage,
    ApiResponse? response,
    ProductException? exception,
  }) {
    return ProductState(
      status: status ?? this.status,
      productName: productName ?? this.productName,
      category: category ?? this.category,
      sku: sku ?? this.sku,
      quantity: quantity ?? this.quantity,
      priceRange: priceRange ?? this.priceRange,
      inStock: inStock ?? this.inStock,
      featured: featured ?? this.featured,
      errorMessage: errorMessage ?? this.errorMessage,
      response: response ?? this.response,
      exception: exception ?? this.exception,
    );
  }

  @override
  List<Object?> get props => [
        status,
        productName,
        category,
        sku,
        quantity,
        priceRange,
        inStock,
        featured,
        errorMessage,
        response,
        exception,
      ];
}

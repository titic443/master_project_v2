import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_project/cubit/product_cubit.dart';
import 'package:master_project/cubit/product_state.dart';

class ProductRegistrationPage extends StatelessWidget {
  const ProductRegistrationPage({super.key});

  static const route = '/product-registration';

  @override
  Widget build(BuildContext context) {
    return const _ProductRegistrationForm();
  }
}

class _ProductRegistrationForm extends StatefulWidget {
  const _ProductRegistrationForm();

  @override
  State<_ProductRegistrationForm> createState() =>
      _ProductRegistrationFormState();
}

class _ProductRegistrationFormState extends State<_ProductRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _skuController = TextEditingController();
  final _quantityController = TextEditingController();

  @override
  void dispose() {
    _productNameController.dispose();
    _skuController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      context.read<ProductCubit>().submitProductDetails();
    }
  }

  void _syncControllers(ProductState state) {
    _updateController(_productNameController, state.productName);
    _updateController(_skuController, state.sku);
    _updateController(
        _quantityController, state.quantity?.toString() ?? '');
  }

  void _updateController(TextEditingController controller, String? value) {
    final val = value ?? '';
    if (controller.text == val) return;
    controller.value = controller.value.copyWith(
      text: val,
      selection: TextSelection.collapsed(offset: val.length),
      composing: TextRange.empty,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Product Registration Form',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocListener<ProductCubit, ProductState>(
        listener: (context, state) {
          if (state.status == ProductStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                key: Key('product_01_expected_success'),
                content: Text(
                  'Product registered successfully',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            );
          } else if (state.status == ProductStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                key: const Key('product_01_expected_fail'),
                content: Text(
                  state.errorMessage ?? 'Unknown error',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            _syncControllers(state);
            final isLoading = state.status == ProductStatus.loading;
            return Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 8),
                      // Product Name - TextFormField
                      TextFormField(
                        key: const Key('product_02_name_textfield'),
                        controller: _productNameController,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Product Name',
                          labelStyle: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(100),
                        ],
                        onChanged: (value) {
                          context.read<ProductCubit>().onProductNameChanged(value);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Product name is required';
                          }
                          if (value.length < 3) {
                            return 'Product name must be at least 3 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Category - Dropdown
                      DropdownButtonFormField<String>(
                        key: const Key('product_03_category_dropdown'),
                        value: state.category,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          labelStyle: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Electronics',
                            child: Text('Electronics',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                          ),
                          DropdownMenuItem(
                            value: 'Clothing',
                            child: Text('Clothing',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                          ),
                          DropdownMenuItem(
                            value: 'Food',
                            child: Text('Food',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                          ),
                          DropdownMenuItem(
                            value: 'Books',
                            child: Text('Books',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                          ),
                        ],
                        onChanged: (value) {
                          context.read<ProductCubit>().onCategoryChanged(value);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a category';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // SKU - TextFormField
                      TextFormField(
                        key: const Key('product_04_sku_textfield'),
                        controller: _skuController,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'SKU (Stock Keeping Unit)',
                          labelStyle: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                          hintText: 'ABC-12345',
                          hintStyle: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[A-Z0-9\-]')),
                          LengthLimitingTextInputFormatter(20),
                        ],
                        onChanged: (value) {
                          context.read<ProductCubit>().onSkuChanged(value);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'SKU is required';
                          }
                          if (!RegExp(r'^[A-Z0-9\-]{5,}$').hasMatch(value)) {
                            return 'SKU must be uppercase alphanumeric with dash (min 5 chars)';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Quantity - TextFormField (numbers only)
                      TextFormField(
                        key: const Key('product_05_quantity_textfield'),
                        controller: _quantityController,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Quantity',
                          labelStyle: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                          hintText: '100',
                          hintStyle: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(6),
                        ],
                        onChanged: (value) {
                          context.read<ProductCubit>().onQuantityChanged(value);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Quantity is required';
                          }
                          final qty = int.tryParse(value);
                          if (qty == null || qty < 1) {
                            return 'Quantity must be at least 1';
                          }
                          if (qty > 999999) {
                            return 'Quantity cannot exceed 999999';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      // Price Range - FormField with Radio buttons
                      FormField<int>(
                        key: const Key('product_06_price_range_formfield'),
                        initialValue: state.priceRange,
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a price range';
                          }
                          return null;
                        },
                        builder: (FormFieldState<int> formState) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Price Range',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              Row(
                                children: [
                                  Radio<int>(
                                    key: const Key(
                                        'product_06_price_0_100_radio'),
                                    value: 1,
                                    groupValue: state.priceRange,
                                    onChanged: (value) {
                                      if (value != null) {
                                        context
                                            .read<ProductCubit>()
                                            .onPriceRangeSelected(value);
                                        formState.didChange(value);
                                      }
                                    },
                                  ),
                                  const Text(
                                    '0-100',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Radio<int>(
                                    key: const Key(
                                        'product_06_price_100_500_radio'),
                                    value: 2,
                                    groupValue: state.priceRange,
                                    onChanged: (value) {
                                      if (value != null) {
                                        context
                                            .read<ProductCubit>()
                                            .onPriceRangeSelected(value);
                                        formState.didChange(value);
                                      }
                                    },
                                  ),
                                  const Text(
                                    '100-500',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Radio<int>(
                                    key: const Key(
                                        'product_06_price_500_plus_radio'),
                                    value: 3,
                                    groupValue: state.priceRange,
                                    onChanged: (value) {
                                      if (value != null) {
                                        context
                                            .read<ProductCubit>()
                                            .onPriceRangeSelected(value);
                                        formState.didChange(value);
                                      }
                                    },
                                  ),
                                  const Text(
                                    '500+',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              if (formState.hasError)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    formState.errorText!,
                                    style: const TextStyle(
                                        color: Colors.red, fontSize: 12),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      // In Stock - FormField with Checkbox
                      FormField<bool>(
                        key: const Key('product_07_instock_formfield'),
                        initialValue: state.inStock,
                        validator: (value) {
                          if (value == null || !value) {
                            return 'Product must be in stock to register';
                          }
                          return null;
                        },
                        builder: (FormFieldState<bool> formState) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    key: const Key('product_07_instock_checkbox'),
                                    value: state.inStock,
                                    onChanged: (value) {
                                      context
                                          .read<ProductCubit>()
                                          .onInStockChanged(value ?? false);
                                      formState.didChange(value);
                                    },
                                  ),
                                  const Text(
                                    'In Stock',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              if (formState.hasError)
                                Text(
                                  formState.errorText!,
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 12),
                                ),
                            ],
                          );
                        },
                      ),
                      // Featured - Checkbox (optional)
                      Row(
                        children: [
                          Checkbox(
                            key: const Key('product_08_featured_checkbox'),
                            value: state.featured,
                            onChanged: (value) {
                              context
                                  .read<ProductCubit>()
                                  .onFeaturedChanged(value ?? false);
                            },
                          ),
                          const Text(
                            'Featured Product',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Submit button
                      ElevatedButton(
                        key: const Key('product_09_end_button'),
                        onPressed: isLoading ? null : _handleSubmit,
                        child: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text(
                                'Register Product',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

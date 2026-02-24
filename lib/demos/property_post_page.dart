import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_project/cubit/property_post_cubit.dart';
import 'package:master_project/cubit/property_post_state.dart';

class PropertyPostPage extends StatelessWidget {
  const PropertyPostPage({super.key});

  static const route = '/property-post';

  @override
  Widget build(BuildContext context) => const _PropertyPostView();
}

// ─── Private View ─────────────────────────────────────────────────────────────

class _PropertyPostView extends StatefulWidget {
  const _PropertyPostView();

  @override
  State<_PropertyPostView> createState() => _PropertyPostViewState();
}

class _PropertyPostViewState extends State<_PropertyPostView> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _districtCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _areaCtrl = TextEditingController();
  final _floorCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _contactCtrl = TextEditingController();

  @override
  void dispose() {
    _titleCtrl.dispose();
    _locationCtrl.dispose();
    _districtCtrl.dispose();
    _priceCtrl.dispose();
    _areaCtrl.dispose();
    _floorCtrl.dispose();
    _descCtrl.dispose();
    _contactCtrl.dispose();
    super.dispose();
  }

  void _sync(PropertyPostState s) {
    if (_titleCtrl.text != s.title) _titleCtrl.text = s.title;
    if (_locationCtrl.text != s.location) _locationCtrl.text = s.location;
    if (_districtCtrl.text != s.district) _districtCtrl.text = s.district;
    if (_priceCtrl.text != s.price) _priceCtrl.text = s.price;
    if (_areaCtrl.text != s.areaSqm) _areaCtrl.text = s.areaSqm;
    if (_floorCtrl.text != s.floor) _floorCtrl.text = s.floor;
    if (_descCtrl.text != s.description) _descCtrl.text = s.description;
    if (_contactCtrl.text != s.contactName) _contactCtrl.text = s.contactName;
  }

  void _onSubmit(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          key: Key('prop_13_expected_fail'),
          content: Text('Please correct the highlighted fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    context.read<PropertyPostCubit>().submit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'List a Property',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocConsumer<PropertyPostCubit, PropertyPostState>(
        listenWhen: (prev, curr) =>
            prev.status == PropertyPostStatus.loading &&
            curr.status != PropertyPostStatus.loading,
        listener: (context, state) {
          if (state.status == PropertyPostStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                key: Key('prop_13_expected_success'),
                content: Text('Property listed successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state.status == PropertyPostStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                key: const Key('prop_13_expected_fail'),
                content: Text(state.errorMessage ?? 'Failed to list property'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          _sync(state);
          final cubit = context.read<PropertyPostCubit>();
          final isLoading = state.status == PropertyPostStatus.loading;

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
              children: [
                // ── Section 1: Listing Info ──────────────────────────────
                const _SectionHeader(
                  title: 'Listing Information',
                  icon: Icons.home_outlined,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  key: const Key('prop_01_title_textfield'),
                  controller: _titleCtrl,
                  decoration: _dec(
                    label: 'Listing Title',
                    hint: 'e.g. Modern 2-Bed Condo near BTS Asok',
                    icon: Icons.title,
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: cubit.onTitleChanged,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    if (v.trim().length < 5) return 'At least 5 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  key: const Key('prop_02_type_dropdown'),
                  value: state.propertyType,
                  decoration: _dec(
                    label: 'Property Type',
                    icon: Icons.domain_outlined,
                  ),
                  hint: const Text('Select type'),
                  items: const [
                    DropdownMenuItem(value: 'Condo', child: Text('Condo')),
                    DropdownMenuItem(value: 'House', child: Text('House')),
                    DropdownMenuItem(value: 'Townhouse', child: Text('Townhouse')),
                    DropdownMenuItem(value: 'Land', child: Text('Land')),
                    DropdownMenuItem(value: 'Commercial', child: Text('Commercial')),
                  ],
                  onChanged: cubit.onPropertyTypeChanged,
                  validator: (v) => v == null ? 'Required' : null,
                ),

                // ── Section 2: Location ──────────────────────────────────
                const SizedBox(height: 28),
                const _SectionHeader(
                  title: 'Location',
                  icon: Icons.location_on_outlined,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  key: const Key('prop_03_location_textfield'),
                  controller: _locationCtrl,
                  decoration: _dec(
                    label: 'Province / City',
                    hint: 'e.g. Bangkok',
                    icon: Icons.location_city_outlined,
                  ),
                  onChanged: cubit.onLocationChanged,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    if (v.trim().length < 2) return 'At least 2 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                TextFormField(
                  key: const Key('prop_04_district_textfield'),
                  controller: _districtCtrl,
                  decoration: _dec(
                    label: 'District / Area',
                    hint: 'e.g. Watthana, Sukhumvit',
                    icon: Icons.map_outlined,
                  ),
                  onChanged: cubit.onDistrictChanged,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    if (v.trim().length < 2) return 'At least 2 characters';
                    return null;
                  },
                ),

                // ── Section 3: Property Details ──────────────────────────
                const SizedBox(height: 28),
                const _SectionHeader(
                  title: 'Property Details',
                  icon: Icons.info_outline,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  key: const Key('prop_05_price_textfield'),
                  controller: _priceCtrl,
                  decoration: _dec(
                    label: 'Price (THB)',
                    hint: '3500000',
                    icon: Icons.attach_money,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: cubit.onPriceChanged,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    final n = int.tryParse(v);
                    if (n == null || n < 100000) return 'Min 100,000 THB';
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        key: const Key('prop_06_bedrooms_dropdown'),
                        value: state.bedrooms,
                        decoration: _dec(
                          label: 'Bedrooms',
                          icon: Icons.bed_outlined,
                        ),
                        hint: const Text('Select'),
                        items: const [
                          DropdownMenuItem(value: 'Studio', child: Text('Studio')),
                          DropdownMenuItem(value: '1', child: Text('1')),
                          DropdownMenuItem(value: '2', child: Text('2')),
                          DropdownMenuItem(value: '3', child: Text('3')),
                          DropdownMenuItem(value: '4+', child: Text('4+')),
                        ],
                        onChanged: cubit.onBedroomsChanged,
                        validator: (v) => v == null ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        key: const Key('prop_07_bathrooms_dropdown'),
                        value: state.bathrooms,
                        decoration: _dec(
                          label: 'Bathrooms',
                          icon: Icons.bathtub_outlined,
                        ),
                        hint: const Text('Select'),
                        items: const [
                          DropdownMenuItem(value: '1', child: Text('1')),
                          DropdownMenuItem(value: '2', child: Text('2')),
                          DropdownMenuItem(value: '3', child: Text('3')),
                          DropdownMenuItem(value: '4+', child: Text('4+')),
                        ],
                        onChanged: cubit.onBathroomsChanged,
                        validator: (v) => v == null ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        key: const Key('prop_08_area_textfield'),
                        controller: _areaCtrl,
                        decoration: _dec(
                          label: 'Area (sqm)',
                          hint: '65',
                          icon: Icons.square_foot_outlined,
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}'),
                          ),
                        ],
                        onChanged: cubit.onAreaSqmChanged,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Required';
                          final n = double.tryParse(v);
                          if (n == null || n < 10) return 'Min 10 sqm';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        key: const Key('prop_09_floor_textfield'),
                        controller: _floorCtrl,
                        decoration: _dec(
                          label: 'Floor / Storey',
                          hint: 'e.g. 12 or 2-storey',
                          icon: Icons.layers_outlined,
                        ),
                        onChanged: cubit.onFloorChanged,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Required';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Card(
                  elevation: 0,
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest
                      .withValues(alpha: 0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.chair_outlined,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Fully Furnished',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Property comes with furniture & appliances',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          key: const Key('prop_10_furnished_switch'),
                          value: state.isFurnished,
                          onChanged: cubit.onIsFurnishedChanged,
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Section 4: Description & Contact ────────────────────
                const SizedBox(height: 28),
                const _SectionHeader(
                  title: 'Description & Contact',
                  icon: Icons.description_outlined,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  key: const Key('prop_11_desc_textfield'),
                  controller: _descCtrl,
                  decoration: _dec(
                    label: 'Description',
                    hint:
                        'Describe the property condition, nearby amenities, highlights...',
                    icon: Icons.description_outlined,
                  ),
                  maxLines: 4,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: cubit.onDescriptionChanged,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    if (v.trim().length < 20) return 'At least 20 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                TextFormField(
                  key: const Key('prop_12_contact_textfield'),
                  controller: _contactCtrl,
                  decoration: _dec(
                    label: 'Contact Name',
                    hint: 'e.g. Somchai Jaidee (Agent)',
                    icon: Icons.person_outline,
                  ),
                  textCapitalization: TextCapitalization.words,
                  onChanged: cubit.onContactNameChanged,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    if (v.trim().length < 2) return 'At least 2 characters';
                    return null;
                  },
                ),

                // ── Submit ───────────────────────────────────────────────
                const SizedBox(height: 36),
                ElevatedButton(
                  key: const Key('prop_13_end_button'),
                  onPressed: isLoading ? null : () => _onSubmit(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.home_work_outlined),
                            SizedBox(width: 8),
                            Text(
                              'List Property',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

InputDecoration _dec({
  required String label,
  String? hint,
  required IconData icon,
}) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
    hintText: hint,
    hintStyle: TextStyle(fontSize: 13, color: Colors.grey[400]),
    prefixIcon: Icon(icon),
    border: const OutlineInputBorder(),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
  );
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.deepPurple),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(child: Divider()),
      ],
    );
  }
}

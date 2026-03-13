import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_project/cubit/property_search_cubit.dart';
import 'package:master_project/cubit/property_search_state.dart';

class PropertySearchPage extends StatelessWidget {
  const PropertySearchPage({super.key});

  static const route = '/property-search';

  @override
  Widget build(BuildContext context) => const _PropertySearchView();
}

// ─── Private View ─────────────────────────────────────────────────────────────

class _PropertySearchView extends StatefulWidget {
  const _PropertySearchView();

  @override
  State<_PropertySearchView> createState() => _PropertySearchViewState();
}

class _PropertySearchViewState extends State<_PropertySearchView> {
  final _locationCtrl = TextEditingController();
  final _minPriceCtrl = TextEditingController();
  final _maxPriceCtrl = TextEditingController();
  final _minAreaCtrl = TextEditingController();

  @override
  void dispose() {
    _locationCtrl.dispose();
    _minPriceCtrl.dispose();
    _maxPriceCtrl.dispose();
    _minAreaCtrl.dispose();
    super.dispose();
  }

  void _sync(PropertySearchState s) {
    if (_locationCtrl.text != s.location) _locationCtrl.text = s.location;
    if (_minPriceCtrl.text != s.minPrice) _minPriceCtrl.text = s.minPrice;
    if (_maxPriceCtrl.text != s.maxPrice) _maxPriceCtrl.text = s.maxPrice;
    if (_minAreaCtrl.text != s.minArea) _minAreaCtrl.text = s.minArea;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Find Properties',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocConsumer<PropertySearchCubit, PropertySearchState>(
        listenWhen: (prev, curr) =>
            prev.status == PropertySearchStatus.loading &&
            curr.status != PropertySearchStatus.loading,
        listener: (context, state) {
          if (state.status == PropertySearchStatus.success) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                key: const Key('search_01_expected_success'),
                title: const Text('Search Successful'),
                content: Text('Found ${state.properties.length} propert${state.properties.length == 1 ? 'y' : 'ies'}'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          } else if (state.status == PropertySearchStatus.error ||
              state.status == PropertySearchStatus.empty) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                key: const Key('search_01_expected_fail'),
                title: const Text('Search Failed'),
                content: Text(
                  state.status == PropertySearchStatus.empty
                      ? 'No properties found matching your criteria'
                      : state.errorMessage ?? 'Search failed',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }
        },
        builder: (context, state) {
          _sync(state);
          return Column(
            children: [
              _SearchPanel(
                locationCtrl: _locationCtrl,
                minPriceCtrl: _minPriceCtrl,
                maxPriceCtrl: _maxPriceCtrl,
                minAreaCtrl: _minAreaCtrl,
                state: state,
              ),
              const Divider(height: 1),
              Expanded(child: _ResultSection(state: state)),
            ],
          );
        },
      ),
    );
  }
}

// ─── Search Panel ─────────────────────────────────────────────────────────────

class _SearchPanel extends StatelessWidget {
  final TextEditingController locationCtrl;
  final TextEditingController minPriceCtrl;
  final TextEditingController maxPriceCtrl;
  final TextEditingController minAreaCtrl;
  final PropertySearchState state;

  const _SearchPanel({
    required this.locationCtrl,
    required this.minPriceCtrl,
    required this.maxPriceCtrl,
    required this.minAreaCtrl,
    required this.state,
  });

  static const _types = [
    null, 'Condo', 'House', 'Townhouse', 'Land', 'Commercial',
  ];

  static const _bedroomOptions = [
    null, 'Studio', '1', '2', '3', '4+',
  ];

  InputDecoration _sDec({
    required String label,
    String? hint,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
      prefixIcon: Icon(icon, size: 18),
      border: const OutlineInputBorder(),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PropertySearchCubit>();
    final isLoading = state.status == PropertySearchStatus.loading;

    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Row 1: Location + Property Type
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextField(
                  key: const Key('search_01_location_textfield'),
                  controller: locationCtrl,
                  style: const TextStyle(fontSize: 14),
                  decoration: _sDec(
                    label: 'Location / Province',
                    hint: 'e.g. Bangkok, Chiang Mai',
                    icon: Icons.location_on_outlined,
                  ),
                  onChanged: cubit.onLocationChanged,
                  onSubmitted: (_) => cubit.search(),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<String>(
                  key: const Key('search_02_type_dropdown'),
                  value: state.propertyType,
                  decoration: _sDec(
                    label: 'Type',
                    icon: Icons.domain_outlined,
                  ),
                  hint: const Text('All', style: TextStyle(fontSize: 13)),
                  items: _types
                      .map(
                        (e) => DropdownMenuItem<String>(
                          value: e,
                          child: Text(
                            e ?? 'All',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: cubit.onPropertyTypeChanged,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Row 2: Bedrooms + Min Price + Max Price
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  key: const Key('search_03_bedrooms_dropdown'),
                  value: state.bedrooms,
                  decoration: _sDec(
                    label: 'Bedrooms',
                    icon: Icons.bed_outlined,
                  ),
                  hint: const Text('Any', style: TextStyle(fontSize: 13)),
                  items: _bedroomOptions
                      .map(
                        (e) => DropdownMenuItem<String>(
                          value: e,
                          child: Text(
                            e ?? 'Any',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: cubit.onBedroomsChanged,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  key: const Key('search_04_min_price_textfield'),
                  controller: minPriceCtrl,
                  style: const TextStyle(fontSize: 14),
                  decoration: _sDec(
                    label: 'Min Price (THB)',
                    hint: '1000000',
                    icon: Icons.south_outlined,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: cubit.onMinPriceChanged,
                  onSubmitted: (_) => cubit.search(),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  key: const Key('search_05_max_price_textfield'),
                  controller: maxPriceCtrl,
                  style: const TextStyle(fontSize: 14),
                  decoration: _sDec(
                    label: 'Max Price (THB)',
                    hint: '5000000',
                    icon: Icons.north_outlined,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: cubit.onMaxPriceChanged,
                  onSubmitted: (_) => cubit.search(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Row 3: Min Area + Furnished + Search button
          Row(
            children: [
              Expanded(
                child: TextField(
                  key: const Key('search_06_min_area_textfield'),
                  controller: minAreaCtrl,
                  style: const TextStyle(fontSize: 14),
                  decoration: _sDec(
                    label: 'Min Area (sqm)',
                    hint: '40',
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
                  onChanged: cubit.onMinAreaChanged,
                  onSubmitted: (_) => cubit.search(),
                ),
              ),
              const SizedBox(width: 10),
              // Furnished toggle pill
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.chair_outlined,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Furnished',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Switch(
                      key: const Key('search_07_furnished_switch'),
                      value: state.furnishedOnly,
                      onChanged: cubit.onFurnishedOnlyChanged,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                key: const Key('search_08_end_button'),
                onPressed: isLoading ? null : cubit.search,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 18,
                  ),
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search, size: 18),
                          SizedBox(width: 4),
                          Text(
                            'Search',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Result Section ───────────────────────────────────────────────────────────

class _ResultSection extends StatelessWidget {
  final PropertySearchState state;

  const _ResultSection({required this.state});

  @override
  Widget build(BuildContext context) {
    switch (state.status) {
      case PropertySearchStatus.initial:
        return const _HintCard();
      case PropertySearchStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case PropertySearchStatus.empty:
        return const _NotFoundCard();
      case PropertySearchStatus.error:
        return _ErrorCard(message: state.errorMessage ?? 'Unknown error');
      case PropertySearchStatus.success:
        return _PropertyList(properties: state.properties);
    }
  }
}

class _HintCard extends StatelessWidget {
  const _HintCard();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.holiday_village_outlined, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'Find your perfect property',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
          const SizedBox(height: 8),
          Text(
            'Use the filters above to search listings',
            style: TextStyle(fontSize: 13, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}

class _NotFoundCard extends StatelessWidget {
  const _NotFoundCard();

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const Key('search_04_not_found'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_outlined, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No properties found',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
          const SizedBox(height: 8),
          Text(
            'Try widening your search criteria',
            style: TextStyle(fontSize: 13, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;

  const _ErrorCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const Key('search_05_error'),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Property List ────────────────────────────────────────────────────────────

class _PropertyList extends StatelessWidget {
  final List<Map<String, dynamic>> properties;

  const _PropertyList({required this.properties});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text(
            '${properties.length} propert${properties.length == 1 ? 'y' : 'ies'} found',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            key: const Key('search_06_result_list'),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            itemCount: properties.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) =>
                _PropertyCard(property: properties[index], index: index),
          ),
        ),
      ],
    );
  }
}

// ─── Property Card ────────────────────────────────────────────────────────────

class _PropertyCard extends StatelessWidget {
  final Map<String, dynamic> property;
  final int index;

  const _PropertyCard({required this.property, required this.index});

  String _fmtPrice(dynamic n) {
    final val = n is int ? n : (int.tryParse(n.toString()) ?? 0);
    if (val >= 1000000) {
      return '฿${(val / 1000000).toStringAsFixed(1)}M';
    }
    if (val >= 1000) return '฿${(val / 1000).toStringAsFixed(0)}K';
    return '฿$val';
  }

  @override
  Widget build(BuildContext context) {
    final title = property['title']?.toString() ?? '-';
    final type = property['propertyType']?.toString() ?? '-';
    final location = property['location']?.toString() ?? '-';
    final district = property['district']?.toString() ?? '-';
    final price = property['price'];
    final bedrooms = property['bedrooms']?.toString();
    final bathrooms = property['bathrooms']?.toString();
    final area = property['areaSqm'];
    final isFurnished = property['isFurnished'] == true;
    final contact = property['contactName']?.toString() ?? '-';

    return Card(
      key: Key('search_property_card_$index'),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.home_outlined,
                      color: Colors.deepPurple,
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 13,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              '$district, $location',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (isFurnished)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.amber.shade400),
                    ),
                    child: const Text(
                      'Furnished',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.amber,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Price (prominent)
            Text(
              price != null ? _fmtPrice(price) : '-',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 8),

            // Chips: type + beds + baths + area
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                _Chip(
                  icon: Icons.domain_outlined,
                  label: type,
                  color: Colors.deepPurple,
                ),
                if (bedrooms != null)
                  _Chip(
                    icon: Icons.bed_outlined,
                    label: bedrooms == 'Studio' ? 'Studio' : '$bedrooms bed',
                    color: Colors.blue,
                  ),
                if (bathrooms != null)
                  _Chip(
                    icon: Icons.bathtub_outlined,
                    label: '$bathrooms bath',
                    color: Colors.teal,
                  ),
                if (area != null)
                  _Chip(
                    icon: Icons.square_foot_outlined,
                    label: '${area}sqm',
                    color: Colors.green,
                  ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(height: 1),
            const SizedBox(height: 8),

            // Contact
            Row(
              children: [
                const Icon(Icons.person_outline, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  contact,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _Chip({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color.withValues(alpha: 0.8)),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}

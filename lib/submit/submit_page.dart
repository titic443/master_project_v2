import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_project/cubit/submit_cubit.dart';
import 'package:master_project/cubit/submit_state.dart';

class SubmitPage extends StatefulWidget {
  const SubmitPage({super.key});
  static const route = '/submit';

  @override
  State<SubmitPage> createState() => _SubmitPageState();
}

class _SubmitPageState extends State<SubmitPage> {
  late final SubmitCubit _cubit;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _cubit = context.read<SubmitCubit>();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _cubit.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ส่งคำร้อง')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocListener<SubmitCubit, SubmitState>(
          listenWhen: (prev, next) =>
              prev.response != next.response || prev.exception != next.exception,
          listener: (context, state) async {
            final response = state.response;
            if (response != null && response.code == 200) {
              await _showStatusDialog(
                context,
                message: 'Submission successful',
                messageKey: const Key('submit_status_200'),
              );
              if (!context.mounted) return;
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const _ConfirmationPage()),
              );
              return;
            }

            final exception = state.exception;
            if (exception != null) {
              final isBadRequest = exception.code == 400;
              await _showStatusDialog(
                context,
                message: isBadRequest
                    ? 'Invalid data'
                    : 'Server error ${exception.code}',
                messageKey: Key(isBadRequest
                    ? 'submit_status_400'
                    : 'submit_status_${exception.code}'),
              );
            }
          },
          child: BlocBuilder<SubmitCubit, SubmitState>(
            builder: (context, state) {
              _syncControllers(state);
              final theme = Theme.of(context);
              return SingleChildScrollView(
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'แบบฟอร์มส่งคำร้อง',
                            style: theme.textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'กรอกข้อมูลให้ครบถ้วนเพื่อส่งคำร้อง',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildTitleField(),
                          const SizedBox(height: 16),
                          _buildDescriptionField(),
                          const SizedBox(height: 16),
                          _buildCategoryDropdown(state),
                          const SizedBox(height: 24),
                          _buildPriorityRadioGroup(state, theme),
                          const SizedBox(height: 16),
                          _buildUrgentCheckbox(state),
                          const SizedBox(height: 32),
                          _buildSubmitButton(),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  TextFormField _buildTitleField() {
    return TextFormField(
      key: const Key('submit_title_textfield'),
      controller: _titleController,
      decoration: const InputDecoration(
        labelText: 'หัวข้อคำร้อง',
        prefixIcon: Icon(Icons.title),
        border: OutlineInputBorder(),
        helperText: 'ระบุหัวข้อที่ชัดเจนและกระชับ',
      ),
      maxLength: 100,
      onChanged: (value) => _cubit.onTitleChanged(value),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Required';
        if (value.length < 5) return 'Title must be at least 5 characters';
        return null;
      },
    );
  }

  TextFormField _buildDescriptionField() {
    return TextFormField(
      key: const Key('submit_description_textfield'),
      controller: _descriptionController,
      decoration: const InputDecoration(
        labelText: 'รายละเอียด',
        prefixIcon: Icon(Icons.description),
        border: OutlineInputBorder(),
        helperText: 'อธิบายรายละเอียดของคำร้อง',
      ),
      maxLines: 5,
      maxLength: 500,
      onChanged: (value) => _cubit.onDescriptionChanged(value),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Required';
        if (value.length < 10) {
          return 'Description must be at least 10 characters';
        }
        return null;
      },
    );
  }

  DropdownButtonFormField<String> _buildCategoryDropdown(SubmitState state) {
    return DropdownButtonFormField<String>(
      key: const Key('submit_category_dropdown'),
      decoration: const InputDecoration(
        labelText: 'หมวดหมู่',
        prefixIcon: Icon(Icons.category),
        border: OutlineInputBorder(),
      ),
      value: state.category,
      items: const [
        DropdownMenuItem(value: 'technical', child: Text('ปัญหาทางเทคนิค')),
        DropdownMenuItem(value: 'billing', child: Text('การเงิน')),
        DropdownMenuItem(value: 'general', child: Text('ทั่วไป')),
        DropdownMenuItem(value: 'complaint', child: Text('ร้องเรียน')),
      ],
      onChanged: (value) => _cubit.onCategorySelected(value),
      validator: (value) {
        if (value == null || value.isEmpty) return 'กรุณาเลือกหมวดหมู่';
        return null;
      },
    );
  }

  Widget _buildPriorityRadioGroup(SubmitState state, ThemeData theme) {
    return FormField<int>(
      key: const Key('submit_priority_group'),
      initialValue: state.priority,
      validator: (value) {
        if (value == null) return 'กรุณาเลือกระดับความสำคัญ';
        return null;
      },
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ระดับความสำคัญ',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildPriorityChip('ต่ำ', 0, field, Colors.green),
                _buildPriorityChip('ปานกลาง', 1, field, Colors.orange),
                _buildPriorityChip('สูง', 2, field, Colors.red),
                _buildPriorityChip('เร่งด่วน', 3, field, Colors.purple),
              ],
            ),
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  field.errorText!,
                  style: TextStyle(
                    color: theme.colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildPriorityChip(
    String label,
    int value,
    FormFieldState<int> field,
    Color color,
  ) {
    final isSelected = field.value == value;
    return ChoiceChip(
      key: Key('priority_${label.toLowerCase()}_radio'),
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          field.didChange(value);
          _cubit.onPrioritySelected(value);
        }
      },
      selectedColor: color.withOpacity(0.3),
      labelStyle: TextStyle(
        color: isSelected ? color : null,
        fontWeight: isSelected ? FontWeight.bold : null,
      ),
    );
  }

  Widget _buildUrgentCheckbox(SubmitState state) {
    return CheckboxListTile(
      key: const Key('submit_urgent_checkbox'),
      title: const Text('เรื่องเร่งด่วน'),
      subtitle: const Text('ต้องการการตอบกลับโดยเร็ว'),
      value: state.isUrgent,
      onChanged: (value) => _cubit.onUrgentChanged(value ?? false),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        key: const Key('submit_form_button'),
        onPressed: () async {
          final isValid = _formKey.currentState?.validate() ?? false;
          if (!isValid) return;
          await _cubit.callApi();
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text(
          'ส่งคำร้อง',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Future<void> _showStatusDialog(
    BuildContext context, {
    required String message,
    required Key messageKey,
  }) {
    return showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        content: Text(message, key: messageKey),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _syncControllers(SubmitState state) {
    _updateController(_titleController, state.title);
    _updateController(_descriptionController, state.description);
  }

  void _updateController(TextEditingController controller, String value) {
    if (controller.text == value) return;
    controller.value = controller.value.copyWith(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
      composing: TextRange.empty,
    );
  }
}

class _ConfirmationPage extends StatelessWidget {
  const _ConfirmationPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('submit_confirmation_root'),
      appBar: AppBar(title: const Text('ยืนยันการส่ง')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              size: 80,
              color: Colors.green[600],
            ),
            const SizedBox(height: 24),
            const Text(
              'ส่งคำร้องสำเร็จ',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'เราได้รับคำร้องของคุณแล้ว\nจะดำเนินการและติดต่อกลับโดยเร็วที่สุด',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

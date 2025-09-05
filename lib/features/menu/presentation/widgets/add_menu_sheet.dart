import 'package:flutter/material.dart';
import '../../constants/index.dart';
import '../../domain/entities/menu_item.dart';
import '../../../../common/theme/app_colors.dart';

enum MenuSheetMode { add, edit, view }

class AddMenuSheet extends StatefulWidget {
  final MenuSheetMode mode;
  final MenuItem? itemData;
  final Function(Map<String, dynamic>)? onSave;
  final VoidCallback onCancel;

  const AddMenuSheet({
    super.key,
    required this.mode,
    this.itemData,
    this.onSave,
    required this.onCancel,
  });

  @override
  State<AddMenuSheet> createState() => _AddMenuSheetState();
}

class _AddMenuSheetState extends State<AddMenuSheet> {
  final _formKey = GlobalKey<FormState>();
  final _itemNameController = TextEditingController();
  final _tagController = TextEditingController();
  final _priceController = TextEditingController();
  final _minPrepTimeController = TextEditingController();
  final _maxPrepTimeController = TextEditingController();
  final _maxOrdersController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _category;
  String? _dietaryType;
  final List<String> _tags = [];
  bool _isFullScreen = false;
  bool _available = true;

  @override
  void initState() {
    super.initState();
    if (widget.itemData != null) {
      _populateFields();
    }
  }

  void _populateFields() {
    final data = widget.itemData!;
    _itemNameController.text = data.name;
    _priceController.text = data.price.toString();
    _category = data.category;
    _dietaryType = data.dietaryDisplayText;
    _minPrepTimeController.text = data.minPrepTime.toString();
    _maxPrepTimeController.text = data.maxPrepTime.toString();
    _maxOrdersController.text = data.maxPossibleOrders.toString();
    _descriptionController.text = data.description;
    _available = data.available;
    _tags.addAll(data.tags);
  }

  String _mapDietaryToApi(String displayDietary) {
    return DietaryMapping.displayToApi[displayDietary] ?? 'veg';
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _tagController.dispose();
    _priceController.dispose();
    _minPrepTimeController.dispose();
    _maxPrepTimeController.dispose();
    _maxOrdersController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _addTag() {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  bool get _isReadOnly => widget.mode == MenuSheetMode.view;

  String get _title {
    switch (widget.mode) {
      case MenuSheetMode.add:
        return MenuTexts.addNewItem;
      case MenuSheetMode.edit:
        return MenuTexts.editItem;
      case MenuSheetMode.view:
        return MenuTexts.viewItem;
    }
  }

  String get _buttonText {
    switch (widget.mode) {
      case MenuSheetMode.add:
        return 'Add Item';
      case MenuSheetMode.edit:
        return 'Update Item';
      case MenuSheetMode.view:
        return 'Close';
    }
  }

  void _handleSave() {
    if (_formKey.currentState!.validate() &&
        _category != null &&
        _dietaryType != null) {
      final menuData = {
        'name': _itemNameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'price': double.tryParse(_priceController.text) ?? 0.0,
        'minPrepTime': int.tryParse(_minPrepTimeController.text) ?? 0,
        'maxPrepTime': int.tryParse(_maxPrepTimeController.text) ?? 0,
        'maxPossibleOrders': int.tryParse(_maxOrdersController.text) ?? 1,
        'tags': _tags,
        'category': _category!,
        'dietary': _mapDietaryToApi(_dietaryType!),
        'images': widget.itemData?.images ?? [],
        'available': _available,
      };

      widget.onSave?.call(menuData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        if (notification.extent == notification.maxExtent) {
          if (!_isFullScreen) {
            setState(() {
              _isFullScreen = true;
            });
          }
        } else if (_isFullScreen) {
          setState(() {
            _isFullScreen = false;
          });
        }
        return true;
      },
      child: DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.6,
        maxChildSize: 1.0,
        snap: true,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.only(
                    top: _isFullScreen ? 30 : 15,
                    bottom: _isFullScreen ? 10 : 0,
                    left: 20,
                    right: 20,
                  ),
                  color: _isFullScreen ? AppColors.background : Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInputField(
                            label: 'Item Name',
                            controller: _itemNameController,
                            hintText: 'e.g. Chicken Tikka',
                            readOnly: _isReadOnly,
                          ),
                          const SizedBox(height: 20),
                          _buildTagsField(),
                          const SizedBox(height: 20),
                          _buildInputField(
                            label: 'Price (\$)',
                            controller: _priceController,
                            hintText: '0.00',
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            readOnly: _isReadOnly,
                          ),
                          const SizedBox(height: 20),
                          _buildDropdownField(
                            label: 'Category',
                            value: _category,
                            items: kMenuCategories,
                            hintText: 'Appetizer',
                            onChanged:
                                _isReadOnly
                                    ? null
                                    : (value) {
                                      setState(() {
                                        _category = value;
                                      });
                                    },
                          ),
                          const SizedBox(height: 20),
                          _buildInputField(
                            label: 'Min Prep Time (mins)',
                            controller: _minPrepTimeController,
                            hintText: '0',
                            keyboardType: TextInputType.number,
                            readOnly: _isReadOnly,
                          ),
                          const SizedBox(height: 20),
                          _buildInputField(
                            label: 'Max Prep Time (mins)',
                            controller: _maxPrepTimeController,
                            hintText: '0',
                            keyboardType: TextInputType.number,
                            readOnly: _isReadOnly,
                          ),
                          const SizedBox(height: 20),
                          _buildInputField(
                            label: 'Max Possible Orders',
                            controller: _maxOrdersController,
                            hintText: '1',
                            keyboardType: TextInputType.number,
                            readOnly: _isReadOnly,
                          ),
                          const SizedBox(height: 20),
                          _buildDropdownField(
                            label: 'Dietary Type',
                            value: _dietaryType,
                            items: kDietaryTypes,
                            hintText: 'Non-Vegetarian',
                            onChanged:
                                _isReadOnly
                                    ? null
                                    : (value) {
                                      setState(() {
                                        _dietaryType = value;
                                      });
                                    },
                          ),
                          const SizedBox(height: 20),
                          _buildInputField(
                            label: 'Description',
                            controller: _descriptionController,
                            hintText: 'Describe your dish',
                            maxLines: 4,
                            readOnly: _isReadOnly,
                          ),
                          const SizedBox(height: 20),
                          _buildImageUploadSection(),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child:
                      widget.mode == MenuSheetMode.view
                          ? SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: widget.onCancel,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey.shade600,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Close',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                          : Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: widget.onCancel,
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    side: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _handleSave,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    _buttonText,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
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

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    String? hintText,
    TextInputType keyboardType = TextInputType.text,
    int? maxLines,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines ?? 1,
          readOnly: readOnly,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.blue),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            filled: readOnly,
            fillColor: readOnly ? Colors.grey.shade50 : null,
          ),
          validator:
              readOnly
                  ? null
                  : (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
        ),
      ],
    );
  }

  Widget _buildTagsField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tags',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        if (!_isReadOnly)
          TextFormField(
            controller: _tagController,
            decoration: InputDecoration(
              hintText: 'Add tags and press Enter',
              hintStyle: TextStyle(color: Colors.grey.shade400),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.blue),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            onFieldSubmitted: (value) {
              _addTag();
            },
          ),
        if (_tags.isNotEmpty) ...[
          SizedBox(height: _isReadOnly ? 0 : 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                _tags.map((tag) {
                  return Chip(
                    label: Text(tag, style: const TextStyle(fontSize: 12)),
                    deleteIcon:
                        _isReadOnly ? null : const Icon(Icons.close, size: 16),
                    onDeleted: _isReadOnly ? null : () => _removeTag(tag),
                    backgroundColor: Colors.blue.shade50,
                    deleteIconColor: Colors.blue.shade700,
                    side: BorderSide(color: Colors.blue.shade200),
                  );
                }).toList(),
          ),
        ],
        if (_isReadOnly && _tags.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'No tags added',
              style: TextStyle(color: Colors.grey.shade400),
            ),
          ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?>? onChanged,
    String? hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.blue),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            filled: _isReadOnly,
            fillColor: _isReadOnly ? Colors.grey.shade50 : null,
          ),
          items:
              items.map((String item) {
                return DropdownMenuItem<String>(value: item, child: Text(item));
              }).toList(),
          onChanged: onChanged,
          validator:
              _isReadOnly
                  ? null
                  : (value) => value == null ? 'This field is required' : null,
        ),
      ],
    );
  }

  Widget _buildImageUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Image',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        if (!_isReadOnly)
          Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cloud_upload_outlined,
                  size: 32,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 8),
                Text(
                  MenuTexts.imageUploadHint,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        const SizedBox(height: 16),
        Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child:
                    widget.itemData?.images.isNotEmpty == true
                        ? Image.network(
                          widget.itemData!.primaryImage,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey.shade200,
                              child: Icon(
                                Icons.restaurant,
                                color: Colors.grey.shade400,
                              ),
                            );
                          },
                        )
                        : Container(
                          color: Colors.grey.shade200,
                          child: Icon(
                            Icons.restaurant,
                            color: Colors.grey.shade400,
                          ),
                        ),
              ),
            ),
            if (!_isReadOnly) ...[
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () {
                  // Handle image upload
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade300,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.add, color: Colors.grey.shade400, size: 24),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

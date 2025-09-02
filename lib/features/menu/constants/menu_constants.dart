/// Categories for menu items (matching API response)
const List<String> kMenuCategories = [
  'Appetizer',
  'Main Course',
  'Side Dish',
  'Dessert',
  'Beverages',
];

/// Dietary types for menu items (display names)
const List<String> kDietaryTypes = [
  'Vegetarian',
  'Non-Vegetarian',
  'Vegan',
  'Gluten-Free',
];

/// Text constants
class MenuTexts {
  static const addNewItem = 'Add New Item';
  static const editItem = 'Edit Item';
  static const viewItem = 'View Item';
  static const imageUploadHint = 'Drag and drop image here or click to browse';
}

/// API dietary mapping
class DietaryMapping {
  static const Map<String, String> displayToApi = {
    'Vegetarian': 'veg',
    'Non-Vegetarian': 'non-veg',
    'Vegan': 'vegan',
    'Gluten-Free': 'gluten-free',
  };

  static const Map<String, String> apiToDisplay = {
    'veg': 'Vegetarian',
    'non-veg': 'Non-Vegetarian',
    'vegan': 'Vegan',
    'gluten-free': 'Gluten-Free',
  };
}
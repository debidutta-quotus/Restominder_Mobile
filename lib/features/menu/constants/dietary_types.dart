const List<String> kDietaryTypes = [
  'Vegetarian',
  'Non-Vegetarian',
  'Vegan',
  'Gluten-Free',
];

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
class Validators {
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your full name';
    }

    final trimmedValue = value.trim();

    if (RegExp(r'^\d').hasMatch(trimmedValue)) {
      return 'Name cannot start with a number';
    }

    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return null; // Optional field
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    final cleanedValue = value.replaceAll(RegExp(r'\D'), '');
    if (cleanedValue.length < 9 || cleanedValue.length > 15) {
      return 'Enter a valid phone number';
    }

    return null; // No error
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one digit';
    }
    if (!RegExp(r'[!@#\$&*~_]').hasMatch(value)) {
      return 'Password must include a special character (!@#\$&*~_)';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }
}

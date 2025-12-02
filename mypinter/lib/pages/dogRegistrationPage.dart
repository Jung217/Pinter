import 'package:flutter/material.dart';
import 'package:mypinter/config/l10n.dart';

class DogRegistrationPage extends StatefulWidget {
  const DogRegistrationPage({super.key});

  @override
  State<DogRegistrationPage> createState() => _DogRegistrationPageState();
}

class _DogRegistrationPageState extends State<DogRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dogNameController = TextEditingController();
  final TextEditingController _chipIdController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  
  String? _selectedGender;
  String? _photoPath;

  void _selectPhoto() {
    // In a real app, this would open image picker
    setState(() {
      _photoPath = 'https://i.pravatar.cc/300?img=${DateTime.now().millisecond}';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(L10n.of(context, 'selectPhoto'))),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedGender == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(L10n.of(context, 'pleaseSelectGender'))),
        );
        return;
      }

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(L10n.of(context, 'registrationSuccess'))),
      );

      // In a real app, submit data to backend
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context, 'dogRegistration')),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Photo Section
                Center(
                  child: GestureDetector(
                    onTap: _selectPhoto,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: colorScheme.primary,
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: _photoPath != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.network(
                                _photoPath!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate,
                                  size: 48,
                                  color: colorScheme.primary,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  L10n.of(context, 'selectPhoto'),
                                  style: TextStyle(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Dog Name
                TextFormField(
                  controller: _dogNameController,
                  decoration: InputDecoration(
                    labelText: L10n.of(context, 'dogName'),
                    hintText: L10n.of(context, 'pleaseEnterDogName'),
                    prefixIcon: const Icon(Icons.pets),
                    filled: true,
                    fillColor: theme.cardTheme.color,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colorScheme.outline),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colorScheme.outline),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colorScheme.primary),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return L10n.of(context, 'pleaseEnterDogName');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Gender
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  decoration: InputDecoration(
                    labelText: L10n.of(context, 'gender'),
                    prefixIcon: const Icon(Icons.wc),
                    filled: true,
                    fillColor: theme.cardTheme.color,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colorScheme.outline),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colorScheme.outline),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colorScheme.primary),
                    ),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'male',
                      child: Text(L10n.of(context, 'male')),
                    ),
                    DropdownMenuItem(
                      value: 'female',
                      child: Text(L10n.of(context, 'female')),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Chip ID
                TextFormField(
                  controller: _chipIdController,
                  decoration: InputDecoration(
                    labelText: '${L10n.of(context, 'chipId')} (${L10n.of(context, 'optional')})',
                    hintText: L10n.of(context, 'chipId'),
                    prefixIcon: const Icon(Icons.qr_code),
                    filled: true,
                    fillColor: theme.cardTheme.color,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colorScheme.outline),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colorScheme.outline),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colorScheme.primary),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // City
                TextFormField(
                  controller: _cityController,
                  decoration: InputDecoration(
                    labelText: L10n.of(context, 'city'),
                    hintText: L10n.of(context, 'pleaseEnterCity'),
                    prefixIcon: const Icon(Icons.location_city),
                    filled: true,
                    fillColor: theme.cardTheme.color,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colorScheme.outline),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colorScheme.outline),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colorScheme.primary),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return L10n.of(context, 'pleaseEnterCity');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Master's Lastname
                TextFormField(
                  controller: _lastnameController,
                  decoration: InputDecoration(
                    labelText: L10n.of(context, 'masterLastname'),
                    hintText: L10n.of(context, 'pleaseEnterLastname'),
                    prefixIcon: const Icon(Icons.person),
                    filled: true,
                    fillColor: theme.cardTheme.color,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colorScheme.outline),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colorScheme.outline),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colorScheme.primary),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return L10n.of(context, 'pleaseEnterLastname');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Submit Button
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    L10n.of(context, 'submit'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Cancel Button
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: colorScheme.outline),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    L10n.of(context, 'cancel'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _dogNameController.dispose();
    _chipIdController.dispose();
    _cityController.dispose();
    _lastnameController.dispose();
    super.dispose();
  }
}

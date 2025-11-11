import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

const Color kCardColor = AppTheme.cardColor;
const Color kPrimaryColor = AppTheme.primaryColor;
const Color kForegroundColor = AppTheme.foregroundColor;
const double kBorderRadius = AppTheme.borderRadius;

class AppTheme {
  static const Color primaryBackgroundColor = Color(0xffF9F9F9);
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color foregroundColor = Color(0xFF1F2937);
  static const Color primaryColor = Color(0xFF4F46E5);
  static const Color softBorderColor = Color(0xFFE5E7EB);
  static const Color codeBackground = Color(0xFFF1F5F9);
  static const double borderRadius = 7.0;

  static final OutlineInputBorder inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(borderRadius),
    borderSide: const BorderSide(color: softBorderColor, width: 1),
  );
}

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  ThemeData _buildTheme(BuildContext context) {
    return ThemeData(
      textTheme: GoogleFonts.ibmPlexSansArabicTextTheme(
        Theme.of(context).textTheme.apply(
          bodyColor: AppTheme.foregroundColor,
          displayColor: AppTheme.foregroundColor,
        ),
      ),
      colorScheme: const ColorScheme.light(
        primary: AppTheme.primaryColor,
        onSurface: AppTheme.foregroundColor,
        surface: AppTheme.cardColor,
        background: AppTheme.primaryBackgroundColor,
      ),
      scaffoldBackgroundColor: AppTheme.primaryBackgroundColor,
      useMaterial3: false,

      // 3. Input/Form Theme Update
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppTheme.cardColor,
        labelStyle: TextStyle(color: AppTheme.foregroundColor.withOpacity(0.7)),
        floatingLabelStyle: const TextStyle(
          color: AppTheme.primaryColor,
          fontWeight: FontWeight.w500,
        ),
        enabledBorder: AppTheme.inputBorder,
        focusedBorder: AppTheme.inputBorder.copyWith(
          borderSide: const BorderSide(
            color: AppTheme.primaryColor,
            width: 1.5,
          ),
        ),
        border: AppTheme.inputBorder,
        errorBorder: AppTheme.inputBorder.copyWith(
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: AppTheme.inputBorder.copyWith(
          borderSide: const BorderSide(color: Colors.red, width: 2.0),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      // 4. Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: AppTheme.cardColor,
          elevation: 2, // Less pronounced shadow in modern web
          shadowColor: AppTheme.primaryColor.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          ),
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            inherit: true,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Forma',
      theme: _buildTheme(context),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

enum FieldType { text, email, mobile, password, integer, decimal, date, url }

extension FieldTypeExtensions on FieldType {
  TextInputType get keyboardType {
    switch (this) {
      case FieldType.email:
        return TextInputType.emailAddress;
      case FieldType.mobile:
        return TextInputType.phone;
      case FieldType.integer:
        return TextInputType.numberWithOptions(signed: false, decimal: false);
      case FieldType.decimal:
        return TextInputType.numberWithOptions(decimal: true, signed: true);
      case FieldType.date:
        return TextInputType.datetime;
      case FieldType.url:
        return TextInputType.url;
      case FieldType.password:
      default:
        return TextInputType.text;
    }
  }

  bool get isObscure => this == FieldType.password;

  static FieldType fromKey(String key) {
    final lowerKey = key.toLowerCase();
    if (lowerKey.contains('password') || lowerKey.contains('secret')) {
      return FieldType.password;
    }
    return FieldType.text;
  }

  static FieldType fromValue(String value) {
    if (value.isEmpty) return FieldType.text;

    final sanitizedValue = value.trim();

    if (RegExp(
      r'^(https?|ftp)://[^\s/$.?#].[^\s]*$',
    ).hasMatch(sanitizedValue)) {
      return FieldType.url;
    }

    if (RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,63}$',
    ).hasMatch(sanitizedValue)) {
      return FieldType.email;
    }

    if (RegExp(r'^\-?\d+[\.,]\d+$').hasMatch(sanitizedValue)) {
      return FieldType.decimal;
    }

    if (RegExp(r'^\-?\d+$').hasMatch(sanitizedValue)) {
      if (sanitizedValue.length >= 8) {
        return FieldType.mobile;
      }
      return FieldType.integer;
    }

    if (RegExp(
          r'^\d{4}[\-/\.]\d{1,2}[\-/\.]\d{1,2}$',
        ).hasMatch(sanitizedValue) ||
        RegExp(
          r'^\d{1,2}[\-/\.]\d{1,2}[\-/\.]\d{4}$',
        ).hasMatch(sanitizedValue)) {
      return FieldType.date;
    }

    return FieldType.text;
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ValueNotifier<Map<String, dynamic>> formDataNotifier = ValueNotifier({
    "full_name": "Hanaa Alharbi",
    "user_email": "user@example.com",
    "phone": "0555555555",
    "password": "e8383838",
    "quantity": "5",
    "start_date": "2025-10-20",
    "homepage": "https://google.com",
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset("assets/logo1.png", width: 110),
            Text("Hanaa Alharbi"),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.foregroundColor),
        titleTextStyle: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: AppTheme.foregroundColor),
      ),
      body: Row(
        children: [
          Expanded(
            child: FormBuilderScreen(formDataNotifier: formDataNotifier),
          ),
          Container(width: 1, color: AppTheme.softBorderColor),

          Expanded(
            child: ValueListenableBuilder<Map<String, dynamic>>(
              valueListenable: formDataNotifier,
              builder: (context, formData, _) {
                return CodeGeneratorScreen(formData: formData);
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    formDataNotifier.dispose();
    super.dispose();
  }
}

class FormBuilderScreen extends StatefulWidget {
  final ValueNotifier<Map<String, dynamic>> formDataNotifier;

  const FormBuilderScreen({super.key, required this.formDataNotifier});

  @override
  State<FormBuilderScreen> createState() => _FormBuilderScreenState();
}

class _FormBuilderScreenState extends State<FormBuilderScreen> {
  final _jsonController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _jsonError;
  String _outputJson = 'Submit the form to see the final JSON output.';
  final Map<String, String> _formDataMap = {};

  @override
  void initState() {
    super.initState();
    _updateJsonText();
    widget.formDataNotifier.addListener(_updateJsonText);
    _formDataMap.addAll(
      widget.formDataNotifier.value.map((k, v) => MapEntry(k, v.toString())),
    );
  }

  @override
  void dispose() {
    widget.formDataNotifier.removeListener(_updateJsonText);
    _jsonController.dispose();
    super.dispose();
  }

  void _updateJsonText() {
    if (!_jsonController.selection.isCollapsed) return;
    try {
      final newJsonText = const JsonEncoder.withIndent(
        '  ',
      ).convert(widget.formDataNotifier.value);
      if (_jsonController.text != newJsonText) {
        _jsonController.text = newJsonText;
      }
    } catch (e) {}
  }

  void _parseJson(String jsonString) {
    try {
      final decoded = json.decode(jsonString);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('JSON must be a valid object (Map)');
      }
      setState(() {
        _jsonError = null;
        widget.formDataNotifier.value = Map<String, dynamic>.from(decoded);
        _formDataMap.clear();
        _formDataMap.addAll(decoded.map((k, v) => MapEntry(k, v.toString())));
        _outputJson = 'Submit the form to see the final JSON output.';
      });
    } on FormatException catch (e) {
      setState(() {
        _jsonError = e.toString().contains('FormatException:')
            ? e.toString().split('FormatException: ').last
            : 'Invalid JSON format.';
      });
    } catch (e) {
      setState(() {
        _jsonError = 'An unknown error occurred during parsing.';
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();

      final encoder = const JsonEncoder.withIndent('  ');
      final finalJson = encoder.convert(_formDataMap);

      setState(() {
        _outputJson = finalJson;
      });
    } else {
      setState(() {
        _outputJson =
            'Validation Failed. Please correct the errors before submitting.';
      });
    }
  }

  String? _validateField(String key, String? value, FieldType type) {
    if (value == null || value.isEmpty) return '$key is required';

    final val = value.trim();

    switch (type) {
      case FieldType.email:
        if (!RegExp(
          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,63}$',
        ).hasMatch(val)) {
          return 'Enter a valid email address';
        }
        break;
      case FieldType.mobile:
        if (!RegExp(r'^\+?[\d\s\-\.]{8,}$').hasMatch(val)) {
          return 'Enter a valid mobile number (min 8 digits)';
        }
        break;
      case FieldType.password:
        if (val.length < 6) {
          return 'Password must be at least 6 characters';
        }
        break;
      case FieldType.integer:
        if (int.tryParse(val) == null) {
          return 'Enter a whole number';
        }
        break;
      case FieldType.decimal:
        if (double.tryParse(val.replaceAll(',', '.')) == null) {
          return 'Enter a valid decimal number';
        }
        break;
      case FieldType.url:
        if (!RegExp(r'^(https?|ftp)://[^\s/$.?#].[^\s]*$').hasMatch(val)) {
          return 'Enter a valid URL';
        }
        break;
      default:
        break;
    }
    return null;
  }

  InputDecoration _getInputDecoration(String key) {
    return InputDecoration(labelText: key, hintText: 'Enter $key');
  }

  Color _getTypeColor(FieldType type) {
    switch (type) {
      case FieldType.password:
        return Colors.deepOrange;
      case FieldType.email:
        return const Color.fromARGB(255, 124, 117, 255);
      case FieldType.mobile:
      case FieldType.integer:
      case FieldType.decimal:
        return const Color.fromARGB(255, 89, 196, 93);
      case FieldType.date:
        return const Color.fromARGB(255, 121, 190, 225);
      case FieldType.url:
        return const Color.fromARGB(255, 225, 113, 244);
      default:
        return Color(0xffEF4444);
    }
  }

  Widget _buildFormField(
    MapEntry<String, dynamic> entry,
    Map<String, dynamic> currentData,
  ) {
    final key = entry.key;
    final value = entry.value.toString();

    final FieldType valueType = FieldTypeExtensions.fromValue(value);
    final FieldType keyType = FieldTypeExtensions.fromKey(key);
    final type = keyType == FieldType.password ? keyType : valueType;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextFormField(
                key: ValueKey(key),
                initialValue: value,
                obscureText: type.isObscure,
                decoration: _getInputDecoration(key).copyWith(
                  filled: true,
                  fillColor: Colors.transparent,
                  enabledBorder: AppTheme.inputBorder.copyWith(
                    borderSide: BorderSide(
                      color: AppTheme.softBorderColor,
                      width: 1,
                    ),
                  ),
                  focusedBorder: AppTheme.inputBorder.copyWith(
                    borderSide: BorderSide(
                      color: AppTheme.primaryColor,
                      width: 1.5,
                    ),
                  ),
                  border: AppTheme.inputBorder.copyWith(
                    borderSide: BorderSide(
                      color: AppTheme.softBorderColor,
                      width: 1,
                    ),
                  ),
                ),
                keyboardType: type.keyboardType,
                validator: (val) => _validateField(key, val, type),
                onChanged: (newValue) {
                  final newData = Map.from(currentData);
                  newData[key] = newValue ?? '';
                  widget.formDataNotifier.value = Map<String, dynamic>.from(
                    newData,
                  );
                },
                onSaved: (newValue) {
                  _formDataMap[key] = newValue ?? '';
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            decoration: BoxDecoration(
              color: _getTypeColor(type),
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            ),
            child: Text(
              type.name.capitalize(),
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: AppTheme.cardColor,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final jsonEditorDecoration = _getInputDecoration('Key-Value Pairs')
        .copyWith(
          hintText:
              '{"key": "value", "email": "test@example.com", "price": "99.50"}',
          errorText: _jsonError,
          suffixIcon: IconButton(
            icon: Icon(
              Icons.clear,
              size: 20,
              color: AppTheme.foregroundColor.withOpacity(0.6),
            ),
            onPressed: () => _jsonController.clear(),
          ),
        );

    return Container(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '1. JSON Schema',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.foregroundColor,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _jsonController,
              maxLines: 5,
              style: GoogleFonts.firaCode(
                fontSize: 14,
                color: AppTheme.foregroundColor,
              ),
              decoration: jsonEditorDecoration,
              onChanged: _parseJson,
            ),
            const SizedBox(height: 24),
            Text(
              '2. Preview',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.foregroundColor,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ValueListenableBuilder<Map<String, dynamic>>(
                valueListenable: widget.formDataNotifier,
                builder: (context, formData, _) {
                  return Form(
                    key: _formKey,
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        const SizedBox(height: 5),
                        ...formData.entries.map((entry) {
                          return _buildFormField(entry, formData);
                        }),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _submitForm,
                          child: const Text('Submit'),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          '3. Output JSON',
                          style: Theme.of(context).textTheme.titleLarge!
                              .copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.foregroundColor,
                              ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.codeBackground,
                            borderRadius: BorderRadius.circular(
                              AppTheme.borderRadius,
                            ),
                            border: Border.all(
                              color: AppTheme.softBorderColor,
                              width: 1,
                            ),
                          ),
                          child: SelectableText(
                            _outputJson,
                            style: GoogleFonts.firaCode(
                              color: AppTheme.foregroundColor,
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// right panel

class CodeGeneratorScreen extends StatelessWidget {
  final Map<String, dynamic> formData;
  const CodeGeneratorScreen({super.key, required this.formData});

  String _generateFieldConfig(MapEntry<String, dynamic> entry) {
    final key = entry.key;
    final value = entry.value.toString().replaceAll("'", "\\'");
    final FieldType valueType = FieldTypeExtensions.fromValue(value);
    final FieldType keyType = FieldTypeExtensions.fromKey(key);
    final type = keyType == FieldType.password ? keyType : valueType;

    String keyboardType;
    switch (type) {
      case FieldType.email:
        keyboardType = 'TextInputType.emailAddress';
        break;
      case FieldType.mobile:
        keyboardType = 'TextInputType.phone';
        break;
      case FieldType.decimal:
        keyboardType = 'TextInputType.numberWithOptions(decimal: true)';
        break;
      case FieldType.integer:
        keyboardType = 'TextInputType.number';
        break;
      case FieldType.url:
        keyboardType = 'TextInputType.url';
        break;
      default:
        keyboardType = 'TextInputType.text';
    }

    return '''
    FieldConfig(
      key: '$key',
      initialValue: '$value',
      isObscure: ${type == FieldType.password},
      keyboardType: $keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$key is required';
        }
        ${_generateValidation(key, type)}
        return null;
      }
    )''';
  }

  String _generateValidation(String key, FieldType type) {
    switch (type) {
      case FieldType.email:
        return '''
        if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,63}\$').hasMatch(value!)) {
          return 'Please enter a valid email address';
        }''';
      case FieldType.mobile:
        return '''
        if (!RegExp(r'^\\+?[0-9]{8,15}\$').hasMatch(value!)) {
          return 'Please enter a valid phone number (8-15 digits)';
        }''';
      case FieldType.password:
        return '''
        if (value!.length < 6) {
          return 'Password must be at least 6 characters';
        }
        // Basic check for mixed letters and numbers
        if (!RegExp(r'^(?=.*?[A-Za-z])(?=.*?[0-9]).{6,}\$').hasMatch(value)) {
          return 'Password must contain both letters and numbers';
        }''';
      case FieldType.decimal:
        return '''
        final parsedValue = double.tryParse(value!.replaceAll(',', '.'));
        if (parsedValue == null) {
          return 'Please enter a valid decimal number';
        }''';
      case FieldType.integer:
        return '''
        final parsedValue = int.tryParse(value!);
        if (parsedValue == null) {
          return 'Please enter a whole number';
        }''';
      case FieldType.url:
        return '''
        if (!RegExp(r'^(https?|ftp):\\/\\/[^\\s\\/\\.\\?#][^\\s]*\$').hasMatch(value!)) {
          return 'Please enter a valid URL';
        }''';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final fieldConfigs = formData.entries.map(_generateFieldConfig).join(',\n');

    final generatedCode =
        '''
// To run this code quickly, ensure you have:
// 1. A Flutter project initialized.
// 2. The \'google_fonts\' package included in your pubspec.yaml.
// 3. Replace the contents of main.dart with this entire block.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color kCardColor = Color(0xFFFFFFFF); // Pure White
const Color kPrimaryColor = Color(0xFF4F46E5); // Indigo/Blue Accent
const Color kForegroundColor = Color(0xFF1F2937); // Dark Text
const double kBorderRadius = 8.0;
const Color kSoftBorderColor = Color(0xFFE5E7EB); // Light border for inputs

// --- Form Field Configuration Structure ---
class FieldConfig {
  final String key;
  final String initialValue;
  final bool isObscure;
  final TextInputType keyboardType;
  final String? Function(String?) validator;

  const FieldConfig({
    required this.key,
    required this.initialValue,
    this.isObscure = false,
    required this.keyboardType,
    required this.validator,
  });
}

// --- Generated Form Widget ---
class GeneratedForm extends StatefulWidget {
  const GeneratedForm({super.key});

  @override
  State<GeneratedForm> createState() => _GeneratedFormState();
}

class _GeneratedFormState extends State<GeneratedForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};

  final fields = [
$fieldConfigs
  ];

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();
      debugPrint('Form Data: \$_formData');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Form Submitted: \$_formData'),
          backgroundColor: kPrimaryColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final generatedTheme = ThemeData(
      textTheme: GoogleFonts.poppinsTextTheme(
        Theme.of(context).textTheme.apply(
          bodyColor: kForegroundColor,
          displayColor: kForegroundColor,
        ),
      ),
      colorScheme: const ColorScheme.light( 
        primary: kPrimaryColor,
        background: Color(0xFFF9FAFB), 
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: kCardColor,
        labelStyle: TextStyle(color: kForegroundColor.withOpacity(0.7)),
        floatingLabelStyle: const TextStyle(
          color: kPrimaryColor,
          fontWeight: FontWeight.w500,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
          borderSide: const BorderSide(color: kSoftBorderColor, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
          borderSide: const BorderSide(color: kPrimaryColor, width: 1.5),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
          borderSide: const BorderSide(color: kSoftBorderColor, width: 1.0),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          foregroundColor: kCardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kBorderRadius),
          ),
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
        ),
      ),
      useMaterial3: false,
    );

    return MaterialApp(
      title: 'Generated Form',
      theme: generatedTheme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB), 
        appBar: AppBar(
          title: const Text('Generated Rich Form'),
          backgroundColor: kCardColor, // White app bar
          elevation: 1,
        ),
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            margin: const EdgeInsets.all(24.0),
            padding: const EdgeInsets.all(32.0),
            decoration: BoxDecoration(
              color: kCardColor,
              borderRadius: BorderRadius.circular(kBorderRadius * 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Complete Your Information',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: kForegroundColor, 
                        fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    // --- SHADOW IMPLEMENTATION FOR GENERATED CODE ---
                    ...fields.map((field) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: kCardColor,
                          borderRadius: BorderRadius.circular(kBorderRadius),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04), // Subtle shadow
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          initialValue: field.initialValue,
                          decoration: InputDecoration(
                            labelText: field.key,
                            hintText: 'Enter \${field.key}',
                            fillColor: Colors.transparent, // Transparent to show Container's color
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(kBorderRadius),
                              borderSide: const BorderSide(color: kSoftBorderColor, width: 1.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(kBorderRadius),
                              borderSide: const BorderSide(color: kPrimaryColor, width: 1.5),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(kBorderRadius),
                              borderSide: const BorderSide(color: kSoftBorderColor, width: 1.0),
                            ),
                          ),
                          obscureText: field.isObscure,
                          keyboardType: field.keyboardType,
                          validator: field.validator,
                          onSaved: (value) => _formData[field.key] = value ?? '',
                        ),
                      ),
                    )),
                    // --- END SHADOW IMPLEMENTATION FOR GENERATED CODE ---
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Submit Form'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- Main function to run the generated form standalone ---
// void main() => runApp(const GeneratedForm());
''';

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '4. Generated Code',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.foregroundColor,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.codeBackground,
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                  border: Border.all(color: AppTheme.softBorderColor, width: 1),
                ),
                child: SelectableText(
                  generatedCode.trim(),
                  style: GoogleFonts.firaCode(
                    color: AppTheme.foregroundColor,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// File: matrimony_registration_form.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MultiStepForm extends StatefulWidget {
  const MultiStepForm({super.key});

  @override
  State<MultiStepForm> createState() => _MultiStepFormState();
}

class _MultiStepFormState extends State<MultiStepForm> {
  int _currentStep = 0;
  final _formKeys = List.generate(6, (_) => GlobalKey<FormState>());

  // Form 1 - Account & Profile
  String? profileCreatedBy;
  String? gender;
  final _nameController = TextEditingController();
  DateTime? _dateOfBirth;
  int? _age;
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Form 2 - Personal Details
  final _heightController = TextEditingController();
  String? maritalStatus;
  final _motherTongueController = TextEditingController();
  String? physicalStatus;

  // Form 3 - Religion & Caste
  final _religionController = TextEditingController();
  final _casteController = TextEditingController();
  final _subCasteController = TextEditingController();
  final _gothramController = TextEditingController();
  final _starRashiController = TextEditingController();
  String? manglikDosham;

  // Form 4 - Education & Profession
  final _educationController = TextEditingController();
  final _collegeController = TextEditingController();
  final _occupationController = TextEditingController();
  String? employedIn;
  final _incomeController = TextEditingController();
  final _organizationController = TextEditingController();
  final _experienceController = TextEditingController();

  // Form 5 - Family & Lifestyle
  final _fatherOccupationController = TextEditingController();
  final _motherOccupationController = TextEditingController();
  final _brothersController = TextEditingController();
  final _sistersController = TextEditingController();
  String? familyType;

  // Form 6 - Location & Contact
  final _countryController = TextEditingController();
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _nativePlaceController = TextEditingController();

  // Image handling for both web and mobile
  XFile? _pickedImageFile;
  bool _hasProfileImage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matrimony Registration',
            style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 48, 34, 198),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildProgressIndicator(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: _buildCurrentForm(),
            ),
          ),
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
  return Container(
    padding: const EdgeInsets.all(16),
    color: Colors.white,
    child: LinearProgressIndicator(
      value: (_currentStep + 1) / 6,
      minHeight: 8,
      backgroundColor: Colors.grey.shade300,
      color: Colors.blue,
    ),
  );
}


  String _getStepTitle() {
    switch (_currentStep) {
      case 0:
        return 'Account & Profile';
      case 1:
        return 'Personal Details';
      case 2:
        return 'Religion & Caste';
      case 3:
        return 'Education & Profession';
      case 4:
        return 'Family & Lifestyle';
      case 5:
        return 'Location & Contact';
      default:
        return '';
    }
  }

  Widget _buildCurrentForm() {
    switch (_currentStep) {
      case 0:
        return _buildForm1();
      case 1:
        return _buildForm2();
      case 2:
        return _buildForm3();
      case 3:
        return _buildForm4();
      case 4:
        return _buildForm5();
      case 5:
        return _buildForm6();
      default:
        return Container();
    }
  }

  Widget _buildForm1() {
    return Form(
      key: _formKeys[0],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Account & Profile Creation'),
          const SizedBox(height: 20),
          _buildImagePicker(),
          const SizedBox(height: 20),
          _buildDropdown(
            label: 'Profile Created By *',
            value: profileCreatedBy,
            items: ['Self', 'Parent', 'Sibling', 'Relative', 'Friend'],
            onChanged: (val) => setState(() => profileCreatedBy = val),
            validator: (val) => val == null ? 'Required' : null,
          ),
          _buildDropdown(
            label: 'Gender *',
            value: gender,
            items: ['Male', 'Female', 'Other'],
            onChanged: (val) => setState(() => gender = val),
            validator: (val) => val == null ? 'Required' : null,
          ),
          _buildTextField(
            controller: _nameController,
            label: 'Full Name *',
            validator: (val) {
              if (val == null || val.isEmpty) return 'Name is required';
              if (val.trim().length < 2)
                return 'Name must be at least 2 characters';
              if (RegExp(r'[0-9]').hasMatch(val))
                return 'Name cannot contain numbers';
              if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(val))
                return 'Only letters and spaces allowed';
              return null;
            },
          ),
          _buildDatePicker(),
          if (_age != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                'Age: $_age years',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          _buildTextField(
            controller: _mobileController,
            label: 'Mobile Number *',
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              TextInputFormatter.withFunction((oldValue, newValue) {
                if (newValue.text.length > 10) {
                  return oldValue;
                }
                return newValue;
              }),
            ],
            validator: (val) {
              if (val == null || val.isEmpty)
                return 'Mobile number is required';
              if (val.length != 10)
                return 'Mobile number must be exactly 10 digits';
              if (!RegExp(r'^[6-9][0-9]{9}$').hasMatch(val)) {
                return 'Enter valid Indian mobile number';
              }
              return null;
            },
          ),
          _buildTextField(
            controller: _emailController,
            label: 'Email ID *',
            keyboardType: TextInputType.emailAddress,
            validator: (val) {
              if (val == null || val.isEmpty) {
                return 'Email is required';
              }

              final email = val.trim().toLowerCase();

              // ✅ Only Gmail allowed
              if (!email.endsWith('@gmail.com')) {
                return 'Only @gmail.com email addresses are allowed';
              }

              // ✅ Valid Gmail format
              if (!RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$').hasMatch(email)) {
                return 'Enter a valid Gmail address';
              }

              return null;
            },
          ),
          _buildTextField(
            controller: _passwordController,
            label: 'Password *',
            obscureText: true,
            validator: (val) {
              if (val == null || val.isEmpty) return 'Password is required';
              if (val.length < 8)
                return 'Password must be at least 8 characters';
              if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(val)) {
                return 'Password must contain uppercase, lowercase & number';
              }
              return null;
            },
          ),
          _buildTextField(
            controller: _confirmPasswordController,
            label: 'Confirm Password *',
            obscureText: true,
            validator: (val) {
              if (val == null || val.isEmpty) return 'Please confirm password';
              if (val != _passwordController.text)
                return 'Passwords do not match';
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildForm2() {
    return Form(
      key: _formKeys[1],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Personal Details'),
          const SizedBox(height: 20),
          _buildTextField(
            controller: _heightController,
            label: 'Height (in cm) *',
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(3),
            ],
            validator: (val) {
              if (val == null || val.isEmpty) return 'Height is required';
              int? height = int.tryParse(val);
              if (height == null || height < 100 || height > 250) {
                return 'Enter valid height (100-250 cm)';
              }
              return null;
            },
          ),
          _buildDropdown(
            label: 'Marital Status *',
            value: maritalStatus,
            items: ['Never Married', 'Divorced', 'Widowed'],
            onChanged: (val) => setState(() => maritalStatus = val),
            validator: (val) => val == null ? 'Required' : null,
          ),
          _buildTextField(
            controller: _motherTongueController,
            label: 'Mother Tongue *',
            validator: (val) {
              if (val == null || val.isEmpty)
                return 'Mother tongue is required';
              if (RegExp(r'[0-9]').hasMatch(val))
                return 'Cannot contain numbers';
              if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(val))
                return 'Only letters allowed';
              return null;
            },
          ),
          _buildDropdown(
            label: 'Physical Status *',
            value: physicalStatus,
            items: ['Normal', 'Differently-abled'],
            onChanged: (val) => setState(() => physicalStatus = val),
            validator: (val) => val == null ? 'Required' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildForm3() {
    return Form(
      key: _formKeys[2],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Religion & Caste Details'),
          const SizedBox(height: 20),
          _buildTextField(
            controller: _religionController,
            label: 'Religion *',
            validator: (val) {
              if (val == null || val.isEmpty) return 'Religion is required';
              if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(val))
                return 'Only letters allowed';
              return null;
            },
          ),
          _buildTextField(
            controller: _casteController,
            label: 'Caste *',
            validator: (val) {
              if (val == null || val.isEmpty) return 'Caste is required';
              if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(val))
                return 'Only letters allowed';
              return null;
            },
          ),
          _buildTextField(
            controller: _subCasteController,
            label: 'Sub-caste *',
            validator: (val) {
              if (val == null || val.isEmpty) return 'Sub-caste is required';
              return null;
            },
          ),
          _buildTextField(
            controller: _gothramController,
            label: 'Gothram *',
            validator: (val) {
              if (val == null || val.isEmpty) return 'Gothram is required';
              return null;
            },
          ),
          _buildTextField(
            controller: _starRashiController,
            label: 'Star / Rashi *',
            validator: (val) {
              if (val == null || val.isEmpty) return 'Star/Rashi is required';
              return null;
            },
          ),
          _buildDropdown(
            label: 'Manglik / Dosham *',
            value: manglikDosham,
            items: ['Yes', 'No', "Don't know"],
            onChanged: (val) => setState(() => manglikDosham = val),
            validator: (val) => val == null ? 'Required' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildForm4() {
    return Form(
      key: _formKeys[3],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Education & Profession'),
          const SizedBox(height: 20),
          _buildTextField(
            controller: _educationController,
            label: 'Highest Education *',
            validator: (val) {
              if (val == null || val.isEmpty) return 'Education is required';
              if (val.trim().length < 2) return 'Enter valid education';
              return null;
            },
          ),
          _buildTextField(
            controller: _collegeController,
            label: 'College / University *',
            validator: (val) {
              if (val == null || val.isEmpty)
                return 'College/University is required';
              if (val.trim().length < 3)
                return 'Enter valid college/university name';
              return null;
            },
          ),
          _buildTextField(
            controller: _occupationController,
            label: 'Occupation *',
            validator: (val) {
              if (val == null || val.isEmpty) return 'Occupation is required';
              if (val.trim().length < 2) return 'Enter valid occupation';
              return null;
            },
          ),
          _buildDropdown(
            label: 'Employed In *',
            value: employedIn,
            items: [
              'Private',
              'Government',
              'Business',
              'Self-Employed',
              'Not Employed'
            ],
            onChanged: (val) => setState(() => employedIn = val),
            validator: (val) => val == null ? 'Required' : null,
          ),
          _buildTextField(
            controller: _incomeController,
            label: 'Annual Income (in ₹) *',
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            validator: (val) {
              if (val == null || val.isEmpty) return 'Income is required';
              int? income = int.tryParse(val);
              if (income == null || income < 0) return 'Enter valid income';
              return null;
            },
          ),
          _buildTextField(
            controller: _organizationController,
            label: 'Organization Name (Optional)',
          ),
          _buildTextField(
            controller: _experienceController,
            label: 'Work Experience in Years (Optional)',
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(2),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildForm5() {
    return Form(
      key: _formKeys[4],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Family & Lifestyle Details'),
          const SizedBox(height: 20),
          _buildTextField(
            controller: _fatherOccupationController,
            label: "Father's Occupation *",
            validator: (val) {
              if (val == null || val.isEmpty) return 'Required';
              if (val.trim().length < 2) return 'Enter valid occupation';
              return null;
            },
          ),
          _buildTextField(
            controller: _motherOccupationController,
            label: "Mother's Occupation *",
            validator: (val) {
              if (val == null || val.isEmpty) return 'Required';
              if (val.trim().length < 2) return 'Enter valid occupation';
              return null;
            },
          ),
          _buildTextField(
            controller: _brothersController,
            label: 'No. of Brothers *',
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(2),
            ],
            validator: (val) {
              if (val == null || val.isEmpty) return 'Required';
              int? count = int.tryParse(val);
              if (count == null || count < 0 || count > 20) {
                return 'Enter valid number (0-20)';
              }
              return null;
            },
          ),
          _buildTextField(
            controller: _sistersController,
            label: 'No. of Sisters *',
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(2),
            ],
            validator: (val) {
              if (val == null || val.isEmpty) return 'Required';
              int? count = int.tryParse(val);
              if (count == null || count < 0 || count > 20) {
                return 'Enter valid number (0-20)';
              }
              return null;
            },
          ),
          _buildDropdown(
            label: 'Family Type *',
            value: familyType,
            items: ['Joint', 'Nuclear'],
            onChanged: (val) => setState(() => familyType = val),
            validator: (val) => val == null ? 'Required' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildForm6() {
    return Form(
      key: _formKeys[5],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Location & Contact Details'),
          const SizedBox(height: 20),
          _buildTextField(
            controller: _countryController,
            label: 'Country *',
            validator: (val) {
              if (val == null || val.isEmpty) return 'Country is required';
              if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(val))
                return 'Only letters allowed';
              return null;
            },
          ),
          _buildTextField(
            controller: _stateController,
            label: 'State *',
            validator: (val) {
              if (val == null || val.isEmpty) return 'State is required';
              if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(val))
                return 'Only letters allowed';
              return null;
            },
          ),
          _buildTextField(
            controller: _cityController,
            label: 'City *',
            validator: (val) {
              if (val == null || val.isEmpty) return 'City is required';
              if (val.trim().length < 2) return 'Enter valid city name';
              return null;
            },
          ),
          _buildTextField(
            controller: _addressController,
            label: 'Address (Optional)',
            maxLines: 3,
          ),
          _buildTextField(
            controller: _pincodeController,
            label: 'Pincode *',
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            validator: (val) {
              if (val == null || val.isEmpty) return 'Pincode is required';
              if (val.length != 6) return 'Pincode must be exactly 6 digits';
              return null;
            },
          ),
          _buildTextField(
            controller: _nativePlaceController,
            label: 'Native Place (Optional)',
          ),
        ],
      ),
    );
  }

  Widget _buildImagePicker() {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFE91E63),
                  width: 3,
                ),
              ),
              child: _hasProfileImage && _pickedImageFile != null
                  ? ClipOval(
                      child: kIsWeb
                          ? Image.network(
                              _pickedImageFile!.path,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              File(_pickedImageFile!.path),
                              fit: BoxFit.cover,
                            ),
                    )
                  : const Icon(
                      Icons.add_a_photo,
                      size: 40,
                      color: Colors.grey,
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _hasProfileImage ? 'Tap to change photo' : 'Tap to add photo',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();

    try {
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _pickedImageFile = pickedFile;
          _hasProfileImage = true;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Color(0xFFE91E63),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    bool obscureText = false,
    int maxLines = 1,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE91E63), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red),
          ),
        ),
        validator: validator,
        keyboardType: keyboardType,
        obscureText: obscureText,
        maxLines: maxLines,
        inputFormatters: inputFormatters,
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE91E63), width: 2),
          ),
        ),
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }

  Widget _buildDatePicker() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () async {
          final date = await showDatePicker(
            context: context,
            initialDate: DateTime.now().subtract(const Duration(days: 6570)),
            firstDate: DateTime(1950),
            lastDate: DateTime.now().subtract(const Duration(days: 6570)),
          );
          if (date != null) {
            setState(() {
              _dateOfBirth = date;
              _age = DateTime.now().year - date.year;
              if (DateTime.now().month < date.month ||
                  (DateTime.now().month == date.month &&
                      DateTime.now().day < date.day)) {
                _age = _age! - 1;
              }
            });
          }
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: 'Date of Birth *',
            labelStyle: const TextStyle(color: Colors.grey),
            suffixIcon: const Icon(Icons.calendar_today),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE91E63), width: 2),
            ),
          ),
          child: Text(
            _dateOfBirth != null
                ? '${_dateOfBirth!.day.toString().padLeft(2, '0')}/${_dateOfBirth!.month.toString().padLeft(2, '0')}/${_dateOfBirth!.year}'
                : 'Select date',
            style: TextStyle(
                color: _dateOfBirth != null ? Colors.black : Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentStep > 0)
            OutlinedButton(
              onPressed: () => setState(() => _currentStep--),
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                side: const BorderSide(color: Color(0xFFE91E63)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Previous',
                  style: TextStyle(color: Color(0xFFE91E63))),
            )
          else
            const SizedBox(),
          ElevatedButton(
            onPressed: _currentStep < 5 ? _nextStep : _submitForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE91E63),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(_currentStep < 5 ? 'Next' : 'Submit'),
          ),
        ],
      ),
    );
  }

  void _nextStep() {
    if (_formKeys[_currentStep].currentState!.validate()) {
      if (_currentStep == 0 && _dateOfBirth == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select date of birth'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      setState(() => _currentStep++);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields correctly'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _submitForm() {
    if (_formKeys[_currentStep].currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 30),
              SizedBox(width: 10),
              Text('Success!'),
            ],
          ),
          content: const Text(
              'Your matrimony profile has been created successfully!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'main.dart';

class ProfileDetailsScreen extends StatefulWidget {
  const ProfileDetailsScreen({super.key});

  @override
  State<ProfileDetailsScreen> createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {
  static const String boxName = 'userBox';
  static const String profileKey = 'profile';

  String fullName = "";
  String birthDate = "";
  String gender = "";
  String phone = "";
  String email = "";
  String address = "";
  String height = "";
  String weight = "";
  String bloodGroup = "";

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController bloodGroupController = TextEditingController();

  static const List<String> genderOptions = ["Male", "Female", "Other"];
  String? selectedGender;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<Box> _openUserBox() async {
    return await Hive.openBox(boxName);
  }

  Future<void> _loadProfileData() async {
    final box = await _openUserBox();
    final savedProfile = box.get(profileKey);

    if (savedProfile is Map) {
      if (!mounted) return;

      setState(() {
        fullName = savedProfile['fullName']?.toString() ?? "";
        birthDate = savedProfile['birthDate']?.toString() ?? "";
        gender = savedProfile['gender']?.toString() ?? "";
        phone = savedProfile['phone']?.toString() ?? "";
        email = savedProfile['email']?.toString() ?? "";
        address = savedProfile['address']?.toString() ?? "";
        height = savedProfile['height']?.toString() ?? "";
        weight = savedProfile['weight']?.toString() ?? "";
        bloodGroup = savedProfile['bloodGroup']?.toString() ?? "";
        _syncEditingFields();
      });
    }
  }

  void _syncEditingFields() {
    fullNameController.text = fullName;
    birthDateController.text = birthDate;
    phoneController.text = phone;
    emailController.text = email;
    addressController.text = address;
    heightController.text = height;
    weightController.text = weight;
    bloodGroupController.text = bloodGroup;
    selectedGender = genderOptions.contains(gender) ? gender : null;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _saveProfileData(Map<String, dynamic> updatedProfile) async {
    final box = await _openUserBox();
    final savedProfile = box.get(profileKey);
    final Map<String, dynamic> profileData = savedProfile is Map
        ? Map<String, dynamic>.from(savedProfile)
        : <String, dynamic>{};

    profileData.addAll(updatedProfile);

    await box.put(profileKey, profileData);

    if (!mounted) return;

    setState(() {
      fullName = profileData['fullName']?.toString() ?? "";
      birthDate = profileData['birthDate']?.toString() ?? "";
      gender = profileData['gender']?.toString() ?? "";
      phone = profileData['phone']?.toString() ?? "";
      email = profileData['email']?.toString() ?? "";
      address = profileData['address']?.toString() ?? "";
      height = profileData['height']?.toString() ?? "";
      weight = profileData['weight']?.toString() ?? "";
      bloodGroup = profileData['bloodGroup']?.toString() ?? "";
    });
  }

  void _startEditing() {
    _syncEditingFields();
    setState(() {
      _isEditing = true;
    });
  }

  Future<void> _saveChanges() async {
    if (fullNameController.text.trim().isEmpty) {
      _showError("Full Name is required");
      return;
    }

    if (birthDateController.text.trim().isEmpty) {
      _showError("Birth Date is required");
      return;
    }

    if (selectedGender == null) {
      _showError("Gender is required");
      return;
    }

    if (phoneController.text.trim().isEmpty) {
      _showError("Phone Number is required");
      return;
    }

    final updatedProfile = {
      'fullName': fullNameController.text.trim(),
      'birthDate': birthDateController.text.trim(),
      'gender': selectedGender ?? '',
      'phone': phoneController.text.trim(),
      'email': emailController.text.trim(),
      'address': addressController.text.trim(),
      'height': heightController.text.trim(),
      'weight': weightController.text.trim(),
      'bloodGroup': bloodGroupController.text.trim(),
    };

    await _saveProfileData(updatedProfile);

    if (!mounted) return;

    setState(() {
      _isEditing = false;
    });
  }

  @override
  void dispose() {
    fullNameController.dispose();
    birthDateController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    heightController.dispose();
    weightController.dispose();
    bloodGroupController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = MyApp.of(context)!.strings;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF7F8FC);
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final titleColor = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final subColor = isDark ? const Color(0xFFB0B0B0) : const Color(0xFF666666);
    final fillColor = isDark
        ? const Color(0xFF2A2A2A)
        : const Color(0xFFF3F4F8);
    final borderColor = isDark
        ? const Color(0xFF383838)
        : const Color(0xFFE2E5EE);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(strings.profileDetails),
        backgroundColor: bgColor,
        elevation: 0,
        foregroundColor: titleColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _infoCard(
            strings.fullName,
            fullName,
            cardColor,
            titleColor,
            subColor,
            strings,
            editor: _buildEditTextField(
              strings.fullNameRequired,
              fullNameController,
              fillColor,
              borderColor,
            ),
          ),
          _infoCard(
            strings.birthDate,
            birthDate,
            cardColor,
            titleColor,
            subColor,
            strings,
            editor: _buildEditTextField(
              strings.birthDateRequired,
              birthDateController,
              fillColor,
              borderColor,
            ),
          ),
          _infoCard(
            strings.gender,
            gender,
            cardColor,
            titleColor,
            subColor,
            strings,
            editor: _buildGenderDropdown(
              strings,
              cardColor,
              titleColor,
              fillColor,
              borderColor,
            ),
          ),
          _infoCard(
            strings.phone,
            phone,
            cardColor,
            titleColor,
            subColor,
            strings,
            editor: _buildEditTextField(
              strings.phoneRequired,
              phoneController,
              fillColor,
              borderColor,
              keyboardType: TextInputType.phone,
            ),
          ),
          _infoCard(
            strings.email,
            email,
            cardColor,
            titleColor,
            subColor,
            strings,
            editor: _buildEditTextField(
              strings.emailRequired,
              emailController,
              fillColor,
              borderColor,
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          _infoCard(
            strings.address,
            address,
            cardColor,
            titleColor,
            subColor,
            strings,
            editor: _buildEditTextField(
              strings.addressOptional,
              addressController,
              fillColor,
              borderColor,
            ),
          ),
          _infoCard(
            strings.heightLabel,
            height,
            cardColor,
            titleColor,
            subColor,
            strings,
            editor: _buildEditTextField(
              strings.heightOptional,
              heightController,
              fillColor,
              borderColor,
              keyboardType: TextInputType.number,
            ),
          ),
          _infoCard(
            strings.weightLabel,
            weight,
            cardColor,
            titleColor,
            subColor,
            strings,
            editor: _buildEditTextField(
              strings.weightOptional,
              weightController,
              fillColor,
              borderColor,
              keyboardType: TextInputType.number,
            ),
          ),
          _infoCard(
            strings.bloodGroup,
            bloodGroup,
            cardColor,
            titleColor,
            subColor,
            strings,
            editor: _buildEditTextField(
              strings.bloodGroupOptional,
              bloodGroupController,
              fillColor,
              borderColor,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: _isEditing ? _saveChanges : _startEditing,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5B5CEB),
              ),
              child: Text(
                _isEditing ? "Save Changes" : "Edit Profile",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(
    String title,
    String value,
    Color cardColor,
    Color titleColor,
    Color subColor,
    dynamic strings, {
    Widget? editor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 6),
          if (_isEditing && editor != null)
            editor
          else
            Text(
              value.isEmpty ? strings.notProvidedYet : value,
              style: TextStyle(fontSize: 14, color: subColor),
            ),
        ],
      ),
    );
  }

  Widget _buildGenderDropdown(
    dynamic strings,
    Color dropdownColor,
    Color textColor,
    Color fillColor,
    Color borderColor,
  ) {
    return DropdownButtonFormField<String>(
      value: selectedGender,
      dropdownColor: dropdownColor,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        hintText: strings.genderRequired,
        filled: true,
        fillColor: fillColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF5B5CEB), width: 1.5),
        ),
      ),
      items: [
        DropdownMenuItem(value: "Male", child: Text(strings.male)),
        DropdownMenuItem(value: "Female", child: Text(strings.female)),
        DropdownMenuItem(value: "Other", child: Text(strings.other)),
      ],
      onChanged: (value) {
        setState(() {
          selectedGender = value;
        });
      },
    );
  }
}

Widget _buildEditTextField(
  String hint,
  TextEditingController controller,
  Color fillColor,
  Color borderColor, {
  TextInputType keyboardType = TextInputType.text,
}) {
  return TextField(
    controller: controller,
    keyboardType: keyboardType,
    decoration: InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: fillColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF5B5CEB), width: 1.5),
      ),
    ),
  );
}

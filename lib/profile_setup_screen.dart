import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'home_screen.dart';
import 'main.dart';
import 'app_strings.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  int currentStep = 0;

  final PageController _pageController = PageController();

  static const String boxName = 'userBox';
  static const String profileKey = 'profile';
  static const String healthKey = 'health_info';
  static const String emergencyKey = 'emergency_contacts';

  // Step 1 - Personal Information
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController bloodGroupController = TextEditingController();

  String? selectedGender;

  // Step 2 - Health Information
  final TextEditingController conditionController = TextEditingController();
  final TextEditingController allergyController = TextEditingController();
  final TextEditingController medicationController = TextEditingController();
  final TextEditingController doctorController = TextEditingController();
  final TextEditingController hospitalController = TextEditingController();
  final TextEditingController healthNotesController = TextEditingController();

  // Step 3 - Emergency Contacts
  final List<Map<String, TextEditingController>> emergencyContacts = [];

  @override
  void initState() {
    super.initState();
    addEmergencyContact();
    _loadSavedUserData();
  }

  Future<Box> _openUserBox() async {
    return await Hive.openBox(boxName);
  }

  Future<void> _loadSavedUserData() async {
    final box = await _openUserBox();

    final profileData = box.get(profileKey);
    final healthData = box.get(healthKey);
    final emergencyData = box.get(emergencyKey);

    if (profileData is Map) {
      fullNameController.text = profileData['fullName'] ?? '';
      birthDateController.text = profileData['birthDate'] ?? '';
      phoneController.text = profileData['phone'] ?? '';
      emailController.text = profileData['email'] ?? '';
      addressController.text = profileData['address'] ?? '';
      heightController.text = profileData['height'] ?? '';
      weightController.text = profileData['weight'] ?? '';
      bloodGroupController.text = profileData['bloodGroup'] ?? '';
      selectedGender = profileData['gender'];
    }

    if (healthData is Map) {
      conditionController.text = healthData['condition'] ?? '';
      allergyController.text = healthData['allergy'] ?? '';
      medicationController.text = healthData['medication'] ?? '';
      doctorController.text = healthData['doctor'] ?? '';
      hospitalController.text = healthData['hospital'] ?? '';
      healthNotesController.text = healthData['healthNotes'] ?? '';
    }

    if (emergencyData is List && emergencyData.isNotEmpty) {
      for (var contact in emergencyContacts) {
        for (var controller in contact.values) {
          controller.dispose();
        }
      }
      emergencyContacts.clear();

      for (var item in emergencyData) {
        if (item is Map) {
          emergencyContacts.add({
            "name": TextEditingController(text: item['name'] ?? ''),
            "relationship": TextEditingController(
              text: item['relationship'] ?? '',
            ),
            "phone": TextEditingController(text: item['phone'] ?? ''),
            "altPhone": TextEditingController(text: item['altPhone'] ?? ''),
            "email": TextEditingController(text: item['email'] ?? ''),
            "address": TextEditingController(text: item['address'] ?? ''),
          });
        }
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _saveUserData() async {
    final box = await _openUserBox();

    final Map<String, dynamic> profileData = {
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

    final Map<String, dynamic> healthData = {
      'condition': conditionController.text.trim(),
      'allergy': allergyController.text.trim(),
      'medication': medicationController.text.trim(),
      'doctor': doctorController.text.trim(),
      'hospital': hospitalController.text.trim(),
      'healthNotes': healthNotesController.text.trim(),
    };

    final List<Map<String, String>> emergencyData = emergencyContacts.map((
      contact,
    ) {
      return {
        'name': contact["name"]!.text.trim(),
        'relationship': contact["relationship"]!.text.trim(),
        'phone': contact["phone"]!.text.trim(),
        'altPhone': contact["altPhone"]!.text.trim(),
        'email': contact["email"]!.text.trim(),
        'address': contact["address"]!.text.trim(),
      };
    }).toList();

    await box.put(profileKey, profileData);
    await box.put(healthKey, healthData);
    await box.put(emergencyKey, emergencyData);
    await box.put('profile_setup_complete', true);
  }

  void addEmergencyContact() {
    setState(() {
      emergencyContacts.add({
        "name": TextEditingController(),
        "relationship": TextEditingController(),
        "phone": TextEditingController(),
        "altPhone": TextEditingController(),
        "email": TextEditingController(),
        "address": TextEditingController(),
      });
    });
  }

  void removeEmergencyContact(int index) {
    if (emergencyContacts.length > 1) {
      setState(() {
        emergencyContacts[index].forEach((key, controller) {
          controller.dispose();
        });
        emergencyContacts.removeAt(index);
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<Contact?> _showContactPicker() async {
    final contacts = await FlutterContacts.getContacts(withProperties: true);

    if (!mounted) return null;

    return await showDialog<Contact>(
      context: context,
      builder: (context) {
        List<Contact> filteredContacts = List.from(contacts);

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Select Contact"),

              content: SizedBox(
                width: double.maxFinite,
                height: 500,

                child: Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        hintText: "Search Contact",
                        prefixIcon: Icon(Icons.search),
                      ),

                      onChanged: (value) {
                        setDialogState(() {
                          filteredContacts = contacts
                              .where(
                                (contact) => contact.displayName
                                    .toLowerCase()
                                    .contains(value.toLowerCase()),
                              )
                              .toList();
                        });
                      },
                    ),

                    const SizedBox(height: 10),

                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredContacts.length,

                        itemBuilder: (context, index) {
                          final contact = filteredContacts[index];

                          return ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.person),
                            ),

                            title: Text(contact.displayName),

                            subtitle: contact.phones.isNotEmpty
                                ? Text(contact.phones.first.number)
                                : null,

                            onTap: () {
                              Navigator.pop(context, contact);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _pickUserPhoneContact() async {
    final contact = await _showContactPicker();

    if (contact != null && contact.phones.isNotEmpty) {
      phoneController.text = contact.phones.first.number;
    }
  }

  Future<void> _pickEmergencyContact(
    TextEditingController nameController,
    TextEditingController phoneController,
  ) async {
    final contact = await _showContactPicker();

    if (contact != null) {
      nameController.text = contact.displayName;

      if (contact.phones.isNotEmpty) {
        phoneController.text = contact.phones.first.number;
      }
    }
  }

  Future<void> _pickAlternativePhone(TextEditingController controller) async {
    final contact = await _showContactPicker();

    if (contact != null && contact.phones.isNotEmpty) {
      controller.text = contact.phones.first.number;
    }
  }

  void nextStep() async {
    if (currentStep == 0) {
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
    }

    if (currentStep == 1) {
      if (conditionController.text.trim().isEmpty) {
        _showError("Medical Conditions are required");
        return;
      }

      if (allergyController.text.trim().isEmpty) {
        _showError("Allergies are required");
        return;
      }

      if (medicationController.text.trim().isEmpty) {
        _showError("Medications are required");
        return;
      }
    }

    if (currentStep == 2) {
      for (var contact in emergencyContacts) {
        if (contact["name"]!.text.trim().isEmpty) {
          _showError("Contact Name is required");
          return;
        }

        if (contact["relationship"]!.text.trim().isEmpty) {
          _showError("Relationship is required");
          return;
        }

        if (contact["phone"]!.text.trim().isEmpty) {
          _showError("Phone Number is required");
          return;
        }
      }

      await _saveUserData();

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );

      return;
    }

    setState(() {
      currentStep++;
    });

    _pageController.animateToPage(
      currentStep,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
      _pageController.animateToPage(
        currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
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

    conditionController.dispose();
    allergyController.dispose();
    medicationController.dispose();
    doctorController.dispose();
    hospitalController.dispose();
    healthNotesController.dispose();

    for (var contact in emergencyContacts) {
      for (var controller in contact.values) {
        controller.dispose();
      }
    }

    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = MyApp.of(context)!.strings;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bgColor = isDark
        ? const Color(0xFF121212)
        : const Color(0xFFF7F8FC);
    final Color cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final Color titleColor = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final Color subTitleColor = isDark
        ? const Color(0xFFB0B0B0)
        : const Color(0xFF666666);
    final Color fieldFillColor = isDark
        ? const Color(0xFF2A2A2A)
        : const Color(0xFFF3F4F8);
    final Color borderColor = isDark
        ? const Color(0xFF383838)
        : const Color(0xFFE2E5EE);
    final Color primaryColor = const Color(0xFF5B5CEB);
    final Color inactiveStepColor = isDark
        ? const Color(0xFF333333)
        : const Color(0xFFDADCE5);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bgColor,
        centerTitle: true,
        title: Text(
          strings.profileSetup,
          style: TextStyle(color: titleColor, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: titleColor),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: List.generate(3, (index) {
                  final bool isActive = index <= currentStep;
                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: index == 2 ? 0 : 8),
                      height: 8,
                      decoration: BoxDecoration(
                        color: isActive ? primaryColor : inactiveStepColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStepLabel(
                    strings.basicInfo,
                    0,
                    currentStep,
                    primaryColor,
                    subTitleColor,
                  ),
                  _buildStepLabel(
                    strings.healthInfo,
                    1,
                    currentStep,
                    primaryColor,
                    subTitleColor,
                  ),
                  _buildStepLabel(
                    strings.contacts,
                    2,
                    currentStep,
                    primaryColor,
                    subTitleColor,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildPersonalInfoStep(
                    strings,
                    cardColor,
                    titleColor,
                    subTitleColor,
                    fieldFillColor,
                    borderColor,
                  ),
                  _buildHealthInfoStep(
                    strings,
                    cardColor,
                    titleColor,
                    subTitleColor,
                    fieldFillColor,
                    borderColor,
                  ),
                  _buildEmergencyContactStep(
                    strings,
                    cardColor,
                    titleColor,
                    subTitleColor,
                    fieldFillColor,
                    borderColor,
                    primaryColor,
                    isDark,
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Row(
                children: [
                  if (currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: previousStep,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: primaryColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          strings.back,
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  if (currentStep > 0) const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: nextStep,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        currentStep == 2 ? strings.finishSetup : strings.next,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepLabel(
    String text,
    int index,
    int currentStep,
    Color activeColor,
    Color inactiveColor,
  ) {
    final bool isActive = index <= currentStep;
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: isActive ? activeColor : inactiveColor,
      ),
    );
  }

  Widget _buildPersonalInfoStep(
    AppStrings strings,
    Color cardColor,
    Color titleColor,
    Color subTitleColor,
    Color fieldFillColor,
    Color borderColor,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              strings.basicInformation,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              strings.basicInfoDesc,
              style: TextStyle(fontSize: 14, color: subTitleColor, height: 1.5),
            ),
            const SizedBox(height: 22),
            _buildTextField(
              strings.fullNameRequired,
              fullNameController,
              fieldFillColor,
              borderColor,
            ),
            const SizedBox(height: 14),
            _buildDateField(
              context,
              strings.birthDateRequired,
              birthDateController,
              fieldFillColor,
              borderColor,
            ),
            const SizedBox(height: 14),
            _buildGenderDropdown(
              strings,
              strings.genderRequired,
              fieldFillColor,
              borderColor,
            ),
            const SizedBox(height: 14),
            _buildTextField(
              strings.phoneRequired,
              phoneController,
              fieldFillColor,
              borderColor,
              keyboardType: TextInputType.phone,
              suffixIcon: IconButton(
                icon: const Icon(Icons.contacts),
                onPressed: _pickUserPhoneContact,
              ),
            ),
            const SizedBox(height: 14),
            _buildTextField(
              strings.emailRequired,
              emailController,
              fieldFillColor,
              borderColor,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 14),
            _buildTextField(
              strings.addressOptional,
              addressController,
              fieldFillColor,
              borderColor,
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    strings.heightOptional,
                    heightController,
                    fieldFillColor,
                    borderColor,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    strings.weightOptional,
                    weightController,
                    fieldFillColor,
                    borderColor,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _buildTextField(
              strings.bloodGroupOptional,
              bloodGroupController,
              fieldFillColor,
              borderColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthInfoStep(
    AppStrings strings,
    Color cardColor,
    Color titleColor,
    Color subTitleColor,
    Color fieldFillColor,
    Color borderColor,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              strings.healthInformation,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              strings.healthInfoDescLong,
              style: TextStyle(fontSize: 14, color: subTitleColor, height: 1.5),
            ),
            const SizedBox(height: 22),
            _buildTextField(
              strings.medicalConditions,
              conditionController,
              fieldFillColor,
              borderColor,
              maxLines: 2,
            ),
            const SizedBox(height: 14),
            _buildTextField(
              strings.allergies,
              allergyController,
              fieldFillColor,
              borderColor,
              maxLines: 2,
            ),
            const SizedBox(height: 14),
            _buildTextField(
              strings.medications,
              medicationController,
              fieldFillColor,
              borderColor,
              maxLines: 2,
            ),
            const SizedBox(height: 14),
            _buildTextField(
              strings.doctorOptional,
              doctorController,
              fieldFillColor,
              borderColor,
            ),
            const SizedBox(height: 14),
            _buildTextField(
              strings.hospitalOptional,
              hospitalController,
              fieldFillColor,
              borderColor,
            ),
            const SizedBox(height: 14),
            _buildTextField(
              strings.healthNotes,
              healthNotesController,
              fieldFillColor,
              borderColor,
              maxLines: 4,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyContactStep(
    AppStrings strings,
    Color cardColor,
    Color titleColor,
    Color subTitleColor,
    Color fieldFillColor,
    Color borderColor,
    Color primaryColor,
    bool isDark,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strings.emergencyContacts,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  strings.emergencyContactsDescLong,
                  style: TextStyle(
                    fontSize: 14,
                    color: subTitleColor,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(emergencyContacts.length, (index) {
            final contact = emergencyContacts[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: borderColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "${strings.contact} ${index + 1}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: titleColor,
                        ),
                      ),
                      const Spacer(),
                      if (emergencyContacts.length > 1)
                        IconButton(
                          onPressed: () => removeEmergencyContact(index),
                          icon: const Icon(Icons.delete_outline_rounded),
                          color: Colors.red,
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    strings.contactName,
                    contact["name"]!,
                    fieldFillColor,
                    borderColor,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    strings.relationship,
                    contact["relationship"]!,
                    fieldFillColor,
                    borderColor,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    strings.phone,
                    contact["phone"]!,
                    fieldFillColor,
                    borderColor,
                    keyboardType: TextInputType.phone,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.contacts),
                      onPressed: () {
                        _pickEmergencyContact(
                          contact["name"]!,
                          contact["phone"]!,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    strings.altPhoneOptional,
                    contact["altPhone"]!,
                    fieldFillColor,
                    borderColor,
                    keyboardType: TextInputType.phone,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.contacts),
                      onPressed: () {
                        _pickAlternativePhone(contact["altPhone"]!);
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    strings.emailOptional,
                    contact["email"]!,
                    fieldFillColor,
                    borderColor,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    strings.addressOptional,
                    contact["address"]!,
                    fieldFillColor,
                    borderColor,
                  ),
                ],
              ),
            );
          }),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: addEmergencyContact,
              icon: Icon(Icons.add_circle_outline_rounded, color: primaryColor),
              label: Text(
                strings.addAnotherContact,
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: primaryColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: isDark
                    ? const Color(0xFF1B1B1B)
                    : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String hint,
    TextEditingController controller,
    Color fillColor,
    Color borderColor, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        hintText: hint,
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
    );
  }

  Widget _buildDateField(
    BuildContext context,
    String hint,
    TextEditingController controller,
    Color fillColor,
    Color borderColor,
  ) {
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime(2000),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );

        if (pickedDate != null) {
          String formattedDate =
              "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
          controller.text = formattedDate;
        }
      },
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: fillColor,
        suffixIcon: const Icon(Icons.calendar_today_rounded),
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
    );
  }

  Widget _buildGenderDropdown(
    AppStrings strings,
    String hint,
    Color fillColor,
    Color borderColor,
  ) {
    return DropdownButtonFormField<String>(
      value: selectedGender,
      decoration: InputDecoration(
        hintText: hint,
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

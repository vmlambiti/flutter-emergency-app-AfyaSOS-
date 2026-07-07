import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:hive/hive.dart';
import 'main.dart';

class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({super.key});

  @override
  State<EmergencyContactsScreen> createState() =>
      _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  static const String boxName = 'userBox';
  static const String emergencyKey = 'emergency_contacts';

  List<Map<String, String>> contacts = [];

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<Box> _openUserBox() async {
    return await Hive.openBox(boxName);
  }

  Future<void> _loadContacts() async {
    final box = await _openUserBox();
    final savedContacts = box.get(emergencyKey);

    if (savedContacts is List) {
      contacts = savedContacts.map<Map<String, String>>((item) {
        final map = Map<String, dynamic>.from(item);
        return {
          "name": map["name"]?.toString() ?? "",
          "relationship": map["relationship"]?.toString() ?? "",
          "phone": map["phone"]?.toString() ?? "",
          "altPhone": map["altPhone"]?.toString() ?? "",
          "email": map["email"]?.toString() ?? "",
          "address": map["address"]?.toString() ?? "",
        };
      }).toList();
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _saveContacts() async {
    final box = await _openUserBox();
    await box.put(emergencyKey, contacts);
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

  Future<String?> _selectPhoneNumber(Contact contact) async {
    if (contact.phones.isEmpty) return null;
    if (contact.phones.length == 1) return contact.phones.first.number;

    return await showDialog<String>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text("Select Phone Number"),
          children: contact.phones.map((phone) {
            return SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, phone.number);
              },
              child: Text(phone.number),
            );
          }).toList(),
        );
      },
    );
  }

  Future<void> _pickEmergencyContact(
    TextEditingController nameController,
    TextEditingController phoneController,
  ) async {
    final contact = await _showContactPicker();

    if (contact == null) return;

    nameController.text = contact.displayName;

    final selectedPhone = await _selectPhoneNumber(contact);
    if (selectedPhone != null) {
      phoneController.text = selectedPhone;
    }
  }

  Future<void> _pickAlternativePhone(TextEditingController controller) async {
    final contact = await _showContactPicker();

    if (contact == null) return;

    final selectedPhone = await _selectPhoneNumber(contact);
    if (selectedPhone != null) {
      controller.text = selectedPhone;
    }
  }

  void _showContactDialog({Map<String, String>? contact, int? index}) {
    final strings = MyApp.of(context)!.strings;

    final nameController = TextEditingController(
      text: contact != null ? contact["name"] : "",
    );
    final relationshipController = TextEditingController(
      text: contact != null ? contact["relationship"] : "",
    );
    final phoneController = TextEditingController(
      text: contact != null ? contact["phone"] : "",
    );
    final altPhoneController = TextEditingController(
      text: contact != null ? contact["altPhone"] : "",
    );
    final emailController = TextEditingController(
      text: contact != null ? contact["email"] : "",
    );
    final addressController = TextEditingController(
      text: contact != null ? contact["address"] : "",
    );

    final bool isEditing = contact != null;

    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final dialogColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
        final textColor = isDark ? Colors.white : const Color(0xFF1A1A1A);
        final fieldColor = isDark
            ? const Color(0xFF2A2A2A)
            : const Color(0xFFF3F4F8);
        final borderColor = isDark
            ? const Color(0xFF383838)
            : const Color(0xFFE2E5EE);
        final primaryColor = const Color(0xFF5B5CEB);

        return AlertDialog(
          backgroundColor: dialogColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            isEditing ? strings.editContact : strings.addContact,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(
                  strings.contactName,
                  nameController,
                  fieldColor,
                  borderColor,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  strings.relationship,
                  relationshipController,
                  fieldColor,
                  borderColor,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  strings.phone,
                  phoneController,
                  fieldColor,
                  borderColor,
                  keyboardType: TextInputType.phone,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.contacts),
                    onPressed: () {
                      _pickEmergencyContact(nameController, phoneController);
                    },
                  ),
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  strings.altPhoneOptional,
                  altPhoneController,
                  fieldColor,
                  borderColor,
                  keyboardType: TextInputType.phone,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.contacts),
                    onPressed: () {
                      _pickAlternativePhone(altPhoneController);
                    },
                  ),
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  strings.emailOptional,
                  emailController,
                  fieldColor,
                  borderColor,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  strings.addressOptional,
                  addressController,
                  fieldColor,
                  borderColor,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                strings.cancel,
                style: TextStyle(color: textColor.withOpacity(0.7)),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.trim().isEmpty ||
                    relationshipController.text.trim().isEmpty ||
                    phoneController.text.trim().isEmpty) {
                  return;
                }

                final newContact = {
                  "name": nameController.text.trim(),
                  "relationship": relationshipController.text.trim(),
                  "phone": phoneController.text.trim(),
                  "altPhone": altPhoneController.text.trim(),
                  "email": emailController.text.trim(),
                  "address": addressController.text.trim(),
                };

                setState(() {
                  if (isEditing && index != null) {
                    contacts[index] = newContact;
                  } else {
                    contacts.add(newContact);
                  }
                });

                await _saveContacts();

                if (!mounted) return;
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                isEditing ? strings.update : strings.save,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteContact(int index) {
    final strings = MyApp.of(context)!.strings;

    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final dialogColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
        final textColor = isDark ? Colors.white : const Color(0xFF1A1A1A);

        return AlertDialog(
          backgroundColor: dialogColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            strings.deleteContact,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
          content: Text(
            strings.deleteContactConfirm,
            style: TextStyle(color: textColor.withOpacity(0.8)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                strings.cancel,
                style: TextStyle(color: textColor.withOpacity(0.7)),
              ),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  contacts.removeAt(index);
                });

                await _saveContacts();

                if (!mounted) return;
                Navigator.pop(context);
              },
              child: Text(
                strings.delete,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
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
    final Color primaryColor = const Color(0xFF5B5CEB);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bgColor,
        title: Text(
          strings.emergencyContacts,
          style: TextStyle(color: titleColor, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: titleColor),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showContactDialog(),
        backgroundColor: primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          strings.addContact,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: contacts.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.contacts_rounded, size: 70, color: primaryColor),
                    const SizedBox(height: 16),
                    Text(
                      strings.noEmergencyContactsYet,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: titleColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      strings.noEmergencyContactsDesc,
                      style: TextStyle(
                        fontSize: 14,
                        color: subTitleColor,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 90),
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person_rounded,
                          color: primaryColor,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              contact["name"] ?? "",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: titleColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              contact["relationship"] ?? "",
                              style: TextStyle(
                                fontSize: 14,
                                color: subTitleColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.phone_rounded,
                                  size: 18,
                                  color: primaryColor,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    contact["phone"] ?? "",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: titleColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if ((contact["altPhone"] ?? "")
                                .trim()
                                .isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.call_rounded,
                                    size: 18,
                                    color: primaryColor,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      contact["altPhone"] ?? "",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: titleColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            if ((contact["email"] ?? "").trim().isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.email_rounded,
                                    size: 18,
                                    color: primaryColor,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      contact["email"] ?? "",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: titleColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            if ((contact["address"] ?? "")
                                .trim()
                                .isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.location_on_rounded,
                                    size: 18,
                                    color: primaryColor,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      contact["address"] ?? "",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: titleColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: Icon(
                          Icons.more_vert_rounded,
                          color: subTitleColor,
                        ),
                        onSelected: (value) {
                          if (value == "edit") {
                            _showContactDialog(contact: contact, index: index);
                          } else if (value == "delete") {
                            _deleteContact(index);
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: "edit",
                            child: Text(strings.edit),
                          ),
                          PopupMenuItem(
                            value: "delete",
                            child: Text(strings.delete),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildTextField(
    String hint,
    TextEditingController controller,
    Color fillColor,
    Color borderColor, {
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
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
        suffixIcon: suffixIcon,
      ),
    );
  }
}

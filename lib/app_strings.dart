class AppStrings {
  final String languageCode;

  AppStrings(this.languageCode);

  static AppStrings of(String languageCode) {
    return AppStrings(languageCode);
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'settings': 'Settings',
      'notifications': 'Notifications',
      'themes': 'Themes',
      'language': 'Language',
      'about': 'About',
      'help': 'Help',
      'privacyPolicy': 'Privacy Policy',
      'preferences': 'Preferences',
      'supportAndInfo': 'Support & Information',
      'changeAppLanguage': 'Change app language (English / Swahili)',
      'chooseLanguage': 'Choose Language',
      'selectLanguageMessage':
          'Select the language you want to use in AfyaSOS.',
      'english': 'English',
      'swahili': 'Swahili',
      'systemDefault': 'System Default',
      'welcome': 'Welcome',
      'continueText': 'Continue',
      'home': 'Home',
      'emergencyContacts': 'Emergency Contacts',
      'healthInfo': 'Health Info',
      'notificationSettings': 'Notification Settings',
      'healthProfile': 'Health Profile',
      'liveMonitoring': 'Live Monitoring',
      'recentReadings': 'Recent Readings',

      'connectionStatus': 'Connection Status',
      'monitoringMode': 'Monitoring Mode',
      'monitoringStatus': 'Status',
      'lastUpdated': 'Last Updated',

      'quickAlerts': 'Quick Emergency Alerts',
      'quickAlertsDesc':
          'AfyaSOS helps you instantly notify your trusted contacts during emergencies.',
      'shareLocation': 'Share Your Location',
      'shareLocationDesc':
          'Your real-time location is sent with your alert so help can reach you faster.',
      'healthMonitoring': 'Health Monitoring Support',
      'healthMonitoringDesc':
          'AfyaSOS can integrate with smart devices to monitor heart rate and support conditions like hypertension and local first aid guidance.',
      'safetyFirst': 'Your Safety Comes First',
      'safetyFirstDesc':
          'Stay prepared, stay connected, and get help when every second counts.',
      'alreadyAccount': 'Already have an account?',
      'signIn': 'Sign in',

      'appName': 'AfyaSOS',
      'save': 'Save',
      'cancel': 'Cancel',
      'edit': 'Edit',
      'delete': 'Delete',
      'update': 'Update',
      'next': 'Next',
      'back': 'Back',
      'done': 'Done',
      'profile': 'Profile',
      'darkMode': 'Dark Mode',
      'lightMode': 'Light Mode',
      'theme': 'Theme',
      'selectOption': 'Select an option',
      'getStarted': 'Get Started',
      'skip': 'Skip',
      'name': 'Name',
      'phone': 'Phone',
      'email': 'Email',
      'address': 'Address',
      'gender': 'Gender',
      'birthDate': 'Birth Date',
      'bloodGroup': 'Blood Group',
      'allergies': 'Allergies',
      'medications': 'Medications',
      'medicalConditions': 'Medical Conditions',
      'doctorName': 'Doctor Name',
      'hospitalName': 'Hospital Name',
      'notes': 'Notes',
      'addContact': 'Add Contact',
      'relationship': 'Relationship',
      'mainContact': 'Main Contact',
      'otherContacts': 'Other Contacts',
      'sos': 'SOS',
      'sendAlert': 'Send Alert',
      'location': 'Location',
      'noData': 'No data available',
      'welcomeToAfyaSOS': 'Welcome to AfyaSOS',
      'staySafePrepared': 'Stay safe and prepared',
      'emergencyHelp': 'Emergency Help',
      'emergencyHelpDesc':
          'Tap the SOS button in case of emergency to quickly alert your trusted contacts.',
      'pressOnlyWhenNeeded': 'Press only when immediate help is needed',
      'locationSharingReady': 'Location sharing ready',
      'locationSharingReadyDesc':
          'Your saved emergency alert can include location support.',
      'quickActions': 'Quick Actions',
      'emergencyContactsDesc': 'View and manage your trusted contacts',
      'healthInfoDesc': 'Check medical details and notes',
      'firstAid': 'First Aid',
      'firstAidDesc': 'See quick support guidance',
      'settingsDesc': 'App preferences and support',
      'homeTip':
          'Tip: Keep your health details and emergency contacts updated so AfyaSOS can help faster when needed.',
      'noEmergencyContactsFound':
          'No emergency contacts found. Please add contacts first.',
      'noValidPhoneNumbers': 'No valid phone numbers found.',
      'turnOnLocationServices': 'Please turn on location services.',
      'locationPermissionDenied': 'Location permission denied.',
      'locationPermissionDeniedForever':
          'Location permission is permanently denied. Enable it in phone settings.',
      'addressNotAvailable': 'Address not available',
      'emergencyMessageLine1': 'Emergency! I need help.',
      'myLocationLabel': 'My location',
      'coordinatesLabel': 'Coordinates',
      'smsPermissionDenied': 'SMS permission denied.',
      'emergencySmsSentCalling': 'Emergency SMS sent and calling',
      'sosError': 'SOS error',
      'profileSetup': 'Profile Setup',
      'basicInfo': 'Basic Info',
      'contacts': 'Contacts',
      'finishSetup': 'Finish Setup',
      'basicInformation': 'Basic Information',
      'basicInfoDesc':
          'Add your personal details for emergency identification.',
      'healthInformation': 'Health Information',
      'healthInfoDescLong':
          'Add important medical details that may help during emergencies.',
      'emergencyContactsDescLong':
          'Add trusted people we can contact during emergencies. You can add as many as you want.',
      'contact': 'Contact',
      'addAnotherContact': 'Add Another Contact',
      'fullNameRequired': 'Full Name *',
      'birthDateRequired': 'Birthdate *',
      'genderRequired': 'Gender *',
      'phoneRequired': 'Phone Number *',
      'emailRequired': 'Email Address *',
      'addressOptional': 'Address / Area (Optional)',
      'heightOptional': 'Height in cm (Optional)',
      'weightOptional': 'Weight in kg (Optional)',
      'bloodGroupOptional': 'Blood Group (Optional)',
      'doctorOptional': 'Doctor Name (Optional)',
      'hospitalOptional': 'Preferred Hospital / Clinic (Optional)',
      'healthNotes': 'Health Notes / First Aid Notes',
      'contactName': 'Contact Name',
      'altPhoneOptional': 'Alternative Phone (Optional)',
      'emailOptional': 'Email (Optional)',
      'male': 'Male',
      'female': 'Female',
      'other': 'Other',
      'editContact': 'Edit Contact',
      'deleteContact': 'Delete Contact',
      'deleteContactConfirm':
          'Are you sure you want to delete this emergency contact?',
      'noEmergencyContactsYet': 'No Emergency Contacts Yet',
      'noEmergencyContactsDesc':
          'Add trusted people who can be contacted during emergencies.',
      'editHealthInfo': 'Edit Health Info',
      'healthSummary': 'Health Summary',
      'healthSummaryDesc':
          'View and manage your medical details for emergency support.',
      'heartRateFromSensor': 'Heart Rate from Sensor / Watch',
      'heartRateAutoUpdateDesc':
          'This will later update automatically from the connected smartwatch or sensor.',
      'preferredHospitalClinic': 'Preferred Hospital / Clinic',
      'editHealthInformation': 'Edit Health Information',
      'notProvidedYet': 'Not provided yet',
      'profileDetails': 'Profile Details',
      'fullName': 'Full Name',
      'heightLabel': 'Height',
      'weightLabel': 'Weight',
      'noFirstAidDataFound': 'No first aid data found',
      'symptoms': 'Symptoms',
      'whatToDo': 'What to Do',
      'whatNotToDo': 'What Not to Do',
      'specialNotes': 'Special Notes',
      'emergencyAction': 'Emergency Action',
      'useSos': 'Use SOS',
      'sosActionNext': 'SOS action will be connected next',
      'languageCodeValue': 'en',
      'notificationsSubtitle': 'Manage emergency alerts and app notifications',
      'themesSubtitle': 'Change app appearance and dark/light mode',
      'aboutSubtitle': 'Learn more about AfyaSOS',
      'helpSubtitle': 'Get support on how to use the app',
      'privacyPolicySubtitle': 'Read how your information is protected',
      'aboutTagline': 'Quick emergency support when it matters most.',
      'aboutAfyaSOSTitle': 'About AfyaSOS',
      'aboutAfyaSOSContent':
          'AfyaSOS is an emergency support mobile application designed to help users quickly send SOS alerts, share important emergency details, and contact trusted people during urgent situations.',
      'mainPurposeTitle': 'Main Purpose',
      'mainPurposeContent':
          'The main purpose of AfyaSOS is to provide a fast and simple way for users to ask for help during emergencies. The app focuses on speed, safety, and easy communication.',
      'keyFeaturesTitle': 'Key Features',
      'keyFeaturesContent':
          '• Send SOS alerts quickly\n'
          '• Manage emergency contacts\n'
          '• Share emergency information\n'
          '• View and update personal details\n'
          '• Control notifications and app theme',
      'versionTitle': 'Version',
      'versionContent': 'Version 1.0.0',
      'developerInfoTitle': 'Developer Information',
      'developerInfoContent':
          'Developed as part of the AfyaSOS project to improve emergency response and support through mobile technology.',
      'helpTitle': 'Help & Support',
      'helpIntro':
          'Find simple guidance on how to use AfyaSOS during emergencies.',
      'howToSendSosTitle': 'How to Send SOS',
      'howToSendSosContent':
          'Open the app and tap the SOS button when you need urgent help. AfyaSOS can quickly alert your emergency contacts and share important emergency details.',
      'manageContactsTitle': 'How to Manage Emergency Contacts',
      'manageContactsContent':
          'Go to the Emergency Contacts section to add, edit, or remove trusted people who should be contacted during an emergency.',
      'changeThemeTitle': 'How to Change App Theme',
      'changeThemeContent':
          'Open Settings, then tap Themes. You can choose Light Theme, Dark Theme, or System Default based on your preference.',
      'controlNotificationsTitle': 'How to Control Notifications',
      'controlNotificationsContent':
          'Open Settings and go to Notifications. There you can turn emergency alerts, SOS confirmation, sound, and vibration on or off.',
      'needSupportTitle': 'Need More Support?',
      'needSupportContent':
          'If you experience problems while using AfyaSOS, check the relevant settings or contact the support team for further assistance.',
      'privacyTitle': 'Privacy Policy',
      'privacyIntro':
          'This page explains how AfyaSOS collects, uses, and protects user information.',

      'infoCollectTitle': 'Information We Collect',
      'infoCollectContent':
          'AfyaSOS may collect personal details entered by the user, such as name, phone number, emergency contacts, optional email address, optional address, and other emergency-related information provided inside the app.',

      'infoUseTitle': 'How We Use Your Information',
      'infoUseContent':
          'The information collected in AfyaSOS is used to support emergency response features, help users manage emergency contacts, send SOS alerts, and improve the safety and functionality of the application.',

      'locationTitle': 'Location and Emergency Sharing',
      'locationContent':
          'If location access is allowed, AfyaSOS may use location information during emergencies to help share the user\'s current position with trusted contacts or emergency responders.',

      'dataProtectionTitle': 'Data Protection',
      'dataProtectionContent':
          'AfyaSOS aims to protect user information by storing it carefully and limiting access to authorized use within the app. Users should also keep their devices secure to help protect their personal information.',

      'sharingTitle': 'Sharing of Information',
      'sharingContent':
          'AfyaSOS does not share user information unnecessarily. Information may only be shared when required for emergency support features, such as sending alerts or sharing emergency details with trusted contacts.',

      'userControlTitle': 'User Control',
      'userControlContent':
          'Users can update or remove some personal information inside the app settings and emergency contact sections. Optional information such as email and address can be edited at any time.',

      'policyUpdateTitle': 'Policy Updates',
      'policyUpdateContent':
          'This privacy policy may be updated in the future when app features or data handling practices change. Users are encouraged to review this page from time to time.',
      'themeTitle': 'Choose App Theme',
      'themeIntro': 'Select how you want AfyaSOS to appear on your device.',
      'lightThemeTitle': 'Light Theme',
      'lightThemeSubtitle': 'Use bright appearance during the day',
      'darkThemeTitle': 'Dark Theme',
      'darkThemeSubtitle': 'Use dark appearance for low light',
      'systemThemeTitle': 'System Default',
      'systemThemeSubtitle': 'Follow your phone theme settings',
      'notificationTitle': 'Notification Settings',
      'notificationIntro':
          'Choose the emergency alerts you want to receive in AfyaSOS.',
      'emergencyAlertsTitle': 'Emergency Alerts',
      'emergencyAlertsSubtitle':
          'Receive important emergency alert notifications',
      'sosConfirmationTitle': 'SOS Confirmation',
      'sosConfirmationSubtitle': 'Get confirmation when an SOS alert is sent',
      'locationSharingTitle': 'Location Sharing Alerts',
      'locationSharingSubtitle': 'Get alerts when your location is shared',
      'alertPreferences': 'Alert Preferences',
      'soundTitle': 'Sound',
      'soundSubtitle': 'Play a sound when an alert is received',
      'vibrationTitle': 'Vibration',
      'vibrationSubtitle':
          'Vibrate your phone for alerts and SOS notifications',
    },
    'sw': {
      'settings': 'Mipangilio',
      'notifications': 'Arifa',
      'themes': 'Mandhari',
      'language': 'Lugha',
      'about': 'Kuhusu',
      'help': 'Msaada',
      'healthProfile': 'Wasifu wa Afya',
      'liveMonitoring': 'Ufuatiliaji wa Moja kwa Moja',
      'recentReadings': 'Historia ya Vipimo',

      'connectionStatus': 'Hali ya Muunganisho',
      'monitoringMode': 'Njia ya Ufuatiliaji',
      'monitoringStatus': 'Hali',
      'lastUpdated': 'Mara ya Mwisho Kusasishwa',
      'privacyPolicy': 'Sera ya Faragha',
      'preferences': 'Mapendeleo',
      'supportAndInfo': 'Msaada na Taarifa',
      'changeAppLanguage':
          'Badilisha lugha ya programu (Kiingereza / Kiswahili)',
      'chooseLanguage': 'Chagua Lugha',
      'selectLanguageMessage': 'Chagua lugha unayotaka kutumia kwenye AfyaSOS.',
      'english': 'Kiingereza',
      'swahili': 'Kiswahili',
      'systemDefault': 'Chaguo la Mfumo',
      'welcome': 'Karibu',
      'continueText': 'Endelea',
      'home': 'Nyumbani',
      'emergencyContacts': 'Watu wa Dharura',
      'healthInfo': 'Taarifa za Afya',
      'notificationSettings': 'Mipangilio ya Arifa',

      'quickAlerts': 'Tahadhari za Dharura Haraka',
      'quickAlertsDesc':
          'AfyaSOS hukusaidia kuwajulisha haraka watu unaowaamini wakati wa dharura.',
      'shareLocation': 'Shiriki Mahali Ulipo',
      'shareLocationDesc':
          'Mahali ulipo hutumwa pamoja na tahadhari ili msaada ufike haraka.',
      'healthMonitoring': 'Ufuatiliaji wa Afya',
      'healthMonitoringDesc':
          'AfyaSOS inaweza kuunganishwa na vifaa vya kisasa kufuatilia mapigo ya moyo na kusaidia hali kama shinikizo la damu na mwongozo wa huduma ya kwanza wa ndani.',
      'safetyFirst': 'Usalama Wako Kwanza',
      'safetyFirstDesc':
          'Kuwa tayari, endelea kuwasiliana, na pata msaada wakati kila sekunde ni muhimu.',
      'alreadyAccount': 'Tayari una akaunti?',
      'signIn': 'Ingia',

      'appName': 'AfyaSOS',
      'save': 'Hifadhi',
      'cancel': 'Ghairi',
      'edit': 'Hariri',
      'delete': 'Futa',
      'update': 'Sasisha',
      'next': 'Ifuatayo',
      'back': 'Rudi',
      'done': 'Maliza',
      'profile': 'Wasifu',
      'darkMode': 'Mandhari Nyeusi',
      'lightMode': 'Mandhari Nyeupe',
      'theme': 'Mandhari',
      'selectOption': 'Chagua chaguo',
      'getStarted': 'Anza',
      'skip': 'Ruka',
      'name': 'Jina',
      'phone': 'Simu',
      'email': 'Barua pepe',
      'address': 'Anwani',
      'gender': 'Jinsia',
      'birthDate': 'Tarehe ya kuzaliwa',
      'bloodGroup': 'Kundi la damu',
      'allergies': 'Mzio',
      'medications': 'Dawa',
      'medicalConditions': 'Hali za kiafya',
      'doctorName': 'Jina la daktari',
      'hospitalName': 'Jina la hospitali',
      'notes': 'Maelezo',
      'addContact': 'Ongeza mawasiliano',
      'relationship': 'Uhusiano',
      'mainContact': 'Mwasiliano mkuu',
      'otherContacts': 'Mawasiliano mengine',
      'sos': 'SOS',
      'sendAlert': 'Tuma tahadhari',
      'location': 'Mahali',
      'noData': 'Hakuna taarifa zilizopo',
      'welcomeToAfyaSOS': 'Karibu AfyaSOS',
      'staySafePrepared': 'Kaa salama na uwe tayari',
      'emergencyHelp': 'Msaada wa Dharura',
      'emergencyHelpDesc':
          'Bonyeza kitufe cha SOS wakati wa dharura ili kuwajulisha haraka watu unaowaamini.',
      'pressOnlyWhenNeeded': 'Bonyeza tu pale msaada wa haraka unapohitajika',
      'locationSharingReady': 'Ushirikishaji wa eneo uko tayari',
      'locationSharingReadyDesc':
          'Tahadhari yako ya dharura inaweza kujumuisha taarifa ya eneo ulipo.',
      'quickActions': 'Vitendo vya Haraka',
      'emergencyContactsDesc': 'Tazama na simamia watu unaowaamini',
      'healthInfoDesc': 'Angalia taarifa za afya na maelezo',
      'firstAid': 'Huduma ya Kwanza',
      'firstAidDesc': 'Angalia mwongozo wa haraka wa msaada',
      'settingsDesc': 'Mipangilio ya programu na msaada',
      'homeTip':
          'Kidokezo: Weka taarifa zako za afya na mawasiliano ya dharura zikiwa zimesasishwa ili AfyaSOS iweze kusaidia haraka inapohitajika.',
      'noEmergencyContactsFound':
          'Hakuna mawasiliano ya dharura yaliyopatikana. Tafadhali ongeza mawasiliano kwanza.',
      'noValidPhoneNumbers': 'Hakuna namba halali za simu zilizopatikana.',
      'turnOnLocationServices': 'Tafadhali washa huduma za eneo.',
      'locationPermissionDenied': 'Ruhusa ya eneo imekataliwa.',
      'locationPermissionDeniedForever':
          'Ruhusa ya eneo imekataliwa kabisa. Iwashe kwenye mipangilio ya simu.',
      'addressNotAvailable': 'Anwani haipatikani',
      'emergencyMessageLine1': 'Dharura! Nahitaji msaada.',
      'myLocationLabel': 'Eneo langu',
      'coordinatesLabel': 'Koordineti',
      'smsPermissionDenied': 'Ruhusa ya SMS imekataliwa.',
      'emergencySmsSentCalling': 'SMS ya dharura imetumwa na inapiga simu kwa',
      'sosError': 'Hitilafu ya SOS',
      'profileSetup': 'Mpangilio wa Wasifu',
      'basicInfo': 'Taarifa za Msingi',
      'contacts': 'Mawasiliano',
      'finishSetup': 'Maliza Usanidi',
      'basicInformation': 'Taarifa za Msingi',
      'basicInfoDesc':
          'Ongeza taarifa zako binafsi kwa utambulisho wa dharura.',
      'healthInformation': 'Taarifa za Afya',
      'healthInfoDescLong':
          'Ongeza taarifa muhimu za afya ambazo zinaweza kusaidia wakati wa dharura.',
      'emergencyContactsDescLong':
          'Ongeza watu wa kuaminika tunaoweza kuwasiliana nao wakati wa dharura. Unaweza kuongeza wengi unavyotaka.',
      'contact': 'Mwasiliano',
      'addAnotherContact': 'Ongeza Mwasiliano Mengine',
      'fullNameRequired': 'Jina Kamili *',
      'birthDateRequired': 'Tarehe ya Kuzaliwa *',
      'genderRequired': 'Jinsia *',
      'phoneRequired': 'Namba ya Simu *',
      'emailRequired': 'Barua Pepe *',
      'addressOptional': 'Anwani / Eneo (Hiari)',
      'heightOptional': 'Urefu kwa cm (Hiari)',
      'weightOptional': 'Uzito kwa kg (Hiari)',
      'bloodGroupOptional': 'Kundi la Damu (Hiari)',
      'doctorOptional': 'Jina la Daktari (Hiari)',
      'hospitalOptional': 'Hospitali / Kliniki Unayopendelea (Hiari)',
      'healthNotes': 'Maelezo ya Afya / Huduma ya Kwanza',
      'contactName': 'Jina la Mwasiliano',
      'altPhoneOptional': 'Namba Mbadala (Hiari)',
      'emailOptional': 'Barua Pepe (Hiari)',
      'male': 'Mwanaume',
      'female': 'Mwanamke',
      'other': 'Nyingine',
      'editContact': 'Hariri Mwasiliano',
      'deleteContact': 'Futa Mwasiliano',
      'deleteContactConfirm':
          'Una uhakika unataka kufuta mwasiliano haya ya dharura?',
      'noEmergencyContactsYet': 'Bado Hakuna Mawasiliano ya Dharura',
      'noEmergencyContactsDesc':
          'Ongeza watu unaowaamini ambao wanaweza kuwasiliana wakati wa dharura.',
      'editHealthInfo': 'Hariri Taarifa za Afya',
      'healthSummary': 'Muhtasari wa Afya',
      'healthSummaryDesc':
          'Tazama na simamia taarifa zako za matibabu kwa msaada wa dharura.',
      'heartRateFromSensor': 'Mapigo ya Moyo kutoka Sensor / Saa',
      'heartRateAutoUpdateDesc':
          'Hii baadaye itasasishwa moja kwa moja kutoka kwenye saa au sensor iliyounganishwa.',
      'preferredHospitalClinic': 'Hospitali / Kliniki Unayopendelea',
      'editHealthInformation': 'Hariri Taarifa za Afya',
      'notProvidedYet': 'Bado haijawekwa',
      'profileDetails': 'Taarifa za Wasifu',
      'fullName': 'Jina Kamili',
      'heightLabel': 'Urefu',
      'weightLabel': 'Uzito',
      'noFirstAidDataFound':
          'Hakuna taarifa za huduma ya kwanza zilizopatikana',
      'symptoms': 'Dalili',
      'whatToDo': 'Cha Kufanya',
      'whatNotToDo': 'Cha Kutofanya',
      'specialNotes': 'Maelezo Maalum',
      'emergencyAction': 'Hatua ya Dharura',
      'useSos': 'Tumia SOS',
      'sosActionNext': 'Hatua ya SOS itaunganishwa baadaye',
      'languageCodeValue': 'sw',
      'notificationsSubtitle': 'Simamia arifa za dharura na arifa za programu',
      'themesSubtitle':
          'Badilisha mwonekano wa programu na hali ya giza/mwanga',
      'aboutSubtitle': 'Jifunze zaidi kuhusu AfyaSOS',
      'helpSubtitle': 'Pata msaada wa jinsi ya kutumia programu',
      'privacyPolicySubtitle': 'Soma jinsi taarifa zako zinavyolindwa',
      'aboutTagline': 'Msaada wa haraka wa dharura unapohitajika zaidi.',
      'aboutAfyaSOSTitle': 'Kuhusu AfyaSOS',
      'aboutAfyaSOSContent':
          'AfyaSOS ni programu ya simu ya msaada wa dharura iliyoundwa kusaidia watumiaji kutuma tahadhari za SOS kwa haraka, kushiriki taarifa muhimu za dharura, na kuwasiliana na watu wanaowaamini wakati wa hali za hatari.',
      'mainPurposeTitle': 'Lengo Kuu',
      'mainPurposeContent':
          'Lengo kuu la AfyaSOS ni kutoa njia ya haraka na rahisi kwa watumiaji kuomba msaada wakati wa dharura. Programu inalenga kasi, usalama, na mawasiliano rahisi.',
      'keyFeaturesTitle': 'Vipengele Muhimu',
      'keyFeaturesContent':
          '• Tuma tahadhari za SOS haraka\n'
          '• Simamia mawasiliano ya dharura\n'
          '• Shiriki taarifa za dharura\n'
          '• Tazama na sasisha taarifa binafsi\n'
          '• Dhibiti arifa na mandhari ya programu',
      'versionTitle': 'Toleo',
      'versionContent': 'Toleo 1.0.0',
      'developerInfoTitle': 'Taarifa za Mtengenezaji',
      'developerInfoContent':
          'Imetengenezwa kama sehemu ya mradi wa AfyaSOS ili kuboresha mwitikio wa dharura na msaada kupitia teknolojia ya simu.',
      'helpTitle': 'Msaada na Usaidizi',
      'helpIntro':
          'Pata mwongozo rahisi wa jinsi ya kutumia AfyaSOS wakati wa dharura.',
      'howToSendSosTitle': 'Jinsi ya Kutuma SOS',
      'howToSendSosContent':
          'Fungua programu na bonyeza kitufe cha SOS unapohitaji msaada wa haraka. AfyaSOS inaweza kuwajulisha haraka watu unaowaamini na kushiriki taarifa muhimu za dharura.',
      'manageContactsTitle': 'Jinsi ya Kusimamia Mawasiliano ya Dharura',
      'manageContactsContent':
          'Nenda sehemu ya Mawasiliano ya Dharura kuongeza, kuhariri au kufuta watu unaowaamini wanaopaswa kuwasiliana wakati wa dharura.',
      'changeThemeTitle': 'Jinsi ya Kubadilisha Mandhari',
      'changeThemeContent':
          'Fungua Mipangilio kisha chagua Mandhari. Unaweza kuchagua Mandhari Nyeupe, Nyeusi au ya Mfumo.',
      'controlNotificationsTitle': 'Jinsi ya Kudhibiti Arifa',
      'controlNotificationsContent':
          'Fungua Mipangilio na nenda kwenye Arifa. Hapo unaweza kuwasha au kuzima arifa za dharura, uthibitisho wa SOS, sauti na mtetemo.',
      'needSupportTitle': 'Unahitaji Msaada Zaidi?',
      'needSupportContent':
          'Ikiwa unapata matatizo kutumia AfyaSOS, angalia mipangilio husika au wasiliana na timu ya msaada.',
      'privacyTitle': 'Sera ya Faragha',
      'privacyIntro':
          'Ukurasa huu unaelezea jinsi AfyaSOS inavyokusanya, kutumia na kulinda taarifa za mtumiaji.',

      'infoCollectTitle': 'Taarifa Tunazokusanya',
      'infoCollectContent':
          'AfyaSOS inaweza kukusanya taarifa binafsi zilizowekwa na mtumiaji kama jina, namba ya simu, mawasiliano ya dharura, barua pepe ya hiari, anwani ya hiari, na taarifa nyingine zinazohusiana na dharura ndani ya programu.',

      'infoUseTitle': 'Jinsi Tunavyotumia Taarifa Zako',
      'infoUseContent':
          'Taarifa zinazokusanywa hutumika kusaidia huduma za dharura, kusimamia mawasiliano ya dharura, kutuma tahadhari za SOS, na kuboresha usalama na utendaji wa programu.',

      'locationTitle': 'Mahali na Ushirikishaji wa Dharura',
      'locationContent':
          'Iwapo ruhusa ya eneo imetolewa, AfyaSOS inaweza kutumia taarifa za eneo wakati wa dharura kusaidia kushiriki mahali ulipo na watu unaowaamini au wahudumu wa dharura.',

      'dataProtectionTitle': 'Ulinzi wa Taarifa',
      'dataProtectionContent':
          'AfyaSOS inalenga kulinda taarifa za mtumiaji kwa kuzihifadhi kwa usalama na kuruhusu matumizi yaliyoidhinishwa tu ndani ya programu. Watumiaji wanapaswa pia kulinda vifaa vyao.',

      'sharingTitle': 'Ushirikishaji wa Taarifa',
      'sharingContent':
          'AfyaSOS haishiriki taarifa za mtumiaji bila sababu. Taarifa hushirikiwa tu inapohitajika kwa huduma za dharura kama kutuma tahadhari au kushiriki taarifa na watu wa kuaminika.',

      'userControlTitle': 'Udhibiti wa Mtumiaji',
      'userControlContent':
          'Mtumiaji anaweza kusasisha au kufuta baadhi ya taarifa binafsi kupitia mipangilio na sehemu ya mawasiliano ya dharura. Taarifa za hiari zinaweza kubadilishwa wakati wowote.',

      'policyUpdateTitle': 'Mabadiliko ya Sera',
      'policyUpdateContent':
          'Sera hii inaweza kubadilishwa baadaye kadri vipengele vya programu vinavyobadilika. Watumiaji wanashauriwa kuitembelea mara kwa mara.',
      'themeTitle': 'Chagua Mandhari ya Programu',
      'themeIntro':
          'Chagua jinsi unavyotaka AfyaSOS kuonekana kwenye kifaa chako.',
      'lightThemeTitle': 'Mandhari Nyeupe',
      'lightThemeSubtitle': 'Tumia mwonekano angavu wakati wa mchana',
      'darkThemeTitle': 'Mandhari Nyeusi',
      'darkThemeSubtitle': 'Tumia mwonekano mweusi kwa mwanga mdogo',
      'systemThemeTitle': 'Chaguo la Mfumo',
      'systemThemeSubtitle': 'Fuata mipangilio ya mandhari ya simu yako',
      'notificationTitle': 'Mipangilio ya Arifa',
      'notificationIntro':
          'Chagua arifa za dharura unazotaka kupokea kwenye AfyaSOS.',

      'emergencyAlertsTitle': 'Arifa za Dharura',
      'emergencyAlertsSubtitle': 'Pokea arifa muhimu za dharura',

      'sosConfirmationTitle': 'Uthibitisho wa SOS',
      'sosConfirmationSubtitle':
          'Pata uthibitisho wakati tahadhari ya SOS inapotumwa',

      'locationSharingTitle': 'Arifa za Mahali',
      'locationSharingSubtitle': 'Pata arifa wakati eneo lako linashirikiwa',

      'alertPreferences': 'Mapendeleo ya Arifa',

      'soundTitle': 'Sauti',
      'soundSubtitle': 'Cheza sauti arifa inapofika',

      'vibrationTitle': 'Mtetemo',
      'vibrationSubtitle': 'Tikisisha simu kwa arifa na tahadhari za SOS',
    },
  };

  String _get(String key) {
    return _localizedValues[languageCode]?[key] ??
        _localizedValues['en']?[key] ??
        key;
  }

  String get settings => _get('settings');
  String get notifications => _get('notifications');
  String get themes => _get('themes');
  String get language => _get('language');
  String get about => _get('about');
  String get help => _get('help');
  String get privacyPolicy => _get('privacyPolicy');
  String get preferences => _get('preferences');
  String get supportAndInfo => _get('supportAndInfo');
  String get changeAppLanguage => _get('changeAppLanguage');
  String get chooseLanguage => _get('chooseLanguage');
  String get selectLanguageMessage => _get('selectLanguageMessage');
  String get english => _get('english');
  String get swahili => _get('swahili');
  String get systemDefault => _get('systemDefault');
  String get welcome => _get('welcome');
  String get continueText => _get('continueText');
  String get home => _get('home');
  String get emergencyContacts => _get('emergencyContacts');
  String get healthInfo => _get('healthInfo');
  String get notificationSettings => _get('notificationSettings');

  String get quickAlerts => _get('quickAlerts');
  String get quickAlertsDesc => _get('quickAlertsDesc');
  String get shareLocation => _get('shareLocation');
  String get shareLocationDesc => _get('shareLocationDesc');
  String get healthMonitoring => _get('healthMonitoring');
  String get healthMonitoringDesc => _get('healthMonitoringDesc');
  String get safetyFirst => _get('safetyFirst');
  String get safetyFirstDesc => _get('safetyFirstDesc');
  String get alreadyAccount => _get('alreadyAccount');
  String get signIn => _get('signIn');

  String get appName => _get('appName');
  String get save => _get('save');
  String get cancel => _get('cancel');
  String get edit => _get('edit');
  String get delete => _get('delete');
  String get update => _get('update');
  String get next => _get('next');
  String get back => _get('back');
  String get done => _get('done');
  String get profile => _get('profile');
  String get darkMode => _get('darkMode');
  String get lightMode => _get('lightMode');
  String get theme => _get('theme');
  String get selectOption => _get('selectOption');
  String get getStarted => _get('getStarted');
  String get skip => _get('skip');
  String get name => _get('name');
  String get phone => _get('phone');
  String get email => _get('email');
  String get address => _get('address');
  String get gender => _get('gender');
  String get birthDate => _get('birthDate');
  String get bloodGroup => _get('bloodGroup');
  String get allergies => _get('allergies');
  String get medications => _get('medications');
  String get medicalConditions => _get('medicalConditions');
  String get doctorName => _get('doctorName');
  String get hospitalName => _get('hospitalName');
  String get notes => _get('notes');
  String get addContact => _get('addContact');
  String get relationship => _get('relationship');
  String get mainContact => _get('mainContact');
  String get otherContacts => _get('otherContacts');
  String get sos => _get('sos');
  String get sendAlert => _get('sendAlert');
  String get location => _get('location');
  String get noData => _get('noData');
  String get welcomeToAfyaSOS => _get('welcomeToAfyaSOS');
  String get staySafePrepared => _get('staySafePrepared');
  String get emergencyHelp => _get('emergencyHelp');
  String get emergencyHelpDesc => _get('emergencyHelpDesc');
  String get pressOnlyWhenNeeded => _get('pressOnlyWhenNeeded');
  String get locationSharingReady => _get('locationSharingReady');
  String get locationSharingReadyDesc => _get('locationSharingReadyDesc');
  String get quickActions => _get('quickActions');
  String get emergencyContactsDesc => _get('emergencyContactsDesc');
  String get healthInfoDesc => _get('healthInfoDesc');
  String get firstAid => _get('firstAid');
  String get firstAidDesc => _get('firstAidDesc');
  String get settingsDesc => _get('settingsDesc');
  String get homeTip => _get('homeTip');
  String get noEmergencyContactsFound => _get('noEmergencyContactsFound');
  String get noValidPhoneNumbers => _get('noValidPhoneNumbers');
  String get turnOnLocationServices => _get('turnOnLocationServices');
  String get locationPermissionDenied => _get('locationPermissionDenied');
  String get locationPermissionDeniedForever =>
      _get('locationPermissionDeniedForever');
  String get addressNotAvailable => _get('addressNotAvailable');
  String get emergencyMessageLine1 => _get('emergencyMessageLine1');
  String get myLocationLabel => _get('myLocationLabel');
  String get coordinatesLabel => _get('coordinatesLabel');
  String get smsPermissionDenied => _get('smsPermissionDenied');
  String get emergencySmsSentCalling => _get('emergencySmsSentCalling');
  String get sosError => _get('sosError');
  String get profileSetup => _get('profileSetup');
  String get basicInfo => _get('basicInfo');
  String get contacts => _get('contacts');
  String get finishSetup => _get('finishSetup');
  String get basicInformation => _get('basicInformation');
  String get basicInfoDesc => _get('basicInfoDesc');
  String get healthInformation => _get('healthInformation');
  String get healthInfoDescLong => _get('healthInfoDescLong');
  String get emergencyContactsDescLong => _get('emergencyContactsDescLong');
  String get contact => _get('contact');
  String get addAnotherContact => _get('addAnotherContact');
  String get fullNameRequired => _get('fullNameRequired');
  String get birthDateRequired => _get('birthDateRequired');
  String get genderRequired => _get('genderRequired');
  String get phoneRequired => _get('phoneRequired');
  String get emailRequired => _get('emailRequired');
  String get addressOptional => _get('addressOptional');
  String get heightOptional => _get('heightOptional');
  String get weightOptional => _get('weightOptional');
  String get bloodGroupOptional => _get('bloodGroupOptional');
  String get doctorOptional => _get('doctorOptional');
  String get hospitalOptional => _get('hospitalOptional');
  String get healthNotes => _get('healthNotes');
  String get contactName => _get('contactName');
  String get altPhoneOptional => _get('altPhoneOptional');
  String get emailOptional => _get('emailOptional');
  String get male => _get('male');
  String get female => _get('female');
  String get other => _get('other');
  String get editContact => _get('editContact');
  String get deleteContact => _get('deleteContact');
  String get deleteContactConfirm => _get('deleteContactConfirm');
  String get noEmergencyContactsYet => _get('noEmergencyContactsYet');
  String get noEmergencyContactsDesc => _get('noEmergencyContactsDesc');
  String get editHealthInfo => _get('editHealthInfo');
  String get healthSummary => _get('healthSummary');
  String get healthSummaryDesc => _get('healthSummaryDesc');
  String get heartRateFromSensor => _get('heartRateFromSensor');
  String get heartRateAutoUpdateDesc => _get('heartRateAutoUpdateDesc');
  String get preferredHospitalClinic => _get('preferredHospitalClinic');
  String get editHealthInformation => _get('editHealthInformation');
  String get notProvidedYet => _get('notProvidedYet');
  String get profileDetails => _get('profileDetails');
  String get fullName => _get('fullName');
  String get heightLabel => _get('heightLabel');
  String get weightLabel => _get('weightLabel');
  String get noFirstAidDataFound => _get('noFirstAidDataFound');
  String get symptoms => _get('symptoms');
  String get whatToDo => _get('whatToDo');
  String get whatNotToDo => _get('whatNotToDo');
  String get specialNotes => _get('specialNotes');
  String get emergencyAction => _get('emergencyAction');
  String get useSos => _get('useSos');
  String get sosActionNext => _get('sosActionNext');
  String get languageCodeValue => _get('languageCodeValue');
  String get notificationsSubtitle => _get('notificationsSubtitle');
  String get themesSubtitle => _get('themesSubtitle');
  String get aboutSubtitle => _get('aboutSubtitle');
  String get helpSubtitle => _get('helpSubtitle');
  String get privacyPolicySubtitle => _get('privacyPolicySubtitle');
  String get aboutTagline => _get('aboutTagline');
  String get aboutAfyaSOSTitle => _get('aboutAfyaSOSTitle');
  String get aboutAfyaSOSContent => _get('aboutAfyaSOSContent');
  String get mainPurposeTitle => _get('mainPurposeTitle');
  String get mainPurposeContent => _get('mainPurposeContent');
  String get keyFeaturesTitle => _get('keyFeaturesTitle');
  String get keyFeaturesContent => _get('keyFeaturesContent');
  String get versionTitle => _get('versionTitle');
  String get versionContent => _get('versionContent');
  String get developerInfoTitle => _get('developerInfoTitle');
  String get developerInfoContent => _get('developerInfoContent');
  String get helpTitle => _get('helpTitle');
  String get helpIntro => _get('helpIntro');
  String get howToSendSosTitle => _get('howToSendSosTitle');
  String get howToSendSosContent => _get('howToSendSosContent');
  String get manageContactsTitle => _get('manageContactsTitle');
  String get manageContactsContent => _get('manageContactsContent');
  String get changeThemeTitle => _get('changeThemeTitle');
  String get changeThemeContent => _get('changeThemeContent');
  String get controlNotificationsTitle => _get('controlNotificationsTitle');
  String get controlNotificationsContent => _get('controlNotificationsContent');
  String get needSupportTitle => _get('needSupportTitle');
  String get needSupportContent => _get('needSupportContent');
  String get privacyTitle => _get('privacyTitle');
  String get privacyIntro => _get('privacyIntro');

  String get infoCollectTitle => _get('infoCollectTitle');
  String get infoCollectContent => _get('infoCollectContent');

  String get infoUseTitle => _get('infoUseTitle');
  String get infoUseContent => _get('infoUseContent');

  String get locationTitle => _get('locationTitle');
  String get locationContent => _get('locationContent');

  String get dataProtectionTitle => _get('dataProtectionTitle');
  String get dataProtectionContent => _get('dataProtectionContent');

  String get sharingTitle => _get('sharingTitle');
  String get sharingContent => _get('sharingContent');

  String get userControlTitle => _get('userControlTitle');
  String get userControlContent => _get('userControlContent');

  String get policyUpdateTitle => _get('policyUpdateTitle');
  String get policyUpdateContent => _get('policyUpdateContent');
  String get themeTitle => _get('themeTitle');
  String get themeIntro => _get('themeIntro');
  String get lightThemeTitle => _get('lightThemeTitle');
  String get lightThemeSubtitle => _get('lightThemeSubtitle');
  String get darkThemeTitle => _get('darkThemeTitle');
  String get darkThemeSubtitle => _get('darkThemeSubtitle');
  String get systemThemeTitle => _get('systemThemeTitle');
  String get systemThemeSubtitle => _get('systemThemeSubtitle');
  String get notificationTitle => _get('notificationTitle');
  String get notificationIntro => _get('notificationIntro');

  String get emergencyAlertsTitle => _get('emergencyAlertsTitle');
  String get emergencyAlertsSubtitle => _get('emergencyAlertsSubtitle');

  String get sosConfirmationTitle => _get('sosConfirmationTitle');
  String get sosConfirmationSubtitle => _get('sosConfirmationSubtitle');

  String get locationSharingTitle => _get('locationSharingTitle');
  String get locationSharingSubtitle => _get('locationSharingSubtitle');

  String get alertPreferences => _get('alertPreferences');

  String get soundTitle => _get('soundTitle');
  String get soundSubtitle => _get('soundSubtitle');

  String get vibrationTitle => _get('vibrationTitle');
  String get vibrationSubtitle => _get('vibrationSubtitle');
  String get healthProfile => _get('healthProfile');
  String get liveMonitoring => _get('liveMonitoring');
  String get recentReadings => _get('recentReadings');

  String get connectionStatus => _get('connectionStatus');
  String get monitoringMode => _get('monitoringMode');
  String get monitoringStatus => _get('monitoringStatus');
  String get lastUpdated => _get('lastUpdated');
}

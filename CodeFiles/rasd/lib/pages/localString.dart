import 'package:get/get.dart';

class LocalString extends Translations {
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
        //English
        'en_US': {
          //global
          'signout': 'Sign Out',
          'Sure': 'Are you sure?',

          //Homepgae
          'greeting': 'Welcome To Rasd',
          'LD': 'Link Dashcam\n',
          'LDA': 'Link your dashcam to our application',
          'L': 'Link',
          'pendVid': 'Pending Videos\n',
          'noPending': 'Currently there are no pending videos',
          'pendVidNum1': 'You have ',
          'pendVidNum2singular': ' pending video',
          'pendVidNum2': ' pending videos',
          'viewButton': 'View',
          'DLS': 'Dashcam Linked Successfully\n',
          'DLSA': 'The IP address of the linked dashcam:',
          'ConfRep': 'Confirmed Reports\n',
          'noConfirmed': 'Currently there are no confirmed reports',
          'confRepNum1': 'Number of confirmed reports:',
          'editLink': 'Edit',

          //settings_screen page
          'sitt': 'Settings',
          'acc': 'My Account',
          'PP': 'Privacy Policy',
          'RASDPP': 'RASD Privacy Policy',
          'contact': 'Contact Us',
          'Plang': 'Preferred Language',
          'change': 'Change',
          'choosePr': 'Choose your language preferences',
          'lang': 'English',
          'AreUSure': "Are you sure you want to sign out?",

          //showVideo page
          'showVideoHead': 'Violation Video',
          'viloation1': 'Tailgating',
          'viloation2': 'Overtaking',
          'viloation3': 'Drifting',
          'viloation4': 'Driving on the opposite direction',
          'confViolation':
              'Are you sure you want to confirm the detected violation?',
          'yes': 'Yes',
          'no': 'No',
          'conf': 'The violation has been confirmed!',
          'delViolation':
              'Are you sure you want to delete the detected violation?\nThis action cannot be undone',
          'delReasonTitle': 'Why?',
          'delReasonQ': 'Why you want to delete this violation?',
          'delReason1': 'Misclassified\nViolation',
          'delReason2': 'Not intrested\nin reporting',
          'delConfirmation': 'The violation has been deleted successfully!',
          '  confButton  ': 'Confirm',
          '  delButton  ': 'Delete',
          'isViolation':
              'Potential violation/s were detected in the video above, Do you agree?',
          'violationType': 'Specify the violation types from the list below:',
          'IDK': 'I don\'t know',
          'addInfo': 'Additional information',

          // pending videos
          'moreText': 'more space for text',
          'PVV': 'Pending Violation Videos',
          'Watch': 'Watch each video to confirm',
          'Select': '\nand select the violation type',
          'VV': 'Violation Video',
          'NPV': 'No Pending Videos',
          'NPVA':
              'Looks like you don\'t have any pending videos at this moment',

          //confirmed reports
          'CVR': 'Confirmed Violation Reports',
          'Send': 'Share your confirmed report with the authorities via email',
          'VR': 'Violation Report',
          'NVR': 'No Violation Reports',
          'NVRA':
              'Looks like you don\'t have any violation reports at this moment',
          'NotSelected': 'No violation type selected',

          //editFile page
          'successEditing': 'Your report information has been updated!',
          'confEdit': 'Are you sure you want to update the report information?',
          'EditReportHead': 'Edit confirmed report',

          //link page
          'LTOAPP': 'Link your dashcam to our application',
          'IP': 'Enter your dashcam IP',
          'Link': 'Link',
          'How': 'How do I get my IP address?',
          'Undo': 'Once you link your dashcam, you can not edit the IP.',
          "Sure": 'Are you sure?',
          'C': 'Cancel',
          'descSucess': 'Your dashcam has been linked successfully!',
          'descS': 'Your dashcam has been linked successfully!',
          'errorLink': 'Please complete your information',
          'S': 'Success',
          'Ok': 'Ok',
          'E': 'Error',
          'DashCamtoolTip':
              'You can find your dashcam IP in your dashcam settings.',
          'editDashCam': 'Edit your dashcam IP ',
          'editMess': 'Are you sure you want to update the IP?',
          'linkMess': 'Are you sure you want to link the entered IP?', //*

          //app root
          'Home': '\nHome',
          'PV': "Pending\n Videos",
          'CR': "\nConfirmed\n   Reports",
          'More': '\n Settings',

          //log in register //changes//
          'passIsNotCorrect':
              'The password is invalid, or the user does not have a password.',
          'EmailPassError': 'The email or password you entered is incorrect',
          'infoCompletionError': 'Please complete your information',
          'logIn': 'Log in',
          'logIn2': 'Log in',
          'signUp': 'Sign Up',
          'forogtPass': 'Forget Password?',
          'creatAcc': 'Create Your Account',
          'FN': 'First Name',
          'LN': 'Last Name',
          'email': 'Email',
          'pass': 'Password',
          'confPass': 'Confirm Password',
          'noAcc': 'Don\'t have an account?',
          'alradyAcc': 'Alrady have an account?',
          'logToAcc': 'Log in to your Account',
          'noAccountError':
              'There is no user record corresponding to this identifier. The user may have been deleted.',
          'Agreemnt1': 'I have read and agree to ',
          'Agreemnt2': 'RASD Privacy Policy.',
          'okButton': 'OK',
          'demandPolicy': "You have to agree on RASD privacy policy",
          'AccountExist':
              'The email address is already in use by another account.',
          'networkError':
              'A network error has occurred!\nPlease check your internet connection',

          //textFormGlobal    //* changes//*
          'enterE': 'Enter your Email',
          'invalidE':
              'Invalid email address, please follow this\nformat: example@example.com',
          'invalidE3':
              'Invalid email address, please follow\nthis format: example@example.com',
          'enterPass': 'Enter your Password',
          'enterFN': 'Enter your First Name',
          'enterLN': 'Enter your Last Name',
          'enterFN0': 'Enter your First\nName',
          'enterLN0': 'Enter your Last\nName',
          'noMatchPass': 'The passwords you entered does not match',
          'enterDIP': 'Enter your dashcam IP',
          'ipForm':
              'The IP must be in form of\n(000.000.000.000) \nwhere 0 is any digit from 0 to 9\nand 000 should not exceeds 255',
          '8charactersValidation':
              'Passowrd must be more than 8 characters\n and contain at least: one upper letter, \none lower letter, one number, and \none symbol',
          'FLValidation': 'Digits and symbols\nare not allowed',

          //verfiyEmail
          'resendE': 'Resend Email',
          'verfE': 'A verification email has been sent to your email',
          'checkSpam':
              'Make sure to check your spam folder if you did not find it in your inbox',
          'cancel': 'Cancel',

          //forgotpass
          'resetPass': 'Reset Password',
          'resetPassE':
              'Password reset email has been sent to your email\nMake sure to check your spam folder if you did not find it in your inbox',
          'assocE':
              'Enter the email associated with your account, and we will send you a password reset link',

          // pdf report
          'vr': '  Violation Report',
          'ViolationRep': 'Violation Report',
          'des':
              '  This report was detected by RASD, which use \n  Artifical Intellgence system to detect violations in \n  Saudi Arabia.',
          'name': 'Name',
          'email': 'Email',
          'link': 'Violation Video Link',
          'viotype': 'Violation Type',
          'Preview': 'Preview',
          'delConfreport':
              'Are you sure you want to delete the violation report?\nThis action cannot be undone',
          'Rdelete': 'The report has been deleted successfully!',
          'VTime': 'Violation Time',

          //email
          'subject': 'Traffic Violation Report',
          'body':
              'Hello,\nThis email was sent by a driver in Saudi Arabia through RASD application. A detailed report of the detected violation is attached to this email.\n\n\nBest regards,\nRASD team.',
          'filename': 'Traffic Violation Report Issued By RASD',

          // privacy page
          'RPP': 'RASD PRIVACY POLICY',
          'it1': 'ITEM ONE: INTRODUCTION',
          'it1text':
              'From the principle of the importance and confidentiality of users\' data, RASD administration is committed to maintaining the confidentiality and privacy of user information, and the materials entered by them as a baisi for the privacy policy, \nRASD administration will not disclose that information except in accordance with the specific and stipulated controls in this policy, and in accordance with the regulatory provisions issued in this regard.',
          'it2': 'ITEM TWO: USER INFORMATION',
          'it2text':
              'User Data and Information indicates all User’s Data contained in the application such as:\n\n- The personal data used for registration.\n- The dashcam information to detect traffic violations.\n- The violation reports.',
          'it3': 'ITEM THREE: COLLECTING AND STORING INFORMATION',
          'it3text':
              'Collecting information in RASD is done by the informations entered from the user and the dashcam to detect traffic violations and then store it in the server specified by the application. ',
          'it4': 'ITEM FOUR:  DATA SHARING',
          'it4text':
              'The user data may be used, such as traffic violation vedio links to enhance the model in detecting traffic violations and share the reports with the authorities. ',
          'it5': 'ITEM FIVE: APPLICATION ADMINSTRATION',
          'it5text':
              'Name of the entity supervising the application: King Saud University,\nCollege of Computer and Information Sciences,\nInformation Technology Department.',

          // account
          'acc': 'My Account',
          'fname': 'First Name',
          'lname': 'Last Name',
          'em': 'Email',
          'oldE': 'Old Email',
          'enterEOld': 'Enter your old Email',
          'update': 'Update',
          'changeE': 'To update your email enter your old email and password:',
          'FLValidation1': 'Digits and symbols are not allowed',
          'save': 'Save',
          'updateMess': 'Your information has been updated!',
          'AreUSureToSave':
              'Are you sure you want to update and save your information? ',
        },

        //Arabic
        'ar_AE': {
          //global
          'signout': 'تسجيل الخروج',
          'Sure': "هل انت متأكد ؟ ",

          //Homepgae
          'greeting': 'مرحبًا بك في رصد',
          'LD': 'ربط الداش كام\n',
          'LDA': 'قم بربط وتوصيل كاميرتك الداش كام بتطبيقنا',
          'L': 'اربط',
          'pendVid': 'مقاطع قيد المراجعة\n',
          'noPending': 'لا يوجد لديك اي مقاطع مخالفات تحت المراجعة',
          'pendVidNum1': 'لديك ',
          'pendVidNum2singular': ' مقطع مخالفة قيد المراجعة',
          'pendVidNum2': ' مقاطع مخالفات قيد المراجعة',
          'viewButton': 'معاينة',
          'DLS': 'تم ربط كاميرا الداش كام بنجاح\n',
          'DLSA': 'الـIP الخاص بالداش كام :',
          'ConfRep': 'تقارير مؤكدة\n',
          'noConfirmed': 'لا يوجد لديك تقارير مؤكده',
          'confRepNum1': 'عدد التقارير المؤكده: ',
          'editLink': 'تعديل',

          //settings_screen page
          'sitt': 'الإعدادات',
          'acc': 'حسابي',
          'PP': 'سياسة الخصوصية',
          'RASDPP': 'سياسة الخصوصية لرصد',
          'contact': 'تواصل معنا',
          'Plang': 'اللغة المفضلة',
          'change': 'تغيير',
          'choosePr': 'اختر لغتك المفضلة ',
          'lang': 'العربية',
          'AreUSure': 'هل أنت متأكد من تسجيل الخروج ؟ ',

          //showVideo page
          'showVideoHead': 'مقطع المخالفة',
          'viloation1': 'عدم ترك مسافة آمنة',
          'viloation2': 'التجاوز',
          'viloation3': 'التفحيط',
          'viloation4': 'عكس الطريق',
          'confViolation': 'هل أنت متأكد من رغبتك في تأكيد المخالفة المضبوطة؟',
          'yes': 'نعم',
          'no': 'لا',
          'conf': 'تم تأكيد المخالفة!',
          'delViolation':
              'هذه العملية غير قابلة للتراجع\nهل أنت متأكد من رغبتك في حذف المخالفة المرصودة؟',
          'delReasonTitle': 'لماذا؟',
          'delReasonQ': 'لماذا تريد حذف هذه المخالفة؟',
          'delReason1': 'مخالفة مصنفة تصنيف خاطئ',
          'delReason2': 'لست مهتمًا بالتبليغ',
          'delConfirmation': '!تم حذف المقطع بنجاح',
          '  confButton  ': 'تأكيد',
          '  delButton  ': 'حذف',
          'success': 'عملية ناجحة',
          'isViolation': 'تم رصد مخالفات في المقطع أعلاه، هل تراها صحيحة؟',
          'violationType': 'حدد نوع المخالفة من القائمة أدناه:',
          'IDK': 'لا أعلم',
          'addInfo': 'معلومات إضافيه',
          //   pending videos
          'moreText': 'مساحة إضافية لكتابة نص',
          'PVV': 'مقاطع قيد المراجعة',
          'Watch': 'شاهد كل مقطع لتأكيده',
          'Select': ' واختر نوع المخالفة',
          'VV': 'مقطع مخالفة ',
          'NPV': 'لا يوجد مقاطع مخالفات',
          'NPVA': 'يبدو أنه لا يوجد لديك مقاطع مخالفات حاليًا',

          // //confirmed reports
          'CVR': 'تقارير مخالفات مؤكده',
          'Send':
              ' شارك تقاريرك المؤكدة الى الجهات المعنية عن طريق البريد الإلكتروني',
          'VR': 'تقرير المخالفة ',
          'NVR': 'لا يوجد تقارير مخالفات',
          'NVRA': 'يبدو أنه ليس لديك تقارير مخالفات حاليًا',
          'NotSelected': 'لم يتم تحديد نوع المخالفة',

          // Edit file
          'successEditing': 'تم تحديث معلومات التقرير بنجاح',
          'confEdit': 'هل انت متأكد من حفظ التغيرات المدخلة',
          'EditReportHead': 'تعديل معلومات التقرير', // **********

          // //link page
          'LTOAPP': 'اربط الداش الخاصة بك بتطبيقنا ',
          'IP': 'أدخل رمز الـ IP الخاص بكاميرا الداش كام', //
          'Link': 'ربط',
          'How': 'كيف أحصل على IP ؟',
          'editMess':
              'هل أنت متأكد من حفظ التغييرات المدخله الخاصة بالـIP ؟ ', //*
          'linkMess': 'هل أنت متأكد من الـ IP المدخل ؟ ', // *
          'C': 'إلغاء',
          'S': 'تمت العملية بنجاح',
          'descSucess': 'تمت عملية ربط كاميراتك الداش كام بتطبيقنا بنجاح ',
          'descS': 'تمت عملية ربط كاميراتك الداش كام بتطبيقنا بنجاح ',
          'Ok': 'حسنًا',
          'E': 'خطأ',
          'DashCamtoolTip': 'يمكنك إيجاد الـ IP في إعدادات الداش كام الخاصة بك',
          'editDashCam': 'حدث الـIP الخاص بالداش كام', //*

          //log in register
          'passIsNotCorrect':
              'كلمة المرور غير صالحة أو ليس لهذا المستخدم كلمة مرور ',
          'EmailPassError':
              'البريد الإلكتروني المدخل أو كلمة المرور المدخلة غير صحيحة',
          'infoCompletionError': 'رجاءً، أكمل إدخال معلوماتك',
          'logIn': 'تسجيل الدخول',
          'register': 'التسجيل',
          'logIn2': 'تسجيل الدخول',
          'signUp': 'إنشاء حساب',
          'forogtPass': 'نسيت كلمة المرور؟',
          'creatAcc': 'أنشئ حسابك',
          'FN': 'الاسم الأول',
          'LN': 'الاسم الأخير',
          'email': 'البريد الإلكتروني',
          'pass': 'كلمة المرور',
          'confPass': 'تأكيد كلمة المرور',
          'noAcc': 'ليس لديك حساب؟',
          'logToAcc': 'سجل الدخول لحسابك',
          'noAccountError':
              'لا يوجد حساب مسجل للعنوان الإلكتروني البريدي المدخل',
          'Agreemnt1': 'لقد قرأت و أوافق على ',
          'Agreemnt2': 'سياسة الخصوصية الخاصة برَصْد',
          'okButton': 'حسنًا',
          'alradyAcc': 'لديك حساب من قبل؟',
          'demandPolicy': "يجب عليك الموافقة على سياسة خصوصية رصد",
          'AccountExist':
              'عنوان البريد الإلكتروني قيد الاستخدام بالفعل من قبل حساب آخر.',
          'networkError':
              'حدث خطأ في الشبكة!\nالرجاء التحقق من اتصال الانترنت الخاص بك',

          //textFormGlobal    //* changes //*
          'ipForm':
              'رمز الـ IP لا بد أن يكون بالصيغة التالية\n (000.000.000.000)\n حيث ان 0 يمثل أي عدد من 0 الى 9\n و الـ 000 يجب ان لاتتجاوز 255',
          'enterDIP': 'أدخل رمز الـ IP الخاص بكاميرا الداش كام',
          'noMatchPass': 'كلمتا المرور التي أدخلتهما لا تتطابقان ',
          'enterLN': 'أدخل اسمك الأخير',
          'enterFN': 'أدخل اسمك الأول',
          'enterFN0': 'ادخل اسمك\nالأول',
          'enterLN0': 'ادخل اسمك\nالأخير ',
          'enterPass': 'أدخل كلمة المرور',
          'invalidE':
              ' عنوان البريد الإلكتروني غير صالح،\n رجاءً اتبع الصيغة التالية : \nexample@example.com',
          'enterE': 'أدخل بريدك الإلكتروني',
          '8charactersValidation':
              'يجب أن تحتوي كلمة المرور على ٨ خانات\n تتضمن أحرف كبيرة وأحرف صغيرة و أرقام\n ورموز',
          'FLValidation': 'يسمح لك بإدخال\n أحرف فقط ',

          //verfiyEmail
          'cancel': 'إلغاء',
          'checkSpam':
              'في حال لم تصلك الرسالة في البريد الالكتروني، تأكد من مراجعة مجلد الرسائل غير المرغوب فيها',
          'verfE': 'تم إرسال رسالة التأكيد إلى عنوان بريدك الإلكتروني',
          'resendE': 'إعادة إرسال البريد الإلكتروني',

          //forgotpass
          'assocE':
              'أدخل البريد الإلكتروني المرتبط بحسابك و سيتم إرسال رابط إعادة ضبط كلمة المرور',
          'resetPassE':
              'تم إرسال رسالة إعادة ضبط كلمة المرور\nفي حال لم تصلك الرسالة في البريد الالكتروني، تأكد من مراجعة مجلد الرسائل غير المرغوب فيها',
          'resetPass': 'إعادة ضبط كلمة المرور',

          //app root
          'Home': '\nالرئيسية',
          'PV': "مقاطع قيد المراجعة",
          'CR': "\nتقارير المخالفات المؤكدة",
          'More': '\nالإعدادات',

          // pdf report
          'vr': 'تقرير المخالفة',
          'ViolationRep': 'تقرير المخالفة',
          'des':
              'هذه المخالفة تم رصدها من قبل رصد عن طريق نموذج الذكاء الإصطناعي في المملكة العربية السعودية.',
          'name': 'الإسم',
          'email': 'البريد الإلكتروني',
          'link': 'رابط المخالفة',
          'viotype': ' نوع المخالفة',
          'VTime': 'وقت المخالفة',
          'Preview': 'عرض',
          'delConfreport':
              'هل أنت متأكد من رغبتك بحذف تقرير المخالفة ؟ \n هذه العملية غير قابلة للتراجع ',
          'Rdelete': 'تم حذف التقرير بنجاح!',

          //email
          'subject': 'تقرير مخالفة مرورية',
          'body':
              'مرحبًا,\nهذا الايميل مرسل عن طريق سائق في المملكة العربية السعودية من خلال تطبيق رَصْد. مرفق لكم تقرير مفصل للمخالفة مرورية المرصودة.\n\n\nشكرًا لكم،\nفريق رَصْد ',
          'filename': 'تقرير مخالفة مرورية مصدر من رَصْد',

          // privacy page
          'RPP': 'سياسية خصوصيةرصد',
          'it1': 'البند الأول: مقدمة',
          'it1text':
              ' من مبدأ أهمية البيانات وسريتها ، وحرصًا من رصد على الالتزام بسرية وخصوصية معلومات المستخدم ، فإن إدارة رصد ملتزمة بالحفاظ على سرية وخصوصية معلومات المستخدم ، والمواد المدخلة من قبله كأساس لسياسة الخصوصية، ولن تقوم إدارة رصد بالإفصاح عن تلك المعلومات إلا وفقًا للضوابط المحددة ، والمنصوص عليها في هذه السياسية ،ووفق الأحكام النطامية الصادرة بهذا الشأن.',
          'it2': ' البند الثاني: معلومات المستخدم',
          'it2text':
              'يقصد ببيانات ومعلومات المستخدم كافة بيانات المستخدم الموجودة في التطبيق ومن ذلك:\n\n- البيانات الشخصية المستخدمة في التسجيل.\n- البيانات المتعلقة بالداش كام لاكتشاف المخالفات المرورية.\n- تقارير المخالفات المرورية.',
          'it3': 'البند الثالث: جمع المعلومات وتخزينها',
          'it3text':
              'يتم جمع المعلومات في رصد عن طريق البيانات المدخلة من المستخد وكاميرا لرصد المخالفات المرورية وتخزينها في الخوادم التي يحددها التطبيق.',
          'it4': 'البند الرابع: مشاركة البيانات',
          'it4text':
              'يجوز استخدام بيانات المستخدم كروابط المخالفات المرورية لتحسين خدمة رصد المخالفات ومشاركة تقارير المخالفات المرورية مع الجهات المختصة.',
          'it5': 'البند الخامس: إدارة التطبيق',
          'it5text':
              'اسم الجهة المشرفة على التطبيق: جامعة الملك سعود كلية علوم الحاسب والمعلومات ،قسم تقنية المعلومات. ',

          // account
          'acc': 'حسابي',
          'fname': 'الإسم الأول',
          'lname': 'الإسم الأخير',
          'em': 'البريد الإلكتروني',
          'save': 'حفظ',
          'FLValidation1': 'يسمح لك بإدخال أحرف فقط ',
          'updateMess': 'تم تحديث معلوماتك بنجاح',
          'AreUSureToSave': 'هل أنت متأكد من تحديث معلوماتك وحفظها؟',
          'oldE': 'عنوان البريد الإلكتروني السابق',
          'enterEOld': 'أدخل عنوان بريدك الإلكتروني السابق',
          'update': 'تحديث',
          'changeE':
              'لتحديث البريد الإلكتروني الرجاء ادخال عنوان البريد الإلكتروني السابق وكلمة المرور:',
          'invalidE2':
              ' عنوان البريد الإلكتروني غير صالح، رجاءً اتبع الصيغة \nالتالية : example@example.com',
        }
      };
}

import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/foundation.dart";
import "package:shared_preferences/shared_preferences.dart";

const _kLocaleStorageKey = "__locale_key__";

class FFLocalizations {
  FFLocalizations(this.locale);

  final Locale locale;

  static FFLocalizations of(BuildContext context) {
    final localization =
        Localizations.of<FFLocalizations>(context, FFLocalizations);
    if (localization == null) {
      // Return a default instance with English locale if not initialized
      return FFLocalizations(const Locale('en'));
    }
    return localization;
  }

  static List<String> languages() => ["en", "ar"];

  static late SharedPreferences _prefs;
  static Future initialize() async =>
      _prefs = await SharedPreferences.getInstance();
  static Future storeLocale(String locale) =>
      _prefs.setString(_kLocaleStorageKey, locale);
  static Locale? getStoredLocale() {
    final locale = _prefs.getString(_kLocaleStorageKey);
    return locale != null && locale.isNotEmpty ? createLocale(locale) : null;
  }

  String get languageCode => locale.toString();
  String? get languageShortCode =>
      _languagesWithShortCode.contains(locale.toString())
          ? "${locale.toString()}_short"
          : null;
  int get languageIndex => languages().contains(languageCode)
      ? languages().indexOf(languageCode)
      : 0;

  String getText(String key) =>
      (kTranslationsMap[key] ?? {})[locale.toString()] ?? "";

  String getVariableText({
    String? enText = "",
    String? arText = "",
  }) =>
      [enText, arText][languageIndex] ?? "";

  static const Set<String> _languagesWithShortCode = {
    "ar",
    "az",
    "ca",
    "cs",
    "da",
    "de",
    "dv",
    "en",
    "es",
    "et",
    "fi",
    "fr",
    "gr",
    "he",
    "hi",
    "hu",
    "it",
    "km",
    "ku",
    "mn",
    "ms",
    "no",
    "pt",
    "ro",
    "ru",
    "rw",
    "sv",
    "th",
    "uk",
    "vi",
  };
}

/// Used if the locale is not supported by GlobalMaterialLocalizations.
class FallbackMaterialLocalizationDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const FallbackMaterialLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<MaterialLocalizations> load(Locale locale) async =>
      SynchronousFuture<MaterialLocalizations>(
        const DefaultMaterialLocalizations(),
      );

  @override
  bool shouldReload(FallbackMaterialLocalizationDelegate old) => false;
}

/// Used if the locale is not supported by GlobalCupertinoLocalizations.
class FallbackCupertinoLocalizationDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      SynchronousFuture<CupertinoLocalizations>(
        const DefaultCupertinoLocalizations(),
      );

  @override
  bool shouldReload(FallbackCupertinoLocalizationDelegate old) => false;
}

class FFLocalizationsDelegate extends LocalizationsDelegate<FFLocalizations> {
  const FFLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<FFLocalizations> load(Locale locale) =>
      SynchronousFuture<FFLocalizations>(FFLocalizations(locale));

  @override
  bool shouldReload(FFLocalizationsDelegate old) => false;
}

Locale createLocale(String language) => language.contains("_")
    ? Locale.fromSubtags(
        languageCode: language.split("_").first,
        scriptCode: language.split("_").last,
      )
    : Locale(language);

bool _isSupportedLocale(Locale locale) {
  final language = locale.toString();
  return FFLocalizations.languages().contains(
    language.endsWith("_")
        ? language.substring(0, language.length - 1)
        : language,
  );
}

final kTranslationsMap = <Map<String, Map<String, String>>>[
  // Login
  {
    "dumbbell": {
      "en": "Dumbbell",
      "ar": "دمبل",
    },
    "machine": {
      "en": "Machine",
      "ar": "الآلة",
    },
    "equipment": {
      "en": "Equipment",
      "ar": "الأجهزة الرياضية",
    },
    "exercises_selected": {
      "en": "Exercises Selected",
      "ar": "التمارين المحددة",
    },
    "jqy87hqi": {
      "en": "Continue Watching",
      "ar": "متابعة المشاهدة",
    },
    "xjwed7h7": {
      "en": "Choose how you\"d like to access this content",
      "ar": "حدد كيف يمكنك الوصول لهذا القسم",
    },
    "w5rfrseu": {
      "en": "Premium Access",
      "ar": "إشتراك في الباقة",
    },
    "29k2j7bb": {
      "en": "/month - No ads, unlimited access",
      "ar": "/شهر - لا يوجد اعلانات",
    },
    "bsb8adg1": {
      "en": "Watch Ad",
      "ar": "مشاهدة إعلان",
    },
    "cpwu14gx1": {
      "en": "Watch a 30-second ad to continue",
      "ar": "مشاهدة اعلان 30 ثانية للمتابعة",
    },
    "ailtp9g7": {
      "en": "Welcome Back,",
      "ar": "مرحبًا بعودتك،",
    },
    "3mailc8e": {
      "en": "Please Enter Your Information",
      "ar": "الرجاء إدخال معلوماتك",
    },
    "sofc33et": {
      "en": "Email Address",
      "ar": "البريد الإلكتروني",
    },
    "oouq0zr5": {
      "en": "abc@gmail.com",
      "ar": "abc@gmail.com",
    },
    "be7jrni4": {
      "en": "Password",
      "ar": "كلمة المرور",
    },
    "ipss5vw9": {
      "en": "***",
      "ar": "***",
    },
    "by7fphqy": {
      "en": "Sign In",
      "ar": "تسجيل الدخول",
    },
    "uym5vj9y": {
      "en": "Forgot Password?",
      "ar": "نسيت كلمة المرور؟",
    },
    "24szukkz": {
      "en": "OR",
      "ar": "أو",
    },
    "m4fuhw1y": {
      "en": "Continue with Google",
      "ar": "التسجيل بإستخدام جوجل",
    },
    "ljqtsraq": {
      "en": "Create Account",
      "ar": "إنشاء حساب",
    },
    "w1d3ch05": {
      "en": "Home",
      "ar": "الرئيسية",
    },
  },
  // UserHome
  {
    "c6ki0mzp": {
      "en": "Hello,",
      "ar": "مرحباً،",
    },
    "q2rx8ftc": {
      "en": "Fitness Goal",
      "ar": "هدفك الرياضي",
    },
    "NoNotifications": {
      "en": "No notifications",
      "ar": "لا يوجد تنبيهات",
    },
    "708uvl64": {
      "en": "You made progress.",
      "ar": "أمامك خطوة للتقدم",
    },
    "cded3l3z": {
      "en": "55%",
      "ar": "55%",
    },
    "3rnohv4q": {
      "en": "Build your muscles weight",
      "ar": "بناء عضلاتك بالوزن",
    },
    "mc7rofba": {
      "en": "Say goodbye to boring workouts and hello to a gym app",
      "ar": "وداعًا للتمارين الرياضية المملة ومرحبًا بتطبيق الصالة الرياضية",
    },
    "p9j0rtg5": {
      "en": "Fitness",
      "ar": "لياقة",
    },
    "fqr3kl0u": {
      "en": "My exercises",
      "ar": "تماريني",
    },
    "no_exercises_found": {
      "en": "No exercises found",
      "ar": "لا توجد تمارين",
    },
    "5nbt3cfv": {
      "en": "What are your exercises today?",
      "ar": "ما هي تمارينك اليوم؟",
    },
    "7omjnrev": {
      "en": "Plan",
      "ar": "خطة",
    },
    "xf6cgl4t": {
      "en": "Make a plan using AI",
      "ar": "وضع خطة بإستخدام الذكاء الإصطناعي",
    },
    "ogrvhqz7": {
      "en": "Get ready for a tailor-made strategy that suits your needs.",
      "ar": "استعد لاستراتيجية مصممة خصيصًا لتناسب احتياجاتك.",
    },
    "mbbgn2x9": {
      "en": "Home",
      "ar": "الرئيسية",
    },
  },
  // SignUp
  {
    "30pdmhlo": {
      "en": "Welcome Back,",
      "ar": "مرحبًا بعودتك،",
    },
    "l540r2yi": {
      "en":
          "Your strength starts here! 🚀 Don't stop, make a difference today! 💪",
      "ar": "قوتك تبدأ من هنا! 🚀 لا تتوقف، اصنع الفرق اليوم! 💪",
    },
    "hfdr7ndk": {
      "en": "Email Address",
      "ar": "البريد الإلكتروني",
    },
    "9bq00hqy": {
      "en": "abc@gmail.com",
      "ar": "abc@gmail.com",
    },
    "1z6uu7dq": {
      "en": "Password",
      "ar": "كلمة المرور",
    },
    "6o2g8wsn": {
      "en": "***",
      "ar": "***",
    },
    "k4gozom7": {
      "en": "Create Account",
      "ar": "إنشاء حساب",
    },
    "dtyksqek": {
      "en": "OR",
      "ar": "أو",
    },
    "9r44g6ni": {
      "en": "Continue with Google",
      "ar": "التسجيل بإستخدام جوجل",
    },
    "5f1qv9wo": {
      "en": "Login",
      "ar": "تسجيل الدخول",
    },
    "m8gdz1wf": {
      "en": "Home",
      "ar": "الرئيسية",
    },
    "coach": {
      "en": "Coach Account",
      "ar": "حساب مدرب",
    },
    "trainee": {
      "en": "Trainee Account",
      "ar": "حساب متدرب",
    },
    "traineeDescription": {
      "en": "Get personalized training plans from professional coaches",
      "ar": "احصل على خطط التدريب الشخصية من مدربك",
    },
    "coachDescription": {
      "en": "Create and manage training plans for your clients",
      "ar": "وإدارة المتدربين وخطط التدريب لعملائك"
    },
  },
  // PreLogin
  {
    "wvijpfp8": {
      "en":
          "Level up your coaching business and leave your competitors in the dust!",
      "ar": "طور شغلك في التدريب وخلّي منافسيك وراك بسنين!",
    },
    "hw4p8n0a": {
      "en":
          "Say goodbye to messy spreadsheets and hello to smooth, stress-free management.",
      "ar":
          "ودّع اللخبطة مع الجداول والدفاتر ورحب بالسلاسة والإدارة بدون أي وجع راس.",
    },
    "f99tksnc": {
      "en": "Get Started",
      "ar": "لنبدأ الأن",
    },
    "el4snzdb": {
      "en": "Home",
      "ar": "الرئيسية",
    },
  },
  // days
  {
    "dv1k6pvj": {
      "en": "Weekly Exercises",
      "ar": "تمارين أسبوعية",
    },
  },
  // userExercises
  {
    "ue602o8f": {
      "en": "Today\"s Workout",
      "ar": "تمرين اليوم",
    },
    "rconapdq": {
      "en": "Today\"s Progress",
      "ar": "تقدم اليوم",
    },
    "keepPushing": {
      "en": "Keep pushing towards your goals!",
      "ar": "استمر في الطليعة نحو أهدافك!",
    },
    "dayStreak": {
      "en": "Day Streak",
      "ar": "يوماً متواصلاً",
    },
    "recentAchievements": {
      "en": "Recent Achievements",
      "ar": "النجاحات الحديثة",
    }
  },
  // userProfile
  {
    "9km4g1xw": {
      "en": "My Profile",
      "ar": "ملفي الشخصي",
    },
    "vxsbf1gq": {
      "en": "View and edit your information",
      "ar": "عرض وتحرير معلوماتك",
    },
    "40ue080t": {
      "en": "End Date",
      "ar": "تاريخ إنتهاء الإشتراك",
    },
    "qvzacvtx": {
      "en": "Edit Profile",
      "ar": "تعديل الملف الشخصي",
    },
    "a8fkfz8o": {
      "en": "Personal Information",
      "ar": "معلومات شخصية",
    },
    "coach_personal_info": {
      "en": "Let's get to know each other better, coach 😉",
      "ar": "عرفنا عن نفسك كوتش 😉",
    },
    "professional_details": {
      "en": "Professional Details",
      "ar": "تفاصيل المهنة",
    },
    "body_metrics": {
      "en": "Body Metrics",
      "ar": "معلومات الجسم",
    },
    "fitness_goals": {
      "en": "Fitness Goals",
      "ar": "اهداف التدريب",
    },
    "5vy2q12i": {
      "en": "Height",
      "ar": "الطول",
    },
    "tcxcdcm7": {
      "en": "Weight",
      "ar": "الوزن",
    },
    "glzsjd4b": {
      "en": "Date of Birth",
      "ar": "تاريخ الميلاد",
    },
    "age": {
      "en": "Age",
      "ar": "العمر",
    },
    "28zm1ir2": {
      "en": "Goal",
      "ar": "الهدف",
    },
    "l71wmkbu": {
      "en": "Account Settings",
      "ar": "إعدادات الحساب",
    },
    "txhqem8w": {
      "en": "Edit Information",
      "ar": "تعديل المعلومات",
    },
    "logout": {
      "en": "Logout",
      "ar": "تسجيل الخروج",
    },
    "vre6qnh1": {
      "en": "Change Password",
      "ar": "تغيير كلمة المرور",
    },
    "4qkg2hwn": {
      "en": "Change language",
      "ar": "تغيير اللغة",
    },
    "42922m6q": {
      "en": "Help Center",
      "ar": "مركز المساعدة",
    },
    "rht8hzyz": {
      "en": "Sign Out",
      "ar": "تسجيل الخروج",
    },
  },
  // CoachHome
  {
    "y6lkmf4w": {
      "en": "Coach Dashboard",
      "ar": "لوحة تحكم المدرب",
    },
    "hct5x4gc": {
      "en": "Welcome back,",
      "ar": "مرحبًا بعودتك،",
    },
    "wuiqzsk2": {
      "en": "Active Clients",
      "ar": "العملاء النشطين",
    },
    "o6oyyl6j": {
      "en": "Total Paid",
      "ar": "الإجمالي المدفوع",
    },
    "iplgncry": {
      "en": "New Users",
      "ar": "مستخدمون جدد",
    },
    "noData": {
      "en": "No Data Available",
      "ar": "لا يوجد بيانات متاحة",
    },
    "3zm1gqar": {
      "en": "New",
      "ar": "جديد",
    },
    "smxiy5uk": {
      "en": "Quick Actions",
      "ar": "إجراءات سريعة",
    },
    "vecicunb": {
      "en": "Add Client",
      "ar": "إضافة عميل",
    },
    "f90f3w9k": {
      "en": "Plans",
      "ar": "الخطط",
    },
    "vj2epgx9": {
      "en": "Messages",
      "ar": "الرسائل",
    },
    "messages_are_automatically_deleted_after_7_days": {
      "en": "Messages are automatically deleted after 7 days",
      "ar": "الرسائل تتم حذفها تلقائياً بعد 7 أيام",
    },
    "f49skyku": {
      "en": "Analytics",
      "ar": "التحليلات",
    },
    "zcsyzdge": {
      "en": "",
      "ar": "",
    },
  },
  // AddClient
  {
    "o7wn7dhx": {
      "en": "Add New Client",
      "ar": "إضافة عميل جديد",
    },
    "rq0vile6": {
      "en": "Enter client information below",
      "ar": "أدخل معلومات العميل أدناه",
    },
    "u8sdx4sw": {
      "en": "Email",
      "ar": "الإيميل",
    },
    "ey7tn5dd": {
      "en": "abc@gmail.com",
      "ar": "abc@gmail.com",
    },
    "1qacacys": {
      "en": "Start Date",
      "ar": "تاريخ البدء",
    },
    "prqg6mlg": {
      "en": "Select Date",
      "ar": "اختر تاريخ",
    },
    "r448i96u": {
      "en": "End Date",
      "ar": "تاريخ الانتهاء",
    },
    "ud6tvmoh": {
      "en": "Training Details",
      "ar": "تفاصيل التدريب",
    },
    "fnycvvuy": {
      "en": "Training Goals",
      "ar": "أهداف التدريب",
    },
    "choose_goal_subtitle": {
      "en": "Choose the primary goal",
      "ar": "اختر الهدف الرئيسي",
    },
    "k7u005at": {
      "en": "weight gain",
      "ar": "زيادة الوزن",
    },
    "dsm2y1ow": {
      "en": "Current Fitness Level",
      "ar": "مستوى اللياقة الحالي",
    },
    "1h4l5b6m": {
      "en": "Beginner",
      "ar": "مبتدئ",
    },
    "vncaynbk": {
      "en": "Intermediate",
      "ar": "متوسط",
    },
    "ocvkm51o": {
      "en": "Advanced",
      "ar": "متقدم",
    },
    "0547geac": {
      "en": "Preferred Training Days",
      "ar": "أيام التدريب المفضلة",
    },
    "74idyhuz": {
      "en": "Mon",
      "ar": "الإثنين",
    },
    "om9u9p6c": {
      "en": "Tue",
      "ar": "الثلاثاء",
    },
    "j6hlv8yt": {
      "en": "Wed",
      "ar": "الأربعاء",
    },
    "u8h2f8la": {
      "en": "Thu",
      "ar": "الخميس",
    },
    "mof3mmpj": {
      "en": "Fri",
      "ar": "الجمعة",
    },
    "aedjdasy": {
      "en": "Sat",
      "ar": "السبت",
    },
    "iew1q13q": {
      "en": "Sun",
      "ar": "الأحد",
    },
    "c11xb84v": {
      "en": "Additional Information",
      "ar": "معلومات إضافية",
    },
    "s3kxq2nc": {
      "en": "Amount paid",
      "ar": "المبلغ المدفوع",
    },
    "aigyqqsb": {
      "en": "100",
      "ar": "100",
    },
    "kcmdk6wv": {
      "en": "Debts",
      "ar": "الديون",
    },
    "vvgu6u6f": {
      "en": "50",
      "ar": "50",
    },
    "h8l2wgyn": {
      "en": "Add Client",
      "ar": "إضافة عميل",
    },
  },
  // CoachExercisesPlans
  {
    "8hnaygrm": {
      "en": "Workout Plans",
      "ar": "خطط التمرين",
    },
    "fglksp95": {
      "en": "Manage training programs",
      "ar": "إنشاء وإدارة برامج التدريب",
    },
    "plans": {
      "en": "Plans",
      "ar": "خطط",
    },
    "drafts": {
      "en": "Drafts",
      "ar": "مسودات",
    },
    "uc74cy6m": {
      "en": "Active Plans",
      "ar": "خطط نشطة",
    },
    "0gi3i7gz": {
      "en": "Active",
      "ar": "نشط",
    },
    "udv61i44": {
      "en": "Draft Plans",
      "ar": "خطط مسودة",
    },
    "7r7i58hl": {
      "en": "Draft",
      "ar": "مسودة",
    },
  },
  // createExercisePlan
  {
    "drkdjo18": {
      "en": "Create Plan",
      "ar": "إنشاء خطة",
    },
    "h5uiph9g": {
      "en": "Design a new training program",
      "ar": "تصميم برنامج تدريبي جديد",
    },
    "itpi07oi": {
      "en": "Plan Details",
      "ar": "تفاصيل الخطة",
    },
    "aj70rhi0": {
      "en": "Plan Name",
      "ar": "اسم الخطة",
    },
    "kac6c4m1": {
      "en": "Description",
      "ar": "الوصف",
    },
    "56uefxy7": {
      "en": "Program Structure",
      "ar": "هيكل البرنامج",
    },
    "spfhprtu": {
      "en": "Beginner",
      "ar": "مبتدئ",
    },
    "1pvh1cxx": {
      "en": "Intermediate",
      "ar": "متوسط",
    },
    "lxrqt25o": {
      "en": "Advanced",
      "ar": "متقدم",
    },
    "amdnrtzx": {
      "en": "Strength",
      "ar": "كسب القوة",
    },
    "9d9lxfgp": {
      "en": "Cardio",
      "ar": "فقدان الوزن",
    },
    "duqb8whi": {
      "en": "Build Muscle",
      "ar": "بناء العضلات",
    },
    "build_muscle_lose_weight": {
      "en": "Build Muscle & Lose Weight",
      "ar": "بناء العضلات & فقدان الوزن",
    },
    "nutrition": {
      "en": "Nutrition",
      "ar": "تغذية",
    },
    "weight_loss": {
      "en": "Weight Loss",
      "ar": "فقدان الوزن",
    },
    "yoga": {
      "en": "Yoga",
      "ar": "يوغا",
    },
    "sports_training": {
      "en": "Sports Training",
      "ar": "تدريب الرياضات",
    },
    "2c8cxh20": {
      "en": "Flexibility",
      "ar": "مرونة",
    },
    "94of5dmb": {
      "en": "Schedule",
      "ar": "الجدول",
    },
    "c71ma75q": {
      "en": "Add Day",
      "ar": "إضافة يوم",
    },
    "bj0yxoi0": {
      "en": "Create Plan",
      "ar": "إنشاء خطة",
    },
    "wowhr087": {
      "en": "Save as Draft",
      "ar": "حفظ كمسودة",
    },
    "save_as_active": {
      "en": "Save as Active",
      "ar": "حفظ كنشط",
    },
  },
  // selectExercisesEdit
  {
    "ini4zgco": {
      "en": "Select Exercises",
      "ar": "اختر التمارين",
    },
    "g39ttzvd": {
      "en": "Search exercises...",
      "ar": "ابحث عن التمارين...",
    },
    "muzuzzpk": {
      "en": "Chest",
      "ar": "صدر",
    },
    "dknt2fwo": {
      "en": "Back",
      "ar": "ظهر",
    },
    "rf1j71ve": {
      "en": "Cardio",
      "ar": "كارديو",
    },
    "tgxssqhx": {
      "en": "Arms",
      "ar": "ذراعين",
    },
    "oer8505b": {
      "en": "Legs",
      "ar": "أرجل",
    },
    "11vb1o4d": {
      "en": "Neck",
      "ar": "رقبة",
    },
    "p8hf1cas": {
      "en": "Shoulders",
      "ar": "أكتاف",
    },
    "a31scl0q": {
      "en": "Waist",
      "ar": "خصر",
    },
    "8c42nk4u": {
      "en": "Exercises",
      "ar": "تمارين",
    },
    "0gd7f5u8": {
      "en": "Exercises",
      "ar": "تمارين",
    },
    "8r5p4tf9": {
      "en": "Add Selected Exercises",
      "ar": "إضافة التمارين المحددة",
    },
    "selected_exercises": {
      "en": "Selected Exercises",
      "ar": "التمارين المحددة",
    },
    "tap_to_edit_exercise": {
      "en": "Tap to edit exercise",
      "ar": "انقر لتعديل التمرين",
    }
  },
  // coachAnalytics
  {
    "gfyo8n2n": {
      "en": "Coach Analytics",
      "ar": "تحليلات المدرب",
    },
    "lknc4121": {
      "en": "Performance Overview",
      "ar": "نظرة عامة على الأداء",
    },
    "xvveezgw": {
      "en": "All Clients",
      "ar": "كل العملاء",
    },
    "p0eikzd9": {
      "en": "Income",
      "ar": "الدخل",
    },
    "6ckgtnyk": {
      "en": "Client Ages",
      "ar": "أعمار العملاء",
    },
    "jwp8kx5a": {
      "en": "Age",
      "ar": "عمر",
    },
    "b87zcx9l": {
      "en": "Recent Activities",
      "ar": "الأنشطة الأخيرة",
    },
    "y22ou22a": {
      "en": "New Client Added",
      "ar": "تم إضافة عميل جديد",
    },
    "uwnv2t7s": {
      "en": "Sarah Johnson started training",
      "ar": "بدأت سارة جونسون التدريب",
    },
    "bno4j468": {
      "en": "2m ago",
      "ar": "منذ دقيقتين",
    },
    "w8jzw2er": {
      "en": "Workout Updated",
      "ar": "تم تحديث التمرين",
    },
    "9vwtm5t7": {
      "en": "Modified chest routine for Mike",
      "ar": "تم تعديل روتين الصدر لمايك",
    },
    "hr4yv3k7": {
      "en": "1h ago",
      "ar": "منذ ساعة",
    },
  },
  // Messages
  {
    "kqnehly5": {
      "en": "Coach Messages",
      "ar": "رسائل المدرب",
    },
    "z6h7b76l": {
      "en": "Send Broadcast Message",
      "ar": "إرسال رسالة جماعية",
    },
    "l0ljacgo": {
      "en": "Type your message to all trainees...",
      "ar": "اكتب رسالتك لجميع المتدربين...",
    },
    "mu14nif2": {
      "en": "Recent Messages",
      "ar": "الرسائل الأخيرة",
    },
    "etu9d3wo": {
      "en": "Sent to: All Members",
      "ar": "تم الإرسال إلى: جميع الأعضاء",
    },
    "all": {
      "en": "All",
      "ar": "الكل",
    },
  },
  // CoachProfile
  {
    "gd27wcki": {
      "en": "Age",
      "ar": "العمر",
    },
    "t70b45uz": {
      "en": "Years Exp.",
      "ar": "سنوات الخبرة",
    },
    "ekri56yw": {
      "en": "Monthly Fee",
      "ar": "الرسوم الشهرية",
    },
    "i1jyd81k": {"en": "🙋 About Me 🤩", "ar": "🙋 معلومات عني 🤩"},
    "ux9ea1rv": {
      "en": "Account Settings",
      "ar": "إعدادات الحساب",
    },
    "k0mwnwkl": {
      "en": "Update Profile",
      "ar": "تحديث الملف الشخصي",
    },
    "ndiv3eaq": {
      "en": "Change Password",
      "ar": "تغيير كلمة المرور",
    },
    "ejww7nol": {
      "en": "Change language",
      "ar": "تغيير اللغة",
    },
    "pd5szt8z": {
      "en": "Messages",
      "ar": "الرسائل",
    },
    "shf84as4": {
      "en": "Get Premium Account",
      "ar": "احصل على حساب بريميوم",
    },
    "premium": {
      "en": "Premium",
      "ar": "بريميوم",
    },
  },
  // Subscribe
  {
    "le9zbw3m": {
      "en": "Choose Your Plan",
      "ar": "اختر خطتك",
    },
    "zkaj2xy9": {
      "en": "Select the perfect plan to achieve your fitness goals",
      "ar": "اختر الخطة المثالية لتحقيق أهداف لياقتك البدنية",
    },
    "utxwvwpn": {
      "en": "Basic Plan",
      "ar": "الخطة الأساسية",
    },
    "mq8vhhev": {
      "en": "\$9.99/month",
      "ar": "9.99 دولار شهريًا",
    },
    "5gyy7sn3": {
      "en": "Popular",
      "ar": "شائع",
    },
    "b2xhfny8": {
      "en": "Personalized workout plans",
      "ar": "خطط تمرين مخصصة",
    },
    "ol573pu6": {
      "en": "Current",
      "ar": "حالياً",
    },
    "member": {
      "en": "Member In gym",
      "ar": "شخص في الجيم",
    },
    "3rcffa99": {
      "en": "Basic nutrition guides",
      "ar": "أدلة التغذية الأساسية",
    },
    "e54yffol": {
      "en": "Choose Basic",
      "ar": "اختر الأساسيات",
    },
    "389yrg72": {
      "en": "You Are subscribed",
      "ar": "أنت مشترك",
    },
    "6aeqqyeu": {
      "en":
          "By subscribing, you agree to our Terms of Service and Privacy Policy",
      "ar":
          "من خلال الاشتراك، فإنك توافق على شروط الخدمة وسياسة الخصوصية الخاصة بنا",
    },
  },
  // CoachEnterInfo
  {
    "xljmjvc1": {
      "en": "Coach Profile Setup",
      "ar": "إعداد ملف المدرب",
    },
    "0ok14kdy": {
      "en": "Tell us about your expertise and experience",
      "ar": "أخبرنا عن خبرتك وتجربتك",
    },
    "jycci6lz": {
      "en": "Basic Information",
      "ar": "معلومات أساسية",
    },
    "personalPicture": {
      "en": "Personal Picture",
      "ar": "صورة شخصية",
    },
    "9vr3ekng": {
      "en": "Full Name",
      "ar": "الاسم الكامل",
    },
    "00els0cr": {
      "en": "Ahmad ...",
      "ar": "أحمد ...",
    },
    "aooiy1wb": {
      "en": "Age",
      "ar": "العمر",
    },
    "m39lhn13": {
      "en": "24",
      "ar": "24",
    },
    "xh0s5bdo": {
      "en": "Expertise & Experience",
      "ar": "الخبرة والتجربة",
    },
    "98tdfdky": {
      "en": "Years of Experience",
      "ar": "سنوات الخبرة",
    },
    "w13dhsn8": {
      "en": "6",
      "ar": "6",
    },
    "69s6avth": {
      "en": "About Me",
      "ar": "معلومات عني",
    },
    "e3cod0mf": {
      "en": "I have 6 years experience ...",
      "ar": "لدي 6 سنوات من الخبرة ...",
    },
    "u1xvkqx1": {
      "en": "Specializations",
      "ar": "التخصص",
    },
    "z4uf52a6": {
      "en": "Strength Training",
      "ar": "تدريب القوة",
    },
    "f3ivjmvf": {
      "en": "HIIT",
      "ar": "تدريب متقطع عالي الكثافة",
    },
    "0daxpqom": {
      "en": "Nutrition",
      "ar": "تغذية",
    },
    "ifgkvihc": {
      "en": "Physical Fitness",
      "ar": "اللياقة البدنية",
    },
    "zojont2z": {
      "en": "Yoga",
      "ar": "يوغا",
    },
    "mfdtfkgi": {
      "en": "Cardio",
      "ar": "كارديو",
    },
    "6qgiotpz": {
      "en": "Sports Training",
      "ar": "تدريب رياضي",
    },
    "5m5pjgd0": {
      "en": "Rehabilitation",
      "ar": "إعادة تأهيل",
    },
    "f9neks31": {
      "en": "Pricing",
      "ar": "التسعير",
    },
    "067ra0t6": {
      "en": "Monthly Subscription Price (\$)",
      "ar": "سعر الاشتراك الشهري",
    },
    "jj2o77x1": {
      "en": "Create Profile",
      "ar": "إنشاء ملف",
    },
  },
  // userEnterInfo
  {
    "yde882gd": {
      "en": "Trainee Profile",
      "ar": "ملف المتدرب",
    },
    "w3fmcsci": {
      "en": "Tell us about yourself to get a personalized training experience",
      "ar": "أخبرنا عن نفسك للحصول على تجربة تدريب مخصصة",
    },
    "5mzcuep6": {
      "en": "Personal Information",
      "ar": "معلومات شخصية",
    },
    "ziwjm0v1": {
      "en": "Full Name",
      "ar": "الاسم الكامل",
    },
    "onenixmk": {
      "en": "Ahmad ...",
      "ar": "أحمد ...",
    },
    "h3ozgph7": {
      "en": "Age",
      "ar": "العمر",
    },
    "jw22ytyd": {
      "en": "24",
      "ar": "24",
    },
    "gciphuh3": {
      "en": "Gender",
      "ar": "الجنس",
    },
    "of3kkd2s": {
      "en": "Male",
      "ar": "ذكر",
    },
    "0qvrqp4v": {
      "en": "Female",
      "ar": "أنثى",
    },
    "5tc3wap3": {
      "en": "Other",
      "ar": "آخر",
    },
    "w2zhnn8t": {
      "en": "Your Physical Attributes",
      "ar": "معلوماتك الفيزيولوجية",
    },
    "ipep4d7i": {
      "en": "Height (cm)",
      "ar": "الطول (سم)",
    },
    "egcg3chl": {
      "en": "170",
      "ar": "170",
    },
    "kt2idkx2": {
      "en": "Weight (kg)",
      "ar": "الوزن (كجم)",
    },
    "d2armcm8": {
      "en": "80",
      "ar": "80",
    },
    "oc68hujx": {
      "en": "Fitness Goals",
      "ar": "أهداف اللياقة البدنية",
    },
    "fpxa6q3k": {
      "en": "Primary Goal",
      "ar": "الهدف الأساسي",
    },
    "l4jnb5s4": {
      "en": "Weight Loss",
      "ar": "فقدان الوزن",
    },
    "6ihfrub3": {
      "en": "Muscle Gain",
      "ar": "زيادة العضلات",
    },
    "hey16u68": {
      "en": "Endurance",
      "ar": "تحمل",
    },
    "jhwxaksc": {
      "en": "Flexibility",
      "ar": "مرونة",
    },
    "2pc70t46": {
      "en": "General Fitness",
      "ar": "لياقة عامة",
    },
    "qi41o5vj": {
      "en": "Save Profile",
      "ar": "حفظ",
    },
  },
  // plansRoutes
  {
    "i4pzcql1": {
      "en": "Plans",
      "ar": "الخطط",
    },
    "lwuee05k": {
      "en": "Choose your fitness journey",
      "ar": "اختر رحلتك في اللياقة البدنية",
    },
    "7ndmh9dh": {
      "en": "Training Plans",
      "ar": "خطط التدريب",
    },
    "9fumi8sq": {
      "en":
          "Customized workout routines to help you achieve your fitness goals",
      "ar": "روتينات تمرين مخصصة لمساعدتك في تحقيق أهداف لياقتك البدنية",
    },
    "ei9frvn8": {
      "en": "View Training Plans",
      "ar": "عرض خطط التدريب",
    },
    "zs7ls2wz": {
      "en": "Nutrition Plans",
      "ar": "خطط التغذية",
    },
    "x5n2l6e3": {
      "en":
          "Personalized meal plans and nutrition guidance for optimal results",
      "ar": "خطط وجبات مخصصة وإرشادات غذائية لتحقيق أفضل النتائج",
    },
    "aeehonbb": {
      "en": "View Nutrition Plans",
      "ar": "عرض خطط التغذية",
    },
  },
  // NutritionPlans
  {
    "0pk4v0z4": {
      "en": "Nutrition Plans",
      "ar": "خطط التغذية",
    },
    "sw35p2u8": {
      "en": "Manage your client nutrition plans",
      "ar": "إدارة خطط التغذية لعملائك",
    },
    "f0lulsew": {
      "en": "View Details",
      "ar": "عرض التفاصيل",
    },
  },
  // CreateNutritionPlans
  {
    "i9vve0di": {
      "en": "Create Nutrition Plan",
      "ar": "إنشاء خطة تغذية",
    },
    "h5t7ep68": {
      "en": "Design a customized nutrition plan for your client",
      "ar": "تصميم خطة تغذية مخصصة لعميلك",
    },
    "jjfz2qkx": {
      "en": "Plan Details",
      "ar": "تفاصيل الخطة",
    },
    "p7xtjsx8": {
      "en": "Plan Name",
      "ar": "اسم الخطة",
    },
    "ch0ra7hl": {
      "en": "e.g. Weight Loss Nutrition Plan",
      "ar": "مثل: خطة تغذية لفقدان الوزن",
    },
    "ngyu3mdr": {
      "en": "Duration (weeks)",
      "ar": "المدة (أسابيع)",
    },
    "weeks": {
      "en": "weeks",
      "ar": "أسابيع",
    },
    "7le0xaer": {
      "en": "Enter number of weeks",
      "ar": "أدخل عدد الأسابيع",
    },
    "v6nv5qtk": {
      "en": "Daily Macros Target",
      "ar": "الهدف اليومي للماكروز",
    },
    "ciujpvfr": {
      "en": "Protein (g)",
      "ar": "بروتين (غ)",
    },
    "gxgmhgxs": {
      "en": "Carbs (g)",
      "ar": "كارب (غ)",
    },
    "atjwz1s7": {
      "en": "Fats (g)",
      "ar": "دهون (غ)",
    },
    "9yr4jrvm": {
      "en": "Meal Schedule",
      "ar": "جدول الوجبات",
    },
    "3menqg1v": {
      "en": "Additional Notes",
      "ar": "ملاحظات إضافية",
    },
    "l6f4hfdc": {
      "en":
          "Enter any additional instructions, restrictions or recommendations...",
      "ar": "أدخل أي تعليمات أو قيود أو توصيات إضافية...",
    },
    "z0lxpu8b": {
      "en": "Create Plan",
      "ar": "إنشاء خطة",
    },
  },
  // editExercisePlan
  {
    "uh8xi482": {
      "en": "Edit Plan",
      "ar": "تعديل الخطة",
    },
    "49kqh6e5": {
      "en": "Design a new training program",
      "ar": "تصميم برنامج تدريبي جديد",
    },
    "sio0n7bz": {
      "en": "Plan Details",
      "ar": "تفاصيل الخطة",
    },
    "tc5ag1oy": {
      "en": "Plan Name",
      "ar": "اسم الخطة",
    },
    "enter_plan_name": {
      "en": "Enter plan name",
      "ar": "أدخل اسم الخطة",
    },
    "43ollymg": {
      "en": "Description",
      "ar": "الوصف",
    },
    "enter_plan_description": {
      "en": "Enter plan description",
      "ar": "أدخل وصف الخطة",
    },
    "90ktr713": {
      "en": "Program Structure",
      "ar": "هيكل البرنامج",
    },
    "program_structure_subtitle": {
      "en": "Choose level and training type",
      "ar": "اختر المستوى ونوع التدريب",
    },
    "laspafpx": {
      "en": "Beginner",
      "ar": "مبتدئ",
    },
    "an9bjzkg": {
      "en": "Intermediate",
      "ar": "متوسط",
    },
    "kd992kuh": {
      "en": "Advanced",
      "ar": "متقدم",
    },
    "md7llt8p": {
      "en": "Strength",
      "ar": "قوة",
    },
    "xqltd9gy": {
      "en": "Cardio",
      "ar": "كارديو",
    },
    "2sxey45x": {
      "en": "HIIT",
      "ar": "تدريب متقطع عالي الكثافة",
    },
    "qmn6oisi": {
      "en": "Flexibility",
      "ar": "مرونة",
    },
    "laamzbep": {
      "en": "Schedule",
      "ar": "الجدول",
    },
    "schedule_subtitle": {
      "en": "Organize your training days",
      "ar": "تنظيم أيام التدريب",
    },
    "yr2raf35": {
      "en": "Edit Plan",
      "ar": "تعديل الخطة",
    },
    "selectType": {
      "en": "Select Type",
      "ar": "اختر النوع",
    },
  },
  // selectExercisesCreate
  {
    "x5im7gqj": {
      "en": "Select Exercises",
      "ar": "اختر التمارين",
    },
    "cpshi239": {
      "en": "Search exercises...",
      "ar": "ابحث عن التمارين...",
    },
    "chest": {
      "en": "Chest",
      "ar": "صدر",
    },
    "back": {
      "en": "Back",
      "ar": "ظهر",
    },
    "cardio": {
      "en": "Cardio",
      "ar": "كارديو",
    },
    "arms": {
      "en": "Arms",
      "ar": "ذراعين",
    },
    "LowerArms": {
      "en": "Lower Arms",
      "ar": "الذراع السفلية",
    },
    "legs": {
      "en": "Legs",
      "ar": "أرجل",
    },
    "neck": {
      "en": "Neck",
      "ar": "رقبة",
    },
    "traps": {
      "en": "Trapezius",
      "ar": "ترابيس",
    },
    "shoulders": {
      "en": "Shoulders",
      "ar": "أكتاف",
    },
    "waist": {
      "en": "Waist",
      "ar": "خصر",
    },
    "9ql1q8sm": {
      "en": "Exercises",
      "ar": "تمارين",
    },
    "3vh5a5su": {
      "en": "Exercises",
      "ar": "تمارين",
    },
    "selectedOnly": {
      "en": "Selected Only",
      "ar": "المضاف فقط",
    },
    "core": {
      "en": "Core",
      "ar": "الخصر والبطن",
    },
    "close": {
      "en": "Close",
      "ar": "اغلاق",
    },
    "2a12ptfb": {
      "en": "Add Selected Exercises",
      "ar": "إضافة التمارين المحددة",
    },
  },
  // nutPlanDetials
  {
    "2gaxu5nj": {
      "en": "Food Plan",
      "ar": "خطة التغذية",
    },
    "0hm6nr9m": {
      "en": "Your personalized meal schedule",
      "ar": "جدول الوجبات المخصص لك",
    },
    "7o3ns13g": {
      "en": "Carbs",
      "ar": "كارب",
    },
    "ys94uz5z": {
      "en": "Protein",
      "ar": "بروتين",
    },
    "04a440i9": {
      "en": "Fat",
      "ar": "دهون",
    },
    "awy23yqq": {
      "en": "Today\"s Meals",
      "ar": "الوجبات اليومية",
    },
    "meals": {
      "en": "Meals",
      "ar": "وجبات",
    },
  },
  // trainees
  {
    "kq4hr4fb": {
      "en": "My Trainees",
      "ar": "المتدربين",
    },
    "iku85ahv": {
      "en": "Manage your subscribed trainees",
      "ar": "إدارة المتدربين المشتركين لديك",
    },
    "gs92ksz0": {
      "en": "Active ",
      "ar": "نشط",
    },
    "traineeWord": {
      "en": "Trainee",
      "ar": "متدرب",
    },
    "ish0tufc": {
      "en": "Mike Thompson",
      "ar": "مايك تومسون",
    },
    "u446qieq": {
      "en": "Subscribed: May 12, 2023",
      "ar": "مشترك: 12 مايو 2023",
    },
    "ri1ypuye": {
      "en": "Subscribed: May 10, 2023",
      "ar": "مشترك: 10 مايو 2023",
    },
    "y39376zl": {
      "en": "Not Active",
      "ar": "غير نشط",
    },
    "946kavdj": {
      "en": "Send Alert",
      "ar": "إرسال تنبيه",
    },
    "7gvz2tj5": {
      "en": "Subscribed: May 12, 2023",
      "ar": "مشترك: 12 مايو 2023",
    },
    "vvhgwkkk": {
      "en": "Subscribed: May 10, 2023",
      "ar": "مشترك: 10 مايو 2023",
    },
  },
  // trainee
  {
    "ictpivuh": {
      "en": "Trainee Details",
      "ar": "تفاصيل المتدرب",
    },
    "memberSince": {
      "en": "Member Since",
      "ar": "عضو منذ",
    },
    "expires": {
      "en": "Expires",
      "ar": "ينتهي",
    },
    "mwejm4ar": {
      "en": "Subscription Status",
      "ar": "حالة الاشتراك",
    },
    "jak72zqo": {
      "en": "Subscription Management",
      "ar": "إدارة الاشتراك",
    },
    "subscriptionStatus": {
      "en": "Subscription Status",
      "ar": "حالة الاشتراك",
    },
    "0pnc4d43": {
      "en": "Renew",
      "ar": "تجديد الاشتراك",
    },
    "lr1wr1c3": {
      "en": "Cancel",
      "ar": "إلغاء الاشتراك",
    },
    "25wwfzgl": {
      "en": "Payment History",
      "ar": "تاريخ الدفع",
    },
    "zu4gu2ow": {
      "en": "Last Payment",
      "ar": "آخر دفعة",
    },
    "79u0ym2f": {
      "en": "Debts",
      "ar": "الديون",
    },
    "vjknhyig": {
      "en": "Add Debts",
      "ar": "إضافة ديون",
    },
    "reprpmqp": {
      "en": "Debt removal",
      "ar": "إزالة الديون",
    },
    "3jreed20": {
      "en": "Training Plans",
      "ar": "خطط التدريب",
    },
    "fgv70x81": {
      "en": "Training plan",
      "ar": "خطة التدريب",
    },
    "dcs5zqc4": {
      "en": "Option 1",
      "ar": "الخيار 1",
    },
    "1mzq8gbi": {
      "en": "Option 2",
      "ar": "الخيار 2",
    },
    "o3gz2shw": {
      "en": "Option 3",
      "ar": "الخيار 3",
    },
    "zbgetnfj": {
      "en": "Select...",
      "ar": "اختر...",
    },
    "n32ask38": {
      "en": "Search...",
      "ar": "ابحث...",
    },
    "search": {
      "en": "Search",
      "ar": "ابحث",
    },
    "3cw2i9ua": {
      "en": "Nutritional plan",
      "ar": "خطة غذائية",
    },
    "zkwj5zhj": {
      "en": "Option 1",
      "ar": "الخيار 1",
    },
    "8uvu442x": {
      "en": "Option 2",
      "ar": "الخيار 2",
    },
    "i9s8nti4": {
      "en": "Option 3",
      "ar": "الخيار 3",
    },
    "ngpmk79r": {
      "en": "Select...",
      "ar": "اختر...",
    },
    "5hmzbfxh": {
      "en": "Search...",
      "ar": "ابحث...",
    },
  },
  // EditUserInfoDialog
  {
    "7fjp01ai": {
      "en": "Edit Profile",
      "ar": "تعديل الملف الشخصي",
    },
    "u3yo2th2": {
      "en": "Full Name",
      "ar": "الاسم الكامل",
    },
    "g6q5j6kk": {
      "en": "Weight",
      "ar": "الوزن",
    },
    "jpb8oaaf": {
      "en": "Height",
      "ar": "الطول",
    },
    "8nhiubwi": {
      "en": "Goal",
      "ar": "الهدف",
    },
    "ayt5365p": {
      "en": "Save Changes",
      "ar": "حفظ التغييرات",
    },
  },
  // EditCoachInfoDialog
  {
    "zhb5uq60": {
      "en": "Edit Profile",
      "ar": "تعديل الملف الشخصي",
    },
    "hgrbhdo4": {
      "en": "Full Name",
      "ar": "الاسم الكامل",
    },
    "0mu7b02h": {
      "en": "Age",
      "ar": "العمر",
    },
    "9rfzwctt": {
      "en": "Experience",
      "ar": "الخبرة",
    },
    "zu10jh82": {
      "en": "Price",
      "ar": "السعر",
    },
    "bux76dx3": {
      "en": "About Me",
      "ar": "معلومات عني",
    },
    "y62153v0": {
      "en": "Save Changes",
      "ar": "حفظ التغييرات",
    },
  },
  // selectDayForPlan
  {
    "isftiu1s": {
      "en": "Select Day",
      "ar": "اختر اليوم",
    },
    "duazsqnb": {
      "en": "Monday",
      "ar": "الإثنين",
    },
    "o89upwj1": {
      "en": "Tuesday",
      "ar": "الثلاثاء",
    },
    "6g27x925": {
      "en": "Wednesday",
      "ar": "الأربعاء",
    },
    "yq96r5o7": {
      "en": "Thursday",
      "ar": "الخميس",
    },
    "ap0v00n3": {
      "en": "Friday",
      "ar": "الجمعة",
    },
    "0w2atzto": {
      "en": "Saturday",
      "ar": "السبت",
    },
    "56cey9g0": {
      "en": "Sunday",
      "ar": "الأحد",
    },
    "o89ikb3u": {
      "en": "Choose which day of the week this training will occur.",
      "ar": "اختر يوم الأسبوع الذي سيحدث فيه هذا التدريب.",
    },
    "epi3088c": {
      "en": "Chest exercises",
      "ar": "تمارين الصدر",
    },
    "n6xxmey2": {
      "en": "Confirm",
      "ar": "تأكيد",
    },
    "already_added": {
      "en": "Already added",
      "ar": "تمت الإضافة مسبقاً",
    },
    "name_training": {
      "en": "Name Your Training",
      "ar": "سمِّ تمرينك",
    },
    "training_name_subtitle": {
      "en": "Give this training day a descriptive name",
      "ar": "أعطي يوم التدريب إسمًا وصفيًا.",
    },
    "training_title": {
      "en": "Training Title",
      "ar": "عنوان التدريب",
    },
    "training_title_hint": {
      "en": "e.g., Upper Body Workout",
      "ar": "مثال: تمرين الجزء العلوي من الجسم",
    },
    "select_exercises": {
      "en": "Select Exercises",
      "ar": "اختر التمارين",
    },
    "select_exercises_subtitle": {
      "en": "Choose exercises for this training day",
      "ar": "اختر التمارين ليوم التدريب هذا",
    },
    "add_exercises": {
      "en": "Add Exercises",
      "ar": "إضافة تمارين",
    },
    "edit_exercises": {
      "en": "Edit Exercises",
      "ar": "تعديل التمارين",
    },
    "next": {
      "en": "Next",
      "ar": "التالي",
    },
    "finish": {
      "en": "Finish",
      "ar": "إنهاء",
    },
    "add_training_day": {
      "en": "Add Training Day",
      "ar": "إضافة يوم تدريب",
    },
    "tap_to_configure": {
      "en": "Tap to configure",
      "ar": "اضغط للإعداد",
    },
    "configure": {
      "en": "Configure",
      "ar": "إعداد",
    }
  },
  // selectLevel
  {
    "sis1n01p": {
      "en": "Select Level",
      "ar": "اختر المستوى",
    },
    "level_subtitle": {
      "en": "Select the program difficulty",
      "ar": "اختر سهولة البرنامج",
    },
    "2epsotxw": {
      "en": "Beginner",
      "ar": "مبتدئ",
    },
    "9nhki2wm": {
      "en": "Intermediate",
      "ar": "متوسط",
    },
    "1a5s8og2": {
      "en": "Advanced",
      "ar": "متقدم",
    },
    "c9m7nvxe": {
      "en": "Expert",
      "ar": "خبير",
    },
    "1qqktqrf": {
      "en": "Confirm",
      "ar": "تأكيد",
    },
  },
  // selectSets
  {
    "odal1r8y": {
      "en": "Add Exercise Set",
      "ar": "إضافة مجموعة تمرين",
    },
    "7eljwytw": {
      "en": "Sets",
      "ar": "المجموعات",
    },
    "wkyczine": {
      "en": "Reps",
      "ar": "التكرارات",
    },
    "time": {
      "en": "Time (Minutes)",
      "ar": "الوقت (دقائق)",
    },
    "time_seconds": {
      "en": "Time (Seconds)",
      "ar": "الوقت (ثواني)",
    },
    "time_label": {
      "en": "Time)",
      "ar": "الوقت",
    },
    "seconds": {
      "en": "seconds",
      "ar": "ثواني",
    },
    "minutes": {
      "en": "minutes",
      "ar": "دقائق",
    },
    "t4fd7lvo": {
      "en": "12",
      "ar": "12",
    },
    "0p2fuvxm": {
      "en": "Add Set",
      "ar": "إضافة مجموعة",
    },
  },
  // createMeal
  {
    "8ia30fhi": {
      "en": "Create New Meal",
      "ar": "إنشاء وجبة جديدة",
    },
    "gjl6p81h": {
      "en": "Meal Name",
      "ar": "اسم الوجبة",
    },
    "sp6604fg": {
      "en": "Breakfast",
      "ar": "الإفطار",
    },
    "vcre8yrp": {
      "en": "Description",
      "ar": "الوصف",
    },
    "ddf60crs": {
      "en": "One loaf of bread...",
      "ar": "رغيف واحد من الخبز...",
    },
    "fag7uot9": {
      "en": "Create Meal",
      "ar": "إنشاء وجبة",
    },
  },
  // EditPassword
  {
    "oldPassword": {
      "en": "Old Password",
      "ar": "كلمة المرور القديمة",
    },
    "c4si8ow5": {
      "en": "Edit Password",
      "ar": "تعديل كلمة المرور",
    },
    "umubztrd": {
      "en": "New Password",
      "ar": "كلمة المرور الجديدة",
    },
    "1zzn9c19": {
      "en": "***",
      "ar": "***",
    },
    "hx8qi5gg": {
      "en": "Confirm",
      "ar": "تأكيد",
    },
    "6a7euwl7": {
      "en": "***",
      "ar": "***",
    },
    "7at8hahs": {
      "en": "Change",
      "ar": "تغيير",
    },
  },
  // coachNav
  {
    "zhq8jv64": {
      "en": "Home",
      "ar": "الرئيسية",
    },
    "features_nav": {
      "en": "Features",
      "ar": "الميزات",
    },
    "messages_nav": {
      "en": "Messages",
      "ar": "الرسائل",
    },
    "zb6vtde1": {
      "en": "Clients",
      "ar": "العملاء",
    },
    "c89dyrdm": {
      "en": "Plans",
      "ar": "الخطط",
    },
    "al6z3vwj": {
      "en": "Analytics",
      "ar": "التحليلات",
    },
    "p7e40md4": {
      "en": "Profile",
      "ar": "الحساب",
    },
  },
  // renewSub
  {
    "d34tbdlp": {
      "en": "Renew Subscription",
      "ar": "تجديد الاشتراك",
    },
    "7wzx81lb": {
      "en": "Select New Date",
      "ar": "اختر تاريخ جديد",
    },
    "hya30zai": {
      "en": "Choose date",
      "ar": "اختر التاريخ",
    },
    'date': {
      "en": "Date",
      "ar": "التاريخ",
    },
    "52ckancw": {
      "en": "Amount Paid",
      "ar": "المبلغ المدفوع",
    },
    "mi6j1k95": {
      "en": "Outstanding Debts",
      "ar": "الديون المستحقة",
    },
    "ivengb0e": {
      "en": "Renew Subscription",
      "ar": "تجديد الاشتراك",
    },
  },
  // addDebts
  {
    "sc2jlg7l": {
      "en": "Edit Debt",
      "ar": "تعديل الدين",
    },
    "enkjrdua": {
      "en": "Debt",
      "ar": "دين",
    },
    "n51nli3x": {
      "en": "50",
      "ar": "50",
    },
    "apqx7rpg": {
      "en": "Save",
      "ar": "حفظ",
    },
  },
  // userNav
  {
    "xgxiwbz2": {
      "en": "Home",
      "ar": "الرئيسية",
    },
    "ss6grjdt": {
      "en": "Exercises",
      "ar": "التمارين",
    },
    "yrbvaao0": {
      "en": "Profile",
      "ar": "الحساب",
    },
  },
  // Miscellaneous
  {
    "nhoi3p07": {
      "en": "Full Name",
      "ar": "الاسم الكامل",
    },
    "nu964cd4": {
      "en": "Ahmad ...",
      "ar": "أحمد ...",
    },
    "7jqxog5p": {
      "en": "",
      "ar": "",
    },
    "dyblq6ff": {
      "en": "",
      "ar": "",
    },
    "8zt4cos2": {
      "en": "",
      "ar": "",
    },
    "56n8tzej": {
      "en": "",
      "ar": "",
    },
    "lpsz2tvr": {
      "en": "",
      "ar": "",
    },
    "9rfme6s2": {
      "en": "",
      "ar": "",
    },
    "5mfz8boz": {
      "en": "",
      "ar": "",
    },
    "1pnv5xct": {
      "en": "",
      "ar": "",
    },
    "0efciuhw": {
      "en": "",
      "ar": "",
    },
    "vi3b9n4h": {
      "en": "",
      "ar": "",
    },
    "8zuhx6q7": {
      "en": "",
      "ar": "",
    },
    "sjevvtcs": {
      "en": "",
      "ar": "",
    },
    "g9e7dsbi": {
      "en": "",
      "ar": "",
    },
    "87ry7bxc": {
      "en": "",
      "ar": "",
    },
    "ux474q7l": {
      "en": "",
      "ar": "",
    },
    "dayk7j6w": {
      "en": "",
      "ar": "",
    },
    "7zt0zm3k": {
      "en": "",
      "ar": "",
    },
    "6pko5fwk": {
      "en": "",
      "ar": "",
    },
    "rjp25jb1": {
      "en": "",
      "ar": "",
    },
    "ngrchfet": {
      "en": "",
      "ar": "",
    },
    "5lz99j4c": {
      "en": "",
      "ar": "",
    },
    "l4jngm64": {
      "en": "",
      "ar": "",
    },
    "zo73e173": {
      "en": "",
      "ar": "",
    },
    "be7vr3g1": {
      "en": "",
      "ar": "",
    },
    "n33hudmq": {
      "en": "",
      "ar": "",
    },
    "1mervfov": {
      "en": "",
      "ar": "",
    },
    "dyr3bvdd": {
      "en": "",
      "ar": "",
    },
  },
  // ErrorPage
  {
    "l7kfx3m8": {
      "en": "Oops! Something went wrong",
      "ar": "عذرًا! حدث خطأ ما",
    },
    "2184r6dy": {
      "en": "We encountered an unexpected error, please try again later.",
      "ar": "واجهنا خطأ غير متوقع، يرجى المحاولة فيما بعد.",
    },
    "2ic7dbdd": {
      "en": "Try Again",
      "ar": "حاول مرة أخرى",
    },
    "e1g3ko1c": {
      "en": "Contact Support",
      "ar": "اتصل بالدعم",
    },
  },
  // New translations for AddClientWidget
  {
    "error_start_before_end": {
      "en": "Start date must be before the end date",
      "ar": "يجب أن يكون تاريخ البدء قبل تاريخ الانتهاء",
    },
    "error_please_select_both_start_and_end_dates": {
      "en": "Please select both start and end dates",
      "ar": "يرجى اختيار تاريخي البدء والانتهاء",
    },
    "error_user_not_found": {
      "en": "User not found",
      "ar": "لم يتم العثور على المستخدم",
    },
    "error_trainee_not_found": {
      "en": "Trainee not found",
      "ar": "لم يتم العثور على المتدرب",
    },
    "success_client_added": {
      "en":
          "Trainee added successfully, wait for the trainee to activate the subscription",
      "ar":
          "تم إضافة المتدرب بنجاح الى الطلبات، يجب إنتظار المتدرب لتفعيل الاشتراك",
    },
    "header_add_new_client": {
      "en": "Add New Client",
      "ar": "إضافة عميل جديد",
    },
    "header_enter_client_info": {
      "en": "Enter client information below",
      "ar": "أدخل معلومات العميل أدناه",
    },
    "label_email": {
      "en": "Email",
      "ar": "البريد الإلكتروني",
    },
    "label_training_goals": {
      "en": "Training Goals",
      "ar": "أهداف التدريب",
    },
    "label_current_fitness_level": {
      "en": "Current Fitness Level",
      "ar": "مستوى اللياقة الحالي",
    },
    "button_add_client": {
      "en": "Add Client",
      "ar": "إضافة عميل",
    },
  },
  // New localization strings for CoachEnterInfoWidget
  {
    "error_empty_full_name": {
      "en": "Please enter your full name",
      "ar": "يرجى إدخال اسمك الكامل",
    },
    "error_empty_years_experience": {
      "en": "Please enter your years of experience",
      "ar": "يرجى إدخال سنوات الخبرة",
    },
    "enter_years_of_experience": {
      "en": "Enter years of experience",
      "ar": "أدخل سنوات الخبرة",
    },
    "enter_about_me": {
      "en": "Enter your bio",
      "ar": "أدخل البايو الخاص بك",
    },
    "enter_price": {
      "en": "Enter your gym subscription price",
      "ar": "أدخل سعر الاشتراك الصالة الرياضية",
    },
    "error_empty_about_me": {
      "en": "Please tell us about yourself",
      "ar": "يرجى إخبارنا عن نفسك",
    },
    "about_me_too_short": {
      "en": "About me is too short",
      "ar": "معلوماتك عن نفسك قصير جدا",
    },
    "about_me_too_long": {
      "en": "About me is too long",
      "ar": "معلوماتك عن نفسك طويلة جدا",
    },
    "gym_name_too_long": {
      "en": "Gym name is too long",
      "ar": "اسم الصالة الرياضية طويل جدا",
    },
    "error_empty_price": {
      "en": "Please enter your subscription price",
      "ar": "يرجى إدخال سعر الاشتراك",
    },
    "noCoachRecordsFound": {
      "en": "No coach records found.",
      "ar": "لم يتم العثور على سجلات المدرب.",
    },
    "defaultErrorMessage": {
      "en": "An error occurred. Please try again.",
      "ar": "حدث خطأ. يرجى المحاولة مرة أخرى.",
    },
    "ok": {
      "en": "OK",
      "ar": "موافق",
    },
    "coach_label": {
      "en": "Coach",
      "ar": "مدرب",
    },
    "about_me": {
      "en": "About me",
      "ar": "عني",
    },
    "paymentProcessCancelled": {
      "en": "Payment process was cancelled.",
      "ar": "تم إلغاء عملية الدفع.",
    },
    "confirmDelete": {
      "en": "Confirm Delete",
      "ar": "تأكيد الحذف",
    },
    "areYouSureYouWantToDeleteThisExercise": {
      "en": "Are you sure you want to delete this exercise?",
      "ar": "هل أنت متأكد أنك تريد حذف هذا التمرين؟",
    },
    "cancel": {
      "en": "Cancel",
      "ar": "إلغاء",
    },
    "delete": {
      "en": "Delete",
      "ar": "حذف",
    },
    "error": {
      "en": "Error",
      "ar": "خطأ",
    },
    "failedToFetchCoachInformation": {
      "en": "Failed to fetch coach information.",
      "ar": "فشل الحصول على معلومات المدرب.",
    },
    "areYouSureYouWantToDeleteThisMeal": {
      "en": "Are you sure you want to delete this meal?",
      "ar": "هل أنت متأكد أنك تريد حذف هذا الوجبة؟",
    },
    "failedToCreatePlan": {
      "en": "Failed to create plan",
      "ar": "فشل إنشاء الخطة",
    },
    "failedToLoadMessagesPleaseTryAgain": {
      "en": "Failed to load messages. Please try again.",
      "ar": "فشل الحصول على الرسائل. يرجى المحاولة مرة أخرى.",
    },
    "messageSentSuccessfully": {
      "en": "Message sent successfully!",
      "ar": "تم إرسال الرسالة بنجاح!",
    },
    "anErrorOccurred": {
      "en": "An error occurred",
      "ar": "حدث خطأ",
    },
    "areYouSureYouWantToDeleteThisNutritionPlan": {
      "en": "Are you sure you want to delete this nutrition plan?",
      "ar": "هل أنت متأكد أنك تريد حذف هذا الخطة؟",
    },
    "failedToFilterExercisesPleaseTryAgain": {
      "en": "Failed to filter exercises. Please try again.",
      "ar": "فشل التصفية. يرجى المحاولة مرة أخرى.",
    },
    "filter": {
      "en": "Filter",
      "ar": "فلتر",
    },
    "failedToRenewSubscriptionPleaseTryAgain": {
      "en": "Failed to renew subscription",
      "ar": "فشل إعادة الاشتراك",
    },
    "areYouSure": {
      "en": "Are you sure?",
      "ar": "هل أنت متأكد؟",
    },
    "cancelSubscription": {
      "en": "Cancel Subscription",
      "ar": "إلغاء الاشتراك",
    },
    "confirm": {
      "en": "Confirm",
      "ar": "تأكيد",
    },
    "anErrorOccurredWhileUpdatingRecordsPleaseTryAgain": {
      "en": "An error occurred while updating records. Please try again.",
      "ar": "حدث خطأ أثناء تحديث السجلات. يرجى المحاولة مرة أخرى.",
    },
    "pleaseFillAllRequiredFields": {
      "en": "Please fill all required fields",
      "ar": "يرجى إدخال جميع الحقول المطلوبة",
    },
    "pleaseSelectADay": {
      "en": "Please select a day",
      "ar": "يرجى اختيار يوم",
    },
    "coachMessage": {
      "en": "Coach Message",
      "ar": "رسالة المدرب",
    },
    "emailRequired": {
      "en": "Email required!",
      "ar": "يرجى إدخال البريد الإلكتروني!",
    },
    "thankYou": {
      "en": "Thank you",
      "ar": "شكرا",
    },
    "weSendEmailForYouItHasBeenSentSuccessfully": {
      "en": "We send Email for you, It has been sent successfully!",
      "ar": "لقد تم إرسال البريد الإلكتروني لك، تم إرساله بنجاح!",
    },
    "userNotFound": {
      "en": "User not found...",
      "ar": "لم يتم العثور على المستخدم...",
    },
    "userNotFoundTryLoginWithGoogle": {
      "en": "User not found Try login with Google",
      "ar": "لم يتم العثور على المستخدم حاول تسجيل الدخول باستخدام Google",
    },
    "pleaseCheckYourEmailAndPassword": {
      "en": "Please check your email and password",
      "ar": "يرجى التحقق من صحة البريد الإلكتروني وكلمة المرور",
    },
    "emailIsAlreadyInUse": {
      "en": "Email is already in use.",
      "ar": "البريد الإلكتروني مستخدم بالفعل.",
    },
    "failedToCreateAccountPleaseTryAgain": {
      "en": "Failed to create account. Please check the data you entered.",
      "ar": "فشل إنشاء الحساب. يرجى التأكد من صحة البيانات المدخلة.",
    },
    "anErrorOccurredPleaseTryAgainLater": {
      "en": "An error occurred. Please try again later.",
      "ar": "حدث خطأ. يرجى المحاولة مرة أخرى لاحقًا.",
    },
    "invalidFileFormatSelected": {
      "en": "Invalid file format selected",
      "ar": "تم اختيار تنسيق الملف غير الصالح",
    },
    "pleaseFixTheErrorsInRedBeforeSubmitting": {
      "en": "Please fix the errors in red before submitting.",
      "ar": "يرجى إصلاح الأخطاء في الأحمر قبل التقديم.",
    },
    "failedToSaveProfile": {
      "en": "Failed to save profile: ",
      "ar": "فشل حفظ الملف الشخصي: ",
    },
    "failedToUploadImage": {
      "en": "Failed to upload image: ",
      "ar": "فشل تحميل الصورة: ",
    },
    "uploadImageText": {
      "en":
          "In muscle or without, we are proud of you, upload your photo 📸 😂",
      "ar": "في عضلات أو بدون، إحنا فخورين فيك، إرفع صورتك 📸 😂",
    },
    "coachUploadImageText": {
      "en":
          "Coach, it's time to show off your muscles! 💪 📸 but no gym selfies in the mirror 😂",
      "ar": "كوتش، وقت تستعرض العضلات! 💪 📸 بس بدون سيلفي بالمراية 😂",
    },
    "exercises": {
      "en": "exercises",
      "ar": "تمارين",
    },
    "plansSaved": {
      "en": "Plans saved successfully",
      "ar": "تم حفظ الخطة بنجاح",
    },
    "savePlans": {
      "en": "Save Plans",
      "ar": "حفظ الخطط",
    },
    "fullNameIsRequired": {
      "en": "Full Name is required",
      "ar": "الاسم الكامل مطلوب",
    },
    "weightIsRequired": {
      "en": "Weight is required",
      "ar": "الوزن مطلوب",
    },
    "heightIsRequired": {
      "en": "Height is required",
      "ar": "الطول مطلوب",
    },
    "goalIsRequired": {
      "en": "Goal is required",
      "ar": "الهدف مطلوب",
    },
    "pleaseFillInAllRequiredFields": {
      "en": "Please fill in all required fields.",
      "ar": "يرجى إدخال جميع الحقول المطلوبة.",
    },
    "oldPasswordIsRequired": {
      "en": "Old Password is required",
      "ar": "كلمة المرور القديمة مطلوبة",
    },
    "newPasswordIsRequired": {
      "en": "New Password is required",
      "ar": "كلمة المرور الجديدة مطلوبة",
    },
    "passwordTooShort": {
      "en": "Password must be at least 8 characters",
      "ar": "يجب أن تكون كلمة المرور أكثر من 8 أحرف",
    },
    "passwordNeedsUppercase": {
      "en": "Password must contain at least one uppercase letter",
      "ar": "يجب أن تحتوي كلمة المرور على حرف أبجدي علوي على الأقل",
    },
    "passwordNeedsNumber": {
      "en": "Password must contain at least one number",
      "ar": "يجب أن تحتوي كلمة المرور على رقم على الأقل",
    },
    "passwordNeedsSpecialChar": {
      "en": "Password must contain at least one special character",
      "ar": "يجب أن تحتوي كلمة المرور على حرف خاص على الأقل",
    },
    "passwordsDoNotMatch": {
      "en": "Passwords do not match",
      "ar": "كلمتا المرور غير متطابقتين",
    },
    "confirmPasswordIsRequired": {
      "en": "Confirm Password is required",
      "ar": "يرجى إدخال كلمة المرور المطلوبة",
    },
    "passwordsMustBeAtLeast8Characters": {
      "en": "Passwords must be at least 8 characters",
      "ar": "يجب أن تكون كلمات المرور أكثر من 8 أحرف",
    },
    "thisFieldIsRequired": {
      "en": "This field is required",
      "ar": "هذه الحقل مطلوب",
    },
    "dateOfBirthIsRequired": {
      "en": "Date of Birth is required",
      "ar": "تاريخ الميلاد مطلوب",
    },
    "newPasswordMustBeDifferentFromOldPassword": {
      "en": "Use a different password from the old one",
      "ar": "إستخدم كلمة مرور مختلفة عن كلمة المرور القديمة",
    },
    "errorUpdatingPassword": {
      "en": "Password is incorrect",
      "ar": "كلمة المرور غير صحيحة",
    },
    "incorrectOldPassword": {
      "en": "Old password is incorrect, please try again",
      "ar": "كلمة المرور القديمة غير صحيحة، يرجى المحاولة مرة اخرى",
    },
    "pleaseReauthenticate": {
      "en": "Please reauthenticate",
      "ar": "يرجى إعادة المصادقة ",
    },
    "requires-recent-login": {
      "en": "'Account deletion failed: requires recent login.",
      "ar": "فشل حذف الحساب: يتطلب تسجيل دخول جديد",
    },
    "ReadNotifications": {
      "en": "Read Notifications",
      "ar": "الرسائل المقروءة",
    },
    "logout_title": {
      "en": "Sign Out",
      "ar": "تسجيل الخروج",
    },
    "logout_confirm": {
      "en": "Are you sure you want to sign out?",
      "ar": "هل أنت متأكد أنك تريد تسجيل الخروج؟",
    },
    "error_invalid_email": {
      "en": "Invalid email",
      "ar": "البريد الإلكتروني غير صالح",
    },
    "error_subscription_already_exists": {
      "en": "This trainee is already subscribed with you",
      "ar": "هذا المتدرب مشترك بالفعل لديك",
    },
    "error_subscription_already_exists_in_trash": {
      "en":
          "This trainee is already subscribed with you in the deleted section, please delete it first",
      "ar":
          "هذا المتدرب مشترك بالفعل لديك في قسم المحذوف مؤخراً، يرجى حذفه بشكل نهائي أولاً",
    },
    "emailInUse": {
      "en": "Email is already in use",
      "ar": "البريد الإلكتروني مستخدم بالفعل",
    },
    "accept": {
      "en": "Accept",
      "ar": "قبول",
    },
    "reject": {
      "en": "Reject",
      "ar": "رفض",
    },
    "SubscriptionRequest": {
      "en": "Subscription Request",
      "ar": "طلب الاشتراك",
    },
    "subscription_requests_from_coach": {
      "en": "You have subscription requests from coach",
      "ar": "لديك طلب اشتراك من المدرب",
    },
    "chooseYourPlan": {
      "en": "Choose Your Plan",
      "ar": "اختر خطتك",
    },
    "selectThePerfectSubscription": {
      "en": "Select the perfect subscription",
      "ar": "اختر الاشتراك المناسب لك",
    },
    "Monthly": {
      "en": "Monthly",
      "ar": "شهري",
    },
    "perfectForGettingStarted": {
      "en": "Perfect for getting started",
      "ar": "مناسب للبدء",
    },
    "registerAndManageTrainees": {
      "en": "Register and manage trainees",
      "ar": "التسجيل والإدارة المتدربين",
    },
    "createTrainingPlans": {
      "en": "Create training plans",
      "ar": "إنشاء خطط التمارين",
    },
    "createNutritionPlans": {
      "en": "Create nutrition plans",
      "ar": "إنشاء خطط التغذية",
    },
    "monitorAnalytics": {
      "en": "Monitor analytics",
      "ar": "مراقبة أداء صالتك الرياضية",
    },
    "adFreeExperience": {
      "en": "Ad-free experience",
      "ar": "تجربة التطبيق بدون إعلانات",
    },
    "chooseMonthly": {
      "en": "Choose Monthly",
      "ar": "اختر شهري",
    },
    "Quarterly": {
      "en": "Quarterly",
      "ar": "ربع سنوي",
    },
    "save27": {
      "en": "Save 27%",
      "ar": "توفير 17%",
    },
    "mostPopularChoice": {
      "en": "Most popular choice",
      "ar": "الاختيار الأكثر شعبية",
    },
    "chooseQuarterly": {
      "en": "Choose Quarterly",
      "ar": "اختر ربع سنوي",
    },
    "annual": {
      "en": "Annual",
      "ar": "سنوي",
    },
    "save25": {
      "en": "Save 25%",
      "ar": "توفير 25%",
    },
    "bestValueForLongTerm": {
      "en": "Best value for long-term",
      "ar": "القيمة الأفضل للمدى الطويل",
    },
    "chooseAnnual": {
      "en": "Choose Annual",
      "ar": "اختر سنوي",
    },
    "subscribe_now": {
      "en": "Subscribe Now",
      "ar": "اشترك الآن",
    },
    "subscription_reminder": {
      "en": "Upgrade Your Training Experience!",
      "ar": "قم بترقية تجربة التمرين الخاصة بك!",
    },
    "subscription_reminder_description": {
      "en":
          "You\'re missing out on premium features! Subscribe now to unlock advanced training tools, detailed analytics, and personalized workout plans without Ads.",
      "ar":
          "أنت تفوت الميزات المدفوعة! اشترك الآن لفتح أدوات التمرين المتقدمة، التحليلات المفصلة، والخطط التمرين المخصصة دون إعلانات.",
    },
    "no_trainees_found": {
      "en": "No trainees found",
      "ar": "لم يتم العثور على متدربين",
    },
    "search_trainees": {
      "en": "Search trainees...",
      "ar": "ابحث عن متدربين...",
    },
    "all": {
      "en": "All",
      "ar": "الكل",
    },
    "active": {
      "en": "Active",
      "ar": "نشط",
    },
    "inactive": {
      "en": "Inactive",
      "ar": "منتهي",
    },
    "247_support": {
      "en": "24/7 Support",
      "ar": "الدعم 24/7",
    },
    "we_here_to_help": {
      "en": "We\"re here to help you",
      "ar": "نحن هنا لنساعدك",
    },
    "your_name": {
      "en": "Your Name",
      "ar": "اسمك",
    },
    "send_us_a_message": {
      "en": "Send us a message",
      "ar": "أرسل لنا رسالة",
    },
    "your_email": {
      "en": "Your Email",
      "ar": "بريدك الإلكتروني",
    },
    "your_message": {
      "en": "Your Message",
      "ar": "رسالتك",
    },
    "send_message": {
      "en": "Send Message",
      "ar": "إرسال الرسالة",
    },
    "contact_us_directly": {
      "en": "Contact Us Directly",
      "ar": "تواصل معنا مباشرة",
    },
    "whatsapp_support": {
      "en": "WhatsApp Support",
      "ar": "دعم WhatsApp",
    },
    "email_support": {
      "en": "Email Support",
      "ar": "دعم البريد الإلكتروني",
    },
    "failed_to_send_email": {
      "en": "Failed to send email. Please try again.",
      "ar": "فشل إرسال البريد الإلكتروني. يرجى المحاولة مرة أخرى.",
    },
    "no_active_plans_found": {
      "en": "No active plans found",
      "ar": "لا يوجد خطط مفعلة",
    },
    "no_draft_plans_found": {
      "en": "No draft plans found",
      "ar": "لا يوجد خطط مسودة",
    },
    "no_days_found": {
      "en": "No days found",
      "ar": "لا يوجد أيام",
    },
    "planNameUsed": {
      "en": "Plan Name Used",
      "ar": "اسم الخطة مستخدم",
    },
    "selectLevel": {
      "en": "Select Level",
      "ar": "اختر المستوى",
    },
    "pleaseEnterSomeText": {
      "en": "Please enter some text",
      "ar": "يرجى إدخال نص",
    },
    "IdontHaveAccount": {
      "en": "I don\"t have an account!",
      "ar": "ليس لدي حساب!",
    },
    "IHaveAccount": {
      "en": "I have an account!",
      "ar": "لدي حساب!",
    },
    "completeProgress": {
      "en": "Complete",
      "ar": "أكمل التقدم",
    },
    "WeeklyExercises": {
      "en": "Weekly Exercises",
      "ar": "التمارين الأسبوعية",
    },
    "passwordUpdatedSuccessfully": {
      "en": "Password updated successfully",
      "ar": "تم تحديث كلمة المرور بنجاح",
    },
    "machine": {
      "en": "Machine",
      "ar": "الآلة",
    },
    "cable": {
      "en": "Cable",
      "ar": "الكابل",
    },
    "bodyweight": {
      "en": "Bodyweight",
      "ar": "فقدان الوزن",
    },
    "kettlebell": {
      "en": "Kettlebell",
      "ar": "كتلبل",
    },
    "bands": {
      "en": "Bands",
      "ar": "تمارين القوة",
    },
    "medicine_ball": {
      "en": "Medicine Ball",
      "ar": "كرة الطبية",
    },
    "stability_ball": {
      "en": "Stability Ball",
      "ar": "كرة الثبات",
    },
    "ez_barbell": {
      "en": "EZ Barbell",
      "ar": "بار EZ",
    },
    "weighted": {
      "en": "Weighted",
      "ar": "محمل بالوزن",
    },
    "other": {
      "en": "Other",
      "ar": "غير ذلك",
    },
    "barbell": {
      "en": "Barbell",
      "ar": "بار",
    },
    "weeklyExercisesDesc": {
      "en": "Your weekly exercise plan",
      "ar": "خطة التمارين الأسبوعية لديك",
    },
    "noExercisesForToday": {
      "en": "No exercises for today",
      "ar": "لا يوجد تمارين لهذا اليوم",
    },
    "exercise": {
      "en": "Exercise",
      "ar": "تمرين",
    },
    "recent": {
      "en": "Recent",
      "ar": "المستجدين",
    },
    "actions": {
      "en": "Actions",
      "ar": "الإجراءات",
    },
    "broadcast_messages_subtitle": {
      "en": "Broadcast messages to your trainees",
      "ar": "إرسال رسائل عامة إلى متدربيك",
    },
    "daysRemaining": {
      "en": "days remaining",
      "ar": "أيام متبقية",
    },
    "load_more": {
      "en": "Load More",
      "ar": "تحميل المزيد",
    },
    "previous": {
      "en": "Previous",
      "ar": "السابق",
    },
    "no_more": {
      "en": "No more",
      "ar": "لا يوجد أكثر",
    },
    "avgAge": {
      "en": "Avg. Age",
      "ar": "متوسط العمر",
    },
    "traineeStatus": {
      "en": "Trainee Status Distribution",
      "ar": "توزيع حالة المتدربين",
    },
    "goalTypes": {
      "en": "Trainee Goals",
      "ar": "أهداف المتدربين",
    },
    "remainingDebt": {
      "en": "Remaining Debt",
      "ar": "الديون المتبقية",
    },
    "changePhoto": {
      "en": "Change Photo",
      "ar": "أضف الصورة",
    },
    "changePhotoDesc": {
      "en": "Change your profile photo",
      "ar": "تغيير صورتك الشخصية",
    },
    "photoHint": {
      "en": "Please upload a photo of yourself",
      "ar": "يرجى تحميل صورة شخصية",
    },
    "enter_full_name_hint": {
      "en": "Enter your full name",
      "ar": "أدخل اسمك الكامل",
    },
    "select_date_hint": {
      "en": "Select your date of birth",
      "ar": "اختر تاريخ ميلادك",
    },
    "error_negative_price": {
      "en": "Price cannot be negative",
      "ar": "السعر لا يمكن أن يكون سالب",
    },
    "error_negative_number": {
      "en": "Number cannot be negative",
      "ar": "الرقم لا يمكن ان يكون سالب",
    },
    "error_invalid_price": {
      "en": "Invalid price",
      "ar": "السعر غير صالح",
    },
    "price_too_high": {
      "en": "Price too high",
      "ar": "السعر كبير جدا",
    },
    "price_info_hint": {
      "en": "Please enter the price of your subscription",
      "ar": "يرجى إدخال سعر الاشتراك الشهري الخاص بك",
    },
    "pleaseEnterPlanName": {
      "en": "Please enter a plan name",
      "ar": "يرجى إدخال اسم الخطة",
    },
    "pleaseEnterNumberOfWeeks": {
      "en": "Please enter the number of weeks",
      "ar": "يرجى إدخال عدد الأسابيع",
    },
    "invalid": {
      "en": "Invalid",
      "ar": "غير صالح",
    },
    "required": {
      "en": "Required",
      "ar": "مطلوب",
    },
    "hint_enter_name": {
      "en": "Enter your name",
      "ar": "أدخل الإسم",
    },
    "client_information": {
      "en": "Client Information",
      "ar": "معلومات المتدرب",
    },
    "goal_description": {
      "en": "Choose your primary fitness goal",
      "ar": "اختر أهدافك الرئيسية في التمارين",
    },
    "fitness_goals_description": {
      "en":
          "Select your primary fitness goal to help us customize your experience",
      "ar": "اختر أهدافك الرئيسية في التمارين لنساعدك في تخصيص تجربتك",
    },
    "profileUpdatedSuccessfully": {
      "en": "Profile updated successfully",
      "ar": "تم تحديث الملف الشخصي بنجاح",
    },
    "timer_complete": {
      "en": "Timer Complete",
      "ar": "تم إنهاء التوقيت",
    },
    "timer_complete_description": {
      "en": "Workout interval completed!",
      "ar": "تم إنهاء فترة الراحة!",
    },
    "weak": {
      "en": "Weak",
      "ar": "ضعيف",
    },
    "medium": {
      "en": "Medium",
      "ar": "متوسط",
    },
    "strong": {
      "en": "Strong",
      "ar": "قوي",
    },
    "passwordIsTooWeak": {
      "en": "Password is too weak",
      "ar": "كلمة المرور ضعيفة",
    },
    "passwordMustBeAtLeast6Characters": {
      "en": "Password must be at least 6 characters",
      "ar": "كلمة المرور يجب أن تكون أكثر من 6 أحرف",
    },
    "passwordIsRequired": {
      "en": "Password is required",
      "ar": "كلمة المرور مطلوبة",
    },
    "passwordMustContainAtLeast6Characters": {
      "en": "Password must contain at least 6 characters",
      "ar": "كلمة المرور يجب أن تكون أكثر من 6 أحرف",
    },
    "emailIsRequired": {
      "en": "Email is required",
      "ar": "البريد الإلكتروني مطلوب",
    },
    "pleaseEnterValidEmail": {
      "en": "Please enter a valid email",
      "ar": "يرجى إدخال بريد إلكتروني صالح",
    },
    "creatingAccount": {
      "en": "Creating Account...",
      "ar": "جاري إنشاء الحساب...",
    },
    "creating_plan": {
      "en": "Creating Plan...",
      "ar": "جاري إنشاء الخطة...",
    },
    "noSubscriptionsFound": {
      "en": "No subscriptions Active found",
      "ar": "لا يوجد اشتراكات مفعلة",
    },
    "uploadPhoto": {
      "en": "Upload Photo",
      "ar": "أضف الصورة",
    },
    "goals_info": {
      "en": "You can always change your goal later in settings",
      "ar": "يمكنك دائما تغيير أهدافك في الإعدادات",
    },
    "subscription_desc": {
      "en": "subscrip now",
      "ar": "اشترك الآن",
    },
    "request_sent": {
      "en": "Request sent",
      "ar": "تم إرسال الطلب",
    },
    "success": {
      "en": "Success",
      "ar": "نجاح",
    },
    "requests": {
      "en": "Requests",
      "ar": "الطلبات",
    },
    "subscriptionCancelled": {
      "en": "Subscription cancelled",
      "ar": "تم إلغاء الاشتراك",
    },
    "coachAlert": {
      "en": "Coach Alert",
      "ar": "تنبيه المدرب",
    },
    "itsTimeForPayment": {
      "en": "It\"s time for payment.",
      "ar": "إليك الوقت للدفع.",
    },
    "tapPlusToAdd": {
      "en": "Tap + to add",
      "ar": "إضغط + لإضافة",
    },
    "deletingPlan": {
      "en": "Deleting Plan",
      "ar": "جاري حذف الخطة",
    },
    "deleting_account": {
      "en": "Deleting Account",
      "ar": "جاري حذف الحساب",
    },
    "planDeletedSuccessfully": {
      "en": "Plan deleted successfully",
      "ar": "تم حذف الخطة بنجاح",
    },
    "alert_sent_success": {
      "en": "Alert sent successfully",
      "ar": "تم إرسال التنبيه بنجاح",
    },
    "value_too_high": {
      "en": "Value is too high",
      "ar": "القيمة عالية جدا",
    },
    "noPlanAddedForYou": {
      "en": "No plan added for you",
      "ar": "لا يوجد خطة مضافة لك",
    },
    "noNutPlanAddedForYou": {
      "en": "No nutritional plan added for you",
      "ar": "لا يوجد خطة تغذية مضافة لك",
    },
    "noPlansDescription": {
      "en": "No plans added for you yet",
      "ar": "لا يوجد خطط مضافة لك بعد",
    },
    "noEmail": {
      "en": "No email",
      "ar": "لا يوجد بريد إلكتروني",
    },
    "noNutritionalPlansYet": {
      "en": "No nutritional plans yet",
      "ar": "لم تنشئ خطط تغذية بعد",
    },
    "noPlansYet": {
      "en": "No training plans yet",
      "ar": "لم تنشئ خطط تدريبية بعد",
    },
    "please_enter_a_value": {
      "en": "Please enter a value",
      "ar": "يرجى إدخال قيمة",
    },
    "please_enter_a_number_less_than_100": {
      "en": "Please enter a number less than 100",
      "ar": "يرجى إدخال رقم أقل من 100",
    },
    "thisActionCannotBeUndone": {
      "en": "This action cannot be undone",
      "ar": "هذه الخطوة غير قابلة للتراجع",
    },
    "planAddedForYou": {
      "en": "Plan added for you",
      "ar": "تم إضافة الخطة لك",
    },
    "timer_title": {
      "en": "Workout Timer",
      "ar": "توقيت التمرين",
    },
    "logging_out": {
      "en": "Logging out...",
      "ar": "جاري تسجيل الخروج...",
    },
    "pleaseEnterAValidNumber": {
      "en": "Please enter a valid number",
      "ar": "يرجى إدخال رقم صالح",
    },
    "pleaseEnterAPositiveNumber": {
      "en": "value>0",
      "ar": "القيمة>0",
    },
    "pleaseEnterANumberLessThan1000": {
      "en": "value<1000",
      "ar": "القيمة<1000",
    },
    "saving": {
      "en": "Saving...",
      "ar": "جاري الحفظ...",
    },
    "chooseAccountType": {
      "en": "Choose Account Type",
      "ar": "اختر نوع الحساب",
    },
    "selectUserTypeTitle": {
      "en": "Select User Type",
      "ar": "اختر نوع المستخدم",
    },
    "selectUserTypeDesc": {
      "en": "Select the type of account you want to create",
      "ar": "اختر نوع الحساب الذي تريد إنشاؤه",
    },
    "gotIt": {
      "en": "Got it",
      "ar": "تم",
    },
    "addExercisesTitle": {
      "en": "Add Exercises",
      "ar": "إضافة التمارين",
    },
    "addExercisesDesc": {
      "en": "You can add exercises to your plan by tapping the + button",
      "ar": "يمكنك إضافة التمارين إلى خطتك بالضغط على الزر +",
    },
    "calories": {
      "en": "Calories",
      "ar": "السعرات الحرارية",
    },
    "caloriesHint": {
      "en": "Enter total calories",
      "ar": "أدخل السعرات الحرارية الكلية",
    },
    "notes": {
      "en": "Notes",
      "ar": "الملاحظات",
    },
    "notes_hint": {
      "en": "Enter your notes",
      "ar": "أدخل ملاحظاتك",
    },
    "noteSaved": {
      "en": "Note saved",
      "ar": "تم حفظ الملاحظة",
    },
    "emailCopied": {
      "en": "Email copied",
      "ar": "تم نسخ البريد الإلكتروني",
    },
    "sendAlert": {
      "en": "Send Alert",
      "ar": "إرسال تنبيه",
    },
    "sendAlertDesc": {
      "en":
          "Send an alert to your trainees who have finished their subscription and have remaining debt",
      "ar": "إرسال تنبيه إلى المتدربين الذين إنتهى إشتراكهم وبقي عليهم ديون",
    },
    "numberIsBigThanDebts": {
      "en": "Number is big than debts amount",
      "ar": "الرقم أكبر من الديون الموجودة",
    },
    "allTime": {
      "en": "All Time",
      "ar": "الكل",
    },
    "thisMonth": {
      "en": "This Month",
      "ar": "هذا الشهر",
    },
    "thisQuarter": {
      "en": "This Quarter",
      "ar": "هذا الربع",
    },
    "thisYear": {
      "en": "This Year",
      "ar": "هذا العام",
    },
    "invalidUserRole": {
      "en": "Invalid user role",
      "ar": "نوع المستخدم غير صالح",
    },
    "navigationFailed": {
      "en": "Navigation failed",
      "ar": "فشل التنقل",
    },
    "sessionValidationFailed": {
      "en": "Session validation failed",
      "ar": "فشل التحقق من الجلسة",
    },
    "failedToInitializeLoginState": {
      "en": "Failed to initialize login state",
      "ar": "فشل تهيئة الحالة للدخول",
    },
    "tooManyLoginAttempts": {
      "en": "Too many login attempts. Please try again later.",
      "ar": "عدد المحاولات للدخول كبير جدا. يرجى المحاولة مرة أخرى لاحقا.",
    },
    "pleaseCheckYourInputAndTryAgain": {
      "en": "Please check your input and try again.",
      "ar": "يرجى التحقق من إدخالك والمحاولة مرة أخرى.",
    },
    "invalidCredentials": {
      "en": "Invalid credentials",
      "ar": "بيانات الدخول غير صالحة، يرجى التأكد من الإيميل وكلمة المرور.",
    },
    "makeSureYouHaveCreatedAnAccountWithThisEmail": {
      "en": "Please make sure you have created an account with this email",
      "ar": "من فضلك تأكد من أنك أنشئت حساب بهذا البريد الإلكتروني",
    },
    "authenticationFailed": {
      "en": "Authentication failed",
      "ar": "فشل التواصل مع الخادم",
    },
    "pleaseEnterAValidEmail": {
      "en": "Please enter a valid email",
      "ar": "يرجى إدخال بريد إلكتروني صالح",
    },
    "passwordMustBeAtLeast8Characters": {
      "en": "Password must be at least 8 characters",
      "ar": "كلمة المرور يجب أن تكون أكثر من 8 أحرف",
    },
    "noUserFoundWithThisEmail": {
      "en": "No user found with this email.",
      "ar": "لا يوجد مستخدم بهذا البريد الإلكتروني.",
    },
    "invalidPassword": {
      "en": "Invalid password.",
      "ar": "كلمة المرور غير صالحة.",
    },
    "thisAccountHasBeenDisabled": {
      "en": "This account has been disabled.",
      "ar": "تم حظر هذا الحساب.",
    },
    "deleted": {
      "en": "Deleted",
      "ar": "المحذوف",
    },
    "are_you_sure_restore": {
      "en": "Are you sure you want to restore this subscription?",
      "ar": "هل أنت متأكد أنك تريد إعادة تفعيل هذا الاشتراك؟",
    },
    "confirm_restore": {
      "en": "Restore",
      "ar": "إعادة تفعيل",
    },
    "restored_success": {
      "en": "Subscription restored successfully",
      "ar": "تم إعادة تفعيل الاشتراك بنجاح",
    },
    "notesTooShort": {
      "en": "Should be at least 10 characters",
      "ar": "يجب أن تكون أكثر من 10 أحرف",
    },
    "permanent_delete": {
      "en": "Permanent Delete",
      "ar": "حذف دائم",
    },
    "permanent_delete_confirm": {
      "en":
          "Are you sure you want to permanently delete this subscription? This action cannot be undone.",
      "ar":
          "هل انت متاكد من حذف هذا الاشتراك بشكل دائم؟ لا يمكن التراجع عن هذا الاجراء.",
    },
    "permanent_delete_warning": {
      "en":
          "This may result in the deletion of trainee data from analytics and affect information such as total payments.",
      "ar":
          "قد يؤدي إلى حذف بيانات المتدرب من التحليلات ويؤثر على المعلومات مثل إجمالي المدفوعات.",
    },
    "permanent_delete_success": {
      "en": "Subscription permanently deleted successfully",
      "ar": "تم حذف الاشتراك بشكل دائم بنجاح",
    },
    "avgRevenue": {
      "en": "Average Revenue",
      "ar": "متوسط الدخل",
    },
    "today": {
      "en": "Today",
      "ar": "اليوم",
    },
    "yesterday": {
      "en": "Yesterday",
      "ar": "اليوم الماضي",
    },
    "thisWeek": {
      "en": "This Week",
      "ar": "هذا الاسبوع",
    },
    "year": {
      "en": "This Year",
      "ar": "هذه السنة",
    },
    "lastWeek": {
      "en": "Last Week",
      "ar": "الاسبوع الماضي",
    },
    "lastMonth": {
      "en": "Last Month",
      "ar": "الشهر الماضي",
    },
    "lastYear": {
      "en": "Last Year",
      "ar": "السنة الماضية",
    },
    "lastQuarter": {
      "en": "Last Quarter",
      "ar": "الربع الماضي",
    },
    "delete_account": {
      "en": "Delete Account",
      "ar": "حذف الحساب",
    },
    "delete_account_title": {
      "en": "Delete Account",
      "ar": "حذف الحساب",
    },
    "delete_account_confirm": {
      "en":
          "Are you sure you want to delete your account? This action cannot be undone.",
      "ar": "هل انت متاكد من حذف حسابك؟ لا يمكن التراجع عن هذا الاجراء.",
    },
    "Notifications": {
      "en": "Notifications",
      "ar": "الاشعارات",
    },
    "MarkAllAsRead": {
      "en": "Mark All As Read",
      "ar": "تحديث كل الاشعارات",
    },
    "noPaymentsYet": {
      "en": "No payments yet",
      "ar": "لا يوجد دفعات حتى الان",
    },
    "viewAllBills": {
      "en": "View All Bills",
      "ar": "اظهار كافة الدفعات",
    },
    "viewAllDebts": {
      "en": "View All Debts",
      "ar": "اظهار كافة الديون",
    },
    "paymentHistory": {
      "en": "Payment History",
      "ar": "تاريخ الدفعات",
    },
    "noBillsYet": {
      "en": "No Bills yet",
      "ar": "لا يوجد دفعات حتى الان",
    },
    "subscription": {
      "en": "Subscription",
      "ar": "الاشتراك",
    },
    "subscriptionDetails": {
      "en": "Subscription Details",
      "ar": "تفاصيل الاشتراك",
    },
    "manageYourFitnessJourney": {
      "en": "Manage your fitness journey",
      "ar": "ادارة رحلتك الرياضية",
    },
    "currentPlan": {
      "en": "Current Plan",
      "ar": "الخطة الحالية",
    },
    "eliteFitnessPackage": {
      "en": "Elite Fitness Package",
      "ar": "باقة رياضية مميزة",
    },
    "monthlyFee": {
      "en": "Monthly Fee",
      "ar": "الرسوم الشهرية",
    },
    "nextPayment": {
      "en": "Next Payment",
      "ar": "الدفع القادم",
    },
    "trainerAccount": {
      "en": "Trainer Account",
      "ar": "حساب المدرب",
    },
    "outstandingBalance": {
      "en": "Outstanding Balance",
      "ar": "الديون",
    },
    "viewNutritionPlan": {
      "en": "View Nutrition Plan",
      "ar": "اظهار خطة التغذية",
    },
    "viewTrainingPlan": {
      "en": "View Training Plan",
      "ar": "اظهار خطة التدريب",
    },
    "remaining_time_notification": {
      "en": "Remaining Time",
      "ar": "الوقت المتبقي",
    },
    "remaining": {
      "en": "Remaining",
      "ar": "الوقت المتبقي",
    },
    "subscriptionEndsOn": {
      "en": "Subscription ends on",
      "ar": "ينتهي الاشتراك في",
    },
    "youAreSubscribed": {
      "en": "You are subscribed as premium",
      "ar": "تم الاشتراك في الخطة المميزة",
    },
    "subscription_active": {
      "en": "Subscription active",
      "ar": "الاشتراك مفعل",
    },
    "subscription_ends": {
      "en": "Subscription ends on",
      "ar": "ينتهي الاشتراك في",
    },
    "subscription_title": {
      "en": "Subscription Plan",
      "ar": "باقة الاشتراك",
    },
    "subscription_description": {
      "en": "Subscribe to get access to all features and support your coach",
      "ar": "اشتراك للوصول إلى جميع الميزات ودعم المدرب",
    },
    "logout_error": {
      "en": "Logout Error",
      "ar": "خطأ في تسجيل الخروج",
    },
    "first_debt": {
      "en": "Subscription Debt",
      "ar": "ديون الإشتراك الأولى",
    },
    "debt_title": {
      "en": "Debt Title",
      "ar": "عنوان الديون",
    },
    "enter_debt_title": {
      "en": "Enter Debt Title",
      "ar": "ادخل عنوان الديون",
    },
    "enter_amount": {
      "en": "Please enter an amount",
      "ar": "الرجاء ادخال المبلغ",
    },
    "noDebtsYet": {
      "en": "No Debts",
      "ar": "لا يوجد ديون",
    },
    "warning": {
      "en": "Warning",
      "ar": "تحذير",
    },
    "warning_message": {
      "en": "You can only start training for the current day: ",
      "ar": "يمكنك بدء التدريب فقط لليوم الحالي: ",
    },
    "unsubscribed": {
      "en": "You have been unsubscribed from the gym",
      "ar": "تم إلغاء إشتراكك في نادي ",
    },
    "gym_name_step": {
      "en": "Add your own brand name",
      "ar": "أضف إسم العلامة التجارية الخاصة بك",
    },
    "gym_name": {
      "en": "Gym Name",
      "ar": "اسم النادي",
    },
    "gym_name_step_subtitle": {
      "en":
          "Enter the name of your gym or training facility where you primarily work with clients",
      "ar":
          "أدخل اسم صالة الألعاب الرياضية أو منشأة التدريب التي تعمل فيها بشكل أساسي مع العملاء",
    },
    "enter_gym_name_hint": {
      "en": "Enter Gym Name",
      "ar": "ادخل اسم النادي",
    },
    "error_empty_gym_name": {
      "en": "Please enter a gym name",
      "ar": "الرجاء ادخال اسم النادي",
    },
    "error_empty": {
      "en": "This field cannot be empty",
      "ar": "هذا الحقل لا يمكن ان يكون فارغ",
    },
    "yearsAgo": {
      "en": "years ago",
      "ar": "سنوات",
    },
    "emptyOrErrorFields": {
      "en":
          "There are some empty or error fields in the form, please check the entered data.",
      "ar": "هناك بعض الحقول فارغة او تحتوي خطأ، يرجى مراجعة البيانات المدخلة.",
    },
    "reset_password": {
      "en":
          "Please check your inbox and follow the instructions to reset your password.",
      "ar":
          "يرجى التحقق من صندوق الوارد وتتبع التعليمات لاستعادة كلمة المرور الخاصة بك.",
    },
    "8yqvtl51": {
      "en": "Trainee Information",
      "ar": "معلومات المتدرب",
    },
    "debtAdded": {
      "en": "Debt Added",
      "ar": "تم اضافة ديون",
    },
    "debtRemoved": {
      "en": "Debt Removed",
      "ar": "تم حذف ديون",
    },
    "subscriptionCanceled": {
      "en": "Subscription Canceled",
      "ar": "تم الغاء الاشتراك",
    },
    "noNutPlanSelected": {
      "en": "No Nutritional Plan Selected",
      "ar": "لم يتم اختيار خطة غذائية",
    },
    "noPlanSelected": {
      "en": "No Training Plan Selected",
      "ar": "لم يتم اختيار خطة تدريبية",
    },
    "notesSaved": {
      "en": "Notes Saved",
      "ar": "تم حفظ الملاحظات",
    },
    "editName": {
      "en": "Edit Name",
      "ar": "تعديل الاسم",
    },
    "editEmail": {
      "en": "Edit Email",
      "ar": "تعديل البريد الإلكتروني",
    },
    "enterName": {
      "en": "Enter new name",
      "ar": "أدخل الاسم الجديد",
    },
    "enterEmail": {
      "en": "Enter new email",
      "ar": "أدخل البريد الإلكتروني الجديد",
    },
    "nameUpdated": {
      "en": "Name updated successfully",
      "ar": "تم تحديث الاسم بنجاح",
    },
    "emailUpdated": {
      "en": "Email updated successfully",
      "ar": "تم تحديث البريد الإلكتروني بنجاح",
    },
    "save": {
      "en": "Save",
      "ar": "حفظ",
    },
    "errorOccurred": {
      "en": "An error occurred",
      "ar": "حدث خطأ ما",
    },
    "editNutritionPlan": {
      "en": "Edit Nutrition Plan",
      "ar": "تعديل خطة غذائية",
    },
    "updateYourNutritionPlan": {
      "en": "Update Your Nutrition Plan",
      "ar": "تحديث خطة غذائية الخاصة بك",
    },
    "updatePlan": {
      "en": "Update Plan",
      "ar": "تحديث الخطة",
    },
    "hasBeenDeleted": {
      "en": "has been deleted",
      "ar": "تم حذفه",
    },
    "verificationSuccessful": {
      "en": "Verification successful",
      "ar": "تم التحقق بنجاح",
    },
    "verifyHumanity": {
      "en": "Verify you are human",
      "ar": "تحقق من انك انسان",
    },
    "pleaseVerifyYouAreHuman": {
      "en": "Please verify you are human",
      "ar": "يرجى التحقق من انك انسان",
    },
    "humanVerification": {
      "en": "Human Verification",
      "ar": "تحقق من انك انسان",
    },
    "verifyToProveYouAreHuman": {
      "en": "Verify to prove you are human",
      "ar": "تحقق من انك انسان",
    },
    "enterYourAnswer": {
      "en": "Enter your answer",
      "ar": "ادخل الجواب الخاص بك",
    },
    "incorrectAnswerPleaseRetry": {
      "en": "Incorrect answer, please retry",
      "ar": "الجواب غير صحيح، يرجى المحاولة مرة اخرى",
    },
    "attemptsLeft": {
      "en": "attempts left",
      "ar": "محاولات متبقية",
    },
    "solveTheMathProblem": {
      "en": "Solve the math problem",
      "ar": "حل المسائل الرياضية",
    },
    "iAmNotARobot": {
      "en": "I am not a robot",
      "ar": "انا ليس روبوت",
    },
    "emailVerification": {
      "en": "Email Verification",
      "ar": "تحقق من البريد الإلكتروني",
    },
    "enterVerificationCode": {
      "en": "Enter verification code",
      "ar": "ادخل رمز التحقق",
    },
    "ifCodeDoesNotArive": {
      "en": "If code does not arrive, please check your spam folder.",
      "ar":
          "اذا لم يصل الكود، يرجى التحقق من قسم الرسائل الغير مرغوب بها في الإيميل.",
    },
    "verifying": {
      "en": "Verifying...",
      "ar": "جار التحقق...",
    },
    "verifyCode": {
      "en": "Verify Code",
      "ar": "تحقق من الكود",
    },
    "enterCode": {
      "en": "Enter Code",
      "ar": "ادخل الكود",
    },
    "resendVerificationCode": {
      "en": "Resend verification code",
      "ar": "ارسل رمز التحقق مرة اخرى",
    },
    "resendIn": {
      "en": "Resend code in",
      "ar": "ارسل رمز التحقق مرة اخرى في",
    },
    "changeEmailAddress": {
      "en": "Change email address",
      "ar": "تغيير عنوان البريد الإلكتروني",
    },
    "emailVerificationMessage": {
      "en": "Verification code sent to your email",
      "ar": "تم ارسال رمز التحقق الى البريد الالكتروني الخاص بك",
    },
    "verificationEmailSent": {
      "en":
          "A verification email has been sent to your email address. Please check your inbox and verify your email.",
      "ar":
          "تم ارسال بريد التحقق الى البريد الالكتروني الخاص بك. يرجى التحقق من البريد الالكتروني الخاص بك",
    },
    "resendEmail": {
      "en": "Resend email",
      "ar": "ارسل البريد الالكتروني مرة اخرى",
    },
    "invalidCode": {
      "en": "Please enter the correct code",
      "ar": "يرجى ادخال الرمز صحيح",
    },
    "previous_step": {
      "en": "Previous step",
      "ar": "الخطوة السابقة",
    },
    "finish": {
      "en": "Finish",
      "ar": "انهاء",
    },
    "next_step": {
      "en": "Next step",
      "ar": "الخطوة التالية",
    },
    "invalidNumber": {
      "en": "Invalid Number",
      "ar": "رقم غير صحيح",
    },
    "invalid_experience": {
      "en": "Invalid Experience",
      "ar": "قيمة الخبرة غير صحيحة",
    },
    "experience_too_high": {
      "en": "Experience too high",
      "ar": "الخبرة كبيرة جداً",
    },
    "name_too_short": {
      "en": "Name too short",
      "ar": "الاسم قصير جداً",
    },
    "personalization_note": {
      "en":
          "Your workout plan will be personalized based on your goals and physical attributes. You can always change these settings later.",
      "ar":
          "سيتم تخصيص خطة التمارين الخاصة بك بناء على مهامك وخصائصك البدنية. يمكنك تغيير هذه الاعدادات في اي وقت",
    },
    "personal_info_step": {
      "en": "Personal Information",
      "ar": "معلومات شخصية",
    },
    "physical_info_step": {
      "en": "Physical Information",
      "ar": "معلومات بدنية",
    },
    "goals_step": {
      "en": "Goals",
      "ar": "الهدف",
    },
    "reauth_required": {
      "en": "Re-Authentication Required",
      "ar": "التحقق مطلوب",
    },
    "relogin_required": {
      "en": "Please log in again to delete your account",
      "ar": "يرجى تسجيل الدخول مرة اخرى لحذف حسابك",
    },
    "reauth_message": {
      "en": "For security reasons, please enter your password to continue.",
      "ar": "للسلامة، يرجى ادخال كلمة المرور الخاصة بك للمتابعة",
    },
    "errorVerifyingPassword": {
      "en": "Failed to verify password. Please try again.",
      "ar": "فشل التحقق من كلمة المرور. يرجى المحاولة مرة اخرى",
    },
    "verify": {
      "en": "Verify",
      "ar": "تاكيد",
    },
    "add_photo": {
      "en": "Add photo",
      "ar": "اضافة صورة",
    },
    "welcome_message": {
      "en": "Welcome to IronFit",
      "ar": "مرحبا بكم في IronFit",
    },
    "physical_info_subtitle": {
      "en": "Help us understand your body better",
      "ar": "ساعدنا على فهم الجسم الخاص بك بشكل افضل",
    },
    "burn_fat": {
      "en": "Burn fat and reduce body weight",
      "ar": "إزالة الدهون وتقليل الوزن",
    },
    "build_strength": {
      "en": "Build strength and increase muscle mass",
      "ar": "تحقيق القوة وتحسين الجسم",
    },
    "maintain_level": {
      "en": "Build strength and size",
      "ar": "تحقيق القوة والحجم",
    },
    "boost_health": {
      "en": "Boost overall health and wellbeing",
      "ar": "تعزيز الصحة العامة",
    },
    "selected_goal": {
      "en": "Selected Goal",
      "ar": "هدف محدد",
    },
    "set_your_goals": {
      "en": "Set your goals",
      "ar": "حدد هدفك",
    },
    "goal_subtitle": {
      "en": "Choose a goal that matches your fitness journey",
      "ar": "اختر هدفاً يتناسق مع رحلة التمارين الخاصة بك",
    },
    "pro_tip": {
      "en": "Pro Tip",
      "ar": "نصيحة مميزة",
    },
    "complete_personal_info": {
      "en": "Complete Personal Info",
      "ar": "أكمل المعلومات الشخصية"
    },
    "invalid_height_range": {
      "en": "Invalid Height Range",
      "ar": "نطاق الارتفاع غير صالح"
    },
    "invalid_weight_range": {
      "en": "invalid weight range",
      "ar": "نطاق الوزن غير صالح"
    },
    "checkBackLater": {"en": "Check back later", "ar": "تحقق منها لاحقا"},
    "contactTrainer": {
      "en": "Contact your trainer for more information",
      "ar": "اتصل بالمدرب لمزيد من المعلومات",
    },
    "continueWithApple": {
      "en": "Continue with Apple",
      "ar": "المتابعة بواسطة Apple",
    },
    "signUp": {"en": "Sign Up", "ar": "إنشاء حساب"},
    "phone": {"en": "Phone", "ar": "رقم الجوال"},
    "phoneHint": {
      "en": "Please enter your phone number",
      "ar": "يرجى ادخال رقم الجوال الخاص بك",
    },
    "dataLoadError": {
      "en": "Failed to load data",
      "ar": "فشل تحميل البيانات",
    },
    "pleaseReviewYourCoach": {
      "en": "Please review your coach, is the plan available?",
      "ar": "يرجى التحقق من مدربك، هل الخطة موجودة؟",
    },
    "privacyPolicy": {
      "en": "By continuing you accept our Privacy Policy",
      "ar": "بالمتابعة أنت توافق على سياسة الخصوصية الخاصة بنا",
    },
    "signInWith": {
      "en": "Sign in with",
      "ar": "تسجيل الدخول بواسطة",
    },
    "personal_best": {"en": "New Personal Best", "ar": "رقم قياسي جديد"},
    "personal_best_description": {
      "en": "Set a new record in your workout!",
      "ar": "حقق رقم جديد في تمرينك!"
    },
    "week_warrior": {"en": "Week Warrior", "ar": "بطل الأسبوع"},
    "week_warrior_description": {
      "en": "Completed workouts for 7 days in a row!",
      "ar": "سبع أيام تدريب متواصل! الأسطورة بنفسها!"
    },
    "monthly_master": {"en": "Monthly Master", "ar": "ملك الشهر"},
    "monthly_master_description": {
      "en": "Completed workouts for 30 days in a row!",
      "ar": "30 يوم تمرين متواصل! إنت أسطورة!"
    },
    "month": {
      "en": "month",
      "ar": "شهر",
    },
    "performance_analytics": {
      "en": "Performance Analytics",
      "ar": "تحليلات الأداء"
    },
    "total_exercises": {"en": "Total Exercises", "ar": "عدد التمارين"},
    "workout_streak": {"en": "Workout Streak", "ar": "تمارين متواصلة"},
    "achievements": {"en": "Achievements", "ar": "إنجازات"},
    "achievement": {"en": "Achievement", "ar": "إنجاز"},
    "recent_improvements": {"en": "Recent Improvements", "ar": "تحسينات جديدة"},
    "today_info": {
      "en": "Today\'s Information",
      "ar": "أخبار اليوم",
    },
    "your_profile": {
      "en": "Your Profile",
      "ar": "ملفك الشخصي",
    },
    "youve_earned": {
      "en": "You\"ve earned",
      "ar": "لقد حصلت على",
    },
    "no_achievements": {
      "en": "No achievements yet",
      "ar": "لا يوجد انجازات حتى الان",
    },
    "duels": {"en": "Duels", "ar": "تحديات"},
    "stats": {"en": "Stats", "ar": "أرقامك"},
    "no_exercise_stats": {
      "en": "No exercise stats yet",
      "ar": "لا يوجد تحليلات حتى الان",
    },
    "best": {"en": "Best Performance", "ar": "أفضل أداء"},
    "total_reps": {
      "en": "Total Reps",
      "ar": "إجمالي العدات",
    },
    "last": {
      "en": "Last",
      "ar": "الأخيرة",
    },
    "daily_progress": {
      "en": "Daily Progress",
      "ar": "التقدم اليومي",
    },
    "no_daily_progress": {
      "en": "No daily progress yet",
      "ar": "لا يوجد تقدم يومي حتى الان",
    },
  },
  {
    "settings": {
      "en": "Settings",
      "ar": "الإعدادات",
    },
    "account_settings": {
      "en": "Account Settings",
      "ar": "إعدادات الحساب",
    },
    "edit_profile": {
      "en": "Edit Profile",
      "ar": "تعديل الملف الشخصي",
    },
    "edit_profile_subtitle": {
      "en": "Update your personal details and preferences",
      "ar": "قم بتحديث بياناتك وتفضيلاتك الشخصية",
    },
    "change_password": {
      "en": "Change Password",
      "ar": "تغيير كلمة المرور",
    },
    "change_password_subtitle": {
      "en": "Update your password to keep your account secure",
      "ar": "قم بتحديث كلمة المرور الخاصة بك للحفاظ على آمنة حسابك."
    },
    "app_settings": {
      "en": "App Settings",
      "ar": "اعدادات التطبيق",
    },
    "change_language": {
      "en": "Change Language",
      "ar": "تغيير اللغة",
    },
    "language": {
      "en": "Language",
      "ar": "اللغة",
    },
    "support": {
      "en": "Support",
      "ar": "الدعم",
    },
    "help_center": {
      "en": "Help Center",
      "ar": "مركز المساعدة",
    },
    "help_center_subtitle": {
      "en": "Get support and troubleshoot problems easily.",
      "ar": "الحصول على الدعم واستكشاف الأخطاء وإصلاحها بسهولة"
    },
    "danger_zone": {
      "en": "Danger Zone",
      "ar": "خانة الخطر",
    },
    "danger": {
      "en": "Danger",
      "ar": "خطر",
    },
    "delete_account": {
      "en": "Delete Account",
      "ar": "حذف الحساب",
    },
    "delete_account_confirmation": {
      "en": "Delete Account?",
      "ar": "حذف الحساب؟",
    },
    "delete_account_warning": {
      "en":
          "Are you sure you want to delete your account? This action cannot be undone.",
      "ar": "هل أنت متأكد من حذف حسابك؟ لا يمكن التراجع عن هذا الإجراء.",
    },
    "cancel": {
      "en": "Cancel",
      "ar": "إلغاء",
    },
    "done": {
      "en": "Done",
      "ar": "تم",
    },
    "paymentInfo": {
      "en": "Payment Info",
      "ar": "معلومات الدفعة",
    },
    "delete": {
      "en": "Delete",
      "ar": "حذف",
    },
    "logout": {
      "en": "Logout",
      "ar": "تسجيل الخروج",
    },
    "logout_title": {
      "en": "Logout",
      "ar": "تسجيل الخروج",
    },
    "logout_confirm": {
      "en": "Are you sure you want to logout?",
      "ar": "هل أنت متأكد من تسجيل الخروج؟",
    },
    "password_reset_sent": {
      "en": "Password reset email sent",
      "ar": "تم ارسال رسالة استعادة كلمة المرور الى البريد الالكتروني",
    },
    "password_reset_failed": {
      "en": "Failed to send password reset email",
      "ar": "فشل ارسال رسالة لإستعادة كلمة المرور الى البريد الالكتروني",
    },
    "today_exercises": {
      "en": "Today\"s Exercises",
      "ar": "تمارين اليوم",
    },
    "more_exercises": {
      "en": "More Exercises",
      "ar": "تمارين اخرى",
    },
    "start_workout": {
      "en": "Start Workout",
      "ar": "بدء التمارين",
    },
    "view_all": {
      "en": "View All",
      "ar": "اظهار الكل",
    },
    "pleaseWait": {
      "en": "Please Wait",
      "ar": "يرجى الانتظار",
    },
    "selectUserTypeDescription": {
      "en":
          "Choose your role to get started. Are you here to guide others on their fitness journey or to achieve your own fitness goals?",
      "ar":
          "اختر دورك للبدء. هل أنت هنا لتوجيه الآخرين في رحلتهم نحو اللياقة البدنية أم لتحقيق أهدافك الخاصة في اللياقة البدنية؟",
    },
    "next": {
      "en": "Next",
      "ar": "التالي",
    },
    "profile_photo": {
      "en": "Profile Photo",
      "ar": "صورة الملف الشخصي",
    },
    "tap_to_upload": {
      "en": "Tap to upload",
      "ar": "انقر للتحميل",
    },
    "profile_photo_title": {
      "en": "Profile Photo",
      "ar": "صورة الملف الشخصي",
    },
    "profile_photo_desc": {
      "en": "Add a professional photo to enhance your profile.",
      "ar": "أضف صورة مميزة لتحسين ملفك الشخصي.",
    },
    "skip": {
      "en": "Skip",
      "ar": "تخطي",
    },
    "go_to_exercises": {
      "en": "Go to Exercises",
      "ar": "الذهاب للتمارين",
    },
    "step": {
      "en": "Step",
      "ar": "خطوة",
    },
    "personal_info_desc": {
      "en":
          "Please fill in your basic information to help us create your professional profile. This information will be visible to your clients.",
      "ar":
          "يرجى ملء معلوماتك الأساسية لمساعدتنا في إنشاء ملفك الشخصي المهني. ستكون هذه المعلومات مرئية لعملائك.",
    },
    "expertise_step": {
      "en": "🚀 Professional Expertise 💪🎓",
      "ar": "🚀 الخبرة المهنية 💪🎓"
    },
    "expertise_step_description": {
      "en":
          "Tell us about your experience and specializations as a fitness coach. This helps clients understand your background and expertise.",
      "ar":
          "أخبرنا عن خبرتك وتخصصاتك كمدرب لياقة بدنية. يساعد هذا العملاء على فهم خلفيتك وخبرتك.",
    },
    "pricing_step": {
      "en": "💰 Set Your Subscription Price 📢",
      "ar": "💰 حدد سعر الاشتراك 📢"
    },
    "pricing_step_subtitle": {
      "en":
          "Enter your monthly training price. Choose a competitive rate that reflects your expertise and services.",
      "ar":
          "أدخل سعر التدريب الشهري الخاص بك. اختر سعرًا تنافسيًا يعكس خبرتك وخدماتك.",
    },
    "in": {
      "en": "in",
      "ar": "في",
    },
    "client_information_desc": {
      "en":
          "Enter your client\'s contact details and subscription period to get started.",
      "ar": "أدخل تفاصيل الاتصال الخاصة بعميلك وفترة الاشتراك للبدء",
    },
    "client_more_desc": {
      "en": "Add payment details and any additional notes about your client.",
      "ar": "أضف تفاصيل الدفع وأي ملاحظات إضافية حول عميلك.",
    },
    "paymentDetails": {"en": "Payment Details", "ar": "تفاصيل الدفع"},
    "client_details_desc": {
      "en": "Please provide information about your client\'s training goals.",
      "ar": "يرجى تقديم معلومات حول أهداف التدريب الخاصة بعميلك."
    },
    "retry": {
      "en": "Retry",
      "ar": "اعادة المحاولة",
    },
    "try_different_search": {
      "en": "Try a different search",
      "ar": "حاول البحث بطريقة مختلفة"
    },
    "invalid_date_format": {
      "en": "Invalid date format",
      "ar": "تنسيق التاريخ غير صحيح"
    },
    "centurion": {"en": "Centurion", "ar": "قائد"},
    "centurion_description": {
      "en": "Incredible! 100 days of consecutive workouts!",
      "ar": "لا يصدق! 100 يوم من التمارين المتتالية!"
    },
    "first_step": {"en": "First Step", "ar": "الخطوة الأولى"},
    "first_step_description": {
      "en": "Started your fitness journey with your first workout!",
      "ar": "بدأت رحلة لياقتك البدنية مع أول تمرين!"
    },
    "reps_master": {"en": "Reps Master", "ar": "سيد التكرارات"},
    "reps_master_description": {
      "en": "Achieved 1000 total reps in a single exercise!",
      "ar": "حققت 1000 تكرار في تمرين واحد!"
    },
    "consistency_champion": {
      "en": "Consistency Champion",
      "ar": "بطل المثابرة"
    },
    "consistency_champion_description": {
      "en": "Completed the same exercise for 5 consecutive days!",
      "ar": "أكملت نفس التمرين لمدة 5 أيام متتالية!"
    },
    "body_part": {"en": "Body Part", "ar": "المنطقة المستهدفة"},
    "characters": {"en": "Characters", "ar": "حروف"},
    "title_too_short": {"en": "Title is too short", "ar": "العنوان قصير جداً"},
    "tips": {"en": "Tips", "ar": "نصائح"},
    "title_tips": {
      "en":
          "Choose a clear, descriptive name for your training day that helps you remember what you\'ll be working on.",
      "ar":
          "اختر اسمًا واضحًا ووصفيًا ليوم التدريب الخاص بك يساعدك على تذكر ما ستعمل عليه."
    },
    "update": {"en": "Update", "ar": "تحديث"},
    "edit_training_day": {"en": "Edit Training Day", "ar": "تعديل يوم التدريب"},
    "edit_training_day_title": {
      "en": "Edit Training Day",
      "ar": "تعديل يوم التدريب"
    },
    "current_day": {"en": "Current Day", "ar": "اليوم الحالي"},
    "delete_account_error": {
      "en": "There was an error deleting your account. Please try again.",
      "ar": "حدث خطأ في حذف حسابك. يرجى المحاولة مجدداً."
    },
    "no_trainees": {
      "en":
          "'No trainee data available for the selected time period until now.'",
      "ar": "لا توجد بيانات للمتدربين للفترة المحددة حتى الان.",
    },
    "no_subscriptions": {
      "en":
          "No subscription data available for the selected time period until now.",
      "ar": "لا توجد بيانات للإشتراكات للفترة المحددة حتى الان.",
    },
    "refresh": {"en": "Refresh", "ar": "تحديث"},
    "nutritionPlanNotFound": {
      "en": "Nutrition plan not found",
      "ar": "لم يتم العثور على خطة التغذية",
    },
    "errorNavigatingToTrainingPlan": {
      "en": "Error navigating to training plan",
      "ar": "خطأ في الإنتقال إلى خطة التدريب",
    },
  },
  {
    "validation_errors": {
      "en": "Validation Errors",
      "ar": "أخطاء التحقق",
    },
    "error_email_required": {
      "en": "Email is required",
      "ar": "البريد الإلكتروني مطلوب",
    },
    "error_invalid_email": {
      "en": "Please enter a valid email",
      "ar": "يرجى إدخال بريد إلكتروني صالح",
    },
    "error_name_required": {
      "en": "Name is required",
      "ar": "الاسم مطلوب",
    },
    "error_start_date_required": {
      "en": "Start date is required",
      "ar": "تاريخ البدء مطلوب",
    },
    "error_end_date_required": {
      "en": "End date is required",
      "ar": "تاريخ الانتهاء مطلوب",
    },
    "error_goal_required": {
      "en": "Goal is required",
      "ar": "الهدف مطلوب",
    },
    "error_level_required": {
      "en": "Level is required",
      "ar": "المستوى مطلوب",
    },
    "error_paid_amount_required": {
      "en": "Paid amount is required",
      "ar": "المبلغ المدفوع مطلوب",
    },
    "error_invalid_paid_amount": {
      "en": "Please enter a valid paid amount",
      "ar": "يرجى إدخال مبلغ مدفوع صالح",
    },
    "error_debts_amount_required": {
      "en": "Debts amount is required",
      "ar": "مبلغ الديون مطلوب",
    },
    "error_invalid_debts_amount": {
      "en": "Please enter a valid debts amount",
      "ar": "يرجى إدخال مبلغ ديون صالح",
    },
    "level": {
      "en": "Level",
      "ar": "المستوى",
    },
    "confirmDeletePlan": {
      "en": "Are you sure you want to delete this plan?",
      "ar": "هل انت متاكد من حذف هذه الخطة؟"
    },
    "deleteTrainingPlan": {
      "en": "Delete Training Plan",
      "ar": "حذف خطة التدريب"
    },
    "deleteNutritionalPlan": {
      "en": "Delete Nutritional Plan",
      "ar": "حذف خطة التغذية"
    },
    "planDeleted": {
      "en": "Plan deleted successfully",
      "ar": "تم حذف الخطة بنجاح"
    },
    "biceps": {"en": "Biceps", "ar": "عضلة الباي"},
    "triceps": {"en": "Triceps", "ar": "عضلة التراي"},
    "days": {"en": "days", "ar": "أيام"},
    "connectWithMe": {"en": "Connect with me", "ar": "اتصل بي"},
    "loadingYourProfile": {
      "en": "Loading your profile...",
      "ar": "جاري تحميل ملفك الشخصي..."
    },
    "loading": {"en": "Loading...", "ar": "جاري تحميل..."},
    "shareMyProfile": {"en": "Share My Profile", "ar": "شارك ملفك الشخصي"},
    "share": {"en": "Share", "ar": "شارك"},
    "planUpdatedSuccessfully": {
      "en": "Plan updated successfully",
      "ar": "تم تحديث الخطة بنجاح"
    },
    "none": {"en": "Nothing", "ar": "لا يوجد"},
    "select_plans_title": {"en": "Select Plans", "ar": "إختر الخطط"},
    "selectPlan": {"en": "Select Plan", "ar": "إختر الخطة"},
    "select_plans_description": {
      "en": "Choose the training and nutrition plans for this client",
      "ar": "اختر خطط التدريب والتغذية لهذا العميل"
    },
    "select_plan": {"en": "Select a training plan", "ar": "حدد خطة التدريب"},
    "select_nutrition_plan": {
      "en": "Select a nutritional plan",
      "ar": "حدد خطة التغذية"
    },
    "weekly_goal_achieved": {
      "en": "Weekly Goal Achieved",
      "ar": "تم تحقيق الهدف الأسبوعي"
    },
    "weekly_goal_achieved_description": {
      "en": "You reached your weekly goal for this exercise!",
      "ar": "لقد وصلت إلى هدفك الأسبوعي لهذا التمرين!"
    },
    "reps_advanced": {"en": "Reps Advanced", "ar": "التمارين المتقدمة"},
    "reps_advanced_description": {
      "en": "Completed 500 reps for this exercise!",
      "ar": "لقد أكملت 500 تكرارًا لهذا التمرين!"
    },
    "reps_beginner": {"en": "Reps Beginner", "ar": "تمارين البداية"},
    "reps_beginner_description": {
      "en": "Completed your first 100 reps for this exercise!",
      "ar": "لقد أكملت أول 100 تكرار لهذا التمرين!"
    },
  },
  // Weight Input Dialog
  {
    "weight_input_title": {
      "en": "Weight Input",
      "ar": "إدخال الوزن",
    },
    "weight_input_subtitle": {
      "en": "How much weight did you lift for",
      "ar": "كم وزن رفعت في",
    },
    "weight_input_label": {
      "en": "Weight (kg)",
      "ar": "الوزن (كجم)",
    },
    "weight_input_required": {
      "en": "Please enter the weight",
      "ar": "الرجاء إدخال الوزن",
    },
    "weight_input_invalid": {
      "en": "Please enter a valid weight between 1 and 500 kg",
      "ar": "الرجاء إدخال وزن صحيح بين 1 و 500 كجم",
    },
    "submit": {
      "en": "Submit",
      "ar": "إرسال",
    },
    "cancel": {
      "en": "Cancel",
      "ar": "إلغاء",
    },
    "session_duration": {
      "en": "Session Duration",
      "ar": "مدة الجلسة",
    },
    "training_time_title": {
      "en": "Preferred Training Times",
      "ar": "أوقات التدريب المفضلة",
    },
    "training_time_subtitle": {
      "en": "When do you prefer to workout?",
      "ar": "متى تفضل ممارسة التمارين الرياضية؟",
    },
    "add_training_time": {"en": "Add Training Time", "ar": "إضافة وقت التدريب"},
    "tap_to_select_time": {
      "en": "Tap to select a time",
      "ar": "انقر لتحديد وقت"
    },
    "no_times_selected": {
      "en": "No training times selected yet",
      "ar": "لم يتم تحديد أوقات التدريب بعد"
    },
    "training_time_step": {"en": "Training Times", "ar": "أوقات التدريب"},
    "training_times_required": {
      "en": "Please select at least one training time",
      "ar": "الرجاء تحديد على الاقل وقت تدريبي"
    },
    "weight_reminder_title": {
      "en": "Time to Check If Gravity Is Still Working! 😜",
      "ar": "يلا نشوف الجاذبية لسه شغالة ولا لأ! 😜"
    },
    "weight_reminder_message": {
      "en":
          "Updating your weight helps us track progress. Or at least pretend we are!",
      "ar":
          "لما تحدّث وزنك، نقدر نتابع التقدم... أو على الأقل نعمل نفسنا بنحاول!"
    },
    "current_weight": {"en": "Current Weight", "ar": "الوزن الحالي"},
    "recommended": {"en": "Recommended", "ar": "موصى به"},
    "rest_time_title": {
      "en": "Rest Time Between Sets",
      "ar": "وقت الراحة بين الجلسات"
    },
    "rest_time_subtitle": {
      "en": "Choose your preferred rest time between workout sets",
      "ar": "اختر وقت الراحة المفضل لديك بين مجموعات التمرين"
    },
    "short_rest": {"en": "Short rest", "ar": "راحة قصيرة"},
    "standard_rest": {"en": "Standard rest", "ar": "الراحة القياسية"},
    "long_rest": {"en": "Long rest", "ar": "راحة طويلة"},
    "rest_time_step": {"en": "Rest Time", "ar": "وقت الراحة"},
    "rest_time_required": {
      "en": "Please select a rest time",
      "ar": "الرجاء تحديد وقت الراحة"
    },
    "maximum_weight": {"en": "Maximum weight", "ar": "أعلى وزن"},
  },
  // User Enter Info Page
  {
    "profile_image_step": {"en": "Profile Photo", "ar": "الصورة الشخصية"},
    "name_step": {"en": "Full Name", "ar": "الاسم الكامل"},
    "birthdate_step": {"en": "Date of Birth", "ar": "تاريخ الميلاد"},
    "gender_step": {"en": "Gender", "ar": "الجنس"},
    "height_step": {"en": "Height", "ar": "الطول"},
    "weight_step": {"en": "Weight", "ar": "الوزن"},
    "profile_image_title": {
      "en": "Add a Profile Photo",
      "ar": "أضف صورة شخصية"
    },
    "profile_image_description": {
      "en": "Upload a clear photo of yourself to personalize your profile",
      "ar": "قم بتحميل صورة واضحة لنفسك لتخصيص ملفك الشخصي"
    },
    "upload_photo": {"en": "Upload Photo", "ar": "تحميل صورة"},
    "change_photo": {"en": "Change Photo", "ar": "تغيير الصورة"},
    "photo_uploaded_success": {
      "en": "Photo uploaded successfully",
      "ar": "تم تحميل الصورة بنجاح"
    },
    "name_title": {"en": "What's your name?", "ar": "ما هو اسمك؟"},
    "name_description": {
      "en": "Enter your full name as you'd like it to appear on your profile",
      "ar": "أدخل اسمك الكامل كما تريد أن يظهر في ملفك الشخصي"
    },
    "name_hint": {"en": "Enter your full name", "ar": "أدخل اسمك الكامل"},
    "name_required": {
      "en": "Please enter your name",
      "ar": "الرجاء إدخال اسمك"
    },
    "birthdate_title": {"en": "When were you born?", "ar": "متى ولدت؟"},
    "birthdate_description": {
      "en": "Your date of birth helps us personalize your fitness plan",
      "ar": "تاريخ ميلادك يساعدنا على تخصيص خطة اللياقة البدنية الخاصة بك"
    },
    "dateOfBirth_hint": {
      "en": "Select your date of birth",
      "ar": "اختر تاريخ ميلادك"
    },
    "dateOfBirth_required": {
      "en": "Please select your date of birth",
      "ar": "الرجاء اختيار تاريخ ميلادك"
    },
    "gender_title": {"en": "What's your gender?", "ar": "ما هو جنسك؟"},
    "gender_description": {
      "en": "This helps us customize your fitness experience",
      "ar": "هذا يساعدنا على تخصيص تجربة اللياقة البدنية الخاصة بك"
    },
    "gender_required": {
      "en": "Please select your gender",
      "ar": "الرجاء اختيار جنسك"
    },
    "height_title": {"en": "How tall are you?", "ar": "كم طولك؟"},
    "height_description": {
      "en": "Your height helps us calculate your fitness metrics accurately",
      "ar": "طولك يساعدنا على حساب مقاييس اللياقة البدنية الخاصة بك بدقة"
    },
    "height_hint": {
      "en": "Enter your height in cm",
      "ar": "أدخل طولك بالسنتيمتر"
    },
    "height_required": {
      "en": "Please enter your height",
      "ar": "الرجاء إدخال طولك"
    },
    "weight_title": {
      "en": "What's your current weight?",
      "ar": "ما هو وزنك الحالي؟"
    },
    "weight_description": {
      "en":
          "Your weight helps us track your progress and set appropriate goals",
      "ar": "وزنك يساعدنا على تتبع تقدمك وتحديد أهداف مناسبة"
    },
    "weight_hint": {
      "en": "Enter your weight in kg",
      "ar": "أدخل وزنك بالكيلوجرام"
    },
    "weight_required": {
      "en": "Please enter your weight",
      "ar": "الرجاء إدخال وزنك"
    },
    "training_time_title": {
      "en": "When do you prefer to train?",
      "ar": "متى تفضل التدريب؟"
    },
    "training_time_subtitle": {
      "en": "Select your preferred training time",
      "ar": "اختر وقت التدريب المفضل لديك"
    },
    "select_training_time": {
      "en": "Select Training Time",
      "ar": "اختر وقت التدريب"
    },
    "change_training_time": {
      "en": "Change Training Time",
      "ar": "تغيير وقت التدريب"
    },
    "tap_to_select_time": {
      "en": "Tap to select a time",
      "ar": "انقر لاختيار وقت"
    },
    "selected_time": {"en": "Selected Time", "ar": "الوقت المختار"},
    "training_time_required": {
      "en": "Please select your preferred training time",
      "ar": "الرجاء اختيار وقت التدريب المفضل لديك"
    },
    "gymBasicInfo": {
      "en": "🏋️ Gym Basic Info 📋",
      "ar": "🏋️ معلومات النادي الأساسية 📋"
    },
    "gymName": {"en": "Gym Name", "ar": "اسم النادي"},
    "gymWebsite": {"en": "Gym Website", "ar": "الموقع الإلكتروني للنادي"},
    "address": {"en": "Gym Address", "ar": "عنوان النادي"},
    "country": {"en": "Gym Country", "ar": "الدولة"},
    "city": {"en": "Gym City", "ar": "المدينة"},
    "gymLocation": {"en": "📍 Gym Location 🏋️", "ar": "📍 موقع النادي 🏋️"},
    "enterGymName": {"en": "Enter Gym Name", "ar": "أدخل اسم النادي"},
    "enterGymWebsite": {"en": "Enter Gym Website", "ar": "أدخل موقع النادي"},
    "enterAddress": {"en": "Enter Gym Address", "ar": "أدخل عنوان النادي"},
    "enterCountry": {"en": "Enter Gym Country", "ar": "أدخل الدولة النادي"},
    "enterCity": {"en": "Enter Gym City", "ar": "أدخل المدينة النادي"},
    "enterGymLocation": {
      "en": "Enter Gym Location",
      "ar": "أدخل الموقع النادي"
    },
    "uploadGymPhotos": {"en": "Upload Gym Photos", "ar": "رفع صور النادي"},
    "gymContact": {"en": "📞 Gym Contact 📞", "ar": "📞 تواصل مع النادي 📞"},
    "phoneNumber": {"en": "Phone Number", "ar": "رقم الهاتف"},
    "email": {"en": "Email", "ar": "البريد الإلكتروني"},
    "enterPhoneNumber": {"en": "Enter Phone Number", "ar": "أدخل رقم الهاتف"},
    "enterEmail": {"en": "Enter Email", "ar": "أدخل البريد الإلكتروني"},
    "enterInstagram": {"en": "Enter Instagram", "ar": "أدخل Instagram"},
    "enterFacebook": {"en": "Enter Facebook", "ar": "أدخل Facebook"},
    "gymFacilities": {
      "en": "🏢 Gym Facilities 🏋️‍♂️",
      "ar": "🏢 مرافق النادي 🏋️‍♂️"
    },
    "cardioEquipment": {"en": "Cardio Equipment", "ar": "معدات الكارديو"},
    "weightTraining": {"en": "Weight Training", "ar": "تدريب الأوزان"},
    "personalTraining": {"en": "Personal Training", "ar": "التدريب الشخصي"},
    "groupClasses": {"en": "Group Classes", "ar": "حصص جماعية"},
    "swimmingPool": {"en": "Swimming Pool", "ar": "حمام سباحة"},
    "sauna": {"en": "Sauna", "ar": "ساونا"},
    "lockerRooms": {"en": "Locker Rooms", "ar": "غرف تبديل الملابس"},
    "parking": {"en": "Parking", "ar": "موقف سيارات"},
    "wifi": {"en": "Wifi", "ar": "واي فاي"},
    "cafe": {"en": "Cafe", "ar": "مقهى"},
    "workingHours": {"en": "Working Hours", "ar": "أوقات العمل"},
    "workingHoursHint": {
      "en": "Enter here the working hours",
      "ar": "أدخل هنا أوقات العمل"
    },
    "edit_coach_info": {
      "en": "Give the Coach a Makeover! 💇‍♂️📋",
      "ar": "خلينا نغير لوك المدرب! 💇‍♂️📋"
    },
    "new_subscription": {"en": "New Subscription", "ar": "اشتراك جديد"},
    "new_subscription_message": {
      "en": "You have a new subscription",
      "ar": "لديك اشتراك جديد"
    },
    "error_loading_active_subscriptions": {
      "en": "Error loading active subscriptions",
      "ar": "خطأ في تحميل الاشتراكات النشطة"
    },
    "error_loading_inactive_subscriptions": {
      "en": "Error loading inactive subscriptions",
      "ar": "خطأ في تحميل الاشتراكات المنتهية"
    },
    "error_loading_requests": {
      "en": "Error loading requests",
      "ar": "خطأ في تحميل الطلبات"
    },
    "multiple_days_hint": {
      "en": "You can select multiple days",
      "ar": "يمكنك اختيار أيام متعددة"
    },
    "multiple_days_hint_edit": {
      "en": "You can select multiple days to apply the same exercises",
      "ar": "يمكنك اختيار أيام متعددة لتطبيق نفس التمارين"
    },
    "view_plan": {"en": "View", "ar": "عرض"},
    "no_days_in_plan": {"en": "No days in plan", "ar": "لا يوجد أيام في الخطة"},
    "go_back": {"en": "Go Back", "ar": "رجوع"},
    "plan_description": {"en": "Plan Description", "ar": "وصف الخطة"},
    "workout_details": {"en": "WORKOUT DETAILS", "ar": "تفاصيل التمرين"},
    "show_less": {"en": "Show Less", "ar": "إخفاء"},
  }
].reduce((a, b) => a..addAll(b));

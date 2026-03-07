// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'STO - سوق السيارات';

  @override
  String get exploreCategories => 'استكشف الفئات';

  @override
  String get home => 'الرئيسية';

  @override
  String get theme => 'المظهر';

  @override
  String get light => 'فاتح';

  @override
  String get dark => 'داكن';

  @override
  String get system => 'النظام';

  @override
  String get verifiedAccount => 'حساب موثق';

  @override
  String get notVerified => 'غير موثق';

  @override
  String get user => 'مستخدم';

  @override
  String get welcomeBack => 'مرحباً بعودتك!';

  @override
  String get searchHint => 'ابحث عن مركبات، قطع، خدمات...';

  @override
  String searchingFor(String value) {
    return 'جاري البحث عن: $value';
  }

  @override
  String languageChangedTo(String language) {
    return 'تم تغيير اللغة إلى $language';
  }

  @override
  String get carAuctions => 'مزادات السيارات';

  @override
  String liveAuctionsCount(int count) {
    return '$count مزادات مباشرة';
  }

  @override
  String get stoPerformance => 'أداء STO';

  @override
  String get bookService => 'احجز خدمة';

  @override
  String get performanceParts => 'قطع الأداء';

  @override
  String companiesCount(int count) {
    return '$count شركات';
  }

  @override
  String get getVerified => 'احصل على التوثيق';

  @override
  String get accountVerified => 'الحساب موثق';

  @override
  String get verifyYourAccount => 'وثّق حسابك';

  @override
  String get signup => 'إنشاء حساب';

  @override
  String get liveAuctions => 'مزادات مباشرة';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String errorLoadingHome(String error) {
    return 'خطأ في تحميل الصفحة الرئيسية: $error';
  }

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageArabic => 'العربية';

  @override
  String get auctionNotFound => 'المزاد غير موجود';

  @override
  String get backToAuctions => 'العودة إلى المزادات';

  @override
  String get description => 'الوصف';

  @override
  String get winningBid => 'الرابح';

  @override
  String get outbid => 'مغالب';

  @override
  String get winning => 'رابح';

  @override
  String get currentBid => 'المزايدة الحالية';

  @override
  String get timeLeft => 'الوقت المتبقي';

  @override
  String get totalBids => 'إجمالي المزايدات';

  @override
  String get endingSoon => 'ينتهي قريباً';

  @override
  String get loginToPlaceBid => 'سجّل الدخول للمزايدة';

  @override
  String get verificationRequired => 'التوثيق مطلوب';

  @override
  String get pleaseVerifyToPlaceBids =>
      'يرجى توثيق حسابك للمشاركة في المزايدات';

  @override
  String get verifyNow => 'وثّق الآن';

  @override
  String get verifyAccountToPlaceBids => 'وثّق حسابك للمزايدة';

  @override
  String get updateBid => 'تحديث المزايدة';

  @override
  String get placeBid => 'تقديم مزايدة';

  @override
  String get noLiveAuctions => 'لا توجد مزادات مباشرة';

  @override
  String get noLiveAuctionsMessage => 'لا توجد حالياً مزادات مباشرة متاحة';

  @override
  String get noBidsYet => 'لا مزايدات بعد';

  @override
  String get loginToViewBiddedAuctions => 'سجّل الدخول لعرض مزاداتك';

  @override
  String get noBidsYetMessage => 'لم تقدم أي مزايدات على مزادات مباشرة';

  @override
  String get noClosedAuctions => 'لا مزادات منتهية';

  @override
  String get loginToViewClosedAuctions => 'سجّل الدخول لعرض المزادات المنتهية';

  @override
  String get noClosedAuctionsMessage => 'ليس لديك مزادات منتهية خسرتها';

  @override
  String get myBids => 'مزايداتي';

  @override
  String get closed => 'منتهي';

  @override
  String get viewDetails => 'عرض التفاصيل';

  @override
  String get verifyToBid => 'توثيق للمزايدة';

  @override
  String placeBidTitle(String title) {
    return 'تقديم مزايدة - $title';
  }

  @override
  String minimumBidIs(String amount) {
    return 'الحد الأدنى للمزايدة $amount درهم';
  }

  @override
  String get bidPlacedSuccess => 'تم تقديم المزايدة بنجاح!';

  @override
  String get bidFailedTryAgain => 'فشل تقديم المزايدة. يرجى المحاولة مرة أخرى.';

  @override
  String bidFailedWithError(String error) {
    return 'فشل تقديم المزايدة: $error';
  }

  @override
  String get cancel => 'إلغاء';

  @override
  String get bidAmount => 'مبلغ المزايدة';

  @override
  String get minimumBid => 'الحد الأدنى';

  @override
  String bidsCount(int count) {
    return '$count مزايدات';
  }

  @override
  String get loginToViewCreateBookings => 'سجّل الدخول لعرض وإنشاء الحجوزات';

  @override
  String get serviceBookings => 'حجوزات الخدمة';

  @override
  String bookingCount(int count) {
    return 'حجز واحد';
  }

  @override
  String bookingsCount(int count) {
    return '$count حجوزات';
  }

  @override
  String get noBookingsYet => 'لا توجد حجوزات بعد';

  @override
  String get bookFirstServiceAppointment => 'احجز موعد خدمتك الأول';

  @override
  String get bookAService => 'احجز خدمة';

  @override
  String get vehicle => 'المركبة';

  @override
  String get date => 'التاريخ';

  @override
  String get time => 'الوقت';

  @override
  String get phone => 'الهاتف';

  @override
  String get bookingNumberLabel => 'رقم الحجز';

  @override
  String get bookingNumberFull => 'رقم الحجز';

  @override
  String get cancelled => 'ملغى';

  @override
  String get back => 'رجوع';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get carName => 'اسم السيارة';

  @override
  String get carModel => 'موديل السيارة';

  @override
  String get enterFullName => 'أدخل اسمك الكامل';

  @override
  String get enterPhoneNumber => 'أدخل رقم هاتفك';

  @override
  String get carNameHint => 'مثال: BMW، مرسيدس';

  @override
  String get carModelHint => 'مثال: 3 Series، C-Class';

  @override
  String get submitBooking => 'إرسال الحجز';

  @override
  String get enterServiceDescription => 'أدخل وصف الخدمة أو ملاحظات إضافية';

  @override
  String get preferredDate => 'التاريخ المفضل';

  @override
  String get preferredTime => 'الوقت المفضل';

  @override
  String get selectPreferredDate => 'اختر التاريخ المفضل';

  @override
  String get selectPreferredTime => 'اختر الوقت المفضل';

  @override
  String get pleaseEnterName => 'يرجى إدخال اسمك';

  @override
  String get pleaseEnterPhone => 'يرجى إدخال رقم هاتفك';

  @override
  String get pleaseEnterCarModel => 'يرجى إدخال موديل السيارة';

  @override
  String get pleaseEnterCarName => 'يرجى إدخال اسم السيارة';

  @override
  String get pleaseSelectDate => 'يرجى اختيار التاريخ';

  @override
  String get pleaseSelectTime => 'يرجى اختيار الوقت';

  @override
  String get bookingSubmittedSuccess => 'تم إرسال الحجز بنجاح!';

  @override
  String failedToSubmitBooking(String error) {
    return 'فشل إرسال الحجز: $error';
  }

  @override
  String get bookingDetails => 'تفاصيل الحجز';

  @override
  String get createdAt => 'تاريخ الإنشاء';

  @override
  String get adminNotes => 'ملاحظات الإدارة';

  @override
  String get selectDate => 'اختر التاريخ';

  @override
  String get selectTime => 'اختر الوقت';

  @override
  String get unverifiedAccount => 'حساب غير موثق';

  @override
  String get accountInformation => 'معلومات الحساب';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get role => 'الدور';

  @override
  String get memberSince => 'عضو منذ';

  @override
  String get emiratesId => 'هوية الإمارات';

  @override
  String get frontSide => 'الجهة الأمامية';

  @override
  String get backSide => 'الجهة الخلفية';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get logoutConfirmMessage => 'هل أنت متأكد أنك تريد تسجيل الخروج؟';

  @override
  String get parts => 'قطع الغيار';

  @override
  String get noPartsAvailable => 'لا توجد قطع متاحة';

  @override
  String get noPartsAvailableMessage => 'هذه الشركة لا تملك قطعاً معروضة بعد';

  @override
  String get inStock => 'متوفر';

  @override
  String get outOfStock => 'غير متوفر';

  @override
  String get price => 'السعر';

  @override
  String get available => 'متاح';

  @override
  String get verifyAccountToPurchaseParts => 'وثّق حسابك لشراء القطع';

  @override
  String get purchase => 'شراء';

  @override
  String get featuredMarketplace => 'السوق المميز';

  @override
  String viewingProductsFrom(String name) {
    return 'عرض منتجات من $name';
  }

  @override
  String showingSpecializedComponents(int count) {
    return 'عرض $count مكونات متخصصة';
  }

  @override
  String get advancedFilters => 'فلاتر متقدمة';

  @override
  String get live => 'مباشر';

  @override
  String get noPartsFound => 'لم يتم العثور على قطع';

  @override
  String get noPartsFoundMessage => 'جرّب تعديل الفلاتر أو البحث';

  @override
  String get resetAll => 'إعادة تعيين الكل';

  @override
  String get condition => 'الحالة';

  @override
  String get priceRangeAed => 'نطاق السعر (درهم)';

  @override
  String get min => 'الحد الأدنى';

  @override
  String get max => 'الحد الأقصى';

  @override
  String get applyFilters => 'تطبيق الفلاتر';

  @override
  String get partsStore => 'متجر القطع';

  @override
  String get explorePremiumComponents => 'استكشف المكونات المميزة';

  @override
  String get searchPartsHint => 'ابحث عن قطع، ماركات، OEM...';

  @override
  String get verifiedBrands => 'ماركات موثقة';

  @override
  String get totalParts => 'إجمالي القطع';

  @override
  String get featured => 'مميز';

  @override
  String get shopByBrand => 'تسوق حسب الماركة';

  @override
  String get allBrands => 'جميع الماركات';

  @override
  String get partNumber => 'رقم القطعة';

  @override
  String get oemNumber => 'رقم OEM';

  @override
  String get compatible => 'متوافق';

  @override
  String get years => 'السنوات';

  @override
  String get present => 'الحالي';

  @override
  String get stock => 'المخزون';

  @override
  String get units => 'وحدات';

  @override
  String unitsCount(int count) {
    return '$count وحدة';
  }

  @override
  String get verifyAccountToPurchase => 'توثيق الحساب للشراء';

  @override
  String get purchaseNow => 'اشتري الآن';

  @override
  String purchasedSuccess(String name) {
    return 'تم شراء $name بنجاح!';
  }

  @override
  String get purchaseFailedTryAgain => 'فشل الشراء. يرجى المحاولة مرة أخرى.';

  @override
  String get notifications => 'الإشعارات';

  @override
  String unreadNotificationCount(int count) {
    return 'إشعار واحد غير مقروء';
  }

  @override
  String unreadNotificationsCount(int count) {
    return '$count إشعارات غير مقروءة';
  }

  @override
  String get allCaughtUp => 'لا شيء جديد!';

  @override
  String get markAllRead => 'تعليم الكل كمقروء';

  @override
  String get delete => 'حذف';

  @override
  String get justNow => 'الآن';

  @override
  String minutesAgo(int count) {
    return 'منذ $count د';
  }

  @override
  String hoursAgo(int count) {
    return 'منذ $count س';
  }

  @override
  String daysAgo(int count) {
    return 'منذ $count يوم';
  }

  @override
  String get noNotifications => 'لا إشعارات';

  @override
  String get emptyNotificationsMessage =>
      'لا شيء جديد!\nسنُعلمك عند حدوث شيء مهم.';

  @override
  String get loginRequired => 'تسجيل الدخول مطلوب';

  @override
  String get pleaseLoginToViewNotifications => 'سجّل الدخول لعرض إشعاراتك';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get dashboard => 'لوحة التحكم';

  @override
  String get adminOverview => 'نظرة عامة للإدارة';

  @override
  String get statisticsOverview => 'نظرة على الإحصائيات';

  @override
  String get auctionRevenue => 'إيرادات المزادات';

  @override
  String get partsRevenue => 'إيرادات القطع';

  @override
  String get pendingAuctions => 'مزادات قيد الانتظار';

  @override
  String get partsAvailable => 'قطع متاحة';

  @override
  String get bookingsToday => 'حجوزات اليوم';

  @override
  String get pendingBookings => 'حجوزات قيد الانتظار';

  @override
  String get totalAuctions => 'إجمالي المزادات';

  @override
  String get totalUsers => 'إجمالي المستخدمين';

  @override
  String get verifiedUsers => 'مستخدمون موثقون';

  @override
  String get visualAnalytics => 'التحليلات المرئية';

  @override
  String get allMetrics => 'جميع المقاييس';

  @override
  String get pendingApproval => 'قيد الموافقة';

  @override
  String get totalBookings => 'إجمالي الحجوزات';

  @override
  String get allTime => 'كل الوقت';

  @override
  String get thisWeek => 'هذا الأسبوع';

  @override
  String get thisMonth => 'هذا الشهر';

  @override
  String get thisYear => 'هذا العام';

  @override
  String get barChart => 'رسم أعمدة';

  @override
  String get pieChart => 'رسم دائري';

  @override
  String get lineChart => 'رسم خطي';

  @override
  String get statisticsComparison => 'مقارنة إحصائية';

  @override
  String get distributionOverview => 'نظرة على التوزيع';

  @override
  String get trendAnalysis => 'تحليل الاتجاه';

  @override
  String get chartAuctions => 'مزادات';

  @override
  String get chartLive => 'مباشر';

  @override
  String get chartPending => 'قيد الانتظار';

  @override
  String get chartParts => 'قطع';

  @override
  String get chartBookings => 'حجوزات';

  @override
  String get chartPendingB => 'قيد الحجز';

  @override
  String get chartUsers => 'مستخدمون';

  @override
  String get chartVerified => 'موثق';

  @override
  String get emailAddress => 'البريد الإلكتروني';

  @override
  String get emailHint => 'example@email.com';

  @override
  String get password => 'كلمة المرور';

  @override
  String get passwordHint => 'أدخل كلمة المرور';

  @override
  String get forgotPassword => 'نسيت كلمة المرور';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟ ';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get fullNameHint => 'أدخل اسمك الكامل';

  @override
  String get phoneNumberHint => 'أدخل رقم هاتفك';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get confirmPasswordHint => 'أكد كلمة المرور';

  @override
  String get tapToUpload => 'اضغط للرفع';

  @override
  String get uploadEmiratesId => 'رفع بطاقة الهوية الإماراتية';

  @override
  String get uploadEmiratesIdDescription =>
      'يرجى رفع الجهة الأمامية والخلفية من بطاقة الهوية للإمارات للتحقق.';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟ ';

  @override
  String get forgotPasswordDescription =>
      'أدخل بريدك الإلكتروني وسنرسل لك رابطاً لإعادة تعيين كلمة المرور.';

  @override
  String get sendResetLink => 'إرسال رابط إعادة التعيين';

  @override
  String get rememberPassword => 'تتذكر كلمة المرور؟ ';

  @override
  String get manageAuctions => 'إدارة المزادات';

  @override
  String get manageAndApproveAuctions => 'إدارة والموافقة على المزادات';

  @override
  String get pendingApprovalTab => 'قيد الموافقة';

  @override
  String get allAuctionsTab => 'جميع المزادات';

  @override
  String get noPendingAuctions => 'لا توجد مزادات قيد الانتظار';

  @override
  String get allAuctionsReviewed => 'تمت مراجعة جميع المزادات';

  @override
  String get noAuctions => 'لا توجد مزادات';

  @override
  String get noAuctionsCreatedYet => 'لم يتم إنشاء أي مزادات بعد';

  @override
  String get startingBid => 'السعر الابتدائي';

  @override
  String get lotNumber => 'لوت #';

  @override
  String get approve => 'موافقة';

  @override
  String get reject => 'رفض';

  @override
  String get statusPending => 'قيد الانتظار';

  @override
  String get statusApproved => 'موافق عليه';

  @override
  String get statusLive => 'مباشر';

  @override
  String get statusClosed => 'مغلق';

  @override
  String get statusRejected => 'مرفوض';

  @override
  String get error => 'خطأ';

  @override
  String get success => 'نجاح';

  @override
  String get auctionApprovedSuccessfully => 'تمت الموافقة على المزاد بنجاح';

  @override
  String get auctionRejected => 'تم رفض المزاد';

  @override
  String get failedToLoadPendingAuctions =>
      'فشل تحميل المزادات قيد الانتظار. يرجى المحاولة مرة أخرى.';

  @override
  String get failedToApproveAuction =>
      'فشل الموافقة على المزاد. يرجى المحاولة مرة أخرى.';

  @override
  String get failedToRejectAuction => 'فشل رفض المزاد. يرجى المحاولة مرة أخرى.';

  @override
  String get manageBookings => 'إدارة الحجوزات';

  @override
  String get manageAndApproveBookings => 'إدارة والموافقة على الحجوزات';

  @override
  String get noPendingBookings => 'لا توجد حجوزات قيد الانتظار';

  @override
  String get allBookingsReviewed => 'تمت مراجعة جميع الحجوزات';

  @override
  String get noBookings => 'لا توجد حجوزات';

  @override
  String get noBookingsCreatedYet => 'لم يتم إنشاء أي حجوزات بعد';

  @override
  String get pendingTab => 'قيد الانتظار';

  @override
  String get allBookingsTab => 'جميع الحجوزات';

  @override
  String get createdLabel => 'تاريخ الإنشاء';

  @override
  String get pending => 'قيد الانتظار';

  @override
  String get approved => 'موافق عليه';

  @override
  String get rejected => 'مرفوض';

  @override
  String get completed => 'مكتمل';

  @override
  String get bookingApprovedSuccessfully => 'تمت الموافقة على الحجز بنجاح';

  @override
  String get bookingRejected => 'تم رفض الحجز';

  @override
  String get rejectBookingTitle => 'رفض الحجز';

  @override
  String get rejectBookingConfirmMessage =>
      'هل أنت متأكد أنك تريد رفض هذا الحجز؟';

  @override
  String get rejectionReasonLabel => 'سبب الرفض *';

  @override
  String get rejectionReasonHint => 'مثال: الخدمة غير متاحة';

  @override
  String get additionalNotesLabel => 'ملاحظات إضافية';

  @override
  String get additionalNotesHint => 'يرجى اختيار تاريخ آخر';

  @override
  String get rejectionReasonRequired => 'سبب الرفض مطلوب';

  @override
  String get bookingIdLabel => 'رقم الحجز';

  @override
  String get userLabel => 'المستخدم';

  @override
  String get statusLabel => 'الحالة';

  @override
  String get dateLabel => 'التاريخ';

  @override
  String get timeLabel => 'الوقت';

  @override
  String get vehicleDetails => 'تفاصيل المركبة';

  @override
  String get carLabel => 'السيارة';

  @override
  String get modelLabel => 'الموديل';

  @override
  String get contactInfo => 'معلومات الاتصال';

  @override
  String get phoneLabel => 'الهاتف';

  @override
  String get descriptionNotes => 'الوصف/الملاحظات';

  @override
  String get close => 'إغلاق';

  @override
  String get details => 'التفاصيل';

  @override
  String get editFormFields => 'تعديل حقول النموذج';

  @override
  String get customizeBookingFormFields => 'تخصيص حقول نموذج الحجز';

  @override
  String get save => 'حفظ';

  @override
  String get formFieldsCustomizeInfo =>
      'خصص حقول نموذج الحجز. سيرى المستخدمون هذه الحقول عند إنشاء حجز.';

  @override
  String get addNewField => 'إضافة حقل جديد';

  @override
  String get noFieldsAddedYet => 'لم تتم إضافة حقول بعد';

  @override
  String get tapAddNewFieldHint => 'اضغط \"إضافة حقل جديد\" لإنشاء أول حقل';

  @override
  String get formFieldsUpdatedSuccess => 'تم تحديث حقول النموذج بنجاح';

  @override
  String get fieldLabel => 'تسمية الحقل';

  @override
  String get enterFieldLabel => 'أدخل تسمية الحقل';

  @override
  String get fieldType => 'نوع الحقل';

  @override
  String get placeholderOptional => 'النص البديل (اختياري)';

  @override
  String get enterPlaceholderText => 'أدخل النص البديل';

  @override
  String get optionsCommaSeparated => 'الخيارات (مفصولة بفواصل)';

  @override
  String get optionsHint => 'خيار 1، خيار 2، خيار 3';

  @override
  String get requiredField => 'حقل مطلوب';

  @override
  String get usersMustFillThisField => 'يجب على المستخدمين تعبئة هذا الحقل';

  @override
  String get newField => 'حقل جديد';

  @override
  String get fieldTypeText => 'نص';

  @override
  String get fieldTypeNumber => 'رقم';

  @override
  String get fieldTypeDate => 'تاريخ';

  @override
  String get fieldTypeTime => 'وقت';

  @override
  String get fieldTypeDropdown => 'قائمة منسدلة';

  @override
  String get fieldTypeCheckbox => 'خانة اختيار';

  @override
  String get fieldTypeTextarea => 'نص متعدد الأسطر';

  @override
  String get soldParts => 'قطع مباعة';

  @override
  String get saleRecorded => 'بيع مسجل';

  @override
  String get salesRecorded => 'مبيعات مسجلة';

  @override
  String get quantity => 'الكمية';

  @override
  String get unit => 'وحدة';

  @override
  String get total => 'الإجمالي';

  @override
  String get soldOn => 'تاريخ البيع';

  @override
  String get buyer => 'المشتري';

  @override
  String get noSalesRecorded => 'لا توجد مبيعات مسجلة';

  @override
  String get noPartsSoldYet => 'لم يتم بيع أي قطع بعد';

  @override
  String get addPart => 'إضافة قطعة';

  @override
  String timeMinAgo(int count) {
    return 'منذ $count دقيقة';
  }

  @override
  String get timeHourAgo => 'منذ ساعة';

  @override
  String timeHoursAgo(int count) {
    return 'منذ $count ساعات';
  }

  @override
  String get yesterday => 'أمس';

  @override
  String timeDaysAgo(int count) {
    return 'منذ $count أيام';
  }

  @override
  String get editPart => 'تعديل القطعة';

  @override
  String get company => 'الشركة';

  @override
  String get partName => 'اسم القطعة';

  @override
  String get category => 'الفئة';

  @override
  String get priceAed => 'السعر (درهم)';

  @override
  String get stockQuantity => 'كمية المخزون';

  @override
  String get pleaseFillRequiredFields => 'يرجى تعبئة جميع الحقول المطلوبة';

  @override
  String get partUpdatedSuccessfully => 'تم تحديث القطعة بنجاح';

  @override
  String get partAddedSuccessfully => 'تمت إضافة القطعة بنجاح';

  @override
  String get deletePartTitle => 'حذف القطعة';

  @override
  String get deletePartConfirmMessage =>
      'هل أنت متأكد أنك تريد حذف هذه القطعة؟';

  @override
  String get partDeletedSuccessfully => 'تم حذف القطعة بنجاح';

  @override
  String get add => 'إضافة';

  @override
  String get wallet => 'المحفظة';

  @override
  String get balance => 'الرصيد';

  @override
  String get recentTransactions => 'المعاملات الأخيرة';

  @override
  String get verificationDescription =>
      'للمشاركة في المزادات وشراء القطع، يرجى إيداع 4,500 درهم للتحقق من حسابك.';

  @override
  String get depositAmountLabel => 'مبلغ الإيداع';

  @override
  String amountCurrency(String currency) {
    return 'المبلغ ($currency)';
  }

  @override
  String get enterDepositAmount => 'أدخل مبلغ الإيداع';

  @override
  String get depositWithStripe => 'إيداع عبر Stripe';

  @override
  String get quickDeposit => 'إيداع سريع';

  @override
  String get deposit => 'إيداع';

  @override
  String get withdrawal => 'سحب';

  @override
  String dateAtTime(String date, String time) {
    return '$date في $time';
  }

  @override
  String get pleaseEnterValidAmount => 'يرجى إدخال مبلغ صحيح';

  @override
  String depositSuccess(Object amount) {
    return 'تم إيداع $amount درهم بنجاح!';
  }

  @override
  String get accountVerifiedMessage =>
      'تم التحقق من الحساب! يمكنك الآن المزايدة وشراء القطع.';

  @override
  String get depositFailed => 'فشل الإيداع';

  @override
  String get depositFailedTryAgain => 'فشل الإيداع. يرجى المحاولة مرة أخرى.';
}

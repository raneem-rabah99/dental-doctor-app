import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctor/features/home/presentation/managers/language_cubit.dart';

class AppStrings {
  final Locale locale;

  AppStrings(this.locale);

  static AppStrings of(BuildContext context) {
    final lang = context.watch<LanguageCubit>().state;
    return AppStrings(Locale(lang));
  }

  bool get isArabic => locale.languageCode == 'ar';

  // ---------------- SETTINGS ----------------
  String get openTimeText => isArabic ? 'وقت الفتح' : 'Open Time';

  String get closeTimeText => isArabic ? 'وقت الإغلاق' : 'Close Time';

  String get settings => isArabic ? 'الإعدادات' : 'Settings';
  String get home => isArabic ? 'الرئيسية' : 'Home';
  String get darkMode => isArabic ? 'الوضع الداكن' : 'Dark Mode';
  String get language =>
      isArabic ? 'اللغة (عربي / إنجليزي)' : 'Language (AR / EN)';
  String get rateFeedback =>
      isArabic ? 'التقييم والملاحظات' : 'Rate & Feedback';
  String get logout => isArabic ? 'تسجيل الخروج' : 'Log Out';

  // ---------------- DIALOGS ----------------
  String get confirmLogout =>
      isArabic
          ? 'هل أنت متأكد من تسجيل الخروج؟'
          : 'Are you sure you want to logout?';

  String get cancel => isArabic ? 'إلغاء' : 'Cancel';
  String get send => isArabic ? 'إرسال' : 'Send';

  // ---------------- RATE ----------------
  String get tapToRate =>
      isArabic ? 'اضغط على النجوم للتقييم' : 'Tap the stars to rate';
  String get writeFeedback =>
      isArabic ? 'اكتب ملاحظاتك هنا...' : 'Write your feedback here...';

  // ---------------- GENERAL ----------------
  String get loading => isArabic ? 'جاري التحميل...' : 'Loading...';
  // ---------------- HOME / BEFORE AFTER ----------------
  String get Appointments => isArabic ? 'الحجوزات' : 'Appointments';

  String get seeAll => isArabic ? 'عرض الكل' : 'See All';

  // ---------------- AI PAGE ----------------
  String get aiTitle =>
      isArabic ? 'العلاج السني بالذكاء الاصطناعي' : 'Dental Treatment with AI';

  String get aiScanTitle =>
      isArabic ? 'فحص العلاج بالذكاء الاصطناعي' : 'AI Treatment Scan';

  String get aiScanDesc =>
      isArabic
          ? 'حلل أسنانك باستخدام الذكاء الاصطناعي\nلاكتشاف المشاكل المحتملة.'
          : 'Analyze your teeth with AI\nto detect possible issues.';

  String get submit => isArabic ? 'تشخيص الأسنان' : 'Dental diagnosis';
  String get result => isArabic ? 'عرض جميع النتائج' : 'show all result';
  // ================= AI PAGE (Doctor) =================

  String get detectTeeth => isArabic ? 'اكتشاف الأسنان' : 'Detect Teeth';

  String get orthodonticDiagnosis =>
      isArabic ? 'تشخيص تقويم الأسنان' : 'Orthodontic Diagnosis';

  String get uploadImageFirst =>
      isArabic ? 'يرجى رفع صورة أولاً' : 'Please upload an image first';

  String get aiScanFailed =>
      isArabic ? 'فشل فحص الذكاء الاصطناعي' : 'AI scan failed';

  // ---------------- EDIT PROFILE ----------------
  String get editProfile => isArabic ? 'تعديل الملف الشخصي' : 'Edit Profile';

  String get displayName => isArabic ? 'اسم العرض' : 'Display Name';

  String get userName => isArabic ? 'اسم المستخدم' : 'User Name';

  String get email => isArabic ? 'البريد الإلكتروني' : 'Email';

  String get emailOptional =>
      isArabic ? 'البريد الإلكتروني (اختياري)' : 'Email (Optional)';

  String get phoneNumber => isArabic ? 'رقم الهاتف' : 'Phone Number';

  String get saveEdit => isArabic ? 'حفظ التعديلات' : 'Save Edit';

  String get selectYourPhoto => isArabic ? 'اختر صورتك' : 'Select your photo';

  String get uploadingPhoto =>
      isArabic ? 'جاري رفع الصورة...' : 'Uploading photo...';

  String get deletingPhoto =>
      isArabic ? 'جاري حذف الصورة...' : 'Deleting photo...';

  String get selectImageFirst =>
      isArabic ? 'يرجى اختيار صورة أولاً!' : 'Select image first!';

  String get profileUpdated =>
      isArabic
          ? 'تم تحديث الملف الشخصي بنجاح!'
          : 'Profile updated successfully!';

  // ================= Patient Details =================

  String get panoramaTitle => isArabic ? 'صورة بانوراما' : 'Panorama';

  String get teethTitle => isArabic ? 'الأسنان' : 'Teeth';

  String get phoneLabel => isArabic ? 'الهاتف' : 'Phone';

  String get emailLabel => isArabic ? 'البريد الإلكتروني' : 'Email';

  String get toothLabel => isArabic ? 'سن' : 'Tooth';
  // ================= Today Approved =================

  String get noAppointmentsToday =>
      isArabic ? 'لا توجد مواعيد اليوم' : 'No appointments today';

  String get appointments => isArabic ? 'المواعيد' : 'Appointments';

  // ================= Today Approved Item =================

  String statusApproved() => isArabic ? 'مؤكد' : 'APPROVED';

  String statusPending() => isArabic ? 'قيد الانتظار' : 'PENDING';

  String statusRejected() => isArabic ? 'مرفوض' : 'REJECTED';
  // ================= Dental Chart =================

  String get orthodonticDiagnosisTitle =>
      isArabic ? 'تشخيص تقويم الأسنان' : 'Orthodontic Diagnosis';

  String get upperLabel => isArabic ? 'الفك العلوي' : 'Upper';

  String get lowerLabel => isArabic ? 'الفك السفلي' : 'Lower';

  String get finalLabel => isArabic ? 'النتيجة النهائية' : 'Final';

  String get toothText => isArabic ? 'سن' : 'Tooth';

  // ---------------- EDIT PAGE ----------------
  String get uploadNewCv => isArabic ? 'رفع سيرة ذاتية جديدة' : 'Upload New CV';

  String get uploadCv =>
      isArabic ? 'رفع السيرة الذاتية (PDF)' : 'Upload CV (PDF)';

  String get changeCv => isArabic ? 'تغيير السيرة الذاتية' : 'Change CV';

  String get writeExperience =>
      isArabic ? 'اكتب خبرتك' : 'Write your experience';

  String get experienceHint =>
      isArabic ? 'خبرة 10 سنوات...' : '10 years experience...';

  String get uploadNewStatus =>
      isArabic ? 'رفع حالة جديدة (قبل / بعد)' : 'Upload new status b/a';

  String get photoBefore => isArabic ? 'صورة قبل' : 'Photo Before';

  String get photoAfter => isArabic ? 'صورة بعد' : 'Photo After';

  String get uploading => isArabic ? 'جاري الرفع...' : 'Uploading...';

  String get hideAllStatus =>
      isArabic ? 'إخفاء جميع الحالات' : 'Hide all status';

  String get showAllStatus =>
      isArabic ? 'عرض جميع الحالات' : 'Show all status b/f';

  String get noStatusFound => isArabic ? 'لا توجد حالات' : 'No status found';

  String get deleteStatus => isArabic ? 'حذف' : 'Delete';

  String get edit => isArabic ? 'تعديل' : 'Edit';

  String get removeFavorite =>
      isArabic ? 'إزالة من المفضلة' : 'Remove favorite';

  String get setAsFavorite => isArabic ? 'تعيين كمفضلة' : 'Set as favorite';

  String get confirmDeleteStatus =>
      isArabic
          ? 'هل أنت متأكد من حذف هذه الحالة؟'
          : 'Are you sure you want to delete this status?';

  // ---------------- BOOKING ----------------
  String get booking => isArabic ? 'الحجوزات' : 'Booking';

  String get findpatient => isArabic ? 'ابحث عن المريض' : 'Find the patient';

  String get browseDoctors =>
      isArabic
          ? 'تصفح المرضى وأدر مواعيدك.'
          : 'Browse patients and manage appointments';

  String get show => isArabic ? 'عرض' : 'Show';

  String get onProgress => isArabic ? 'قيد التنفيذ' : 'OnProgress';

  String get waiting => isArabic ? 'قيد الانتظار' : 'Waiting';

  String get done => isArabic ? 'مكتمل' : 'Done';

  String get canceled => isArabic ? 'ملغي' : 'Canceled';

  // ---------------- SHOW RESULT ----------------
  String get showResultTitle =>
      isArabic
          ? 'هنا ستظهر نتيجة علاج الأسنان الخاص بك'
          : 'Here will show the result of your tooth treatment';

  String get showResultDesc =>
      isArabic
          ? 'يقوم الذكاء الاصطناعي بتحليل الصورة بعناية، ويحدد أي أسنان قد تعاني من مشاكل، ويبرز المناطق التي تحتاج إلى اهتمام.\n\n'
              'يساعدك ذلك على فهم حالتك السنية بوضوح قبل زيارة طبيب الأسنان — سريع، دقيق، وسهل الاستخدام.'
          : 'The AI carefully analyzes your image, identifies any teeth that may have issues, and highlights areas that need attention.\n\n'
              'This helps you understand your dental condition clearly before visiting your dentist — quick, accurate, and easy to use.';

  String get showResultHint =>
      isArabic
          ? 'لبدء تحليل الأسنان بالذكاء الاصطناعي، انتقل إلى الخطوة التالية ودع النظام يفحص أسنانك باستخدام الكشف الذكي.'
          : 'To begin your AI dental analysis, continue to the next step and let the system examine your teeth with smart detection.';

  String get startAiTreatment =>
      isArabic ? 'ابدأ علاج الذكاء الاصطناعي' : 'Start AI Treatment';

  // ---------------- DOCTORS LIST ----------------
  String get patient => isArabic ? 'المرضى' : 'patients';

  String get patientHint =>
      isArabic
          ? 'اختر المريض المناسب لاحتياجاتك.\nابحث حسب المريض أو التخصص أو الموقع.'
          : 'Click the right patient for your needs.\nSearch by patient';

  String get search => isArabic ? 'بحث...' : 'Search...';

  String get noDoctorsFound => isArabic ? 'لا يوجد مرضى' : 'No patients found';
  // ---------------- DOCTOR DETAILS ----------------
  String get before => isArabic ? 'قبل' : 'Before';

  String get after => isArabic ? 'بعد' : 'After';

  String get selectTime => isArabic ? 'اختر الوقت' : 'Select Time';

  String get selectDate => isArabic ? 'اختر التاريخ' : 'Select Date';

  String get takeDate => isArabic ? 'حجز موعد' : 'Take a Date';

  String get specialization => isArabic ? 'التخصص' : 'Specialization';

  String get distance => isArabic ? 'المسافة' : 'Distance';

  String get availableTime => isArabic ? 'الوقت المتاح' : 'Available Time';
}

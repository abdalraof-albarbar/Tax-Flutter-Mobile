import '../domain/essential_content.dart';
import '../core/app_assets.dart';

abstract final class EssentialSamples {
  static const guide = <GuideStep>[
    GuideStep(
      BilingualText('يومك الميداني، أوضح', 'A clearer field day'),
      BilingualText(
        'راجع جدول الزيارات وحدد مهمتك التالية من مكان واحد.',
        'Review your schedule and find your next visit in one place.',
      ),
      AppAssets.fieldWelcome,
    ),
    GuideStep(
      BilingualText('وثّق كل خطوة', 'Document every step'),
      BilingualText(
        'راجع البنود وأضف ملاحظاتك وصورك، ثم احفظ مسودة الزيارة.',
        'Review checks, add notes and photos, then save a visit draft.',
      ),
      AppAssets.accessFolio,
    ),
    GuideStep(
      BilingualText('راجع قبل الإرسال', 'Review before submitting'),
      BilingualText(
        'عاين المحضر ومرفقاته. الإرسال هنا تجربة محلية دون جهة رسمية.',
        'Preview your report and attachments. Submission here is a local demo.',
      ),
      AppAssets.accessFolio,
    ),
  ];
  static const help = <HelpArticle>[
    HelpArticle(
      'accounts',
      BilingualText(
        'هل يمكن إنشاء حساب حقيقي؟',
        'Can I create a real account?',
      ),
      BilingualText(
        'هذه معاينة للواجهات فقط. لا تُنشأ حسابات ولا تُحفظ كلمات مرور، ولا يتم إرسال بريد. يمكنك فتح التجربة دون إدخال بيانات.',
        'These are preview screens. No accounts are created, passwords stored or emails sent. You can explore without entering details.',
      ),
    ),
    HelpArticle(
      'drafts',
      BilingualText('كيف أحفظ مسودة الزيارة؟', 'How do I save a visit draft?'),
      BilingualText(
        'استخدم حفظ مسودة أو ارجع من خطوات الزيارة. عند فشل الحفظ تبقى الصفحة مفتوحة لتتمكن من المحاولة مجددًا.',
        'Use Save draft or go back from visit steps. If saving fails, the page stays open so you can retry.',
      ),
    ),
    HelpArticle(
      'photos',
      BilingualText(
        'كيف أضيف صورة أو مستندًا؟',
        'How do I add a photo or document?',
      ),
      BilingualText(
        'افتح خطوة المرفقات واختر صورة أو ملف PDF. الحد ستة مرفقات، وحجم كل ملف حتى 2 MB.',
        'Open Attachments and choose a photo or PDF. The limit is six attachments, up to 2 MB each.',
      ),
    ),
    HelpArticle(
      'preferences',
      BilingualText(
        'أين أغيّر اللغة وحجم الخط؟',
        'Where can I change language and text size?',
      ),
      BilingualText(
        'اضغط الصورة الدائرية أعلى الرئيسية. من الملف الشخصي يمكنك تغيير اللغة وحجم النص وتقليل الحركة.',
        'Tap the circular avatar above Home. Your profile has language, text size and reduced-motion settings.',
      ),
    ),
    HelpArticle(
      'submission',
      BilingualText(
        'هل تُرسل المحاضر إلى جهة رسمية؟',
        'Are reports sent to an authority?',
      ),
      BilingualText(
        'لا. كل المحاضر وحالات المراجعة بيانات تجريبية محلية، والخريطة رسم توضيحي وليست تتبع GPS.',
        'No. Reports and review states are local demo data. The map is illustrative, not GPS tracking.',
      ),
    ),
    HelpArticle(
      'exit',
      BilingualText(
        'هل تنحذف مسوداتي عند الخروج؟',
        'Does leaving remove my drafts?',
      ),
      BilingualText(
        'إنهاء التجربة يعيدك إلى الترحيب ويبقي المسودات والصورة والتفضيلات على الجهاز. التخزين غير مشفر؛ استخدم بيانات نموذجية فقط.',
        'Ending the demo returns to Welcome and keeps drafts, photo and preferences on this device. Storage is unencrypted; use sample data only.',
      ),
    ),
  ];
  static final privacy = List<HelpArticle>.unmodifiable(
    help.where(
      (article) =>
          const ['accounts', 'exit', 'submission'].contains(article.id),
    ),
  );
  static const notifications = <DemoNotification>[
    DemoNotification(
      'schedule',
      BilingualText('جدول زياراتك جاهز', 'Your visit schedule is ready'),
      BilingualText(
        'راجع مواعيد العينة في تبويب زياراتي. هذا تذكير تجريبي.',
        'Review sample appointments in My visits. This is a demo reminder.',
      ),
    ),
    DemoNotification(
      'draft',
      BilingualText(
        'احفظ تقدمك أثناء الزيارة',
        'Save your progress during a visit',
      ),
      BilingualText(
        'يمكنك حفظ مسودة والعودة إليها من محاضري. لا توجد مزامنة خادم.',
        'Save a draft and return from My reports. There is no server sync.',
      ),
    ),
    DemoNotification(
      'reading',
      BilingualText('قراءة أريح في الميدان', 'More comfortable field reading'),
      BilingualText(
        'اختر حجم النص المناسب وفعل تقليل الحركة من ملفك الشخصي.',
        'Choose your text size and reduced-motion preference in your profile.',
      ),
    ),
  ];
}

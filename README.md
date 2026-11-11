# تفتيش — تطبيق المفتش الميداني

واجهة Flutter عربية RTL للمفتشين فقط، مبنية على تصاميم الهاتف V2.
المشروع **نسخة تجريبية تفاعلية**، وليس منظومة تشغيل معتمدة لمصلحة الضرائب.

## ما تم تنفيذه في المصدر

- الرئيسية: زيارات اليوم، نسبة الإنجاز والزيارة التالية.
- قائمة الزيارات: بحث بالاسم/الرقم الضريبي، تصفية المنطقة والأولوية والتاريخ.
- تفاصيل الزيارة وبدء المهمة ومتابعتها.
- قائمة تحقق قابلة للتغيير من بيانات مرجعية منفصلة.
- اختيار الصور من الكاميرا/المعرض وإرفاق مستندات عبر خدمات منفصلة.
- حفظ مسودة للجلسة، مراجعة المحضر، وإرسال **تجريبي محلي** للمراجعة.
- قائمة المحاضر، حالات منفصلة، مرفقات ورمز QR فعلي لمعرّف تجريبي.
- حالات فارغة، رسائل أخطاء، تحقق من المدخلات وحماية التعديلات عند الرجوع.

## حدود النسخة الحالية

البيانات والمرفقات في الذاكرة وتُفقد عند إغلاق التطبيق أو تحديث صفحة الويب.
لا توجد مصادقة، قاعدة بيانات دائمة، API، إرسال رسمي، اعتماد من مشرف أو قياس GPS.
الخريطة المضمّنة رسم توضيحي؛ فتح الموقع يستخدم إحداثيات النشاط التجريبي في المتصفح.
النماذج والمخالفات أمثلة غير رسمية. لا تستخدم هذه النسخة لحفظ بيانات حقيقية.

**التحقق المحلي من Flutter لم يُنفَّذ.** راجع [حالة التحقق](docs/VERIFICATION.md)
و[نتائج GitHub Actions](https://github.com/abdalraof-albarbar/Tax-Flutter-Mobile/actions)
لحالة الفحص والبناء؛ وجود المصدر لا يعني نجاح الاختبارات أو جاهزية التطبيق للإنتاج.

المستودع المستهدف: [Tax-Flutter-Mobile](https://github.com/abdalraof-albarbar/Tax-Flutter-Mobile).
وافق صاحب المشروع صراحةً على نشر المصدر في مستودع عام بتاريخ 2026-11-12.

## التشغيل في بيئة Flutter موثوقة

تم تحديد Flutter **3.50.0 stable** لـCI. الحد الأدنى للحزم: Flutter 3.41 / Dart 3.11.
استخدم Android SDK 24+، أو Chrome لمعاينة الواجهة. Android هو هدف الهاتف الأول.

```bash
git clone https://github.com/abdalraof-albarbar/Tax-Flutter-Mobile.git
cd Tax-Flutter-Mobile
bash tool/bootstrap_platforms.sh
flutter pub get
flutter run
```

ملفات المضيف Android/Web تُنشأ بواسطة Flutter القياسي عند الخطوة الأولى؛ لا تستخدم
`--overwrite`، ولا تستبدل ملفات `lib/`. على Windows شغّل الأمر التالي بدل Bash:

```powershell
flutter create --empty --platforms=android,web --project-name tax_inspector_mobile --org com.libyancode --no-pub .
flutter pub get
flutter run
```

لمعاينة المتصفح استخدم `flutter run -d chrome`.
لـiOS، أنشئ المضيف على macOS بـ`bash tool/bootstrap_platforms.sh ios` ثم أضف
وصف إذن الكاميرا والصور كما هو موضح في [الحزم](docs/PACKAGES.md).
بناء iOS وتوقيعه غير منفذين هنا.

## الفحص والبناء

```bash
bash tool/check_project.sh
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test --coverage
flutter build apk --debug
```

بعد أول `pub get` ناجح، أضف `pubspec.lock` إلى Git لضبط النسخ الانتقالية.
يوجد workflow في `.github/workflows/flutter.yml`؛ راجع آخر تشغيل لنفس commit
ولا تعتبر إعداد الملف دليلًا على نجاحه.
لا تنشر التطبيق قبل نجاح الفحوص ومراجعة الواجهات على هاتف حقيقي.

## قواعد المشروع

- SOLID مع interfaces وحقن اعتمادات وControllers صغيرة.
- كل ملف مكتوب يدويًا بحد أقصى **300 سطر**، مع فحص آلي.
- البيانات التجريبية قوائم typed داخل `lib/data/sample/`، وليست في Widgets.
- أي حزمة مباشرة يجب أن تكون مسجلة في [PACKAGES.md](docs/PACKAGES.md).
- أسماء إنجليزية واضحة للكود، وعربية واضحة للمستخدم، بدون إخفاء الأخطاء.
- ملفات المنصات وملفات lock المولّدة آليًا تبقى بتنسيق أدواتها الأصلي.

## أين تبدأ القراءة؟

| الغرض | المكان |
|---|---|
| نقطة تشغيل التطبيق | `lib/main.dart` |
| اختيار وربط الاعتمادات | `lib/app/app_dependencies.dart` |
| النماذج والعقود والتحقق | `lib/domain/` |
| البيانات التجريبية والتخزين والخدمات | `lib/data/` |
| منطق حالة الشاشات | `lib/application/controllers/` |
| الشاشات والمكونات المشتركة | `lib/presentation/` |
| اختبارات المجال والحالة والواجهات | `test/` |

التفاصيل: [المعمارية وSOLID](docs/ARCHITECTURE.md) ·
[البيانات التجريبية](docs/DEMO_DATA.md) · [قواعد التطوير](docs/DEVELOPMENT.md) ·
[الأصول وترخيص الخط](docs/ASSETS.md) · [فحص التصميم](design-qa.md).

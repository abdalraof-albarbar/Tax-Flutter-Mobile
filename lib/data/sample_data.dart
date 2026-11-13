import '../domain/contracts.dart';
import '../domain/visit.dart';

abstract final class SampleData {
  static final date = DateTime(2026, 11, 11);
  static const inspector = ['أحمد الزروق', 'Ahmed Al-Zarrouq'];
  static final visits = <Visit>[
    Visit(
      id: 'v1',
      name: 'مخبز النخيل',
      englishName: 'Al Nakheel Bakery',
      area: 'تاجوراء',
      englishArea: 'Tajoura',
      taxNumber: '10024581',
      time: '09:00',
      date: date,
      category: 'مخبز',
      englishCategory: 'Bakery',
      latitude: 32.881,
      longitude: 13.351,
      status: VisitStatus.completed,
    ),
    Visit(
      id: 'v2',
      name: 'شركة الندى للخدمات',
      englishName: 'Al Nada Services',
      area: 'سوق الجمعة',
      englishArea: 'Souq Al Jumaa',
      taxNumber: '10024587',
      time: '10:30',
      date: date,
      category: 'شركة',
      englishCategory: 'Company',
      latitude: 32.887,
      longitude: 13.235,
      highPriority: true,
    ),
    Visit(
      id: 'v3',
      name: 'مكتبة الزيتون',
      englishName: 'Al Zaytoun Bookshop',
      area: 'طرابلس',
      englishArea: 'Tripoli',
      taxNumber: '10024590',
      time: '13:00',
      date: date,
      category: 'مكتبة',
      englishCategory: 'Bookshop',
      latitude: 32.875,
      longitude: 13.187,
    ),
    Visit(
      id: 'v4',
      name: 'ورشة الأمان',
      englishName: 'Al Aman Workshop',
      area: 'عين زارة',
      englishArea: 'Ain Zara',
      taxNumber: '10024596',
      time: '15:30',
      date: date,
      category: 'ورشة',
      englishCategory: 'Workshop',
      latitude: 32.816,
      longitude: 13.264,
    ),
    Visit(
      id: 'v5',
      name: 'مخبز النخيل',
      englishName: 'Al Nakheel Bakery',
      area: 'تاجوراء',
      englishArea: 'Tajoura',
      taxNumber: '10024581',
      time: '09:30',
      date: date.add(const Duration(days: 1)),
      category: 'مخبز',
      englishCategory: 'Bakery',
      latitude: 32.881,
      longitude: 13.351,
    ),
  ];
  static const checklist = <ChecklistItem>[
    ChecklistItem(
      'business',
      'التحقق من بيانات النشاط',
      'Verify business details',
    ),
    ChecklistItem(
      'documents',
      'مراجعة المستندات المتاحة',
      'Review available documents',
    ),
    ChecklistItem(
      'notes',
      'تسجيل ملاحظات الزيارة',
      'Record inspection observations',
    ),
  ];
  static const violations = <NamedOption>[
    NamedOption(
      'registration',
      'بيانات تسجيل تحتاج تحديثًا',
      'Registration needs updating',
    ),
    NamedOption('documents', 'مستندات غير مكتملة', 'Incomplete documentation'),
    NamedOption('other', 'ملاحظة أخرى', 'Other observation'),
  ];
  static const priorities = <NamedOption>[
    NamedOption('all', 'الكل', 'All'),
    NamedOption('high', 'مرتفعة', 'High'),
    NamedOption('normal', 'عادية', 'Normal'),
  ];
  static const weekdays = <NamedOption>[
    NamedOption('1', 'الإثنين', 'Mon'),
    NamedOption('2', 'الثلاثاء', 'Tue'),
    NamedOption('3', 'الأربعاء', 'Wed'),
    NamedOption('4', 'الخميس', 'Thu'),
    NamedOption('5', 'الجمعة', 'Fri'),
    NamedOption('6', 'السبت', 'Sat'),
    NamedOption('7', 'الأحد', 'Sun'),
  ];
}

class DemoVisitRepository implements VisitRepository {
  @override
  List<Visit> get visits => List.unmodifiable(SampleData.visits);
}

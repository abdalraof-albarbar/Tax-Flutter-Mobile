import 'package:flutter/widgets.dart';
import 'localization.dart';

/// UI grammar only. Counts always come from the existing lists or local state.
abstract final class RecordCount {
  static String _arabic(
    int count,
    String one,
    String two,
    String few,
    String other,
  ) {
    if (count == 1) return one;
    if (count == 2) return two;
    return '$count ${count % 100 >= 3 && count % 100 <= 10 ? few : other}';
  }

  static String visits(BuildContext context, int count) => context.tr(
    _arabic(count, 'زيارة واحدة', 'زيارتان', 'زيارات', 'زيارة'),
    '$count ${count == 1 ? 'visit' : 'visits'}',
  );
  static String reports(BuildContext context, int count) => context.tr(
    _arabic(count, 'محضر واحد', 'محضران', 'محاضر', 'محضر'),
    '$count ${count == 1 ? 'report' : 'reports'}',
  );
  static String businesses(BuildContext context, int count) => context.tr(
    _arabic(count, 'نشاط واحد', 'نشاطان', 'أنشطة', 'نشاط'),
    '$count ${count == 1 ? 'business' : 'businesses'}',
  );
  static String attachments(BuildContext context, int count) => context.tr(
    _arabic(count, 'مرفق واحد', 'مرفقان', 'مرفقات', 'مرفق'),
    '$count ${count == 1 ? 'attachment' : 'attachments'}',
  );
}

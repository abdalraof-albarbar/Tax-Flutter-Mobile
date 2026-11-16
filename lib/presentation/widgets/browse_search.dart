import 'package:flutter/material.dart';
import '../../core/localization.dart';
import '../../core/browse_style.dart';

class BrowseSearch extends StatefulWidget {
  const BrowseSearch({
    super.key,
    required this.id,
    required this.value,
    required this.label,
    required this.hint,
    required this.onChanged,
  });
  final String id, value, label, hint;
  final ValueChanged<String> onChanged;
  @override
  State<BrowseSearch> createState() => _BrowseSearchState();
}

class _BrowseSearchState extends State<BrowseSearch> {
  late final text = TextEditingController(text: widget.value);
  @override
  void didUpdateWidget(BrowseSearch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (text.text != widget.value) {
      text.value = TextEditingValue(
        text: widget.value,
        selection: TextSelection.collapsed(offset: widget.value.length),
      );
    }
  }

  @override
  void dispose() {
    text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TextField(
    key: ValueKey(widget.id),
    controller: text,
    onChanged: widget.onChanged,
    textInputAction: TextInputAction.search,
    onSubmitted: (_) => FocusScope.of(context).unfocus(),
    decoration: InputDecoration(
      floatingLabelBehavior:
          MediaQuery.sizeOf(context).width < BrowseTokens.stackedWidth ||
              MediaQuery.textScalerOf(context).scale(1) > BrowseTokens.largeText
          ? FloatingLabelBehavior.always
          : FloatingLabelBehavior.auto,
      labelText: widget.label,
      hintText: widget.hint,
      prefixIcon: const Icon(Icons.search_rounded),
      suffixIcon: widget.value.isEmpty
          ? null
          : IconButton(
              key: ValueKey('${widget.id}-clear'),
              tooltip: context.tr('مسح البحث', 'Clear search'),
              onPressed: () => widget.onChanged(''),
              icon: const Icon(Icons.close_rounded),
            ),
    ),
  );
}

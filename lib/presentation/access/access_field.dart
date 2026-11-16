import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../core/localization.dart';
import '../../core/theme.dart';

class AccessField extends StatefulWidget {
  const AccessField({
    super.key,
    required this.fieldKey,
    required this.label,
    required this.controller,
    required this.validator,
    this.password = false,
    this.email = false,
    this.enabled = true,
    this.onSubmitted,
    this.hint,
  });
  final String fieldKey, label;
  final String? hint;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final bool password, email, enabled;
  final VoidCallback? onSubmitted;
  @override
  State<AccessField> createState() => _AccessFieldState();
}

class _AccessFieldState extends State<AccessField> {
  bool visible = false;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: Space.lg),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(widget.label, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: Space.sm),
        Semantics(
          label: widget.label,
          child: TextFormField(
            key: ValueKey(widget.fieldKey),
            controller: widget.controller,
            enabled: widget.enabled,
            validator: widget.validator,
            obscureText: widget.password && !visible,
            autocorrect: !widget.password && !widget.email,
            enableSuggestions: !widget.password && !widget.email,
            textDirection: widget.email ? TextDirection.ltr : null,
            // Flutter 3.35 web semantics cannot select text in input[type=email].
            // https://github.com/flutter/flutter/issues/173239
            keyboardType: widget.email && !kIsWeb
                ? TextInputType.emailAddress
                : TextInputType.text,
            textInputAction: widget.onSubmitted == null
                ? TextInputAction.next
                : TextInputAction.done,
            onFieldSubmitted: (_) => widget.onSubmitted?.call(),
            decoration: InputDecoration(
              hintText: widget.hint,
              errorMaxLines: 4,
              suffixIcon: !widget.password
                  ? null
                  : IconButton(
                      key: ValueKey('${widget.fieldKey}-visibility'),
                      tooltip: visible
                          ? context.tr('إخفاء كلمة المرور', 'Hide password')
                          : context.tr('إظهار كلمة المرور', 'Show password'),
                      onPressed: () => setState(() => visible = !visible),
                      icon: Icon(
                        visible
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                    ),
            ),
          ),
        ),
      ],
    ),
  );
}

import 'package:flutter/material.dart';
import '../../core/localization.dart';
import '../../core/theme.dart';

class DemoMap extends StatelessWidget {
  const DemoMap({super.key, this.route = false});
  final bool route;
  @override
  Widget build(BuildContext context) => Semantics(
    label: context.tr(
      'خريطة توضيحية غير تفاعلية',
      'Noninteractive illustrative map',
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(Space.controlRadius),
      child: SizedBox(
        height: Space.mapHeight,
        width: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(child: CustomPaint(painter: _MapPainter(route))),
            Center(
              child: Icon(
                Icons.location_on,
                color: Palette.teal,
                size: Space.touch,
              ),
            ),
            PositionedDirectional(
              start: Space.md,
              bottom: Space.sm,
              child: Container(
                color: Palette.white,
                padding: const EdgeInsets.symmetric(horizontal: Space.sm),
                child: Text(
                  context.tr('طرابلس • رسم توضيحي', 'Tripoli • Illustration'),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _MapPainter extends CustomPainter {
  _MapPainter(this.route);
  final bool route;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(const Color(0xFFEFEEE7), BlendMode.src);
    final sea = Path()
      ..lineTo(size.width * .38, 0)
      ..quadraticBezierTo(
        size.width * .28,
        size.height * .35,
        0,
        size.height * .6,
      )
      ..close();
    canvas.drawPath(sea, Paint()..color = const Color(0xFFAAD8E9));
    final street = Paint()
      ..color = Palette.white
      ..strokeWidth = Space.xs;
    for (var i = -4; i < 18; i++) {
      canvas.drawLine(
        Offset(i * size.width / 12, 0),
        Offset(i * size.width / 12 + size.width / 3, size.height),
        street,
      );
    }
    for (var i = 0; i < 9; i++) {
      canvas.drawLine(
        Offset(0, i * size.height / 7),
        Offset(size.width, i * size.height / 7 - size.height / 3),
        street,
      );
    }
    final road = Paint()
      ..color = const Color(0xFFFFE4A0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = Space.xs;
    canvas.drawPath(
      Path()
        ..moveTo(0, size.height * .85)
        ..quadraticBezierTo(
          size.width * .6,
          -size.height * .2,
          size.width,
          size.height * .6,
        ),
      road,
    );
    if (route) {
      canvas.drawPath(
        Path()
          ..moveTo(size.width * .2, size.height * .8)
          ..cubicTo(
            size.width * .4,
            0,
            size.width * .6,
            size.height,
            size.width * .8,
            size.height * .3,
          ),
        Paint()
          ..color = Palette.teal
          ..style = PaintingStyle.stroke
          ..strokeWidth = Space.xs,
      );
    }
  }

  @override
  bool shouldRepaint(_MapPainter oldDelegate) => oldDelegate.route != route;
}

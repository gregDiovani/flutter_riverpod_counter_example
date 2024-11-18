import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_belajar/screen/home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. Membuat kelas kustom RenderBox untuk menggambar area scan
class ScanAreaRenderBox extends RenderBox {
  @override
  void performLayout() {
    // Menentukan ukuran area efek scan
    size = Size(300.0, 200.0); // Ukuran area scan (300x200)
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Paint paint = Paint()
      ..color = Colors.blue.withOpacity(0.4) // Warna dengan transparansi
      ..style = PaintingStyle.fill;

    // Menggambar kotak yang menunjukkan area pemindaian
    context.canvas.drawRect(offset & size, paint);

    // Menambahkan efek pemindaian (misalnya garis putus-putus atau efek lainnya)
    final Paint dashedPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Path path = Path()
      ..moveTo(offset.dx, offset.dy)
      ..lineTo(offset.dx + size.width, offset.dy)
      ..lineTo(offset.dx + size.width, offset.dy + size.height)
      ..lineTo(offset.dx, offset.dy + size.height)
      ..close();

    // Menggambar garis putus-putus (scan efek)
    _drawDashedLine(context.canvas, path, dashedPaint);
  }

  // Fungsi untuk menggambar garis putus-putus
  void _drawDashedLine(Canvas canvas, Path path, Paint paint) {
    const dashWidth = 10.0; // Lebar setiap garis putus
    const dashSpace = 5.0; // Spasi antar garis

    double distance = 0.0;
    final PathMetrics pathMetrics = path.computeMetrics();
    for (PathMetric pathMetric in pathMetrics) {
      while (distance < pathMetric.length) {
        final Path extractPath =
            pathMetric.extractPath(distance, distance + dashWidth);
        canvas.drawPath(extractPath, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }
}

// 2. Membuat widget yang menggunakan RenderBox Kustom
class ScanAreaWidget extends SingleChildRenderObjectWidget {
  const ScanAreaWidget({Key? key}) : super(key: key);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return ScanAreaRenderBox(); // Menggunakan ScanAreaRenderBox untuk menggambar
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderObject renderObject) {
    super.updateRenderObject(context, renderObject);
    // Update RenderObject jika perlu
  }
}

// 3. Menggunakan widget ScanAreaWidget dalam aplikasi
void main() {
  runApp(ProviderScope(
      child: MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: Text('Scan Area Effect')),
      body: Center(
        child: HomeScreen(), // Menampilkan area scan dengan efek
      ),
    ),
  )));
}

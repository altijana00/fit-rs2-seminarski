import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

class PdfService {
  static Future<Uint8List> generateReport({
    required int totalUsers,
    required int totalStudios,
    required Uint8List barChartImage,
  }) async {
    final pdf = pw.Document();

    final logo = pw.MemoryImage(
      (await rootBundle.load('assets/logo.png')).buffer.asUint8List(),
    );

    final now = DateTime.now();

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(24),
        build: (context) => [

          // HEADER
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Image(logo, height: 50),
              pw.Text(
                "Generated: ${now.day}.${now.month}.${now.year}",
                style: const pw.TextStyle(fontSize: 10),
              ),
            ],
          ),

          pw.SizedBox(height: 20),

          pw.Text(
            "Statistics Report",
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
            ),
          ),

          pw.SizedBox(height: 20),

          // KPI
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              _kpi("Total Users", totalUsers.toString()),
              _kpi("Total Studios", totalStudios.toString()),
            ],
          ),

          pw.SizedBox(height: 30),

          // BAR CHART
          pw.Text("Most Popular Cities",
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          pw.Image(pw.MemoryImage(barChartImage), height: 200),

          pw.SizedBox(height: 30),


        ],
      ),
    );

    return pdf.save();
  }

  static Future<Uint8List> generateStudioReport({
    required double revenue,
    required int participants,
    required Uint8List pieChartImage,
    required Uint8List barChartImage,
  }) async {
    final pdf = pw.Document();

    final now = DateTime.now();
    final date = DateFormat('dd.MM.yyyy').format(now);

    final pieImage = pw.MemoryImage(pieChartImage);
    final barImage = pw.MemoryImage(barChartImage);

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [

          pw.Text(
            "Studio Statistics Report",
            style: pw.TextStyle(
              fontSize: 22,
              fontWeight: pw.FontWeight.bold,
            ),
          ),

          pw.SizedBox(height: 10),
          pw.Text("Date: $date"),

          pw.SizedBox(height: 20),

          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              _kpi("Revenue", revenue.toString()),
              _kpi("Participants", participants.toString()),
            ],
          ),

          pw.SizedBox(height: 30),

          pw.Text("Classes by Type"),
          pw.SizedBox(height: 10),
          pw.Image(pieImage, height: 200),

          pw.SizedBox(height: 20),

          pw.Text("Classes by Instructor"),
          pw.SizedBox(height: 10),
          pw.Image(barImage, height: 200),
        ],
      ),
    );

    return pdf.save();
  }

  static pw.Widget _kpi(String title, String value) {
    return pw.Container(
      width: 120,
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(
        children: [
          pw.Text(title, style: const pw.TextStyle(fontSize: 10)),
          pw.SizedBox(height: 5),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
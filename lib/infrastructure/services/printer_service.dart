import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/entities/business.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';

class PrinterService {
  PrinterService._();

  static Future<void> printThermalReceipt({
    required Invoice invoice,
    required Business business,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text(
                  business.name,
                  style: const pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
                ),
              ),
              if (business.address.isNotEmpty)
                pw.Center(
                  child: pw.Text(
                    business.address,
                    style: const pw.TextStyle(fontSize: 8),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
              if (business.phone.isNotEmpty)
                pw.Center(
                  child: pw.Text('Ph: ${business.phone}', style: const pw.TextStyle(fontSize: 8)),
                ),
              if (business.gstEnabled && business.gstin.isNotEmpty)
                pw.Center(
                  child: pw.Text('GSTIN: ${business.gstin}', style: const pw.TextStyle(fontSize: 8)),
                ),
              pw.Divider(thickness: 0.5),
              pw.Text('Invoice #: ${invoice.invoiceNumber}', style: const pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
              pw.Text('Date: ${DateFormatter.formatDateTime(invoice.invoiceDate)}', style: const pw.TextStyle(fontSize: 8)),
              pw.Text('Customer: ${invoice.customerName}', style: const pw.TextStyle(fontSize: 8)),
              pw.Divider(thickness: 0.5),
              // Items
              pw.Table(
                columnWidths: {
                  0: const pw.FlexColumnWidth(3),
                  1: const pw.FlexColumnWidth(1),
                  2: const pw.FlexColumnWidth(2),
                },
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text('Item', style: const pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8)),
                      pw.Text('Qty', style: const pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8), textAlign: pw.TextAlign.center),
                      pw.Text('Amount', style: const pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8), textAlign: pw.TextAlign.right),
                    ],
                  ),
                  ...invoice.items.map(
                    (item) => pw.TableRow(
                      children: [
                        pw.Text(item.productName, style: const pw.TextStyle(fontSize: 8)),
                        pw.Text('${item.quantity}', style: const pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center),
                        pw.Text(CurrencyFormatter.formatNoDecimal(item.totalAmount), style: const pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.right),
                      ],
                    ),
                  ),
                ],
              ),
              pw.Divider(thickness: 0.5),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Grand Total:', style: const pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                  pw.Text(CurrencyFormatter.format(invoice.grandTotal), style: const pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Text('Payment Mode: ${invoice.paymentType.name.toUpperCase()}', style: const pw.TextStyle(fontSize: 8)),
              pw.SizedBox(height: 10),
              pw.Center(
                child: pw.Text('Thank you! Visit Again.', style: const pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}

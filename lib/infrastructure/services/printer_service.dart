import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/entities/business.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../database/app_database.dart';

class PrinterService {
  PrinterService._();

  static Future<void> printThermalReceipt({
    required Invoice invoice,
    required Business business,
  }) async {
    final pdf = pw.Document();
    final settings = AppDatabase.instance.invoiceDisplaySettings;

    final pageFormat = settings.paperSize == 'A4'
        ? PdfPageFormat.a4
        : (settings.paperSize == 'A5' ? PdfPageFormat.a5 : PdfPageFormat.roll80);

    pdf.addPage(
      pw.Page(
        pageFormat: pageFormat,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              if (settings.showBusinessName)
                pw.Center(
                  child: pw.Text(
                    business.name,
                    style: const pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
                  ),
                ),
              if (settings.showBusinessAddress && business.address.isNotEmpty)
                pw.Center(
                  child: pw.Text(
                    business.address,
                    style: const pw.TextStyle(fontSize: 8),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
              if (settings.showPhone && business.phone.isNotEmpty)
                pw.Center(
                  child: pw.Text('Ph: ${business.phone}', style: const pw.TextStyle(fontSize: 8)),
                ),
              if (settings.showGstin && business.gstEnabled && business.gstin.isNotEmpty)
                pw.Center(
                  child: pw.Text('GSTIN: ${business.gstin}', style: const pw.TextStyle(fontSize: 8)),
                ),
              pw.Divider(thickness: 0.5),
              if (settings.showInvoiceNumber)
                pw.Text('Invoice #: ${invoice.invoiceNumber}', style: const pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
              if (settings.showInvoiceDate)
                pw.Text(
                  settings.showInvoiceTime
                      ? 'Date: ${DateFormatter.formatDateTime(invoice.invoiceDate)}'
                      : 'Date: ${DateFormatter.formatShortDate(invoice.invoiceDate)}',
                  style: const pw.TextStyle(fontSize: 8),
                ),
              if (settings.showCustomerDetails && invoice.customerName.isNotEmpty)
                pw.Text('Customer: ${invoice.customerName}', style: const pw.TextStyle(fontSize: 8)),
              pw.Divider(thickness: 0.5),
              // Items Table
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
                      if (settings.showQuantity)
                        pw.Text('Qty', style: const pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8), textAlign: pw.TextAlign.center),
                      pw.Text('Amount', style: const pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8), textAlign: pw.TextAlign.right),
                    ],
                  ),
                  ...invoice.items.map(
                    (item) => pw.TableRow(
                      children: [
                        pw.Text(item.productName, style: const pw.TextStyle(fontSize: 8)),
                        if (settings.showQuantity)
                          pw.Text('${item.quantity}', style: const pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center),
                        pw.Text(CurrencyFormatter.formatNoDecimal(item.totalAmount), style: const pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.right),
                      ],
                    ),
                  ),
                ],
              ),
              pw.Divider(thickness: 0.5),
              if (settings.showSubtotal)
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Subtotal:', style: const pw.TextStyle(fontSize: 8)),
                    pw.Text(CurrencyFormatter.format(invoice.subtotal), style: const pw.TextStyle(fontSize: 8)),
                  ],
                ),
              if (settings.showTaxRowAndRate && settings.showTaxTotal && business.gstEnabled)
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('GST Total:', style: const pw.TextStyle(fontSize: 8)),
                    pw.Text(CurrencyFormatter.format(invoice.cgst + invoice.sgst + invoice.igst), style: const pw.TextStyle(fontSize: 8)),
                  ],
                ),
              if (settings.showGrandTotal)
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Grand Total:', style: const pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                    pw.Text(CurrencyFormatter.format(invoice.grandTotal), style: const pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                  ],
                ),
              if (settings.showPaymentMethod) ...[
                pw.SizedBox(height: 4),
                pw.Text('Payment Mode: ${invoice.paymentType.name.toUpperCase()}', style: const pw.TextStyle(fontSize: 8)),
              ],
              pw.SizedBox(height: 10),
              if (settings.showFooterMessage && settings.footerMessage.isNotEmpty)
                pw.Center(
                  child: pw.Text(settings.footerMessage, style: const pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
                ),
              if (settings.showTermsAndConditions && settings.termsAndConditions.isNotEmpty) ...[
                pw.SizedBox(height: 4),
                pw.Center(
                  child: pw.Text(settings.termsAndConditions, style: const pw.TextStyle(fontSize: 7), textAlign: pw.TextAlign.center),
                ),
              ],
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

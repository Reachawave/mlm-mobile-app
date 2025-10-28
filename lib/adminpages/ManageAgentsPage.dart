// ManageAgentPage.dart
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle; // <— added
import 'package:new_project/widgets/app_shell.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:new_project/utils/AuthApi.dart';
import 'package:new_project/widgets/app_drawer.dart';
import 'package:new_project/adminpages/CreateAgentPage.dart';
import 'package:new_project/utils/diff_utils.dart';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:open_filex/open_filex.dart';
import 'package:share_plus/share_plus.dart';

class ManageAgentPage extends StatelessWidget {
  const ManageAgentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppShell(title: 'Agents', body: ManageAgentPageBody());
  }
}

class ManageAgentPageBody extends StatefulWidget {
  const ManageAgentPageBody({super.key});

  @override
  State<ManageAgentPageBody> createState() => _ManageAgentPageBodyState();
}

class _ManageAgentPageBodyState extends State<ManageAgentPageBody> {
  final _search = TextEditingController();
  final _focusNode = FocusNode();

  AuthApi? _api;
  bool _loading = true;
  String? _error;
  List<_Agent> _agents = [];

  @override
  void initState() {
    super.initState();
    _initApiAndLoad();
  }

  @override
  void dispose() {
    _search.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _initApiAndLoad() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final sp = await SharedPreferences.getInstance();
    final token = sp.getString('token') ?? sp.getString('auth_token') ?? '';
    if (token.isEmpty) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'You are not logged in';
      });
      return;
    }

    _api = AuthApi(token: token);
    await _loadAgents();
  }

  Future<void> _loadAgents() async {
    try {
      final resp = await _api!.getAgentDetails();
      final raw = (resp.data?['agentDetails'] as List?) ?? [];
      _agents = raw
          .map((e) => _Agent.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      setState(() {
        _loading = false;
        _error = null;
      });
    } on ApiException catch (e) {
      setState(() {
        _loading = false;
        _error = e.message;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = 'Failed to load agents: $e';
      });
    }
  }

  Future<void> _goToCreateAgent() async {
    final sp = await SharedPreferences.getInstance();
    final token = sp.getString('auth_token') ?? sp.getString('token') ?? '';
    if (token.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('You are not logged in')));
      return;
    }
    final api = AuthApi(token: token);
    if (!mounted) return;
    final created = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => CreateAgentPage(api: api)),
    );
    if (created == true) {
      _loadAgents();
    }
  }

  // ---------- VIEW: eye icon -> read-only details dialog ----------
  Future<void> _showAgentDetails(_Agent a) async {
    await showDialog<void>(
      context: context,
      builder: (ctx) {
        TextStyle h(String t) =>
            const TextStyle(fontWeight: FontWeight.w600, color: Colors.black54);
        Widget row(String label, String value) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 140, child: Text(label, style: h(label))),
              const SizedBox(width: 10),
              Expanded(child: Text(value.isEmpty ? '-' : value)),
            ],
          ),
        );

        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 24,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.visibility, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(
                          'Agent Details (${a.referalId})',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Divider(height: 1),
                    const SizedBox(height: 12),

                    // Basic
                    row('Name', a.name),
                    row('Nominee Name', a.otherName),
                    row('Father/Spouse Name', a.fatherName),
                    row('Email', a.email),
                    row('Phone', a.contactNumber),
                    row('Address', a.address),

                    const SizedBox(height: 8),
                    const Divider(height: 1),
                    const SizedBox(height: 8),

                    // IDs
                    row('Referral ID', a.referalId),
                    row('Upline', a.agentReferalName ?? ''),
                    row('Aadhar', a.aadharNo),
                    row('PAN', a.panNo),

                    const SizedBox(height: 8),
                    const Divider(height: 1),
                    const SizedBox(height: 8),

                    // Bank
                    row('Bank Name', a.bankName),
                    row('IFSC', a.ifscCode),
                    row('Account No', a.accountNo),
                    row('A/C Holder', a.accountHolderName),

                    const SizedBox(height: 8),
                    const Divider(height: 1),
                    const SizedBox(height: 8),

                    // Mappings
                    row('Venture', '${a.ventureName} • ${a.ventureLocation}'),
                    row('Branch', '${a.branchName} • ${a.location}'),

                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Created: ${a.createdAt}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ---------- EDIT: open modal, submit only changed fields ----------
  Future<void> _openEditDialog(_Agent a) async {
    final formKey = GlobalKey<FormState>();

    // Controllers prefilled from the row data
    final name = TextEditingController(text: a.name);
    final otherName = TextEditingController(text: a.otherName);
    final aadharNo = TextEditingController(text: a.aadharNo);
    final panNo = TextEditingController(text: a.panNo);
    final address = TextEditingController(text: a.address);
    final bankName = TextEditingController(text: a.bankName);
    final ifscCode = TextEditingController(text: a.ifscCode);
    final accountNo = TextEditingController(text: a.accountNo);
    final accountHolderName = TextEditingController(text: a.accountHolderName);
    final fatherName = TextEditingController(text: a.fatherName);

    bool submitting = false;
    String? errorText;

    final updated = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return StatefulBuilder(
          builder: (ctx, setS) {
            InputDecoration dec(String label) => const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
            ).copyWith(labelText: label);

            Future<void> submit() async {
              if (!formKey.currentState!.validate()) return;

              final original = <String, dynamic>{
                "name": a.name,
                "aadharNo": a.aadharNo,
                "address": a.address,
                "bankName": a.bankName,
                "ifscCode": a.ifscCode,
                "accountNo": a.accountNo,
                "accountHolderName": a.accountHolderName,
                "otherName": a.otherName,
                "panNo": a.panNo,
                "fatherName": a.fatherName,
              };

              final edited = <String, dynamic>{
                "name": name.text,
                "aadharNo": aadharNo.text,
                "address": address.text,
                "bankName": bankName.text,
                "ifscCode": ifscCode.text.toUpperCase(),
                "accountNo": accountNo.text,
                "accountHolderName": accountHolderName.text,
                "otherName": otherName.text,
                "fatherName": fatherName.text,
                "panNo": panNo.text.toUpperCase(),
              };

              final diff = changedFields(original, edited);
              if (diff.isEmpty) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No changes to save')),
                );
                return;
              }

              setS(() {
                submitting = true;
                errorText = null;
              });

              try {
                await _api!.updateAgentMobile(id: a.id.toString(), body: diff);
                if (!mounted) return;
                Navigator.pop(ctx, true);
              } catch (e) {
                setS(() {
                  submitting = false;
                  errorText = e.toString();
                });
              }
            }

            return Dialog(
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 24,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.edit, color: Colors.green),
                              const SizedBox(width: 8),
                              Text(
                                'Edit Agent (${a.referalId})',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: submitting
                                    ? null
                                    : () => Navigator.pop(ctx, false),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          if (errorText != null) ...[
                            Text(
                              errorText!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],

                          LayoutBuilder(
                            builder: (c, con) {
                              double colW(bool full) =>
                                  full ? con.maxWidth : (con.maxWidth - 12) / 2;

                              return Wrap(
                                spacing: 12,
                                runSpacing: 12,
                                children: [
                                  SizedBox(
                                    width: colW(false),
                                    child: TextFormField(
                                      controller: name,
                                      decoration: dec('Name'),
                                      validator: (v) =>
                                          v!.trim().isEmpty ? 'Required' : null,
                                    ),
                                  ),
                                  SizedBox(
                                    width: colW(false),
                                    child: TextFormField(
                                      controller: otherName,
                                      decoration: dec('Nominee Name'),
                                    ),
                                  ),
                                  SizedBox(
                                    width: colW(false),
                                    child: TextFormField(
                                      controller: fatherName,
                                      decoration: dec('Father Name'),
                                    ),
                                  ),
                                  SizedBox(
                                    width: colW(false),
                                    child: TextFormField(
                                      controller: aadharNo,
                                      decoration: dec('Aadhar No'),
                                      keyboardType: TextInputType.number,
                                      validator: (v) =>
                                          v!.trim().isEmpty ? 'Required' : null,
                                    ),
                                  ),
                                  SizedBox(
                                    width: colW(false),
                                    child: TextFormField(
                                      controller: panNo,
                                      decoration: dec('PAN No'),
                                      textCapitalization:
                                          TextCapitalization.characters,
                                      validator: (v) =>
                                          v!.trim().isEmpty ? 'Required' : null,
                                    ),
                                  ),
                                  SizedBox(
                                    width: colW(true),
                                    child: TextFormField(
                                      controller: address,
                                      decoration: dec('Address'),
                                      maxLines: 2,
                                    ),
                                  ),
                                  SizedBox(
                                    width: colW(false),
                                    child: TextFormField(
                                      controller: bankName,
                                      decoration: dec('Bank Name'),
                                    ),
                                  ),
                                  SizedBox(
                                    width: colW(false),
                                    child: TextFormField(
                                      controller: ifscCode,
                                      decoration: dec('IFSC Code'),
                                      textCapitalization:
                                          TextCapitalization.characters,
                                    ),
                                  ),
                                  SizedBox(
                                    width: colW(false),
                                    child: TextFormField(
                                      controller: accountNo,
                                      decoration: dec('Account No'),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  SizedBox(
                                    width: colW(false),
                                    child: TextFormField(
                                      controller: accountHolderName,
                                      decoration: dec('Account Holder Name'),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),

                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: submitting ? null : submit,
                                  icon: submitting
                                      ? const SizedBox(
                                          height: 18,
                                          width: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Icon(Icons.save),
                                  label: const Text('Save changes'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    if (updated == true) {
      await _loadAgents();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Agent updated')));
    }
  }

  // ----------------------- RECEIPT: PDF helpers -----------------------

  Widget _receiptMenu(_Agent a) {
    return PopupMenuButton<String>(
      tooltip: 'Receipt',
      icon: const Icon(Icons.receipt_long),
      onSelected: (v) async {
        if (v == 'view') {
          await _viewReceiptPdf(a);
        } else if (v == 'download') {
          await _downloadReceiptPdf(a);
        } else if (v == 'share') {
          await _shareReceiptPdf(a);
        }
      },
      itemBuilder: (ctx) => const [
        PopupMenuItem(value: 'view', child: Text('View PDF')),
        PopupMenuItem(value: 'download', child: Text('Download PDF')),
        PopupMenuItem(value: 'share', child: Text('Share PDF')),
      ],
    );
  }

  String _sanitizeFileName(String input) {
    final s = input.trim().replaceAll(RegExp(r'\s+'), '_');
    return s.replaceAll(RegExp(r'[^A-Za-z0-9._-]+'), '');
  }

  String _amountInWords(double n) {
    final v = n.round();
    if (v == 0) return 'Zero Only';
    if (v == 50000) return 'Rupees Fifty thousand Only';
    return 'Rupees $v Only';
  }

  Future<Uint8List> _buildReceiptPdf(_Agent a) async {
    final doc = pw.Document();

    // Colors
    final blue = PdfColor.fromInt(0xFF4a90e2);
    final textGrey = PdfColor.fromInt(0xFF555555);
    final lineGrey = PdfColor.fromInt(0xFFDDDDDD);

    // ✅ Fonts that include ₹ (Rupee)
    final base = await PdfGoogleFonts.notoSansRegular();
    final bold = await PdfGoogleFonts.notoSansBold();
    final italic = await PdfGoogleFonts.notoSansItalic();
    final boldItalic = await PdfGoogleFonts.notoSansBoldItalic();

    // ✅ Load logo from lib/assets/logo.png
    final logoBytes = await rootBundle.load('lib/assets/logo.png');
    final logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());

    // Rupee symbol
    const rupee = '\u20B9';

    pw.Widget cellH(String t) => pw.Container(
      color: PdfColor.fromInt(0xFFF2F2F2),
      padding: pw.EdgeInsets.all(8),
      child: pw.Text(
        t,
        style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
      ),
    );

    pw.Widget cellV(String t) => pw.Container(
      padding: pw.EdgeInsets.all(8),
      child: pw.Text(
        t.isEmpty ? '-' : t,
        style: pw.TextStyle(
          fontSize: 12,
          fontWeight: pw.FontWeight.bold,
          color: textGrey,
        ),
      ),
    );

    pw.Widget sectionTitle(String t) => pw.Padding(
      padding: pw.EdgeInsets.only(top: 16, bottom: 8),
      child: pw.Container(
        decoration: pw.BoxDecoration(
          border: pw.Border(bottom: pw.BorderSide(color: blue, width: 1)),
        ),
        child: pw.Text(
          t,
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: blue,
          ),
        ),
      ),
    );

    pw.Widget signBlock(String label) => pw.Column(
      children: [
        pw.Container(
          width: 200,
          height: 0,
          decoration: pw.BoxDecoration(
            border: pw.Border(
              top: pw.BorderSide(
                color: PdfColors.black,
                width: 1,
                style: pw.BorderStyle.dashed,
              ),
            ),
          ),
        ),
        pw.SizedBox(height: 5),
        pw.Text(
          label,
          style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
        ),
      ],
    );

    doc.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          margin: pw.EdgeInsets.all(20),
          theme: pw.ThemeData.withFont(
            base: base,
            bold: bold,
            italic: italic,
            boldItalic: boldItalic,
          ),
        ),
        build: (ctx) => [
          // Header
          pw.Container(
            padding: pw.EdgeInsets.only(bottom: 8),
            decoration: pw.BoxDecoration(
              border: pw.Border(bottom: pw.BorderSide(color: blue, width: 2)),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Row(
                  children: [
                    // ✅ Logo image
                    pw.ClipRRect(
                      horizontalRadius: 6,
                      verticalRadius: 6,
                      child: pw.Image(logoImage, width: 36, height: 36),
                    ),
                    pw.SizedBox(width: 10),
                    pw.Text(
                      'Sri Vayutej Developers',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromInt(0xFF333333),
                      ),
                    ),
                  ],
                ),
                pw.Text(
                  'Office Copy',
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromInt(0xFF333333),
                  ),
                ),
              ],
            ),
          ),

          pw.SizedBox(height: 14),
          pw.Center(
            child: pw.Text(
              'ACKNOWLEDGEMENT RECEIPT',
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
                color: blue,
                decoration: pw.TextDecoration.underline,
              ),
            ),
          ),
          pw.SizedBox(height: 10),

          // Meta
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.RichText(
                text: pw.TextSpan(
                  text: 'Receipt No: ',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  children: [
                    pw.TextSpan(
                      text: a.referalId.isNotEmpty ? a.referalId : '—',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.normal),
                    ),
                  ],
                ),
              ),
              pw.RichText(
                text: pw.TextSpan(
                  text: 'Date: ',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  children: [
                    pw.TextSpan(
                      text: a.createdAt.isNotEmpty ? a.createdAt : '—',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.normal),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Received From
          sectionTitle('Received From'),
          pw.Table(
            border: pw.TableBorder.all(color: lineGrey, width: 1),
            columnWidths: {
              0: pw.FixedColumnWidth(160),
              1: const pw.FlexColumnWidth(),
            },
            children: [
              pw.TableRow(children: [cellH('Agent ID'), cellV(a.referalId)]),
              pw.TableRow(children: [cellH('Name'), cellV(a.name)]),
              pw.TableRow(
                children: [cellH('S/o, W/o, D/o'), cellV(a.fatherName)],
              ),
              pw.TableRow(
                children: [cellH('Mobile No.'), cellV(a.contactNumber)],
              ),
              pw.TableRow(children: [cellH('Email'), cellV(a.email)]),
              pw.TableRow(children: [cellH('Aadhar No.'), cellV(a.aadharNo)]),
              pw.TableRow(children: [cellH('PAN'), cellV(a.panNo)]),
            ],
          ),

          // Payment Details
          sectionTitle('Payment Details'),
          pw.Table(
            border: pw.TableBorder.all(color: lineGrey, width: 1),
            columnWidths: {
              0: pw.FixedColumnWidth(160),
              1: const pw.FlexColumnWidth(),
            },
            children: [
              pw.TableRow(
                children: [
                  cellH('Amount Received'),
                  // ✅ Rupee symbol now renders with Noto Sans
                  cellV('$rupee${a.totalAmount.toStringAsFixed(0)}/-'),
                ],
              ),
              pw.TableRow(
                children: [cellH('Venture Name'), cellV(a.ventureName)],
              ),
              pw.TableRow(
                children: [cellH('Number of Trees'), cellV(a.count.toString())],
              ),
            ],
          ),

          pw.SizedBox(height: 8),
          pw.Text(
            'In words: ${_amountInWords(a.totalAmount)}.',
            style: pw.TextStyle(fontStyle: pw.FontStyle.italic, fontSize: 12),
          ),

          pw.SizedBox(height: 10),
          pw.Text(
            'This is a computer-generated receipt and does not require a physical signature. '
            'The validity of this receipt is subject to the realization of the payment. '
            'All disputes are subject to jurisdiction of courts in the respective city only.',
            style: pw.TextStyle(
              fontSize: 10,
              color: PdfColor.fromInt(0xFF666666),
            ),
          ),

          pw.SizedBox(height: 24),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              signBlock('Customer Signature'),
              signBlock('Authorized Signatory'),
            ],
          ),
        ],
      ),
    );

    return doc.save();
  }

  Future<void> _viewReceiptPdf(_Agent a) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PdfPreview(
          canChangeOrientation: false,
          canChangePageFormat: false,
          allowPrinting: true,
          allowSharing: true,
          build: (format) => _buildReceiptPdf(a),
          pdfFileName: _sanitizeFileName(
            'receipt-${a.referalId}-${a.name}.pdf',
          ),
        ),
      ),
    );
  }

  Future<File> _saveReceiptPdfToAppDir(_Agent a) async {
    final bytes = await _buildReceiptPdf(a);
    final dir = await getApplicationDocumentsDirectory();
    final fileName = _sanitizeFileName('receipt-${a.referalId}-${a.name}.pdf');
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  Future<void> _downloadReceiptPdf(_Agent a) async {
    try {
      final file = await _saveReceiptPdfToAppDir(a);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Saved: ${file.path.split('/').last}')),
      );
      await OpenFilex.open(file.path);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Save failed: $e')));
    }
  }

  Future<void> _shareReceiptPdf(_Agent a) async {
    try {
      final file = await _saveReceiptPdfToAppDir(a);
      await Share.shareXFiles([
        XFile(file.path),
      ], text: 'Receipt for ${a.name}');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Share failed: $e')));
    }
  }

  // ----------------------- UI -----------------------

  @override
  Widget build(BuildContext context) {
    final filtered = _search.text.trim().isEmpty
        ? _agents
        : _agents.where((a) {
            final q = _search.text.trim().toLowerCase();
            return a.name.toLowerCase().contains(q) ||
                a.referalId.toLowerCase().contains(q) ||
                a.contactNumber.toLowerCase().contains(q);
          }).toList();

    return Scaffold(
      drawer: const AppDrawer(),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(_error!, textAlign: TextAlign.center),
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadAgents,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back + Title
                    Row(
                      children: [
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12),
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: const Icon(Icons.arrow_back),
                          ),
                        ),
                        const SizedBox(width: 20),
                        const Text(
                          "Manage Agents",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Search + Create
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _search,
                            focusNode: _focusNode,
                            onChanged: (_) => setState(() {}),
                            decoration: InputDecoration(
                              hintText: 'Search by name / referral / phone...',
                              prefixIcon: const Icon(Icons.search),
                              contentPadding: const EdgeInsets.all(10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Colors.green,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: _goToCreateAgent,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: Colors.green,
                                width: 0.5,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.person_add,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  "Create Agent",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // --------- SIMPLE VERTICAL LIST (no horizontal scroll) ---------
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        final a = filtered[i];

                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            leading: CircleAvatar(
                              backgroundColor: Colors.green.shade50,
                              child: const Icon(
                                Icons.person,
                                color: Colors.green,
                              ),
                            ),
                            title: Text(
                              a.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 2),
                                Text(
                                  a.referalId,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.green,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${a.contactNumber} • ${a.email}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 6,
                                  children: [
                                    _chip(
                                      "${a.ventureName} • ${a.ventureLocation}",
                                    ),
                                    _chip("${a.branchName} • ${a.location}"),
                                  ],
                                ),
                              ],
                            ),
                            trailing: Wrap(
                              spacing: 6,
                              children: [
                                IconButton(
                                  tooltip: 'View details',
                                  icon: const Icon(Icons.remove_red_eye),
                                  onPressed: () => _showAgentDetails(a),
                                ),
                                IconButton(
                                  tooltip: 'Edit',
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _openEditDialog(a),
                                ),
                                _receiptMenu(a),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  static Widget _chip(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.green.shade50,
      borderRadius: BorderRadius.circular(50),
    ),
    child: Text(
      text,
      style: const TextStyle(fontSize: 11, color: Colors.green),
    ),
  );
}

// ---------- model ----------
class _Agent {
  final int id;
  final String name;
  final String referalId;
  final String email;
  final String contactNumber;
  final String address;
  final String branchName;
  final String location;
  final String ventureName;
  final String ventureLocation;
  final int ventureId;
  final int branchId;
  final double totalAmount;
  final int count;
  final String bankName;
  final String accountNo;
  final String ifscCode;
  final String accountHolderName;
  final String fatherName;
  final String panNo;
  final String aadharNo;
  final int agentReferalId;
  final String? agentReferalName;
  final String otherName;
  final String createdAt;

  _Agent({
    required this.id,
    required this.name,
    required this.referalId,
    required this.email,
    required this.contactNumber,
    required this.address,
    required this.branchName,
    required this.location,
    required this.ventureName,
    required this.ventureLocation,
    required this.ventureId,
    required this.branchId,
    required this.totalAmount,
    required this.count,
    required this.bankName,
    required this.accountNo,
    required this.ifscCode,
    required this.accountHolderName,
    required this.fatherName,
    required this.panNo,
    required this.aadharNo,
    required this.agentReferalId,
    required this.agentReferalName,
    required this.otherName,
    required this.createdAt,
  });

  factory _Agent.fromJson(Map<String, dynamic> j) => _Agent(
    id: (j['id'] ?? 0) as int,
    name: (j['name'] ?? '').toString(),
    referalId: (j['referalId'] ?? '').toString(),
    email: (j['email'] ?? '').toString(),
    contactNumber: (j['contactNumber'] ?? '').toString(),
    address: (j['address'] ?? '').toString(),
    branchName: (j['branchName'] ?? '').toString(),
    location: (j['location'] ?? '').toString(),
    ventureName: (j['ventureName'] ?? '').toString(),
    ventureLocation: (j['ventureLocation'] ?? '').toString(),
    ventureId: (j['ventureId'] ?? 0) as int,
    branchId: (j['branchId'] ?? 0) as int,
    totalAmount: (j['totalAmount'] ?? 0).toDouble(),
    count: (j['count'] ?? 0) as int,
    bankName: (j['bankName'] ?? '').toString(),
    accountNo: (j['accountNo'] ?? '').toString(),
    ifscCode: (j['ifscCode'] ?? '').toString(),
    accountHolderName: (j['accountHolderName'] ?? '').toString(),
    panNo: (j['panNo'] ?? '').toString(),
    aadharNo: (j['aadharNo'] ?? '').toString(),
    agentReferalId: (j['agentReferalId'] ?? 0) as int,
    agentReferalName: (j['agentReferalName'])?.toString(),
    otherName: (j['otherName'] ?? '').toString(),
    fatherName: (j['fatherName'] ?? '').toString(),
    createdAt: (j['createdAt'] ?? '').toString(),
  );
}

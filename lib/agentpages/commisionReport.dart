import 'dart:typed_data';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mainpage.dart';
import 'package:new_project/utils/AuthApi.dart';

class CommissionReport extends StatefulWidget {
  const CommissionReport({Key? key}) : super(key: key);

  @override
  State<CommissionReport> createState() => _CommissionReportState();
}

class _CommissionReportState extends State<CommissionReport> {
  List<dynamic> commissionList = [];
  bool isLoading = true;
  String? _token;
  String? _agentId;

  @override
  void initState() {
    super.initState();
    _loadAndFetch();
  }

  Future<void> _loadAndFetch() async {
    try {

      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString("token");
      _agentId = prefs.get("agentId")?.toString();



      debugPrint("CommissionReport: token=$_token, agentId=$_agentId");

      if (_token == null || _agentId == null) {
        setState(() {
          isLoading = false;
        });
        _showError("Missing authentication. Please login again.");
        return;
      }

      await _fetchCommissionData();
    } catch (e, st) {
      debugPrint("Error in initialization: $e");
      debugPrint("Stack trace: $st");
      setState(() {
        isLoading = false;
      });
      _showError("Initialization error: $e");
    }
  }

  Future<void> _fetchCommissionData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final api = AuthApi();
      final response = await api.fetchAgentCommissionReport(
        token: _token!,
        agentId: _agentId!,
      );
      debugPrint("Commission API response: status = ${response.status}, message = ${response.message}, data = ${response.data}");

      final data = response.data ?? {};
      final list = data["commisionDetails"];
      if (list is List) {
        setState(() {
          commissionList = list;
        });
      } else {
        // If the field is not a list, log
        debugPrint("commissionDetails is not a List: $list");
      }
    } on SocketException catch (e) {
      debugPrint("Network (SocketException) in fetchCommissionData: $e");
      _showError("Network error: $e");
    } catch (e, st) {
      debugPrint("Error in fetchCommissionData: $e");
      debugPrint("Stack trace: $st");
      _showError("Failed to load commission data: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<Uint8List> _generatePdf(List<dynamic> data) async {
    final pdf = pw.Document();

    // Define colors and text styles
    final headerBgColor = PdfColors.blue800;
    final headerTextColor = PdfColors.white;
    final oddRowBgColor = PdfColors.grey200;
    final evenRowBgColor = PdfColors.white;

    final headerTextStyle = pw.TextStyle(
      fontWeight: pw.FontWeight.bold,
      fontSize: 14,
      color: headerTextColor,
    );

    final cellTextStyle = pw.TextStyle(
      fontSize: 12,
      color: PdfColors.black,
    );




    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) {
          return pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [

              pw.Text(
                'Commission Report',
                style: pw.TextStyle(
                  fontSize: 28,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue900,
                ),
              ),
              pw.Text(
                'Date: ${DateTime.now().toLocal().toString().split(" ")[0]}',
                style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey600),
              ),
            ],
          );
        },
        footer: (context) {
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
              'Page ${context.pageNumber} of ${context.pagesCount}',
              style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey600),
            ),
          );
        },
        build: (context) {
          return [
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              headers: ['Level', 'Amount', 'Agent', 'Referred', 'Total'],
              data: List<List<String>>.generate(
                data.length,
                    (index) {
                  final item = data[index];
                  return [
                    item["level"]?.toString() ?? '',
                    'Rs.${item["amount"]?.toString() ?? '0'}',
                    item["agentName"]?.toString() ?? '-',
                    item["agentReferredName"]?.toString() ?? '-',
                    'Rs.${item["totalAmount"]?.toString() ?? '0'}',
                  ];
                },
              ),
              headerStyle: headerTextStyle,
              headerDecoration: pw.BoxDecoration(color: headerBgColor),
              cellStyle: cellTextStyle,
              cellAlignment: pw.Alignment.centerLeft,
              columnWidths: {
                0: const pw.FixedColumnWidth(70),
                1: const pw.FixedColumnWidth(90),
                2: const pw.FlexColumnWidth(2),
                3: const pw.FlexColumnWidth(2),
                4: const pw.FixedColumnWidth(80),
              },
              border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey300),
              cellPadding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              // Alternate row background colors
              rowDecoration: pw.BoxDecoration(
                color: evenRowBgColor,
              ),
              oddRowDecoration: pw.BoxDecoration(
                color: oddRowBgColor,
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Divider(color: PdfColors.grey400),
            pw.SizedBox(height: 10),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                '',
                style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
              ),
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  void _downloadPdf() async {
    if (commissionList.isEmpty) {
      _showError("No data to export");
      return;
    }
    try {
      final bytes = await _generatePdf(commissionList);
      await Printing.sharePdf(bytes: bytes, filename: "commission_report.pdf");
    } catch (e, st) {
      debugPrint("Error generating PDF: $e");
      debugPrint("Stack trace: $st");
      _showError("Failed to generate PDF: $e");
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Commission Report"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (c) => Agentdashboardmainpage(initialIndex: 0),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _downloadPdf,
            tooltip: "Download PDF",
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildListView(),
    );
  }

  Widget _buildListView() {
    if (commissionList.isEmpty) {
      return const Center(child: Text("No commission data found."));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: commissionList.length,
      itemBuilder: (context, index) {
        final item = commissionList[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   "ID: ${item["id"]}",
                //   style: const TextStyle(fontWeight: FontWeight.bold),
                // ),
                const SizedBox(height: 4),
                Text("Level: ${item["level"]}"),
                Text("Amount: ₹${item["amount"]}"),
                Text("Agent: ${item["agentName"] ?? ""}"),
                Text("Referred: ${item["agentReferredName"] ?? ""}"),
                Text("Total Amount: ₹${item["totalAmount"]}"),
              ],
            ),
          ),
        );
      },
    );
  }
}

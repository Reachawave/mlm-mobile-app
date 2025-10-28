import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_project/widgets/app_shell.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:new_project/utils/AuthApi.dart';
import 'package:new_project/widgets/app_drawer.dart';

// ===== Export libs =====
import 'package:csv/csv.dart';
import 'package:excel/excel.dart' as xls;
import 'package:file_saver/file_saver.dart';
import 'package:open_filex/open_filex.dart';
import 'package:pdf/pdf.dart' show PdfPageFormat; // for PdfPageFormat.a4
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

/// Reports page (entry)
class Reportspage extends StatelessWidget {
  const Reportspage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppShell(title: 'Reports', body: ReportspageBody());
  }
}

/// Reports page body (stateful)
class ReportspageBody extends StatefulWidget {
  const ReportspageBody({super.key});

  @override
  State<ReportspageBody> createState() => _ReportspageBodyState();
}

class _ReportspageBodyState extends State<ReportspageBody> {
  // ------------------------ Services & State ------------------------
  AuthApi? _api;

  bool _loading = true;
  String? _error;

  // Date range picker
  final GlobalKey _fieldKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  String _selectedDateText = "pick a date range";
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  // Tabs
  static const _tabs = [
    "Agents",
    "Ventures",
    "Investments",
    "Withdrawals",
    "Branches",
  ];
  int _selectedIndex = 0;

  // Data
  List<_AgentRow> _agents = [];
  List<_InvestmentRow> _investments = []; // derived from agents.totalAmount
  List<_WithdrawalRow> _withdrawals = [];
  List<_VentureRow> _ventures = [];
  List<_BranchRow> _branches = [];

  @override
  void initState() {
    super.initState();
    _initApiAndLoad();
  }

  // ------------------------ Initialization ------------------------
  Future<void> _initApiAndLoad() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final sp = await SharedPreferences.getInstance();
      final token = sp.getString('token') ?? sp.getString('auth_token') ?? '';
      if (token.isEmpty) {
        setState(() {
          _loading = false;
          _error = 'You are not logged in';
        });
        return;
      }
      _api = AuthApi(token: token);
      await _loadAll();
    } catch (e) {
      setState(() {
        _loading = false;
        _error = 'Failed to initialize: $e';
      });
    }
  }

  Future<void> _loadAll() async {
    try {
      // -------- AGENTS (API) --------
      final agentsResp = await _api!.getAgentDetails();
      final agentRaw = (agentsResp.data?['agentDetails'] as List?) ?? [];
      _agents = agentRaw.map<_AgentRow>((e) {
        final m = Map<String, dynamic>.from(e as Map);
        final createdStr =
        (m['createdAt'] ?? m['created_at'] ?? m['createdDate'] ?? '')
            .toString();
        return _AgentRow(
          id: (m['referalId'] ?? '').toString(),
          name: (m['name'] ?? '').toString(),
          email: (m['email'] ?? '').toString(),
          branch: (m['branch'] ?? m['branchName'] ?? '').toString(),
          createdAt: _parseFlexibleDate(createdStr),
          totalAmount: _toDouble(m['totalAmount']),
        );
      }).toList();

      // -------- INVESTMENTS (derived) --------
      _investments = _agents
          .map(
            (a) => _InvestmentRow(
          id: a.id,
          agent: a.name,
          totalAmount: a.totalAmount,
          createdAt: a.createdAt,
        ),
      )
          .toList();

      // -------- WITHDRAWALS (API) --------
      final wResp = await _api!.getWithdrawlDetails();
      final wRaw = (wResp.data?['withdrawlDetails'] as List?) ?? [];
      _withdrawals = wRaw.map<_WithdrawalRow>((e) {
        final m = Map<String, dynamic>.from(e as Map);
        final dateStr =
        (m['paidDate'] ?? m['paymentDate'] ?? m['raisedDate'] ?? '')
            .toString();
        return _WithdrawalRow(
          id: (m['id'] ?? 0).toString(),
          agent: (m['name'] ?? '').toString(),
          referalId: (m['referalId'] ?? '').toString(),
          amount: _toDouble(m['withdrawlAmount']),
          date: _parseFlexibleDate(dateStr),
        );
      }).toList();

      // -------- VENTURES (API) --------
      final vResp = await _api!.getVentureDetails();
      final vRaw = (vResp.data?['ventureDetails'] as List?) ?? [];
      _ventures = vRaw.map<_VentureRow>((e) {
        final m = Map<String, dynamic>.from(e as Map);
        final createdStr = (m['createdAt'] ?? m['created_at'] ?? '').toString();
        return _VentureRow(
          id: (m['id'] ?? m['ventureId'] ?? '').toString(),
          name: (m['name'] ?? m['ventureName'] ?? '').toString(),
          treesSold: int.tryParse(m['treesSold']?.toString() ?? '0') ?? 0,
          totalTrees: int.tryParse(m['totalTrees']?.toString() ?? '0') ?? 0,
          createdAt: _parseFlexibleDate(createdStr),
        );
      }).toList();

      // -------- BRANCHES (API) --------
      final bResp = await _api!.getBranchDetails();
      final bRaw = (bResp.data?['branchDetails'] as List?) ?? [];
      _branches = bRaw.map<_BranchRow>((e) {
        final m = Map<String, dynamic>.from(e as Map);
        final createdStr = (m['createdAt'] ?? m['created_at'] ?? '').toString();
        return _BranchRow(
          id: (m['id'] ?? m['branchId'] ?? '').toString(),
          name: (m['name'] ?? m['branchName'] ?? '').toString(),
          location: (m['location'] ?? m['city'] ?? '').toString(),
          agents: int.tryParse(m['agents']?.toString() ?? '0') ?? 0,
          totalSales: int.tryParse(m['totalSales']?.toString() ?? '0') ?? 0,
          createdAt: _parseFlexibleDate(createdStr),
        );
      }).toList();

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
        _error = 'Failed to load: $e';
      });
    }
  }

  // ------------------------ Date Range ------------------------
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is! PickerDateRange) return;
    final range = args.value as PickerDateRange;

    final start0 = range.startDate;
    final end0 = range.endDate ?? start0;
    if (start0 == null || end0 == null) return;

    // Promote to non-nullable locals
    var s = DateTime(start0.year, start0.month, start0.day);
    var e = DateTime(end0.year, end0.month, end0.day);

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (e.isAfter(today)) e = today;

    setState(() {
      _rangeStart = s;
      _rangeEnd = e;
      _selectedDateText = s.isAtSameMomentAs(e)
          ? DateFormat("dd MMMM yyyy").format(s)
          : "${DateFormat('dd MMM yyyy').format(s)} → ${DateFormat('dd MMM yyyy').format(e)}";
    });
  }

  void _showCalendar(BuildContext context) {
    if (_overlayEntry != null) return;
    final rb = _fieldKey.currentContext!.findRenderObject() as RenderBox;
    final pos = rb.localToGlobal(Offset.zero);
    final size = rb.size;
    final now = DateTime.now();
    final screenWidth = MediaQuery.of(context).size.width;
    const overlayWidth = 340.0;
    final left = (pos.dx + overlayWidth > screenWidth)
        ? (screenWidth - overlayWidth - 8) // small right margin
        : pos.dx;

    _overlayEntry = OverlayEntry(
      builder: (_) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _removeOverlay,
              behavior: HitTestBehavior.translucent,
            ),
          ),
          Positioned(
            top: pos.dy + size.height + 6,
            left: left, // <-- use clamped left
            width: overlayWidth,
            child: Material(
              elevation: 10,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 340,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: SfDateRangePicker(
                  selectionMode: DateRangePickerSelectionMode.range,
                  onSelectionChanged: _onSelectionChanged,
                  view: DateRangePickerView.month,
                  minDate: DateTime(now.year, 1, 1),
                  maxDate: DateTime(now.year, now.month, now.day),
                  initialDisplayDate: now,
                  showNavigationArrow: true,
                  allowViewNavigation: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _setToday() {
    final d = DateTime.now();
    final only = DateTime(d.year, d.month, d.day);
    setState(() {
      _rangeStart = only;
      _rangeEnd = only;
      _selectedDateText = DateFormat("dd MMMM yyyy").format(only);
    });
  }

  void _setThisWeek() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final start = today.subtract(Duration(days: today.weekday - 1));
    setState(() {
      _rangeStart = start;
      _rangeEnd = today;
      _selectedDateText =
      "${DateFormat('dd MMM').format(start)} → ${DateFormat('dd MMM').format(today)}";
    });
  }

  void _setThisMonth() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month, now.day);
    setState(() {
      _rangeStart = start;
      _rangeEnd = end;
      _selectedDateText =
      "${DateFormat('dd MMM').format(start)} → ${DateFormat('dd MMM').format(end)}";
    });
  }

  void _setAllTime() {
    setState(() {
      _rangeStart = null;
      _rangeEnd = null;
      _selectedDateText = "All time";
    });
  }

  // ------------------------ Filtering ------------------------
  bool _inRange(DateTime? d) {
    if (d == null) return false;
    if (_rangeStart == null || _rangeEnd == null) return true;
    final dd = DateTime(d.year, d.month, d.day);
    return (dd.isAtSameMomentAs(_rangeStart!) || dd.isAfter(_rangeStart!)) &&
        (dd.isAtSameMomentAs(_rangeEnd!) || dd.isBefore(_rangeEnd!));
  }

  List<_AgentRow> get _agentsFiltered =>
      _agents.where((a) => _inRange(a.createdAt)).toList();

  List<_InvestmentRow> get _investmentsFiltered =>
      _investments.where((i) => _inRange(i.createdAt)).toList();

  List<_WithdrawalRow> get _withdrawalsFiltered =>
      _withdrawals.where((w) => _inRange(w.date)).toList();

  List<_VentureRow> get _venturesFiltered =>
      _ventures.where((v) => _inRange(v.createdAt)).toList();

  List<_BranchRow> get _branchesFiltered =>
      _branches.where((b) => _inRange(b.createdAt)).toList();

  // ------------------------ EXPORT HELPERS ------------------------
  /// Returns current tab title, columns and rows (as strings) based on filters
  (String title, List<String> cols, List<List<String>> rows) _currentTable() {
    switch (_selectedIndex) {
      case 0:
        return (
        'Agents',
        const ['ID', 'Name', 'Email', 'Branch', 'Created'],
        _agentsFiltered
            .map((a) => [
          a.id,
          a.name,
          a.email,
          a.branch,
          a.createdAt != null
              ? DateFormat('dd/MM/yyyy').format(a.createdAt!)
              : '-',
        ])
            .toList(),
        );
      case 1:
        return (
        'Ventures',
        const ['ID', 'Name', 'Trees Sold', 'Total Trees', 'Created'],
        _venturesFiltered
            .map((v) => [
          v.id,
          v.name,
          v.treesSold.toString(),
          v.totalTrees.toString(),
          v.createdAt != null
              ? DateFormat('dd/MM/yyyy').format(v.createdAt!)
              : '-',
        ])
            .toList(),
        );
      case 2:
        return (
        'Investments (per Agent)',
        const ['ID', 'Agent', 'Total Amount', 'Created'],
        _investmentsFiltered
            .map((inv) => [
          inv.id,
          inv.agent,
          _fmtINR(inv.totalAmount),
          inv.createdAt != null
              ? DateFormat('dd/MM/yyyy').format(inv.createdAt!)
              : '-',
        ])
            .toList(),
        );
      case 3:
        return (
        'Withdrawals',
        const ['ID', 'Agent', 'Amount', 'Date'],
        _withdrawalsFiltered
            .map((w) => [
          w.id,
          "${w.agent}${w.referalId.isNotEmpty ? " • ${w.referalId}" : ""}",
          _fmtINR(w.amount),
          w.date != null
              ? DateFormat('dd/MM/yyyy').format(w.date!)
              : '-',
        ])
            .toList(),
        );
      case 4:
        return (
        'Branches',
        const ['ID', 'Name', 'Location', 'Agents', 'Total Sales', 'Created'],
        _branchesFiltered
            .map((b) => [
          b.id,
          b.name,
          b.location,
          b.agents.toString(),
          b.totalSales.toString(),
          b.createdAt != null
              ? DateFormat('dd/MM/yyyy').format(b.createdAt!)
              : '-',
        ])
            .toList(),
        );
      default:
        return ('Report', const [], const []);
    }
  }

  Future<void> _exportCsv() async {
    final (title, cols, rows) = _currentTable();
    final data = [cols, ...rows];
    final csv = const ListToCsvConverter().convert(data);
    final bytes = Uint8List.fromList(csv.codeUnits);
    await _saveBytes(bytes, '${_fileTitle(title)}.csv', MimeType.csv);
  }

  Future<void> _exportXlsx() async {
    final (title, cols, rows) = _currentTable();
    final book = xls.Excel.createExcel();
    final sheet = book['Sheet1'];
    sheet.appendRow(cols);
    for (final r in rows) {
      sheet.appendRow(r);
    }
    final bytes = Uint8List.fromList(book.encode()!);
    await _saveBytes(bytes, '${_fileTitle(title)}.xlsx', MimeType.microsoftExcel);
  }

  Future<void> _exportPdf() async {
    final (title, cols, rows) = _currentTable();
    final doc = pw.Document();

    final String dateCaption = _rangeStart == null || _rangeEnd == null
        ? 'All time'
        : '${DateFormat('dd MMM yyyy').format(_rangeStart!)} → ${DateFormat('dd MMM yyyy').format(_rangeEnd!)}';

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (ctx) => [
          pw.Text(title, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 4),
          pw.Text('Date range: $dateCaption', style: const pw.TextStyle(fontSize: 10)),
          pw.SizedBox(height: 12),
          pw.Table.fromTextArray(
            headers: cols,
            data: rows,
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            cellStyle: const pw.TextStyle(fontSize: 9),
            headerDecoration: const pw.BoxDecoration(),
            border: pw.TableBorder.all(width: 0.3),
            cellAlignment: pw.Alignment.centerLeft,
          ),
        ],
      ),
    );

    final bytes = await doc.save();
    await _saveBytes(bytes, '${_fileTitle(title)}.pdf', MimeType.pdf);
  }

  String _fileTitle(String title) {
    final ts = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    return '${title.replaceAll('/', '-')}_$ts';
  }

  Future<void> _saveBytes(Uint8List bytes, String fileName, MimeType type) async {
    try {
      final path = await FileSaver.instance.saveFile(
        name: fileName,
        ext: fileName.split('.').last,
        bytes: bytes,
        mimeType: type,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Saved: $fileName')),
      );
      try {
        await OpenFilex.open(path);
      } catch (_) {}
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save: $e')),
      );
    }
  }

  // ------------------------ UI ------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(_error!, textAlign: TextAlign.center),
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: _SectionCard(
          title: "Reports",
          icon: Icons.bar_chart_rounded,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quick date chips
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _quickChip("Today", _setToday),
                  _quickChip("This Week", _setThisWeek),
                  _quickChip("This Month", _setThisMonth),
                  _quickChip("All Time", _setAllTime),
                ],
              ),
              const SizedBox(height: 10),

              // Date range field + export buttons row
              GestureDetector(
                key: _fieldKey,
                onTap: () => _overlayEntry == null
                    ? _showCalendar(context)
                    : _removeOverlay(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 16),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _selectedDateText,
                              style: TextStyle(
                                fontSize: 13,
                                color: _selectedDateText == "pick a date range"
                                    ? Colors.grey
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _ExportButton(icon: Icons.download, label: 'CSV', onPressed: _exportCsv),
                          const SizedBox(width: 6),
                          _ExportButton(icon: Icons.table_chart, label: 'XLSX', onPressed: _exportXlsx),
                          const SizedBox(width: 6),
                          _ExportButton(icon: Icons.picture_as_pdf, label: 'PDF', onPressed: _exportPdf),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8),
              const Text(
                "View, download and share detailed reports for your business operations",
                style: TextStyle(fontSize: 12, color: Colors.green),
              ),
              const SizedBox(height: 16),

              // Tabs
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F2),
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(_tabs.length, (i) {
                      final sel = _selectedIndex == i;
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: InkWell(
                          onTap: () => setState(() => _selectedIndex = i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: sel
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _tabs[i],
                              style: TextStyle(
                                fontSize: 13,
                                color: sel
                                    ? Colors.black87
                                    : Colors.green,
                                fontWeight: sel
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Content
              _buildPage(_selectedIndex),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(int i) {
    switch (i) {
      case 0: // Agents
        return _DataTableCard(
          title: "Agents",
          columns: const ["ID", "Name", "Email", "Branch", "Created"],
          rows: _agentsFiltered
              .map(
                (a) => [
              a.id,
              a.name,
              a.email,
              a.branch,
              a.createdAt != null
                  ? DateFormat('dd/MM/yyyy').format(a.createdAt!)
                  : '-',
            ],
          )
              .toList(),
        );
      case 1: // Ventures
        return _DataTableCard(
          title: "Ventures",
          columns: const ["ID", "Name", "Trees Sold", "Total Trees", "Created"],
          rows: _venturesFiltered
              .map(
                (v) => [
              v.id,
              v.name,
              v.treesSold.toString(),
              v.totalTrees.toString(),
              v.createdAt != null
                  ? DateFormat('dd/MM/yyyy').format(v.createdAt!)
                  : '-',
            ],
          )
              .toList(),
        );
      case 2: // Investments
        return _DataTableCard(
          title: "Investments (per Agent)",
          columns: const ["ID", "Agent", "Total Amount", "Created"],
          rows: _investmentsFiltered
              .map(
                (inv) => [
              inv.id,
              inv.agent,
              _fmtINR(inv.totalAmount),
              inv.createdAt != null
                  ? DateFormat('dd/MM/yyyy').format(inv.createdAt!)
                  : '-',
            ],
          )
              .toList(),
        );
      case 3: // Withdrawals
        return _DataTableCard(
          title: "Withdrawals",
          columns: const ["ID", "Agent", "Amount", "Date"],
          rows: _withdrawalsFiltered
              .map(
                (w) => [
              w.id,
              "${w.agent}${w.referalId.isNotEmpty ? " • ${w.referalId}" : ""}",
              _fmtINR(w.amount),
              w.date != null
                  ? DateFormat('dd/MM/yyyy').format(w.date!)
                  : '-',
            ],
          )
              .toList(),
        );
      case 4: // Branches
        return _DataTableCard(
          title: "Branches",
          columns: const [
            "ID",
            "Name",
            "Location",
            "Agents",
            "Total Sales",
            "Created",
          ],
          rows: _branchesFiltered
              .map(
                (b) => [
              b.id,
              b.name,
              b.location,
              b.agents.toString(),
              b.totalSales.toString(),
              b.createdAt != null
                  ? DateFormat('dd/MM/yyyy').format(b.createdAt!)
                  : '-',
            ],
          )
              .toList(),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  // ---------- AppBar ----------
  AppBar _buildAppBar() => AppBar(
    backgroundColor: Colors.white,
    leading: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
    ),
    actions: const [
      Padding(
        padding: EdgeInsets.only(right: 8),
        child: Icon(Icons.person_outline, color: Colors.black87),
      ),
    ],
    bottom: const PreferredSize(
      preferredSize: Size.fromHeight(1),
      child: Divider(height: 1, color: Colors.black12),
    ),
  );

  // ---------- utils ----------
  static double _toDouble(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0.0;
  }

  static DateTime? _parseFlexibleDate(String s) {
    if (s.isEmpty) return null;
    for (final f in const [
      'yyyy-MM-dd',
      'dd/MM/yyyy',
      'dd-MM-yyyy',
      'yyyy/MM/dd',
      "yyyy-MM-dd'T'HH:mm:ss",
      "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
    ]) {
      try {
        return DateFormat(f).parseStrict(s);
      } catch (_) {}
    }
    // fallback non-strict
    try {
      return DateTime.parse(s);
    } catch (_) {}
    return null;
  }

  String _fmtINR(double v) {
    final bool hasCents = (v % 1) != 0;
    return NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: hasCents ? 2 : 0,
    ).format(v);
  }

  Widget _quickChip(String label, VoidCallback onTap) => InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    ),
  );
}

// -------- Cards & Tables (shared) --------
class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.green),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _DataTableCard extends StatelessWidget {
  const _DataTableCard({
    required this.title,
    required this.columns,
    required this.rows,
  });

  final String title;
  final List<String> columns;
  final List<List<String>> rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Material(
          elevation: 0,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(
                  const Color(0xFFF6FFF6),
                ),
                headingTextStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.green,
                ),
                dataRowMinHeight: 42,
                dataRowMaxHeight: 56,
                columns: columns
                    .map((c) => DataColumn(label: Text(c)))
                    .toList(),
                rows: rows
                    .map(
                      (r) => DataRow(
                    cells: r
                        .map(
                          (cell) => DataCell(
                        Text(
                          cell,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    )
                        .toList(),
                  ),
                )
                    .toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ExportButton extends StatelessWidget {
  const _ExportButton({required this.icon, required this.label, required this.onPressed});
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28,
      child: TextButton.icon(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          backgroundColor: const Color(0xFFF6FFF6),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: Color(0xFFE0EDE0))),
        ),
        onPressed: onPressed,
        icon: Icon(icon, size: 14),
        label: Text(label, style: const TextStyle(fontSize: 12)),
      ),
    );
  }
}

// -------- Models --------
class _AgentRow {
  final String id;
  final String name;
  final String email;
  final String branch;
  final DateTime? createdAt;
  final double totalAmount; // for Investments

  const _AgentRow({
    required this.id,
    required this.name,
    required this.email,
    required this.branch,
    required this.createdAt,
    required this.totalAmount,
  });
}

class _InvestmentRow {
  final String id;
  final String agent;
  final double totalAmount;
  final DateTime? createdAt; // used for range filtering

  const _InvestmentRow({
    required this.id,
    required this.agent,
    required this.totalAmount,
    required this.createdAt,
  });
}

class _WithdrawalRow {
  final String id;
  final String agent;
  final String referalId;
  final double amount;
  final DateTime? date;

  const _WithdrawalRow({
    required this.id,
    required this.agent,
    required this.referalId,
    required this.amount,
    required this.date,
  });
}

class _VentureRow {
  final String id;
  final String name;
  final int treesSold;
  final int totalTrees;
  final DateTime? createdAt;

  const _VentureRow({
    required this.id,
    required this.name,
    required this.treesSold,
    required this.totalTrees,
    required this.createdAt,
  });
}

class _BranchRow {
  final String id;
  final String name;
  final String location;
  final int agents;
  final int totalSales;
  final DateTime? createdAt;

  const _BranchRow({
    required this.id,
    required this.name,
    required this.location,
    required this.agents,
    required this.totalSales,
    required this.createdAt,
  });
}

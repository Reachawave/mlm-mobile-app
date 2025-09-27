import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DashboardFilters extends StatefulWidget {
  const DashboardFilters({super.key});

  @override
  State<DashboardFilters> createState() => _DashboardFiltersState();
}

class _DashboardFiltersState extends State<DashboardFilters> {
  String _selectedDate = "pick a date range";
  final GlobalKey _fieldKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is PickerDateRange) {
      final start = args.value.startDate as DateTime?;
      final endNullable = (args.value.endDate ?? start) as DateTime?;
      if (start == null || endNullable == null) return;

      final now = DateTime.now();
      final end = endNullable.isAfter(now) ? now : endNullable;

      setState(() {
        _selectedDate = start == end
            ? DateFormat("dd MMMM yyyy").format(start)
            : "${DateFormat('dd MMM yyyy').format(start)} → ${DateFormat('dd MMM yyyy').format(end)}";
      });
    }
  }

  void _showCalendar(BuildContext context) {
    if (_overlayEntry != null) return;
    final renderBox = _fieldKey.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    final now = DateTime.now();

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(onTap: _removeOverlay, behavior: HitTestBehavior.translucent),
          ),
          Positioned(
            top: position.dy + size.height + 5,
            left: position.dx,
            width: 320,
            child: Material(
              elevation: 6,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 320,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: SfDateRangePicker(
                  selectionMode: DateRangePickerSelectionMode.range,
                  onSelectionChanged: _onSelectionChanged,
                  view: DateRangePickerView.month,
                  minDate: DateTime(now.year, 1, 1),
                  maxDate: now,
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

  @override
  Widget build(BuildContext context) {
    Widget chip(String text) => Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(padding: const EdgeInsets.all(8.0), child: Text(text, style: const TextStyle(fontSize: 16))),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [chip("Today"), const SizedBox(width: 10), chip("This Week"), const SizedBox(width: 10), chip("This Month")]),
        const SizedBox(height: 10),
        chip("All Time"),
        const SizedBox(height: 10),
        GestureDetector(
          key: _fieldKey,
          onTap: () => _overlayEntry == null ? _showCalendar(context) : _removeOverlay(),
          child: Container(
            height: 55,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.black),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _selectedDate,
                    style: TextStyle(fontSize: 18, color: _selectedDate == "pick a date range" ? Colors.grey : Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

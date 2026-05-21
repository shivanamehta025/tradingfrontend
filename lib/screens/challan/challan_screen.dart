import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import 'challan_edit_details_screen.dart';

class ChallanScreen extends StatefulWidget {
  const ChallanScreen({super.key});

  @override
  State<ChallanScreen> createState() => _ChallanScreenState();
}

class _ChallanScreenState extends State<ChallanScreen>
    with SingleTickerProviderStateMixin {
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _rows = [];

  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  static const Color _primary = Color(0xFF1A56DB);
  static const Color _secondary = Color(0xFF3B82F6);
  static const Color _accent = Color(0xFF60A5FA);
  static const Color _bg = Color(0xFFF0F4FF);
  static const Color _cardBg = Colors.white;
  static const Color _textDark = Color(0xFF1E293B);
  static const Color _textMid = Color(0xFF64748B);
  static const Color _gridBorder = Color(0xFFC7D2FE);
  static const Color _gridHeaderBorder = Color(0xFF93C5FD);

  static const List<_ColDef> _columns = [
    _ColDef(key: 'date', label: 'Date', flex: 3),
    _ColDef(key: 'sp_468', label: 'Challan No', flex: 3),
    _ColDef(key: 'sp_469', label: 'Customer Name', flex: 5),
  ];

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );

    _loadData();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    _animController.reset();

    try {
      final data = await ApiService.getChallanRetailIncentive();

      setState(() {
        _rows = List<Map<String, dynamic>>.from(data);
        _loading = false;
      });

      _animController.forward();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  String _cell(Map<String, dynamic> row, String key) {
    final value = row[key];

    if (value == null) {
      return '-';
    }

    String text = value.toString();

    if (key == 'date' && text.contains('T')) {
      text = text.split('T').first;
    }

    return text;
  }

  void _onEdit(Map<String, dynamic> row) async {
    print("🔍 Edit clicked for row: $row");
    
    final sp462 = row['sp_462']?.toString() ?? '';
    final challanNo = row['sp_468']?.toString() ?? '';

    print("📋 sp_462: '$sp462', challanNo: '$challanNo'");

    if (sp462.isEmpty) {
      print("❌ sp_462 is empty! Available keys: ${row.keys.toList()}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFFE53935),
          behavior: SnackBarBehavior.floating,
          content: Text("Invalid challan ID. Available fields: ${row.keys.take(5).join(', ')}"),
          duration: const Duration(seconds: 5),
        ),
      );
      return;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChallanEditDetailsScreen(
          sp462: sp462,
          challanNo: challanNo,
        ),
      ),
    );

    // Refresh the list if challan was approved/rejected
    if (result == true) {
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _loading
                ? _buildLoader()
                : _error != null
                    ? _buildError()
                    : _rows.isEmpty
                        ? _buildEmpty()
                        : _buildGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF1A3A8F),
            _primary,
            _secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x551A56DB),
            blurRadius: 20,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 10, 16, 18),
          child: Row(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: const Icon(
                  Icons.receipt_long_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Challan",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.4,
                      ),
                    ),
                    Text(
                      "Pending Challan",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: _loadData,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.refresh_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoader() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 52,
            height: 52,
            child: CircularProgressIndicator(
              strokeWidth: 3.5,
              color: _primary,
              backgroundColor: _accent.withValues(alpha: 0.2),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            "Loading challans...",
            style: TextStyle(
              fontSize: 14,
              color: _textMid,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 44,
                color: Color(0xFFE53935),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Failed to load challans",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: _textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: _textMid,
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: _loadData,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text("Retry"),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: _accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(28),
            ),
            child: const Icon(
              Icons.inbox_rounded,
              size: 50,
              color: _accent,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "No challans found",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: _textMid,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return FadeTransition(
      opacity: _fadeAnim,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                _StatChip(
                  icon: Icons.receipt_long_rounded,
                  label:
                      "${_rows.length} Record${_rows.length == 1 ? '' : 's'}",
                  color: _primary,
                ),
                const Spacer(),
                _StatChip(
                  icon: Icons.calendar_today_rounded,
                  label: "Pending Challan",
                  color: const Color(0xFF0891B2),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Container(
                decoration: BoxDecoration(
                  color: _cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _gridBorder,
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _primary.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    _buildTableHeader(),
                    Expanded(
                      child: _buildTableRows(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF1A3A8F),
            _primary,
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: _gridBorder,
            width: 1.2,
          ),
        ),
      ),
      child: Row(
        children: [
          for (var i = 0; i < _columns.length; i++)
            Expanded(
              flex: _columns[i].flex,
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: _gridHeaderBorder,
                      width: 1,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 13,
                  ),
                  child: Text(
                    _columns[i].label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(
            width: 72,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 13,
              ),
              child: Text(
                "Action",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRows() {
    return ListView.separated(
      itemCount: _rows.length,
      separatorBuilder: (_, __) {
        return const Divider(
          height: 1,
          thickness: 1,
          color: _gridBorder,
        );
      },
      itemBuilder: (context, index) {
        final row = _rows[index];

        return _DataRow(
          row: row,
          columns: _columns,
          isEven: index % 2 == 0,
          cellFn: _cell,
          onEdit: () => _onEdit(row),
        );
      },
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _DataRow extends StatelessWidget {
  static const Color _borderColor = Color(0xFFC7D2FE);
  static const Color _evenRowColor = Colors.white;
  static const Color _oddRowColor = Color(0xFFEAF1FF);

  final Map<String, dynamic> row;
  final List<_ColDef> columns;
  final bool isEven;
  final String Function(Map<String, dynamic>, String) cellFn;
  final VoidCallback onEdit;

  const _DataRow({
    required this.row,
    required this.columns,
    required this.isEven,
    required this.cellFn,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isEven ? _evenRowColor : _oddRowColor,
      child: Row(
        children: [
          ...columns.map((col) {
            final value = cellFn(row, col.key);
            final isChallanNo = col.key == 'sp_468';

            return Expanded(
              flex: col.flex,
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: _borderColor,
                      width: 1,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 12,
                  ),
                  child: isChallanNo
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A56DB)
                                .withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: const Color(0xFFBFDBFE),
                            ),
                          ),
                          child: Text(
                            value,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF1A56DB),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        )
                      : Text(
                          value,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: col.key == 'date'
                                ? FontWeight.w600
                                : FontWeight.w700,
                            color: col.key == 'date'
                                ? const Color(0xFF475569)
                                : const Color(0xFF1E293B),
                          ),
                        ),
                ),
              ),
            );
          }),
          SizedBox(
            width: 72,
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: _borderColor,
                    width: 1,
                  ),
                ),
              ),
              child: Center(
                child: GestureDetector(
                  onTap: onEdit,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF1A56DB),
                          Color(0xFF3B82F6),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1A56DB)
                              .withValues(alpha: 0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.edit_rounded,
                          size: 12,
                          color: Colors.white,
                        ),
                        SizedBox(width: 4),
                        Text(
                          "Edit",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EditSheet extends StatefulWidget {
  final Map<String, dynamic> row;
  final VoidCallback onSaved;

  const _EditSheet({
    required this.row,
    required this.onSaved,
  });

  @override
  State<_EditSheet> createState() => _EditSheetState();
}

class _EditSheetState extends State<_EditSheet> {
  late TextEditingController _dateCtrl;
  late TextEditingController _challanCtrl;
  late TextEditingController _partyCtrl;

  bool _saving = false;

  @override
  void initState() {
    super.initState();

    String dateVal = widget.row['date']?.toString() ?? '';

    if (dateVal.contains('T')) {
      dateVal = dateVal.split('T').first;
    }

    _dateCtrl = TextEditingController(text: dateVal);

    _challanCtrl = TextEditingController(
      text: widget.row['sp_468']?.toString() ?? '',
    );

    _partyCtrl = TextEditingController(
      text: widget.row['sp_469']?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _dateCtrl.dispose();
    _challanCtrl.dispose();
    _partyCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() {
      _saving = true;
    });

    await Future.delayed(
      const Duration(milliseconds: 800),
    );

    if (!mounted) return;

    setState(() {
      _saving = false;
    });

    Navigator.pop(context);

    widget.onSaved();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF1A56DB),
        behavior: SnackBarBehavior.floating,
        content: const Text(
          "Challan updated successfully",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      padding: EdgeInsets.fromLTRB(
        20,
        24,
        20,
        20 + bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SheetField(
            controller: _dateCtrl,
            label: "Date",
            icon: Icons.calendar_today_rounded,
          ),
          const SizedBox(height: 14),
          _SheetField(
            controller: _challanCtrl,
            label: "Challan No",
            icon: Icons.tag_rounded,
          ),
          const SizedBox(height: 14),
          _SheetField(
            controller: _partyCtrl,
            label: "Customer Name",
            icon: Icons.person_rounded,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _saving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A56DB),
                    foregroundColor: Colors.white,
                  ),
                  child: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text("Save Changes"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SheetField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;

  const _SheetField({
    required this.controller,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          icon,
          color: const Color(0xFF1A56DB),
        ),
        filled: true,
        fillColor: const Color(0xFFF8FAFF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

class _ColDef {
  final String key;
  final String label;
  final int flex;

  const _ColDef({
    required this.key,
    required this.label,
    required this.flex,
  });
}

import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class ChallanEditDetailsScreen extends StatefulWidget {
  final String sp462;
  final String challanNo;

  const ChallanEditDetailsScreen({
    super.key,
    required this.sp462,
    required this.challanNo,
  });

  @override
  State<ChallanEditDetailsScreen> createState() =>
      _ChallanEditDetailsScreenState();
}

class _ChallanEditDetailsScreenState extends State<ChallanEditDetailsScreen> {
  bool _loading = true;
  String? _error;
  Map<String, dynamic>? _data;
  bool _processing = false;
  String loggedInUserId = '';
  String? _expandedSection = 'Basic Information';

  static const Color _primary = Color(0xFF1A56DB);
  static const Color _secondary = Color(0xFF3B82F6);
  static const Color _bg = Color(0xFFF0F4FF);
  static const Color _cardBg = Colors.white;
  static const Color _textDark = Color(0xFF1E293B);
  static const Color _textMid = Color(0xFF64748B);
  static const Color _rowBorder = Color(0xFFC7D2FE);
  static const Color _evenRowColor = Colors.white;
  static const Color _oddRowColor = Color(0xFFEAF1FF);

  @override
  void initState() {
    super.initState();
    _initializePage();
  }

  Future<void> _initializePage() async {
    final uid = await ApiService.getUserId();
    loggedInUserId = uid ?? '';
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final data = await ApiService.getChallanEditDetails(widget.sp462);
      setState(() {
        _data = data;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceAll('Exception: ', '');
        _loading = false;
      });
    }
  }

  String _formatValue(dynamic value) {
    if (value == null) return '-';
    if (value is String && value.isEmpty) return '-';
    return value.toString();
  }

  String? _summary(String template) {
    final text = template.trim();
    if (text.isEmpty || text.endsWith(': -') || text.endsWith(':-')) {
      return null;
    }
    return text;
  }

  List<_SectionDef> _buildSections() {
    final d = _data!;
    return [
      _SectionDef(
        title: 'Basic Information',
        summary: _summary(
          'Customer: ${_formatValue(d['customername'])}',
        ),
        icon: Icons.info_outline_rounded,
        iconColor: const Color(0xFF3B82F6),
        fields: [
          _FieldData('Date', _formatValue(d['cdate'])),
          _FieldData('Challan No', _formatValue(d['challanno']),
              highlight: true),
          _FieldData('Customer Name', _formatValue(d['customername'])),
          _FieldData('Model Name', _formatValue(d['modelname'])),
          _FieldData('Variant Name', _formatValue(d['variantname'])),
          _FieldData('Color Name', _formatValue(d['colorname'])),
          _FieldData('Sales Consultant', _formatValue(d['scname'])),
          _FieldData('Team Leader', _formatValue(d['tlname'])),
          _FieldData('VIN No', _formatValue(d['vinno'])),
          _FieldData('Engine No', _formatValue(d['engineno'])),
        ],
      ),
      _SectionDef(
        title: 'Pricing Details',
        summary: _summary(
          'Ex-Showroom: ${_formatValue(d['ExshowRoomPrice'])}',
        ),
        icon: Icons.attach_money_rounded,
        iconColor: const Color(0xFF10B981),
        fields: [
          _FieldData('Ex-Showroom Price', _formatValue(d['ExshowRoomPrice'])),
          _FieldData('Fasttag', _formatValue(d['fasttag'])),
          _FieldData('Handling Charge', _formatValue(d['handlingchrg'])),
          _FieldData('TCS', _formatValue(d['tcs'])),
          _FieldData('TRC', _formatValue(d['trc'])),
          _FieldData('Accessories', _formatValue(d['Accessories'])),
          _FieldData(
              'Additional Warranty', _formatValue(d['AdditionalWarranty'])),
          _FieldData('Warranty Year', _formatValue(d['WarrantyYear'])),
          _FieldData('Warranty Amount', _formatValue(d['WarrantyAmount'])),
        ],
      ),
      _SectionDef(
        title: 'Discounts & Offers',
        summary: _summary('Corporate: ${_formatValue(d['Corporateyn'])}'),
        icon: Icons.local_offer_rounded,
        iconColor: const Color(0xFFF59E0B),
        fields: [
          _FieldData('Corporate Y/N', _formatValue(d['Corporateyn'])),
          _FieldData('Corporate Amount', _formatValue(d['Corporateamount'])),
          _FieldData('Corporate Given', _formatValue(d['Corporategiven'])),
          _FieldData('Exchange Y/N', _formatValue(d['Exchangeyn'])),
          _FieldData('Exchange Amount', _formatValue(d['Exchangeamount'])),
          _FieldData('Exchange Given', _formatValue(d['Exchangegiven'])),
          _FieldData('Loyalty Y/N', _formatValue(d['Loyalityyn'])),
          _FieldData('Loyalty Amount', _formatValue(d['Loyalityamount'])),
          _FieldData('Loyalty Given', _formatValue(d['Loyalitygiven'])),
          _FieldData('Dealer Y/N', _formatValue(d['dealeryn'])),
          _FieldData('Dealer Amount', _formatValue(d['dealeramount'])),
          _FieldData('Dealer Given', _formatValue(d['dealergiven'])),
        ],
      ),
      _SectionDef(
        title: 'RTO Details',
        summary: _summary('RTO Amount: ${_formatValue(d['RTOAmount'])}'),
        icon: Icons.directions_car_rounded,
        iconColor: const Color(0xFF8B5CF6),
        fields: [
          _FieldData('RTO Rate', _formatValue(d['RTORate'])),
          _FieldData('RTO Tax Surcharge', _formatValue(d['RTOTaxSurcharge'])),
          _FieldData('Green Tax', _formatValue(d['GreenTax'])),
          _FieldData('Reg Fee', _formatValue(d['RegFee'])),
          _FieldData('HPN', _formatValue(d['HPN'])),
          _FieldData('Duplicate', _formatValue(d['Duplicate'])),
          _FieldData('Smart Card', _formatValue(d['SmartCard'])),
          _FieldData('Other', _formatValue(d['Other'])),
          _FieldData('RTO Amount', _formatValue(d['RTOAmount'])),
          _FieldData('RTO City', _formatValue(d['rtocity'])),
          _FieldData('RTO From', _formatValue(d['rtofrom'])),
          _FieldData('RTO Temp', _formatValue(d['RTO TEMP'])),
        ],
      ),
      _SectionDef(
        title: 'Tax Details',
        summary: _summary('Subtotal: ${_formatValue(d['subtotal'])}'),
        icon: Icons.receipt_rounded,
        iconColor: const Color(0xFFEC4899),
        fields: [
          _FieldData('GST', _formatValue(d['GST'])),
          _FieldData('CESS', _formatValue(d['CESS'])),
          _FieldData('SGST', _formatValue(d['sgst'])),
          _FieldData('CGST', _formatValue(d['cgst'])),
          _FieldData('GST Percentage', _formatValue(d['GSTPercentage'])),
          _FieldData('GST Amount', _formatValue(d['GSTAmount'])),
          _FieldData('Subtotal', _formatValue(d['subtotal'])),
          _FieldData('Amount', _formatValue(d['Amount'])),
        ],
      ),
      _SectionDef(
        title: 'Insurance Details',
        summary: _summary('Insurance Amt: ${_formatValue(d['insamt'])}'),
        icon: Icons.security_rounded,
        iconColor: const Color(0xFF06B6D4),
        fields: [
          _FieldData('IDV', _formatValue(d['Idv'])),
          _FieldData('IDV Amount', _formatValue(d['IdvAmount'])),
          _FieldData(
              'Insurance Percentage', _formatValue(d['InsurancePercentage'])),
          _FieldData('Insurance Per Amount', _formatValue(d['InsperAmount'])),
          _FieldData(
              'Discount Percentage', _formatValue(d['DiscountPrecentage'])),
          _FieldData('Discount Amount', _formatValue(d['DiscountAmount'])),
          _FieldData('Third Party', _formatValue(d['ThirdParty'])),
          _FieldData('PA Cover', _formatValue(d['PACover'])),
          _FieldData('ZD', _formatValue(d['ZD'])),
          _FieldData('PB', _formatValue(d['PB'])),
          _FieldData('KP', _formatValue(d['KP'])),
          _FieldData('Paid Driver', _formatValue(d['PaidDriver'])),
          _FieldData('Insurance Amount', _formatValue(d['InsuranceAmount'])),
          _FieldData('Insurance Company', _formatValue(d['inscmpy'])),
          _FieldData('Policy', _formatValue(d['policy'])),
          _FieldData(
              'Insurance Issue Date', _formatValue(d['insissuedate'])),
          _FieldData('Insurance Amt', _formatValue(d['insamt'])),
          _FieldData('Insurance Type', _formatValue(d['instype'])),
          _FieldData('Insurance Showroom', _formatValue(d['insshowroom'])),
          _FieldData('Previous Insurance Amt', _formatValue(d['preinsamt'])),
          _FieldData('NCB', _formatValue(d['NCB'])),
        ],
      ),
      _SectionDef(
        title: 'Financial Details',
        summary: _summary('Net Amount: ${_formatValue(d['netamount'])}'),
        icon: Icons.account_balance_rounded,
        iconColor: const Color(0xFFEF4444),
        fields: [
          _FieldData('Net Amount', _formatValue(d['netamount'])),
          _FieldData('Less of All Encashment Scheme',
              _formatValue(d['lessofallencashmentschemne'])),
          _FieldData('Hypothecation', _formatValue(d['hypothecationname'])),
          _FieldData('Bank Name', _formatValue(d['bankname'])),
          _FieldData('Bank Amount', _formatValue(d['bankamt'])),
          _FieldData('Finance Amount', _formatValue(d['financeamt'])),
          _FieldData('Finance Type', _formatValue(d['financetype'])),
          _FieldData('Bank Due', _formatValue(d['bankdue'])),
          _FieldData('Customer Due', _formatValue(d['custdue'])),
          _FieldData('Customer Receive', _formatValue(d['crecive'])),
          _FieldData('Finance Receive', _formatValue(d['freceive'])),
          _FieldData('RC Amount', _formatValue(d['rcamt'])),
          _FieldData('Balance', _formatValue(d['bal'])),
        ],
      ),
      _SectionDef(
        title: 'Customer Information',
        summary: _summary('Mobile: ${_formatValue(d['mobileno'])}'),
        icon: Icons.person_rounded,
        iconColor: const Color(0xFF6366F1),
        fields: [
          _FieldData('Address', _formatValue(d['address'])),
          _FieldData('Father Name', _formatValue(d['fathername'])),
          _FieldData('Mobile No', _formatValue(d['mobileno'])),
          _FieldData('Aadhar Card', _formatValue(d['aadharcard'])),
          _FieldData('PAN No', _formatValue(d['panno'])),
          _FieldData('Nominee Name', _formatValue(d['nomineename'])),
          _FieldData('Age', _formatValue(d['age'])),
          _FieldData('Relation', _formatValue(d['relation'])),
          _FieldData('GSTIN', _formatValue(d['gstin'])),
          _FieldData('Title', _formatValue(d['title'])),
        ],
      ),
    ];
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
                    : _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A3A8F), _primary, _secondary],
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
              _headerIconButton(
                icon: Icons.arrow_back_ios_new_rounded,
                onTap: () => Navigator.pop(context),
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
                  Icons.description_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Challan Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.4,
                      ),
                    ),
                    Text(
                      'Challan No: ${widget.challanNo}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
              _headerIconButton(
                icon: Icons.refresh_rounded,
                onTap: _loadData,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
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
          child: Icon(icon, color: Colors.white, size: 18),
        ),
      ),
    );
  }

  Widget _buildLoader() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 52,
            height: 52,
            child: CircularProgressIndicator(
              strokeWidth: 3.5,
              color: _primary,
            ),
          ),
          SizedBox(height: 18),
          Text(
            'Loading challan details...',
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
                color: Color(0xFFFFEBEE),
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
              'Failed to load details',
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
              style: const TextStyle(fontSize: 12, color: _textMid),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: _loadData,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
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

  Widget _buildContent() {
    if (_data == null) return const SizedBox.shrink();

    final sections = _buildSections();

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Container(
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _rowBorder, width: 1.2),
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
                  for (var i = 0; i < sections.length; i++)
                    _buildSection(
                      section: sections[i],
                      showDivider: i < sections.length - 1,
                    ),
                ],
              ),
            ),
          ),
        ),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildSection({
    required _SectionDef section,
    required bool showDivider,
  }) {
    final isExpanded = _expandedSection == section.title;
    final summaryMaxWidth =
        MediaQuery.of(context).size.width < 700 ? 130.0 : 460.0;

    return Column(
      children: [
        Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            key: ValueKey('${section.title}-$isExpanded'),
            tilePadding: const EdgeInsets.symmetric(horizontal: 12),
            childrenPadding: EdgeInsets.zero,
            leading: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: section.iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(section.icon, color: section.iconColor, size: 20),
            ),
            title: Text(
              section.title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: _textDark,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (section.summary != null)
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: summaryMaxWidth),
                    child: Text(
                      section.summary!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: _textDark,
                      ),
                    ),
                  ),
                if (section.summary != null) const SizedBox(width: 6),
                AnimatedRotation(
                  turns: isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Color(0xFF334155),
                  ),
                ),
              ],
            ),
            initiallyExpanded: isExpanded,
            onExpansionChanged: (expanded) {
              setState(() {
                _expandedSection = expanded ? section.title : null;
              });
            },
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: _rowBorder, width: 1.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      for (var i = 0; i < section.fields.length; i++)
                        _SectionFieldRow(
                          field: section.fields[i],
                          isEven: i % 2 == 0,
                          isLast: i == section.fields.length - 1,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(height: 1, thickness: 1, color: _rowBorder),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _processing ? null : _onReject,
                icon: const Icon(Icons.close_rounded, size: 20),
                label: _processing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Reject'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF4444),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: _processing ? null : _onApprove,
                icon: const Icon(Icons.check_circle_rounded, size: 20),
                label: _processing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Approve'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onApprove() async {
    if (_data == null) return;

    setState(() => _processing = true);

    try {
      final approvalData = _prepareDataForSubmission(_data!);
      approvalData['loginUserId'] = loggedInUserId;
      approvalData['sp_583'] = loggedInUserId;
      approvalData['sp_584'] = await ApiService.getClientIp();

      final result = await ApiService.approveChallan(approvalData);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          content: Text(result['message'] ?? 'Challan approved successfully'),
        ),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          content: Text(e.toString().replaceAll('Exception: ', '')),
        ),
      );
    } finally {
      if (mounted) setState(() => _processing = false);
    }
  }

  Future<void> _onReject() async {
    if (_data == null) return;

    final remark = await showDialog<String>(
      context: context,
      builder: (context) => const _RejectDialog(),
    );

    if (remark == null || remark.isEmpty) return;

    setState(() => _processing = true);

    try {
      final rejectionData = _prepareDataForSubmission(_data!);
      rejectionData['loginUserId'] = loggedInUserId;
      rejectionData['sp_587'] = loggedInUserId;
      rejectionData['sp_588'] = await ApiService.getClientIp();

      final result = await ApiService.rejectChallan(rejectionData, remark);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          content: Text(result['message'] ?? 'Challan rejected successfully'),
        ),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          content: Text(e.toString().replaceAll('Exception: ', '')),
        ),
      );
    } finally {
      if (mounted) setState(() => _processing = false);
    }
  }

  Map<String, dynamic> _prepareDataForSubmission(Map<String, dynamic> data) {
    final prepared = Map<String, dynamic>.from(data);
    if (prepared['sp_462'] == null && prepared['unq'] != null) {
      prepared['sp_462'] = prepared['unq'];
    }
    return prepared;
  }
}

class _SectionDef {
  final String title;
  final String? summary;
  final IconData icon;
  final Color iconColor;
  final List<_FieldData> fields;

  const _SectionDef({
    required this.title,
    this.summary,
    required this.icon,
    required this.iconColor,
    required this.fields,
  });
}

class _FieldData {
  final String label;
  final String value;
  final bool highlight;

  const _FieldData(this.label, this.value, {this.highlight = false});
}

class _SectionFieldRow extends StatelessWidget {
  static const Color _borderColor = Color(0xFFC7D2FE);
  static const Color _evenRowColor = Colors.white;
  static const Color _oddRowColor = Color(0xFFEAF1FF);
  static const Color _textDark = Color(0xFF1E293B);
  static const Color _textMid = Color(0xFF64748B);
  static const Color _primary = Color(0xFF1A56DB);

  final _FieldData field;
  final bool isEven;
  final bool isLast;

  const _SectionFieldRow({
    required this.field,
    required this.isEven,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isEven ? _evenRowColor : _oddRowColor,
        border: Border(
          bottom: isLast
              ? BorderSide.none
              : const BorderSide(color: _borderColor, width: 1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  right: BorderSide(color: _borderColor, width: 1),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: Text(
                field.label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _textMid,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: field.highlight
                  ? Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: _primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFBFDBFE)),
                        ),
                        child: Text(
                          field.value,
                          style: const TextStyle(
                            fontSize: 12,
                            color: _primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    )
                  : Text(
                      field.value,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _textDark,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RejectDialog extends StatefulWidget {
  const _RejectDialog();

  @override
  State<_RejectDialog> createState() => _RejectDialogState();
}

class _RejectDialogState extends State<_RejectDialog> {
  final _remarkController = TextEditingController();

  @override
  void dispose() {
    _remarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Row(
        children: [
          Icon(Icons.warning_rounded, color: Color(0xFFEF4444)),
          SizedBox(width: 12),
          Text(
            'Reject Challan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Please provide a reason for rejection:',
            style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _remarkController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Enter rejection reason...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: const Color(0xFFF8FAFF),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_remarkController.text.trim().isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please enter a rejection reason'),
                  backgroundColor: Color(0xFFEF4444),
                ),
              );
              return;
            }
            Navigator.pop(context, _remarkController.text.trim());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFEF4444),
            foregroundColor: Colors.white,
          ),
          child: const Text('Reject'),
        ),
      ],
    );
  }
}

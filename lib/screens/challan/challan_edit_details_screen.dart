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

  static const Color _primary = Color(0xFF1A56DB);
  static const Color _secondary = Color(0xFF3B82F6);
  static const Color _bg = Color(0xFFF0F4FF);
  static const Color _cardBg = Colors.white;
  static const Color _textDark = Color(0xFF1E293B);
  static const Color _textMid = Color(0xFF64748B);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      print("🔍 Loading challan details for sp_462: ${widget.sp462}");
      
      final data = await ApiService.getChallanEditDetails(widget.sp462);

      print("📦 Received data: ${data != null ? 'Success' : 'Null'}");

      setState(() {
        _data = data;
        _loading = false;
      });
      
      print("✅ Data loaded successfully");
    } catch (e) {
      print("❌ Error loading challan details: $e");
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
                      "Challan Details",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.4,
                      ),
                    ),
                    Text(
                      "Challan No: ${widget.challanNo}",
                      style: const TextStyle(
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
              backgroundColor: _secondary.withValues(alpha: 0.2),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            "Loading challan details...",
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
              "Failed to load details",
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

  Widget _buildContent() {
    if (_data == null) return const SizedBox.shrink();

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildSection(
                  title: "Basic Information",
                  icon: Icons.info_outline_rounded,
                  iconColor: const Color(0xFF3B82F6),
                  fields: [
                    _FieldData("Date", _formatValue(_data!['cdate'])),
                    _FieldData("Challan No", _formatValue(_data!['challanno'])),
                    _FieldData("Customer Name", _formatValue(_data!['customername'])),
                    _FieldData("Model Name", _formatValue(_data!['modelname'])),
                    _FieldData("Variant Name", _formatValue(_data!['variantname'])),
                    _FieldData("Color Name", _formatValue(_data!['colorname'])),
                    _FieldData("VIN No", _formatValue(_data!['vinno'])),
                    _FieldData("Engine No", _formatValue(_data!['engineno'])),
                  ],
                ),
                _buildSection(
                  title: "Pricing Details",
                  icon: Icons.attach_money_rounded,
                  iconColor: const Color(0xFF10B981),
                  fields: [
                    _FieldData("Ex-Showroom Price", _formatValue(_data!['ExshowRoomPrice'])),
                    _FieldData("Fasttag", _formatValue(_data!['fasttag'])),
                    _FieldData("Handling Charge", _formatValue(_data!['handlingchrg'])),
                    _FieldData("TCS", _formatValue(_data!['tcs'])),
                    _FieldData("TRC", _formatValue(_data!['trc'])),
                    _FieldData("Accessories", _formatValue(_data!['Accessories'])),
                    _FieldData("Additional Warranty", _formatValue(_data!['AdditionalWarranty'])),
                    _FieldData("Warranty Year", _formatValue(_data!['WarrantyYear'])),
                    _FieldData("Warranty Amount", _formatValue(_data!['WarrantyAmount'])),
                  ],
                ),
                _buildSection(
                  title: "Discounts & Offers",
                  icon: Icons.local_offer_rounded,
                  iconColor: const Color(0xFFF59E0B),
                  fields: [
                    _FieldData("Corporate Y/N", _formatValue(_data!['Corporateyn'])),
                    _FieldData("Corporate Amount", _formatValue(_data!['Corporateamount'])),
                    _FieldData("Corporate Given", _formatValue(_data!['Corporategiven'])),
                    _FieldData("Exchange Y/N", _formatValue(_data!['Exchangeyn'])),
                    _FieldData("Exchange Amount", _formatValue(_data!['Exchangeamount'])),
                    _FieldData("Exchange Given", _formatValue(_data!['Exchangegiven'])),
                    _FieldData("Loyalty Y/N", _formatValue(_data!['Loyalityyn'])),
                    _FieldData("Loyalty Amount", _formatValue(_data!['Loyalityamount'])),
                    _FieldData("Loyalty Given", _formatValue(_data!['Loyalitygiven'])),
                    _FieldData("Dealer Y/N", _formatValue(_data!['dealeryn'])),
                    _FieldData("Dealer Amount", _formatValue(_data!['dealeramount'])),
                    _FieldData("Dealer Given", _formatValue(_data!['dealergiven'])),
                  ],
                ),
                _buildSection(
                  title: "RTO Details",
                  icon: Icons.directions_car_rounded,
                  iconColor: const Color(0xFF8B5CF6),
                  fields: [
                    _FieldData("RTO Rate", _formatValue(_data!['RTORate'])),
                    _FieldData("RTO Tax Surcharge", _formatValue(_data!['RTOTaxSurcharge'])),
                    _FieldData("Green Tax", _formatValue(_data!['GreenTax'])),
                    _FieldData("Reg Fee", _formatValue(_data!['RegFee'])),
                    _FieldData("HPN", _formatValue(_data!['HPN'])),
                    _FieldData("Duplicate", _formatValue(_data!['Duplicate'])),
                    _FieldData("Smart Card", _formatValue(_data!['SmartCard'])),
                    _FieldData("Other", _formatValue(_data!['Other'])),
                    _FieldData("RTO Amount", _formatValue(_data!['RTOAmount'])),
                    _FieldData("RTO City", _formatValue(_data!['rtocity'])),
                    _FieldData("RTO From", _formatValue(_data!['rtofrom'])),
                    _FieldData("RTO Temp", _formatValue(_data!['RTO TEMP'])),
                  ],
                ),
                _buildSection(
                  title: "Tax Details",
                  icon: Icons.receipt_rounded,
                  iconColor: const Color(0xFFEC4899),
                  fields: [
                    _FieldData("GST", _formatValue(_data!['GST'])),
                    _FieldData("CESS", _formatValue(_data!['CESS'])),
                    _FieldData("SGST", _formatValue(_data!['sgst'])),
                    _FieldData("CGST", _formatValue(_data!['cgst'])),
                    _FieldData("GST Percentage", _formatValue(_data!['GSTPercentage'])),
                    _FieldData("GST Amount", _formatValue(_data!['GSTAmount'])),
                    _FieldData("Subtotal", _formatValue(_data!['subtotal'])),
                    _FieldData("Amount", _formatValue(_data!['Amount'])),
                  ],
                ),
                _buildSection(
                  title: "Insurance Details",
                  icon: Icons.security_rounded,
                  iconColor: const Color(0xFF06B6D4),
                  fields: [
                    _FieldData("IDV", _formatValue(_data!['Idv'])),
                    _FieldData("IDV Amount", _formatValue(_data!['IdvAmount'])),
                    _FieldData("Insurance Percentage", _formatValue(_data!['InsurancePercentage'])),
                    _FieldData("Insurance Per Amount", _formatValue(_data!['InsperAmount'])),
                    _FieldData("Discount Percentage", _formatValue(_data!['DiscountPrecentage'])),
                    _FieldData("Discount Amount", _formatValue(_data!['DiscountAmount'])),
                    _FieldData("Third Party", _formatValue(_data!['ThirdParty'])),
                    _FieldData("PA Cover", _formatValue(_data!['PACover'])),
                    _FieldData("ZD", _formatValue(_data!['ZD'])),
                    _FieldData("PB", _formatValue(_data!['PB'])),
                    _FieldData("KP", _formatValue(_data!['KP'])),
                    _FieldData("Paid Driver", _formatValue(_data!['PaidDriver'])),
                    _FieldData("Insurance Amount", _formatValue(_data!['InsuranceAmount'])),
                    _FieldData("Insurance Company", _formatValue(_data!['inscmpy'])),
                    _FieldData("Policy", _formatValue(_data!['policy'])),
                    _FieldData("Insurance Issue Date", _formatValue(_data!['insissuedate'])),
                    _FieldData("Insurance Amt", _formatValue(_data!['insamt'])),
                    _FieldData("Insurance Type", _formatValue(_data!['instype'])),
                    _FieldData("Insurance Showroom", _formatValue(_data!['insshowroom'])),
                    _FieldData("Previous Insurance Amt", _formatValue(_data!['preinsamt'])),
                    _FieldData("NCB", _formatValue(_data!['NCB'])),
                  ],
                ),
                _buildSection(
                  title: "Financial Details",
                  icon: Icons.account_balance_rounded,
                  iconColor: const Color(0xFFEF4444),
                  fields: [
                    _FieldData("Net Amount", _formatValue(_data!['netamount'])),
                    _FieldData("Less of All Encashment Scheme", _formatValue(_data!['lessofallencashmentschemne'])),
                    _FieldData("Hypothecation", _formatValue(_data!['hypothecationname'])),
                    _FieldData("Bank Name", _formatValue(_data!['bankname'])),
                    _FieldData("Bank Amount", _formatValue(_data!['bankamt'])),
                    _FieldData("Finance Amount", _formatValue(_data!['financeamt'])),
                    _FieldData("Finance Type", _formatValue(_data!['financetype'])),
                    _FieldData("Bank Due", _formatValue(_data!['bankdue'])),
                    _FieldData("Customer Due", _formatValue(_data!['custdue'])),
                    _FieldData("Customer Receive", _formatValue(_data!['crecive'])),
                    _FieldData("Finance Receive", _formatValue(_data!['freceive'])),
                    _FieldData("RC Amount", _formatValue(_data!['rcamt'])),
                    _FieldData("Balance", _formatValue(_data!['bal'])),
                  ],
                ),
                _buildSection(
                  title: "Customer Information",
                  icon: Icons.person_rounded,
                  iconColor: const Color(0xFF6366F1),
                  fields: [
                    _FieldData("Address", _formatValue(_data!['address'])),
                    _FieldData("Father Name", _formatValue(_data!['fathername'])),
                    _FieldData("Mobile No", _formatValue(_data!['mobileno'])),
                    _FieldData("Aadhar Card", _formatValue(_data!['aadharcard'])),
                    _FieldData("PAN No", _formatValue(_data!['panno'])),
                    _FieldData("Nominee Name", _formatValue(_data!['nomineename'])),
                    _FieldData("Age", _formatValue(_data!['age'])),
                    _FieldData("Relation", _formatValue(_data!['relation'])),
                    _FieldData("GSTIN", _formatValue(_data!['gstin'])),
                    _FieldData("Title", _formatValue(_data!['title'])),
                  ],
                ),
                const SizedBox(height: 100), // Space for buttons
              ],
            ),
          ),
        ),
        _buildActionButtons(),
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
                    : const Text("Reject"),
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
                    : const Text("Approve"),
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

    setState(() {
      _processing = true;
    });

    try {
      // Prepare data for approval - map display fields back to sp_ fields
      final approvalData = _prepareDataForSubmission(_data!);
      
      final result = await ApiService.approveChallan(approvalData);
      
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          content: Text(result['message'] ?? 'Challan approved successfully'),
        ),
      );

      // Navigate back to grid
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
      if (mounted) {
        setState(() {
          _processing = false;
        });
      }
    }
  }

  Future<void> _onReject() async {
    if (_data == null) return;

    // Show dialog to get reject remark
    final remark = await showDialog<String>(
      context: context,
      builder: (context) => _RejectDialog(),
    );

    if (remark == null || remark.isEmpty) return;

    setState(() {
      _processing = true;
    });

    try {
      // Prepare data for rejection - map display fields back to sp_ fields
      final rejectionData = _prepareDataForSubmission(_data!);
      
      final result = await ApiService.rejectChallan(
        rejectionData,
        remark,
      );
      
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          content: Text(result['message'] ?? 'Challan rejected successfully'),
        ),
      );

      // Navigate back to grid
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
      if (mounted) {
        setState(() {
          _processing = false;
        });
      }
    }
  }

  /// Prepares data for submission by ensuring sp_462 exists
  Map<String, dynamic> _prepareDataForSubmission(Map<String, dynamic> data) {
    // Return the data as-is since the backend expects the same format
    // that was returned from the edit endpoint
    print("📦 Preparing data for submission");
    print("📦 Data keys: ${data.keys.toList()}");
    print("📦 sp_462 value: ${data['sp_462']}");
    print("📦 unq value: ${data['unq']}");
    
    return data;
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<_FieldData> fields,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 1),
      decoration: const BoxDecoration(
        color: _cardBg,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: _textDark,
            ),
          ),
          initiallyExpanded: title == "Basic Information",
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: fields.map((field) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            field.label,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: _textMid,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 3,
                          child: Text(
                            field.value,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: _textDark,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldData {
  final String label;
  final String value;

  _FieldData(this.label, this.value);
}

class _RejectDialog extends StatefulWidget {
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: const Row(
        children: [
          Icon(Icons.warning_rounded, color: Color(0xFFEF4444)),
          SizedBox(width: 12),
          Text(
            "Reject Challan",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Please provide a reason for rejection:",
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _remarkController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "Enter rejection reason...",
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
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            if (_remarkController.text.trim().isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Please enter a rejection reason"),
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
          child: const Text("Reject"),
        ),
      ],
    );
  }
}

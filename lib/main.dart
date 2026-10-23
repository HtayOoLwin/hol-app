import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const KyatthaApp());

class KyatthaApp extends StatelessWidget {
  const KyatthaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KG to Kyattha Calculator',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF176B56)),
        scaffoldBackgroundColor: const Color(0xFFF6F8F7),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  static const double kyatthaPerKg = 63.0; // Custom business rate
  final _kgController = TextEditingController(text: '1');
  final _amountController = TextEditingController(text: '30000');
  final _targetController = TextEditingController(text: '10');

  double? _number(String value) => double.tryParse(value.replaceAll(',', '').trim());

  double? get _totalKyattha {
    final kg = _number(_kgController.text);
    if (kg == null || kg <= 0) return null;
    return kg * kyatthaPerKg;
  }

  double? get _pricePerKyattha {
    final amount = _number(_amountController.text);
    final total = _totalKyattha;
    if (amount == null || amount < 0 || total == null) return null;
    return amount / total;
  }

  double? get _result {
    final target = _number(_targetController.text);
    final unitPrice = _pricePerKyattha;
    if (target == null || target <= 0 || unitPrice == null) return null;
    return unitPrice * target;
  }

  String _format(double? number, {int decimals = 2}) {
    if (number == null || !number.isFinite) return '—';
    final parts = number.toStringAsFixed(decimals).split('.');
    final digits = parts[0];
    final out = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) out.write(',');
      out.write(digits[i]);
    }
    return decimals == 0 ? out.toString() : '${out.toString()}.${parts[1]}';
  }

  void _selectTarget(int value) {
    _targetController.text = value.toString();
    setState(() {});
  }

  void _reset() {
    _kgController.text = '1';
    _amountController.text = '30000';
    _targetController.text = '10';
    setState(() {});
  }

  @override
  void dispose() {
    _kgController.dispose();
    _amountController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  Widget _field(String label, TextEditingController controller, String suffix) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(suffixText: suffix),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final result = _result;
    return Scaffold(
      appBar: AppBar(
        title: const Text('KG to Kyattha Calculator'),
        backgroundColor: const Color(0xFFF6F8F7),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Card(
              color: const Color(0xFFE2F2EB),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Custom Conversion', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Text('1 KG = 63 ကျပ်သား', style: Theme.of(context).textTheme.titleLarge),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _field('Weight', _kgController, 'KG'),
            const SizedBox(height: 16),
            _field('Total Amount', _amountController, 'MMK'),
            const SizedBox(height: 8),
            const Text('ထည့်ထားသော KG အားလုံး၏ စုစုပေါင်းတန်ဖိုး',
                style: TextStyle(color: Colors.black54, fontSize: 12)),
            const SizedBox(height: 20),
            _field('Calculate Price For', _targetController, 'ကျပ်သား'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [5, 10, 25, 50, 100].map((value) {
                return ChoiceChip(
                  label: Text('$value'),
                  selected: _number(_targetController.text) == value,
                  onSelected: (_) => _selectTarget(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 0,
              color: const Color(0xFFE2F2EB),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('ကျသင့်ငွေ', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text('${_format(result)} MMK',
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold,
                              color: Color(0xFF176B56))),
                    ),
                    const Divider(height: 28),
                    Text('စုစုပေါင်း ကျပ်သား: ${_format(_totalKyattha)}'),
                    const SizedBox(height: 6),
                    Text('1 ကျပ်သားဈေး: ${_format(_pricePerKyattha)} MMK'),
                    if (result == null) ...[
                      const SizedBox(height: 10),
                      const Text('KG, Amount နှင့် ကျပ်သားကို မှန်ကန်စွာ ထည့်ပါ။',
                          style: TextStyle(color: Colors.red)),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _reset,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: result == null ? null : () async {
                      await Clipboard.setData(ClipboardData(text:
                        '${_targetController.text} ကျပ်သား = ${_format(result)} MMK'));
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Result copied')),
                      );
                    },
                    icon: const Icon(Icons.copy),
                    label: const Text('Copy Result'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

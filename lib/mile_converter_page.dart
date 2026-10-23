import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MileConverterPage extends StatefulWidget {
  const MileConverterPage({super.key});

  @override
  State<MileConverterPage> createState() => _MileConverterPageState();
}

class _MileConverterPageState extends State<MileConverterPage> {
  static const double kilometersPerMile = 1.609344;
  final TextEditingController _input = TextEditingController(text: '10');
  bool _mileToKm = true;

  double? get _result {
    final value = double.tryParse(_input.text.replaceAll(',', '').trim());
    if (value == null || !value.isFinite || value < 0) return null;
    return _mileToKm ? value * kilometersPerMile : value / kilometersPerMile;
  }

  String _format(double value) {
    final fixed = value.toStringAsFixed(4);
    return fixed.replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
  }

  void _swap() {
    setState(() {
      final result = _result;
      _mileToKm = !_mileToKm;
      if (result != null) _input.text = _format(result);
    });
  }

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final result = _result;
    final source = _mileToKm ? 'Mile' : 'Kilometer';
    final target = _mileToKm ? 'Kilometer' : 'Mile';
    final sourceUnit = _mileToKm ? 'mi' : 'km';
    final targetUnit = _mileToKm ? 'km' : 'mi';
    return Scaffold(
      appBar: AppBar(title: const Text('Mile to Kilometer')),
      body: SafeArea(
        child: ListView(padding: const EdgeInsets.all(20), children: [
          Card(
            elevation: 0,
            color: const Color(0xFFEEE8FF),
            child: Padding(padding: const EdgeInsets.all(20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Distance Conversion', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('1 mile = 1.609344 kilometers', style: Theme.of(context).textTheme.titleMedium),
              ]),
            ),
          ),
          const SizedBox(height: 24),
          Text('From ($source)', style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            controller: _input,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(suffixText: sourceUnit, hintText: 'Enter distance'),
          ),
          const SizedBox(height: 16),
          Center(child: IconButton.filledTonal(
            tooltip: 'Swap units',
            onPressed: _swap,
            icon: const Icon(Icons.swap_vert),
          )),
          const SizedBox(height: 16),
          Text('To ($target)', style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            color: const Color(0xFFEEE8FF),
            child: Padding(padding: const EdgeInsets.all(22),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Converted Distance', style: TextStyle(color: Colors.black54)),
                const SizedBox(height: 9),
                FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerLeft,
                  child: Text(result == null ? '—' : '${_format(result)} $targetUnit',
                    style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF6840CD))),
                ),
                if (result == null) const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text('Please enter a valid non-negative number.', style: TextStyle(color: Colors.red)),
                ),
              ]),
            ),
          ),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(child: OutlinedButton.icon(
              onPressed: () => setState(() { _input.text = '10'; _mileToKm = true; }),
              icon: const Icon(Icons.refresh), label: const Text('Reset'),
            )),
            const SizedBox(width: 12),
            Expanded(child: FilledButton.icon(
              onPressed: result == null ? null : () async {
                await Clipboard.setData(ClipboardData(text: '${_input.text} $sourceUnit = ${_format(result)} $targetUnit'));
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Result copied')));
              },
              icon: const Icon(Icons.copy), label: const Text('Copy Result'),
            )),
          ]),
        ]),
      ),
    );
  }
}

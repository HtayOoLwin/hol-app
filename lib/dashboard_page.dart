import 'package:flutter/material.dart';

import 'main.dart';
import 'mile_converter_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HOL Converter')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 12),
            Text('Hello there!', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text('What would you like to convert?', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text('Choose a converter to get started.', style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 30),
            _ConverterCard(
              icon: Icons.scale_outlined,
              title: 'KG to Kyattha',
              subtitle: 'Weight & price calculator',
              detail: '1 KG = 63 ကျပ်သား (custom)',
              color: const Color(0xFFEEE8FF),
              onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const CalculatorPage())),
            ),
            const SizedBox(height: 16),
            _ConverterCard(
              icon: Icons.route_outlined,
              title: 'Mile to Kilometer',
              subtitle: 'Distance converter',
              detail: '1 mile = 1.609344 km',
              color: const Color(0xFFE9EEFF),
              onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const MileConverterPage())),
            ),
            const SizedBox(height: 30),
            const Center(child: Text('More converters coming soon', style: TextStyle(color: Colors.black45))),
          ],
        ),
      ),
    );
  }
}

class _ConverterCard extends StatelessWidget {
  const _ConverterCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.detail,
    required this.color,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final String detail;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.deepPurple.withValues(alpha: .12)),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(children: [
            Container(
              width: 60, height: 60,
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(18)),
              child: Icon(icon, size: 30, color: const Color(0xFF6840CD)),
            ),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text(subtitle, style: const TextStyle(color: Colors.black54)),
              const SizedBox(height: 7),
              Text(detail, style: const TextStyle(color: Color(0xFF6840CD), fontSize: 12, fontWeight: FontWeight.w600)),
            ])),
            const Icon(Icons.chevron_right, color: Color(0xFF6840CD)),
          ]),
        ),
      ),
    );
  }
}

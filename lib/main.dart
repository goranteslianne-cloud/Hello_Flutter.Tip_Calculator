
import 'package:flutter/material.dart';

void main() {
  runApp(const TipApp());
}

double? parseBill(String input) {
  return double.tryParse(input.trim());
}

({double tip, double total}) computeTip(double bill, int percent) {
  final tip = bill * percent / 100;
  return (tip: tip, total: bill + tip);
}

class TipApp extends StatelessWidget {
  const TipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tip Calculator',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const TipPage(),
    );
  }
}

class TipPage extends StatefulWidget {
  const TipPage({super.key});

  @override
  State<TipPage> createState() => _TipPageState();
}

class _TipPageState extends State<TipPage> {
  final TextEditingController billController = TextEditingController();

  int selectedPercent = 15;
  double? tip;
  double? total;
  String message = '';

  void calculateTip() {
    final bill = parseBill(billController.text);

    if (bill == null || bill < 0) {
      setState(() {
        message = 'Please enter a valid amount';
        tip = null;
        total = null;
      });
      return;
    }

    final result = computeTip(bill, selectedPercent);

    setState(() {
      tip = result.tip;
      total = result.total;
      message = '';
    });
  }

  void resetCalculator() {
    setState(() {
      billController.clear();
      selectedPercent = 15;
      tip = null;
      total = null;
      message = '';
    });
  }

  @override
  void dispose() {
    billController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tip Calculator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: resetCalculator,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: billController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              onChanged: (_) => calculateTip(),
              decoration: const InputDecoration(
                labelText: 'Enter Bill Amount',
                border: OutlineInputBorder(),
                prefixText: '₱',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Tip Percentage',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: [10, 15, 20].map((percent) {
                return ChoiceChip(
                  label: Text('$percent%'),
                  selected: selectedPercent == percent,
                  onSelected: (_) {
                    setState(() {
                      selectedPercent = percent;
                    });
                    calculateTip();
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 25),
            Center(
              child: ElevatedButton(
                onPressed: calculateTip,
                child: const Text('Calculate'),
              ),
            ),
            const SizedBox(height: 25),
            if (message.isNotEmpty)
              Text(
                message,
                style: const TextStyle(color: Colors.red, fontSize: 18),
              ),
            if (tip != null && total != null) ...[
              Text(
                'Tip: ₱${tip!.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),
              Text(
                'Total: ₱${total!.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}


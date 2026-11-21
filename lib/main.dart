import 'package:flutter/material.dart';

void main() => runApp(const TipApp());

class TipApp extends StatelessWidget {
  const TipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tip Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFB6C1),
        ),
        scaffoldBackgroundColor: const Color(0xFFFFF5F7),
        useMaterial3: true,
      ),
      home: const TipPage(),
    );
  }
}

double? parseBill(String input) => double.tryParse(input.trim());

({double tip, double total}) computeTip(double bill, int percent) {
  final tip = bill * percent / 100;
  return (tip: tip, total: bill + tip);
}

class TipPage extends StatefulWidget {
  const TipPage({super.key});

  @override
  State<TipPage> createState() => _TipPageState();
}

class _TipPageState extends State<TipPage> {
  static int _lastTipPercent = 15;

  final _billController = TextEditingController();
  late int _selectedPercent = _lastTipPercent;
  int _splitCount = 1;

  @override
  void dispose() {
    _billController.dispose();
    super.dispose();
  }

  void _updateSplitCount(int delta) {
    setState(() {
      final next = _splitCount + delta;
      if (next >= 1) {
        _splitCount = next;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final parsedBill = parseBill(_billController.text);
    final tipData =
        parsedBill != null ? computeTip(parsedBill, _selectedPercent) : null;
    final perPerson = tipData != null ? tipData.total / _splitCount : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tip Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _billController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Bill Amount',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 20),
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 10, label: Text('10%')),
                ButtonSegment(value: 15, label: Text('15%')),
                ButtonSegment(value: 20, label: Text('20%')),
              ],
              selected: {_selectedPercent},
              onSelectionChanged: (newSelection) {
                setState(() {
                  _selectedPercent = newSelection.first;
                  _lastTipPercent = _selectedPercent;
                });
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Split between: $_splitCount ${_splitCount == 1 ? 'person' : 'people'}',
                  style: const TextStyle(fontSize: 16),
                ),
                Row(
                  children: [
                    IconButton.filledTonal(
                      onPressed: _splitCount > 1 ? () => _updateSplitCount(-1) : null,
                      icon: const Icon(Icons.remove),
                      tooltip: 'Decrease people',
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        '$_splitCount',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton.filledTonal(
                      onPressed: () => _updateSplitCount(1),
                      icon: const Icon(Icons.add),
                      tooltip: 'Increase people',
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            if (parsedBill == null || tipData == null || perPerson == null)
              const Text(
                'Enter a valid amount',
                style: TextStyle(color: Colors.red, fontSize: 16),
              )
            else ...[
              Text(
                'Tip: ${tipData.tip.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'Total: ${tipData.total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Per Person: ${perPerson.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
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
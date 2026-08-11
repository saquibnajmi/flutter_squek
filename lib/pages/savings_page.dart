import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class SavingsPage extends StatefulWidget {
  const SavingsPage({super.key});

  @override
  State<SavingsPage> createState() => _SavingsPageState();
}

class _SavingsPageState extends State<SavingsPage> {
  final List<Map<String, dynamic>> _entries = [
    {
      'title': 'Snacks',
      'date': DateTime(2026, 8, 6),
      'amount': 50.0,
      'positive': false,
    },
    {
      'title': 'Reimbursement',
      'date': DateTime(2026, 7, 2),
      'amount': 79000.0,
      'positive': true,
    },
    {
      'title': 'Salary',
      'date': DateTime(2026, 7, 2),
      'amount': 50000.0,
      'positive': true,
    },
  ];

  final _currencyFormat = NumberFormat('#,##0.##');

  Widget _transactionTile(BuildContext context, Map<String, dynamic> e) {
    final w = MediaQuery.of(context).size.width;
    final titleStyle = TextStyle(
      fontSize: w > 600 ? 18 : 16,
      fontWeight: FontWeight.w600,
    );
    final amountStyle = TextStyle(
      fontSize: w > 600 ? 20 : 18,
      fontWeight: FontWeight.bold,
      color: e['positive'] ? Colors.green : Colors.red,
    );

    final dateStr = DateFormat('d MMMM yyyy').format(e['date'] as DateTime);
    final amountStr = _currencyFormat.format(e['amount']);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          const BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.03),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e['title'] as String, style: titleStyle),
                const SizedBox(height: 6),
                Text(dateStr, style: TextStyle(color: Colors.grey.shade600)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Row(
            children: [
              Text(amountStr, style: amountStyle),
              const SizedBox(width: 6),
              Icon(
                e['positive'] ? Icons.arrow_upward : Icons.arrow_downward,
                color: e['positive'] ? Colors.green : Colors.red,
                size: w > 600 ? 20 : 18,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChart() {
    if (_entries.isEmpty) return const Center(child: Text('No data to display'));

    // Use oldest -> newest order for X axis
    final data = _entries.reversed.toList();
    double cum = 0.0;
    final spots = <FlSpot>[];
    for (var i = 0; i < data.length; i++) {
      final e = data[i];
      final amt = (e['amount'] as num).toDouble();
      cum += (e['positive'] ? amt : -amt);
      spots.add(FlSpot(i.toDouble(), cum));
    }

    final ys = spots.map((s) => s.y).toList();
    double minY = ys.reduce((a, b) => math.min(a, b));
    double maxY = ys.reduce((a, b) => math.max(a, b));
    final range = (maxY - minY).abs();
    final pad = range == 0 ? (maxY.abs() * 0.1 + 10) : range * 0.2;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true, horizontalInterval: (range == 0 ? 10 : range / 4)),
          titlesData: FlTitlesData(
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 40, interval: (range == 0 ? 10 : range / 4)),
            ),
          ),
          minY: minY - pad,
          maxY: maxY + pad,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              barWidth: 2,
              color: Colors.blue,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(show: true, color: Colors.blue.withAlpha(38)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openAddEntrySheet() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: _AddEntryForm(),
      ),
    );

    if (result != null) {
      setState(() {
        _entries.insert(0, result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Saving'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      backgroundColor: const Color(0xFFF3F3F3),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final chartHeight = constraints.maxHeight * 0.32;
          final small = constraints.maxWidth < 420;
          return Padding(
            padding: EdgeInsets.all(small ? 8 : 12),
            child: Column(
              children: [
                Container(
                  height: chartHeight.clamp(160.0, 420.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _buildChart(),
                ),
                SizedBox(height: small ? 8 : 12),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 12),
                    itemCount: _entries.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'RECENT',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              letterSpacing: 1,
                            ),
                          ),
                        );
                      }
                      final e = _entries[index - 1];
                      return _transactionTile(context, e);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddEntrySheet,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _AddEntryForm extends StatefulWidget {
  @override
  State<_AddEntryForm> createState() => _AddEntryFormState();
}

class _AddEntryFormState extends State<_AddEntryForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _positive = false; // income when true
  String _category = 'Shopping';
  String _subCategory = 'Clothes';

  @override
  void dispose() {
    _amountCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (d != null) setState(() => _selectedDate = d);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final amount = double.tryParse(_amountCtrl.text.replaceAll(',', '')) ?? 0.0;
    final entry = {
      'title': _descCtrl.text.isEmpty ? (_positive ? 'Income' : 'Expense') : _descCtrl.text,
      'date': _selectedDate,
      'amount': amount,
      'positive': _positive,
      'category': _category,
      'subCategory': _subCategory,
    };
    Navigator.of(context).pop(entry);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChoiceChip(
                    label: const Text('EXPENSE'),
                    selected: !_positive,
                    onSelected: (v) => setState(() => _positive = !v ? _positive : false),
                    selectedColor: Colors.red.shade100,
                  ),
                  const SizedBox(width: 12),
                  ChoiceChip(
                    label: const Text('INCOME'),
                    selected: _positive,
                    onSelected: (v) => setState(() => _positive = v),
                    selectedColor: Colors.green.shade100,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountCtrl,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Amount'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Enter amount';
                  if (double.tryParse(v.replaceAll(',', '')) == null) return 'Invalid number';
                  return null;
                },
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text('Date: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}'),
                  ),
                  TextButton(onPressed: _pickDate, child: const Text('Pick')),
                ],
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _category,
                items: ['Shopping', 'Food', 'Travel', 'Income']
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _category = v ?? _category),
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _subCategory,
                items: ['Clothes', 'Snacks', 'Dinner', 'Rent']
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _subCategory = v ?? _subCategory),
                decoration: const InputDecoration(labelText: 'Sub - Category'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                      child: const Text('SAVE'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('CANCEL'),
                  )
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

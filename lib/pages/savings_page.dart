import 'package:flutter/material.dart';

class SavingsPage extends StatelessWidget {
  const SavingsPage({super.key});

  Widget _transactionTile(
    BuildContext context,
    String title,
    String date,
    String amount, {
    bool positive = false,
  }) {
    final w = MediaQuery.of(context).size.width;
    final titleStyle = TextStyle(
      fontSize: w > 600 ? 18 : 16,
      fontWeight: FontWeight.w600,
    );
    final amountStyle = TextStyle(
      fontSize: w > 600 ? 20 : 18,
      fontWeight: FontWeight.bold,
      color: positive ? Colors.green : Colors.red,
    );

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
                Text(title, style: titleStyle),
                const SizedBox(height: 6),
                Text(date, style: TextStyle(color: Colors.grey.shade600)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Row(
            children: [
              Text(amount, style: amountStyle),
              const SizedBox(width: 6),
              Icon(
                positive ? Icons.arrow_upward : Icons.arrow_downward,
                color: positive ? Colors.green : Colors.red,
                size: w > 600 ? 20 : 18,
              ),
            ],
          ),
        ],
      ),
    );
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
                  child: const Center(child: Text('Savings chart placeholder')),
                ),
                SizedBox(height: small ? 8 : 12),
                Expanded(
                  child: ListView(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'AUGUST',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      _transactionTile(
                        context,
                        'Snacks',
                        '6 August 2026',
                        '50',
                      ),
                      _transactionTile(context, 'Lunch', '5 August 2026', '50'),
                      _transactionTile(
                        context,
                        'Dinner',
                        '4 August 2026',
                        '50',
                      ),
                      _transactionTile(
                        context,
                        'Travel',
                        '4 August 2026',
                        '50',
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'JULY',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      _transactionTile(
                        context,
                        'Hotel charge',
                        '4 July 2026',
                        '54,160',
                      ),
                      _transactionTile(
                        context,
                        'Reimbursement',
                        '2 July 2026',
                        '79,000',
                        positive: true,
                      ),
                      _transactionTile(
                        context,
                        'Salary',
                        '2 July 2026',
                        '50,000',
                        positive: true,
                      ),
                      _transactionTile(
                        context,
                        'Breakfast',
                        '1 July 2026',
                        '50',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_theme.dart';
import '../../application/dashboard_notifier.dart';
import '../../application/transactions_list_notifier.dart';
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    
    return Scaffold(
      backgroundColor: theme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Balance',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.primary,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Consumer(
                  builder: (context, ref, child) {
                    final txs = ref.watch(transactionsListNotifierProvider);
                    double income = 0;
                    double expenses = 0;
                    
                    for (var tx in txs) {
                      if (tx.amount > 0) income += tx.amount;
                      if (tx.amount < 0) expenses += tx.amount.abs();
                    }
                    
                    final balance = income - expenses;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '₹ ${balance.toStringAsFixed(0)}',
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildSummaryColumn('Income', '₹ ${income.toStringAsFixed(0)}', theme.accent),
                            _buildSummaryColumn('Expenses', '₹ ${expenses.toStringAsFixed(0)}', Colors.white70),
                          ],
                        ),
                      ],
                    );
                  }
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Spending Analytics',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Container(
                 height: 200,
                 width: double.infinity,
                 padding: const EdgeInsets.only(top: 24, bottom: 8, left: 8, right: 8),
                 decoration: BoxDecoration(
                   color: Colors.white,
                   borderRadius: BorderRadius.circular(24),
                 ),
                 child: ref.watch(dashboardNotifierProvider).when(
                   data: (data) => _buildBarChart(data, theme),
                   loading: () => const Center(child: CircularProgressIndicator()),
                   error: (e, s) => const Center(child: Text('Failed to load chart')),
                 ),
               ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBarChart(List<DailySpend> data, AppTheme theme) {
    return BarChart(
      BarChartData(
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          show: true,
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    days[(value.toInt() - 1) % 7], // Corrected index bounds mathematically safe.
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                );
              },
            ),
          ),
        ),
        barGroups: data.map((aggregate) {
          return BarChartGroupData(
            x: aggregate.weekday,
            barRods: [
              BarChartRodData(
                toY: aggregate.amount,
                color: theme.secondary,
                width: 16,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSummaryColumn(String label, String amount, Color amountColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          style: TextStyle(color: amountColor, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

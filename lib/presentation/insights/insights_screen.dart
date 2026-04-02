import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_theme.dart';
import '../../application/insights_notifier.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    final limits = ref.watch(insightsNotifierProvider);

    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        title: const Text('Insights'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: limits.when(
        data: (matrix) => SingleChildScrollView(
           padding: const EdgeInsets.all(24),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Text('Spending by Category', style: Theme.of(context).textTheme.titleLarge),
               const SizedBox(height: 32),
               SizedBox(
                 height: 250,
                 child: _buildPieChart(matrix.categoryDistribution, theme),
               ),
               const SizedBox(height: 48),
               Text('6-Month Trend', style: Theme.of(context).textTheme.titleLarge),
               const SizedBox(height: 24),
               SizedBox(
                 height: 250,
                 child: _buildTrendBarChart(matrix.monthlyTrend, theme),
               ),
               const SizedBox(height: 80), // Fab spacing
             ],
           ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error compiling bounds: $e')),
      ),
    );
  }

  Widget _buildPieChart(Map<String, double> dist, AppTheme theme) {
    if (dist.isEmpty) return const Center(child: Text('No transactions mapped.'));
    
    Color getColor(String category) {
      switch (category) {
        case 'Transport': return const Color(0xFF006C4B);
        case 'Food': return const Color(0xFF1E1B4B);
        case 'Shopping': return const Color(0xFF64F9BC);
        default: return const Color(0xFFF8F9FA);
      }
    }

    return PieChart(
      PieChartData(
        sectionsSpace: 0,
        centerSpaceRadius: 60,
        sections: dist.entries.map((e) => PieChartSectionData(
          color: getColor(e.key),
          value: e.value,
          title: '₹${e.value.toInt()}',
          radius: 40,
          titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
        )).toList(),
      ),
    );
  }

  Widget _buildTrendBarChart(Map<int, double> trend, AppTheme theme) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          show: true,
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    value.toInt().toString(), // Lazy month rendering representation
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                );
              },
            ),
          ),
        ),
        barGroups: trend.entries.map((e) => BarChartGroupData(
          x: e.key,
          barRods: [
            BarChartRodData(
              toY: e.value,
              color: theme.primary,
              width: 16,
              borderRadius: BorderRadius.circular(4),
            )
          ],
        )).toList(),
      ),
    );
  }
}

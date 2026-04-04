import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/currency_formatter.dart';
import '../../application/insights_notifier.dart';
import '../../application/transactions_list_notifier.dart';
import '../transactions/widgets/transaction_icon.dart';
import '../widgets/ai_coach_bottom_sheet.dart';
import '../widgets/shimmer_loading.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    final colorScheme = Theme.of(context).colorScheme;
    final limits = ref.watch(insightsNotifierProvider);
    final txs = ref.watch(transactionsListNotifierProvider);

    // Calculate totals
    double totalIncome = 0;
    double totalExpenses = 0;
    double thisWeekSpend = 0;
    double lastWeekSpend = 0;

    final now = DateTime.now();
    final startOfThisWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfLastWeek = startOfThisWeek.subtract(const Duration(days: 7));

    for (final tx in txs) {
      if (tx.amount > 0) totalIncome += tx.amount;
      if (tx.amount < 0) totalExpenses += tx.amount.abs();

      if (tx.amount < 0) {
        final txDate = DateTime(tx.date.year, tx.date.month, tx.date.day);
        final weekStart = DateTime(startOfThisWeek.year, startOfThisWeek.month, startOfThisWeek.day);
        final lastWeekStart = DateTime(startOfLastWeek.year, startOfLastWeek.month, startOfLastWeek.day);

        if (!txDate.isBefore(weekStart)) {
          thisWeekSpend += tx.amount.abs();
        } else if (!txDate.isBefore(lastWeekStart) && txDate.isBefore(weekStart)) {
          lastWeekSpend += tx.amount.abs();
        }
      }
    }

    // Week comparison
    double weekChange = 0;
    bool spendingDecreased = true;
    if (lastWeekSpend > 0) {
      weekChange = ((thisWeekSpend - lastWeekSpend) / lastWeekSpend * 100).abs();
      spendingDecreased = thisWeekSpend <= lastWeekSpend;
    }

    // Wealth momentum
    final bool positiveMomentum = totalIncome > totalExpenses;
    final double momentumPercent = totalIncome > 0
        ? ((totalIncome - totalExpenses) / totalIncome * 100)
        : 0;

    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/app_icon.png', width: 28, height: 28),
            const SizedBox(width: 8),
            Text(
              'Flo',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                letterSpacing: -0.5,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: limits.when(
        data: (matrix) => SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // A. Portfolio Analytics Header
              Text(
                'PORTFOLIO ANALYTICS',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Your Spending\nThis Month',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  Text(
                    CurrencyFormatter.formatINR(totalExpenses),
                    style: TextStyle(
                      color: theme.primary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // B. Category Breakdown
              Text(
                'Category Breakdown',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Top spending categories this month',
                style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13),
              ),
              const SizedBox(height: 16),
              _buildCategoryBars(matrix.categoryDistribution, totalExpenses, theme),
              const SizedBox(height: 24),

              // B2. Most Frequent Card
              _buildMostFrequentCard(txs, theme, colorScheme),

              // C. Week Comparison Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1B4B),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Week Comparison',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'This week vs Last week',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 13),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          spendingDecreased ? Icons.arrow_upward : Icons.arrow_downward,
                          color: spendingDecreased ? const Color(0xFF64F9BC) : Colors.redAccent,
                          size: 28,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${weekChange.toStringAsFixed(1)}%',
                          style: TextStyle(
                            color: spendingDecreased ? const Color(0xFF64F9BC) : Colors.redAccent,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      spendingDecreased ? 'Lower than previous week 🎉' : 'Higher than previous week',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // D. Top Spending Highlight
              _buildTopSpendingCard(matrix.categoryDistribution, theme, colorScheme),
              const SizedBox(height: 24),

              // E. Wealth Momentum Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1B4B),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            positiveMomentum
                                ? 'Your wealth momentum is positive (+${momentumPercent.toStringAsFixed(1)}%)'
                                : 'Your wealth momentum needs attention',
                            style: TextStyle(
                              color: positiveMomentum ? const Color(0xFF64F9BC) : Colors.redAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            positiveMomentum
                                ? 'Keep it up! You\'re building wealth.'
                                : 'Expenses exceed income this period.',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.show_chart,
                      color: positiveMomentum ? const Color(0xFF64F9BC) : Colors.redAccent,
                      size: 32,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // 6-Month Trend Chart
              Text('6-Month Trend', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Container(
                height: 200,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: colorScheme.shadow.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: _buildTrendBarChart(matrix.monthlyTrend, theme),
              ),
              const SizedBox(height: 32),

              // F. AI Coach Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [BoxShadow(color: colorScheme.shadow.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Financial Sanctuary Coach',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Get personalized advice based on your spending patterns',
                      style: TextStyle(color: theme.onSurfaceVariant, fontSize: 13),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF64F9BC),
                          foregroundColor: const Color(0xFF1E1B4B),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => const AiCoachBottomSheet(),
                          );
                        },
                        icon: const Icon(Icons.auto_awesome, size: 20),
                        label: const Text('Ask AI Coach', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
        loading: () => const InsightsShimmer(),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildCategoryBars(Map<String, double> dist, double total, AppTheme theme) {
    if (dist.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.pie_chart_outline, size: 48, color: theme.onSurfaceVariant),
              const SizedBox(height: 12),
              Text('No spending data yet', style: TextStyle(color: theme.onSurfaceVariant)),
            ],
          ),
        ),
      );
    }

    // Only show expenses (negative amounts become positive in the dist)
    final sorted = dist.entries.where((e) => e.value < 0).toList()
      ..sort((a, b) => a.value.compareTo(b.value)); // most negative first
    final top5 = sorted.take(5).toList();
    final maxAmt = top5.isNotEmpty ? top5.first.value.abs() : 1.0;

    return Column(
      children: top5.map((entry) {
        final amt = entry.value.abs();
        final fraction = maxAmt > 0 ? (amt / maxAmt).clamp(0.0, 1.0) : 0.0;
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            children: [
              Row(
                children: [
                  TransactionIcon(category: entry.key),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.w600)),
                  ),
                  Text(
                    CurrencyFormatter.formatINR(amt),
                    style: TextStyle(fontWeight: FontWeight.bold, color: theme.onBackground),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: fraction,
                  minHeight: 6,
                  backgroundColor: theme.onSurfaceVariant.withValues(alpha: 0.15),
                  valueColor: AlwaysStoppedAnimation<Color>(theme.secondary),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTopSpendingCard(Map<String, double> dist, AppTheme theme, ColorScheme colorScheme) {
    if (dist.isEmpty) return const SizedBox();

    final sorted = dist.entries.where((e) => e.value < 0).toList()
      ..sort((a, b) => a.value.compareTo(b.value));
    if (sorted.isEmpty) return const SizedBox();

    final top = sorted.first;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: const Border(left: BorderSide(color: Color(0xFF64F9BC), width: 4)),
        boxShadow: [BoxShadow(color: colorScheme.shadow.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TOP SPENDING',
            style: TextStyle(
              color: theme.onSurfaceVariant,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              TransactionIcon(category: top.key),
              const SizedBox(width: 12),
              Expanded(
                child: Text(top.key, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              Text(
                CurrencyFormatter.formatINR(top.value.abs()),
                style: TextStyle(
                  color: theme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrendBarChart(Map<int, double> trend, AppTheme theme) {
    final months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
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
                final idx = value.toInt();
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    idx > 0 && idx <= 12 ? months[idx] : '',
                    style: TextStyle(color: theme.onSurfaceVariant, fontSize: 11),
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
              toY: e.value.abs(),
              color: theme.secondary,
              width: 16,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        )).toList(),
      ),
    );
  }

  Widget _buildMostFrequentCard(
    List<dynamic> txs,
    AppTheme theme,
    ColorScheme colorScheme,
  ) {
    // Count expenses per category
    final Map<String, int> categoryCounts = {};
    for (final tx in txs) {
      if (tx.amount < 0) {
        categoryCounts[tx.category] = (categoryCounts[tx.category] ?? 0) + 1;
      }
    }

    if (categoryCounts.isEmpty) return const SizedBox();

    // Find most frequent
    final sorted = categoryCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top = sorted.first;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          TransactionIcon(category: top.key),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MOST FREQUENT',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  top.key,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${top.value} transactions this month',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

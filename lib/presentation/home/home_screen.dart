import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/currency_formatter.dart';
import '../../application/dashboard_notifier.dart';
import '../../application/transactions_list_notifier.dart';
import '../../domain/models/user_profile_model.dart';
import '../transactions/widgets/transaction_icon.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return 'Good morning';
    if (hour >= 12 && hour < 17) return 'Good afternoon';
    if (hour >= 17 && hour < 22) return 'Good evening';
    return 'Good night';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final check = DateTime(date.year, date.month, date.day);

    if (check == today) return 'Today';
    if (check == yesterday) return 'Yesterday';
    return DateFormat('dd MMM').format(date);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    
    final userProfileBox = Hive.box<UserProfile>('userProfileBox');
    final profile = userProfileBox.get('currentUser');
    final initials = profile?.name != null && profile!.name.isNotEmpty 
        ? (profile.name.length == 1 ? profile.name.toUpperCase() : profile.name.substring(0, 2).toUpperCase())
        : '';
        
    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/app_icon.png',
              width: 28,
              height: 28,
            ),
            const SizedBox(width: 8),
            Text(
              'Flo',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dynamic Greeting Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_getGreeting()},',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                      ),
                      Text(
                        '${profile?.name ?? 'User'} 👋',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      // Custom profile settings handler
                    },
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: theme.secondary.withValues(alpha: 0.1),
                      backgroundImage: profile?.profileImagePath != null ? FileImage(File(profile!.profileImagePath!)) : null,
                      child: profile?.profileImagePath == null 
                          ? Text(initials, style: TextStyle(color: theme.secondary, fontWeight: FontWeight.bold))
                          : null,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 24),

              Consumer(
                builder: (context, ref, child) {
                  final txs = ref.watch(transactionsListNotifierProvider);
                  double income = 0;
                  double expenses = 0;
                  
                  for (var tx in txs) {
                    if (tx.amount > 0) income += tx.amount;
                    if (tx.amount < 0) expenses += tx.amount.abs();
                  }
                  
                  final balance = income - expenses;
                  
                  // Sorting txs to get recent 3
                  final recentTxs = List.of(txs)..sort((a, b) => b.date.compareTo(a.date));
                  final lastThree = recentTxs.take(3).toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Total Balance Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: theme.primary,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Total Balance', style: TextStyle(color: Colors.white70, fontSize: 16)),
                            const SizedBox(height: 8),
                            Text(
                              CurrencyFormatter.formatINR(balance),
                              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Income and Expense Cards
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(backgroundColor: Colors.green.withValues(alpha: 0.1), radius: 20, child: const Icon(Icons.arrow_upward, color: Colors.green, size: 20)),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('Income', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                        Text(CurrencyFormatter.formatINR(income), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), overflow: TextOverflow.ellipsis),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(backgroundColor: Colors.red.withValues(alpha: 0.1), radius: 20, child: const Icon(Icons.arrow_downward, color: Colors.red, size: 20)),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('Expenses', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                        Text(CurrencyFormatter.formatINR(expenses), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), overflow: TextOverflow.ellipsis),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      
                      // Recent Transactions
                      if (lastThree.isNotEmpty) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Recent Transactions', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                            TextButton(
                              onPressed: () => context.go('/transactions'),
                              child: Text('VIEW ALL', style: TextStyle(color: theme.secondary, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...lastThree.map((tx) => Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 4))],
                          ),
                          child: Row(
                            children: [
                              TransactionIcon(category: tx.category),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(tx.category, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    const SizedBox(height: 4),
                                    Text(_formatDate(tx.date), style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                                  ],
                                ),
                              ),
                              Text(
                                '${tx.amount > 0 ? '+' : ''}${CurrencyFormatter.formatINR(tx.amount)}',
                                style: TextStyle(
                                  color: tx.amount > 0 ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )),
                        const SizedBox(height: 32),
                      ],
                    ],
                  );
                }
              ),

              Text(
                'Spending Analytics',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Container(
                 height: 200,
                 width: double.infinity,
                 padding: const EdgeInsets.only(top: 24, bottom: 8, left: 8, right: 8),
                 decoration: BoxDecoration(
                   color: Colors.white,
                   borderRadius: BorderRadius.circular(24),
                   boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
                 ),
                 child: ref.watch(dashboardNotifierProvider).when(
                   data: (data) => _buildBarChart(data, theme),
                   loading: () => const Center(child: CircularProgressIndicator()),
                   error: (e, s) => const Center(child: Text('Failed to load chart')),
                 ),
               ),
               const SizedBox(height: 80), // Fab spacing
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
                    days[(value.toInt() - 1) % 7], 
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
}

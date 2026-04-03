import 'package:hive/hive.dart';

part 'challenge_model.g.dart';

@HiveType(typeId: 2)
class Challenge extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String category;
  
  @HiveField(3)
  final double budgetLimit;
  
  @HiveField(4)
  final DateTime startDate;
  
  @HiveField(5)
  final DateTime endDate;

  Challenge({
    required this.id,
    required this.name,
    required this.category,
    required this.budgetLimit,
    required this.startDate,
    required this.endDate,
  });

  Challenge copyWith({
    String? id,
    String? name,
    String? category,
    double? budgetLimit,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return Challenge(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      budgetLimit: budgetLimit ?? this.budgetLimit,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}

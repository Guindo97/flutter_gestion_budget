import 'package:flutter/material.dart';
import '../main.dart';
import './app_colors.dart';

class ListRowDepense extends StatelessWidget {
  final Map<String, dynamic> depenseObj;
  final int index;

  const ListRowDepense({
    super.key,
    required this.depenseObj,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(depenseObj),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        homeScreenKey.currentState?.supprimerDepense(index);
      },
      background: Container(
        color: AppColors.errorColor,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        color: AppColors.backgroundLight,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.buttonBackground,
            foregroundColor: AppColors.buttonTextColor,
            child: Text('\$${depenseObj['amount'].toString()}'),
          ),
          title: Text(depenseObj['name'], style: const TextStyle(color: AppColors.primary)),
          subtitle: Text(
            '${depenseObj['category']} - ${depenseObj['date'].toString().split(' ')[0]}',
            style: const TextStyle(color: AppColors.secondary),
          ),
        ),
      ),
    );
  }
}

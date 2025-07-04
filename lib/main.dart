import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import '/custom_widget/list_row.dart';
import '/custom_widget/app_colors.dart';

// Clé globale pour la gestion de l'état
final GlobalKey<GestionBudgetHomeState> homeScreenKey = GlobalKey<GestionBudgetHomeState>();

void main() {
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const GestionBudgetApp(),
    ),
  );
}

// Classe principale de l'application
class GestionBudgetApp extends StatelessWidget {
  const GestionBudgetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.latoTextTheme(),
      ),
      home: GestionBudgetHome(key: homeScreenKey),
    );
  }
}

// Widget principal StatefulWidget
class GestionBudgetHome extends StatefulWidget {
  const GestionBudgetHome({super.key});

  @override
  GestionBudgetHomeState createState() => GestionBudgetHomeState();
}

class GestionBudgetHomeState extends State<GestionBudgetHome> {
  final List<Map<String, dynamic>> _expenses = [];
  String _selectedCategory = 'Alimentation';
  DateTime? _selectedDate;

  // Somme des dépenses
  double get totalDepenses => _expenses.fold(0, (sum, item) => sum + item['amount']);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestion du Budget"),
        backgroundColor: AppColors.primary,
      ),
      body: Column(
        children: [
          // Section des statistiques
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            color: AppColors.accentColor,
            child: Text(
              "Total Dépenses: ${totalDepenses.toStringAsFixed(2)} \$",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _expenses.length,
              itemBuilder: (context, index) {
                return ListRowDepense(
                  depenseObj: _expenses[index],
                  index: index,
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddExpenseDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  // Méthode pour supprimer une dépense
  void supprimerDepense(int index) {
    setState(() {
      _expenses.removeAt(index);
    });
  }

  // Boîte de dialogue pour ajouter une dépense
  void _showAddExpenseDialog() {
    String expenseName = '';
    double expenseAmount = 0.0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Ajouter une dépense"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: "Nom"),
                onChanged: (value) => expenseName = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: "Montant"),
                keyboardType: TextInputType.number,
                onChanged: (value) => expenseAmount = double.tryParse(value) ?? 0.0,
              ),
              DropdownButton<String>(
                value: _selectedCategory,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
                items: <String>['Alimentation', 'Transport', 'Loisirs', 'Autres']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () {
                if (expenseName.isNotEmpty && expenseAmount > 0) {
                  setState(() {
                    _expenses.add({
                      'name': expenseName,
                      'amount': expenseAmount,
                      'category': _selectedCategory,
                      'date': _selectedDate ?? DateTime.now(),
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text("Ajouter"),
            ),
          ],
        );
      },
    );
  }
}

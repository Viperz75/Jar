import 'package:expense_jar/components/settings.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import '../components/add_dialog.dart';
import '../components/deadline.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final TextEditingController _jar_name = TextEditingController();
  final TextEditingController _saved = TextEditingController();
  final TextEditingController _goal = TextEditingController();
  final TextEditingController _dateController = TextEditingController();


  late AnimationController _controller;
  late Animation<double> _animation;

  List<Map<String, dynamic>> _items = [];

  final _jarBox = Hive.box("jar_box");

  int totalSaved = 0;
  int totalGoal = 0;
  double perDaySave = 0;
  double perMonthSave = 0;
  double perYearSave = 0;


  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _refreshItems(); // Load data when app starts
    calculateSavedAmount();
    calculateGoalAmount();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200), // Adjust the duration as needed
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  void _refreshItems() {
    final data = _jarBox.keys.map((key) {
      final item = _jarBox.get(key);
      return {
        "key": key,
        "name": item["name"],
        "saved_amount": item["saved_amount"],
        "goal_amount": item["goal_amount"],
        "deadline": item["deadline"],
      };
    }).toList();

    setState(() {
      _items = data.reversed.toList();
    });
  }

  // create new items
  Future<void> _createItem(Map<String, dynamic> newItem) async {
    await _jarBox.add(newItem);
    _refreshItems();
    await calculateSavedAmount();
    await calculateGoalAmount();
  }

  Future<void> _update_item(int itemKey, Map<String, dynamic> item) async {
    await _jarBox.put(itemKey, item);
    _refreshItems();
    await calculateSavedAmount();
    await calculateGoalAmount();
  }

  Future<void> _delete_item(int itemKey) async {
    await _jarBox.delete(itemKey);
    _refreshItems();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Jar Deleted'),
      ),
    );

    await calculateSavedAmount();
    await calculateGoalAmount();
  }

  Future<int> calculateSavedAmount() async {
    double calculateSavedAmount = 0.0;

    for (var item in _items) {
      if (item['saved_amount'] != null) {
        calculateSavedAmount += double.parse(item['saved_amount'] as String);
      }
    }

    setState(() {
      totalGoal = calculateSavedAmount.toInt(); // Convert double to int
    });

    return totalGoal;
  }

  Future<int> calculateGoalAmount() async {
    double calculateGoalAmount = 0.0;

    for (var item in _items) {
      if (item['goal_amount'] != null) {
        calculateGoalAmount += double.parse(item['goal_amount'] as String);
      }
    }

    setState(() {
      totalSaved = calculateGoalAmount.toInt(); // Convert double to int
    });

    return totalSaved;
  }

  double calculatePercentage(Map<String, dynamic> currentItem) {
    double savedAmount = double.parse(currentItem['saved_amount'] as String);
    double goalAmount = double.parse(currentItem['goal_amount'] as String);

    if (goalAmount == 0) {
      return 0.0;
    } else {
      return savedAmount / goalAmount;
    }
  }

  void openAddDialog(BuildContext context, int? itemKey) async {
    if (itemKey != null) {
      //Fetch existing item data and populate text controllers
      final existingItem =
      _items.firstWhere((element) => element['key'] == itemKey);
      _jar_name.text = existingItem['name'];
      _saved.text = existingItem['saved_amount'];
      _goal.text = existingItem['goal_amount'];
      _dateController.text = existingItem['deadline'];
    } else {
      //CLear text controllers for next item
      _jar_name.clear();
      _saved.clear();
      _goal.clear();
      _dateController.clear();
    }

    showGeneralDialog(
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return Container();
      },
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 200),
      transitionBuilder: (context, a1, a2, widget) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
            child: AlertDialog(
              title: const Text('Add a jar'),
              content: SingleChildScrollView(
                child: Container(
                  constraints:
                  const BoxConstraints(maxHeight: 354, maxWidth: 500),
                  child: Column(
                    children: [
                      TextField(
                        controller: _jar_name,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                                color: Colors.black, width: 2.0),
                          ),
                          labelText: 'Jar name',
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _saved,
                        keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                                color: Colors.black, width: 2.0),
                          ),
                          labelText: 'Saved',
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _goal,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                                color: Colors.black, width: 2.0),
                          ),
                          labelText: 'Goal (Optional)',
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: _dateController,
                        keyboardType: TextInputType.datetime,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2015, 8),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            _dateController.text =
                                DateFormat('dd/MM/yyyy').format(pickedDate);
                            print(_dateController.text);
                          }
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                                color: Colors.black, width: 2.0),
                          ),
                          labelText: 'Deadline (Optional)',
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (itemKey == null) {
                              _createItem({
                                "name": _jar_name.text,
                                "saved_amount": _saved.text,
                                "goal_amount": _goal.text,
                                "deadline": _dateController.text,
                              });
                            }

                            if (itemKey != null) {
                              _update_item(itemKey, {
                                'name': _jar_name.text.trim(),
                                'saved_amount': _saved.text.trim(),
                                'goal_amount': _goal.text.trim(),
                                'deadline': _dateController.text.trim(),
                              });
                            }

                            // clearing text field
                            _jar_name.text = '';
                            _saved.text = '';
                            _goal.text = '';
                            _dateController.text = '';

                            Navigator.of(context).pop();
                          },
                          child: Text(
                            itemKey == null ? 'Save' : 'Update',
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        );
      },
    );
  }

  // List of card colors
  // List<Color> colors = [
  //   Color(0xffdbdbdb),
  //   Color(0xffd5fcd2),
  //   Color(0xffd2fcfc),
  //   Color(0xffdbd2fc),
  //   Color(0xfffcead2),
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f7ec),
      appBar: AppBar(
        backgroundColor: Color(0xfff5f7ec),
        title: Text('Saved ৳$totalGoal/৳$totalSaved'),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsPage()));
              },
              icon: const Icon(
                Icons.settings,
                size: 25.0,
              ),
            ),
            FloatingActionButton(
              backgroundColor: const Color(0xfffcd9c3),
              child: const Icon(Icons.add),
              onPressed: () {
                openAddDialog(context, null);
              },
            )
          ],
        ),
      ),
      body: _items.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Show this when there's no jar
            Image.asset('images/jar_background.png'),
            const SizedBox(height: 8.0),
            const Text(
              'Add a new jar by clicking the button below!',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      )
          : ListView.builder(
          itemCount: _items.length,
          itemBuilder: (_, index) {
            final currentItem = _items[index];
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Card(
                    color: const Color(0xffdbdbdb), // Jar color
                    elevation: 2,
                    shape: const RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black, width: 2.0),
                        // Jar Shape
                        borderRadius: BorderRadius.all(
                            Radius.circular(15))),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              // Jar Name
                              Text(
                                currentItem['name'] ?? 'Default Name',
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Jar Informations ( Saved amounts, goals, remaining amount

                              if(currentItem['goal_amount'].length == 0)
                                Text('৳${currentItem['saved_amount']}'),

                              if (currentItem['goal_amount'].length > 0)
                                Text(
                                    '৳${currentItem['saved_amount']}/ ৳${currentItem['goal_amount']} '
                                        '(${(double.parse(currentItem['saved_amount'] as String) / double.parse(currentItem['goal_amount'] as String) * 100).toStringAsFixed(2)}%)',
                                    style: const TextStyle(fontSize: 16)),
                              if (currentItem['goal_amount'].length == 0)
                                Text('৳${currentItem['saved_amount']}',
                                    style: const TextStyle(fontSize: 16)),
                              const SizedBox(height: 5.0),
                              if (currentItem['goal_amount'].length > 0)
                                Text(
                                    'Remaining: ৳${(double.parse(currentItem['goal_amount'] as String) - double.parse(currentItem['saved_amount'] as String))}',
                                    style: TextStyle(fontSize: 16)),
                              const SizedBox(height: 5.0),

                              // Jar Deadline
                              if (currentItem['deadline'].length > 0)
                                ExpandableDeadlineButton(
                                  deadline: currentItem['deadline'],
                                  savedAmount: double.parse(
                                      currentItem['saved_amount']
                                      as String),
                                  goalAmount: double.parse(
                                      currentItem['goal_amount'] as String),
                                ),

                              // TODO: Quick Edit Button
                              MyDropdownTextField(
                                itemKey: currentItem['key'],
                                savedAmount: double.parse(currentItem['saved_amount']),
                                onUpdateSavedAmount: (newValue){
                                  var convertToString = newValue.toString();
                                  _update_item(currentItem['key'], {
                                    'name': currentItem['name'],
                                    'saved_amount': convertToString,
                                    'goal_amount': currentItem['goal_amount'],
                                    'deadline': currentItem['deadline'],
                                  },);
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 1.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Jar Edit Button
                              IconButton(
                                onPressed: () {
                                  openAddDialog(
                                      context, currentItem['key']);
                                },
                                icon: const Icon(Icons.edit,
                                    color: Colors.black),
                              ),
                              const SizedBox(width: 10),
                              // Jar Delete Button
                              IconButton(
                                onPressed: () {
                                  _delete_item(currentItem['key']);
                                },
                                icon: const Icon(Icons.delete_outline,
                                    color: Colors.black),
                              )
                            ],
                          ),
                          const SizedBox(height: 5.0)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}

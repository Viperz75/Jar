import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jar_app/components/settings.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:math';
import '../components/archive.dart';
import '../components/chart.dart';
import '../components/quick_edit.dart';
import '../components/deadline.dart';
import '../components/currencies.dart';
import '../theme/theme_manager.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class Jar {
  final String name;
  final String savedAmount;
  final String goalAmount;
  final String deadline;
  final List<double> history;
  final bool isArchived;

  Jar({
    required this.name,
    required this.savedAmount,
    required this.goalAmount,
    required this.deadline,
    required this.history,
    this.isArchived = false,
  });
}

class JarAdapter extends TypeAdapter<Jar> {
  @override
  final int typeId = 0;

  @override
  Jar read(BinaryReader reader) {
    return Jar(
      name: reader.readString(),
      savedAmount: reader.readString(),
      goalAmount: reader.readString(),
      deadline: reader.readString(),
      history: reader.readList().cast<double>(),
      isArchived:  reader.readBool(),
    );
  }

  @override
  void write(BinaryWriter writer, Jar obj) {
    writer.writeString(obj.name);
    writer.writeString(obj.savedAmount);
    writer.writeString(obj.goalAmount);
    writer.writeString(obj.deadline);
    writer.writeList(obj.history);
    writer.writeBool(obj.isArchived);
  }
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
  void initState() {
    super.initState();
    _refreshItems(); // Load data when app starts
    calculateSavedAmount();
    calculateGoalAmount();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200), // Adjust the duration as needed
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
        "history": item["history"],
        "isArchived": item["isArchived"],
      };
    }).toList();

    setState(() {
      _items = data.reversed.toList();
    });
  }

  // create new items
  Future<void> _createItem(Map<String, dynamic> newItem) async {
    newItem['history'] = <double>[];

    await _jarBox.add(newItem);
    _refreshItems();
    await calculateSavedAmount();
    await calculateGoalAmount();
  }

  Future<void> _update_item(
    int itemKey,
    Map<String, dynamic> newItem,
    double historyValue,
  ) async {
    // Update the jar item
    await _jarBox.put(itemKey, newItem);

    // Fetch the updated item from the box
    var updatedItem = _jarBox.get(itemKey);

    // Get the existing history or initialize an empty list
    List<double> history = updatedItem['history'] ?? [];

    // Check if the last history entry is the same as the new value
    if (history.isEmpty || history.last != historyValue) {
      // Add the new history entry only if it's different from the last one
      history.add(historyValue);
    }

    // Update the history of the item
    updatedItem['history'] = history;

    // Update the item in the box with the updated history
    await _jarBox.put(itemKey, updatedItem);

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
      // calculateSavedAmount += double.parse(item['saved_amount'] as String);
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
      if (item['goal_amount'] != null && item['goal_amount'].isNotEmpty) {
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

    final _formKey = GlobalKey<FormState>();

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
                      const BoxConstraints(maxHeight: 345, maxWidth: 500),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _jar_name,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 2.0),
                            ),
                            labelText: 'Jar name',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a jar name';
                            }
                            return null; // Return null if the input is valid
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _saved,
                          keyboardType:
                              const TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 2.0),
                            ),
                            labelText: 'Saved',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a saved amount';
                            }
                            // Additional validation logic can be added here if needed
                            return null; // Return null if the input is valid
                          },
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _goal,
                          keyboardType:
                              const TextInputType.numberWithOptions(decimal: true),
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
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(onPressed: (){ Navigator.pop(context); }, child: Text('Cancel'),),
                TextButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Form is valid, proceed with saving/updating
                      if (itemKey == null) {
                        _createItem({
                          "name": _jar_name.text,
                          "saved_amount": _saved.text,
                          "goal_amount": _goal.text,
                          "deadline": _dateController.text,
                          'history': [], // Initialize history as empty list
                          'isArchived': false,
                        });
                      }

                      if (itemKey != null) {
                        Map<String, dynamic> existingItem =
                        _items.firstWhere(
                                (element) => element['key'] == itemKey);
                        await _update_item(
                          itemKey,
                          {
                            'name': _jar_name.text.trim(),
                            'saved_amount': _saved.text.trim(),
                            'goal_amount': _goal.text.trim(),
                            'deadline': _dateController.text.trim(),
                            'history': existingItem['history'], // Preserve the existing history
                            'isArchived': false,
                          },
                          // Pass a null value as the history value since no change is made to saved amount or goal amount
                          0.0,
                        );
                      }

                      // clearing text field
                      _jar_name.text = '';
                      _saved.text = '';
                      _goal.text = '';
                      _dateController.text = '';


                      calculateGoalAmount();

                      Navigator.of(context).pop();}


                  },
                  child: Text(itemKey == null ? 'Save' : 'Update',),
                ),
              ],
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
  List<Color> colors = [
    const Color(0xffdbdbdb),
    const Color(0xffd5fcd2),
    const Color(0xffd2fcfc),
    const Color(0xffdbd2fc),
    const Color(0xfffcead2),
  ];

  void _updateArchive(int itemKey, bool isArchived) {
    setState(() {
      _items.forEach((item) {
        if (item['key'] == itemKey) {
          item['isArchived'] = isArchived;
        }
      });
    });
  }

  // Color(0xffdbdbdb), Color(0xffd5fcd2), Color(0xffd2fcfc), Color(0xffdbd2fc), Color(0xfffcead2)
  @override
  Widget build(BuildContext context) {
    // Generate a random index to select a color from the list
    Random random = Random();
    int randomIndex = random.nextInt(colors.length);
    Color selectedColor = colors[randomIndex];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Saved '),
            CurrencyWidget(), // Include CurrencyWidget here
            Text('$totalGoal/'),
            CurrencyWidget(),
            Text('$totalSaved'),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const SettingsPage()));
                  },
                  icon: const FaIcon(FontAwesomeIcons.gear),
                ),
                SizedBox(width: 10.0,),
                IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Archive(items: _items)));
                  },
                  icon: const FaIcon(FontAwesomeIcons.boxArchive),
                ),
              ],
            ),
            FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                openAddDialog(context, null);
                calculateGoalAmount();
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
                  Image.asset('images/jar_background.png', scale: 3,),
                  const SizedBox(height: 8.0),
                  const Text(
                    'Add a new jar by clicking the button below!',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            )
          : Column(
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (_, index) {
                      final currentItem = _items[index];
                      if(currentItem['isArchived'] == false) {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Card(
                                elevation: 2,
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
                                            // currentItem['name'] ?? 'Default name',
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
                                          // Jar Informations ( Saved amounts, goals, remaining amount )
                                          if (currentItem['goal_amount'].length > 0)
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                if(double.parse(currentItem['goal_amount'] as String) != null)
                                                  CurrencyWidget(), Text('${currentItem['saved_amount']} /', style: const TextStyle(fontSize: 16)), CurrencyWidget(), Text('${currentItem['goal_amount']} ', style: const TextStyle(fontSize: 16)),
                                                Text(
                                                    '(${(double.parse(currentItem['saved_amount'] as String) / double.parse(currentItem['goal_amount'] as String) * 100).toStringAsFixed(2)}%)',
                                                    style: const TextStyle(fontSize: 16)),
                                                // Text(
                                                //     '৳${currentItem['saved_amount']}/ ৳${currentItem['goal_amount']} '
                                                //     '(${(double.parse(currentItem['saved_amount'] as String) / double.parse(currentItem['goal_amount'] as String) * 100).toStringAsFixed(2)}%)',
                                                //     style: const TextStyle(fontSize: 16)),
                                              ],
                                            ),
                                          if (currentItem['goal_amount'].length == 0)
                                            // Text('৳${currentItem['saved_amount']}',
                                            //     style: const TextStyle(fontSize: 16)),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                CurrencyWidget(),
                                                Text('${currentItem['saved_amount']}',
                                                    style: const TextStyle(fontSize: 16))
                                              ],
                                            ),
                                          const SizedBox(height: 5.0),
                                          if (currentItem['goal_amount'].length > 0)
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text('Remaining: ', style: const TextStyle(fontSize: 16),),
                                                CurrencyWidget(),
                                                Text(
                                                    '${(double.parse(currentItem['goal_amount'] as String) - double.parse(currentItem['saved_amount'] as String))}',
                                                    style: const TextStyle(fontSize: 16)),
                                              ],
                                            ),
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
                                          const SizedBox(height: 8.0),
                        currentItem['goal_amount'] != null && currentItem['goal_amount'].toString().isNotEmpty
                        ? // Code for when goal amount is present
                        double.parse(currentItem['saved_amount'] as String) == double.parse(currentItem['goal_amount'] as String)
                        ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        Text('Goal has been reached  '),
                        FaIcon(FontAwesomeIcons.circleCheck, color: Provider.of<ThemeProvider>(context)
                            .themeModeType ==
                            ThemeModeType.dark
                            ? Colors.greenAccent
                            : Colors.greenAccent[700],)
                        ],
                        )
                            : SizedBox() // Return an empty SizedBox if goal is not reached
                            : Text(''),
                                          MyDropdownTextField(
                                            itemKey: currentItem['key'],
                                            savedAmount: double.parse(
                                                currentItem['saved_amount']),
                                            onUpdateSavedAmount:
                                                (newValue, enteredValues) {
                                              var convertToString = newValue.toString();
                                              // Get the existing history or initialize an empty list
                                              List<double> history =
                                                  currentItem['history'] ?? [];
                                              // Add the entered value to the history
                                              history.add(enteredValues);
                                              // Update the jar item data including the updated history
                                              _update_item(
                                                currentItem['key'],
                                                {
                                                  'name': currentItem['name'],
                                                  'saved_amount': convertToString,
                                                  'goal_amount':
                                                      currentItem['goal_amount'],
                                                  'deadline': currentItem['deadline'],
                                                  'history': history, // Include the updated history
                                                  'isArchived': false,
                                                },
                                                enteredValues,
                                              );
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
                                            icon: const Icon(Icons.edit, size: 30.0),
                                          ),
                                          const SizedBox(width: 10),
                                          IconButton(
                                            onPressed: () {
                                              _update_item(currentItem['key'], {
                                                'name': currentItem['name'],
                                                'saved_amount': currentItem['saved_amount'],
                                                'goal_amount': currentItem['goal_amount'],
                                                'deadline': currentItem['deadline'],
                                                'history': currentItem['history'], // Include the updated history
                                                'isArchived': true,
                                              }, 0);
                                            },
                                            icon: const Icon(Icons.archive_rounded, size: 30.0),
                                          ),
                                          const SizedBox(width: 10),
                                          IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) => AlertDialog(
                                                  title: Text(
                                                      'History for ${currentItem['name']}'),
                                                  content: SingleChildScrollView(
                                                    child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                        children: currentItem[
                                                                    'history'] !=
                                                                null
                                                            ? currentItem['history']
                                                                .map<Widget>((amount) {
                                                                bool isPositive = false;
                                                                if (amount is double) {
                                                                  isPositive =
                                                                      amount > 0;
                                                                }
                                                                return ListTile(
                                                                  title: Text(
                                                                    isPositive
                                                                        ? 'DEPOSIT: +$amount'
                                                                        : 'WITHDRAWAL: $amount',
                                                                    style: TextStyle(
                                                                        color: isPositive
                                                                            ? Colors
                                                                                .green
                                                                            : Colors
                                                                                .red),
                                                                  ),
                                                                );
                                                              }).toList()
                                                            : []),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text('Close'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            icon: const Icon(Icons.history, size: 30.0,),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  if (currentItem['history'] == null ||
                                                      currentItem['goal_amount'] ==
                                                          null) {
                                                    // If either history or goal_amount is null, show 'Chart not available' message
                                                    return AlertDialog(
                                                      title:
                                                          const Text('Chart not available'),
                                                      content: const Text(
                                                          'History or Goal Amount data is missing.'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(context);
                                                          },
                                                          child: const Text('Close'),
                                                        ),
                                                      ],
                                                    );
                                                  } else {
                                                    double goalAmount;
                                                    try {
                                                      // Parse goal_amount as a double
                                                      goalAmount = double.parse(
                                                          currentItem['goal_amount']);
                                                    } catch (e) {
                                                      // If parsing fails, show 'Chart not available' message
                                                      return AlertDialog(
                                                        title:
                                                            const Text('Chart not available'),
                                                        content: const Text(
                                                            'Invalid Goal Amount data.'),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(context);
                                                            },
                                                            child: const Text('Close'),
                                                          ),
                                                        ],
                                                      );
                                                    }

                                                    // If both history and parsed goal_amount are present, show the chart
                                                    return AlertDialog(
                                                      title: const Text(
                                                          'History vs. Goal Amount'),
                                                      content: SizedBox(
                                                        height: 300, //  height
                                                        child: LineChartWidget(
                                                          history:
                                                              currentItem['history'],
                                                          goalAmount: goalAmount,
                                                        ),
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(context);
                                                          },
                                                          child: const Text('Close'),
                                                        ),
                                                      ],
                                                    );
                                                  }
                                                },
                                              );
                                            },
                                            icon: const FaIcon(FontAwesomeIcons.chartLine),
                                          ),

                                          const SizedBox(width: 10),
                                          // Jar Delete Button
                                          IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text('Delete Jar?'),
                                                    content: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                          },
                                                          child: const Text('Close'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            _delete_item(
                                                                currentItem['key']);
                                                            Navigator.of(context).pop();
                                                          },
                                                          child: const Text('Confirm'),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            icon: const Icon(Icons.delete, size: 30.0,),
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
                      }
                      // else{
                      //   return Center(
                      //     child: Padding(
                      //       padding: const EdgeInsets.only(top: 200.0),
                      //       child: Column(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           // Show this when there's no jar
                      //           Image.asset('images/jar_background.png', scale: 3,),
                      //           const SizedBox(height: 8.0),
                      //           const Text(
                      //             'Add a new jar by clicking the button below!',
                      //             style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   );
                      // }
                    }),
              ),
              if (_items.every((item) => item['isArchived'] == true))
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 130.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('images/jar_background.png', scale: 3,),
                        const SizedBox(height: 8.0),
                        const Text(
                          'Add a new jar by clicking the button below!',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'currencies.dart';
import 'deadline.dart';

class Archive extends StatefulWidget {
  final List<Map<String, dynamic>> items;

  const Archive({Key? key, required this.items}) : super(key: key);

  @override
  State<Archive> createState() => _ArchiveState();
}

class _ArchiveState extends State<Archive> {
  List<Map<String, dynamic>> _archivedItems = [];

  @override
  void initState() {
    super.initState();
    _loadArchivedItems();
  }

  void _loadArchivedItems() {
    final archivedData = widget.items.where((item) => item['isArchived'] == true).toList();
    setState(() {
      _archivedItems = archivedData;
    });
  }

  void _unarchiveItem(int itemIndex) {
    setState(() {
      _archivedItems[itemIndex]['isArchived'] = false; // Update local state
    });

    _updateDatabase(_archivedItems[itemIndex]['key'], false); // Update database

    // Remove the unarchived item from the list
    _archivedItems.removeAt(itemIndex);
  }


  void _updateDatabase(int itemKey, bool isArchived) {
    // Assuming you are using Hive for database operations
    final jarBox = Hive.box("jar_box");
    final jarItem = jarBox.get(itemKey);
    jarItem['isArchived'] = isArchived; // Update isArchived flag
    jarBox.put(itemKey, jarItem); // Put the updated item back to the database
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Archive'),
      ),
      body: _archivedItems.isEmpty
          ? Center(
        child: Text('No archived jars found.'),
      )
          : ListView.builder(
        itemCount: _archivedItems.length,
        itemBuilder: (context, index) {
          final currentItem = _archivedItems[index];
          // Build your UI here for each archived jar item
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
                            IconButton(
                              onPressed: () {
                                _unarchiveItem(index);
                              },
                              icon: const Icon(Icons.archive_rounded, size: 30.0),
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

                                ],
                              ),
                            if (currentItem['goal_amount'].length == 0)
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
                            const SizedBox(width: 10),
                          ],
                        ),
                        const SizedBox(height: 10.0)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpandableDeadlineButton extends StatefulWidget {
  final String deadline;
  final double savedAmount;
  final double goalAmount;

  const ExpandableDeadlineButton({
    required this.deadline,
    required this.savedAmount,
    required this.goalAmount,
  });

  @override
  _ExpandableDeadlineButtonState createState() => _ExpandableDeadlineButtonState();
}

class _ExpandableDeadlineButtonState extends State<ExpandableDeadlineButton> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Deadline: ${widget.deadline}', style: const TextStyle(fontSize: 16)),
              Icon(_isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
            ],
          ),
        ),
        if (_isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5.0),
                Text('Save: ৳${calculatePerDaySaving().toStringAsFixed(2)}/day', style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 5.0),
                Text('Save: ৳${calculatePerWeekSaving().toStringAsFixed(2)}/week', style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 5.0),
                Text('Save: ৳${calculatePerMonthSaving().toStringAsFixed(2)}/month', style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
      ],
    );
  }

  double calculatePerDaySaving() {
    double remainingAmount = widget.goalAmount - widget.savedAmount;
    DateTime parsedDeadline = DateFormat('dd/MM/yyyy').parse(widget.deadline);
    DateTime currentDate = DateTime.now();
    int daysRemaining = parsedDeadline.difference(currentDate).inDays;
    return remainingAmount / daysRemaining;
  }

  double calculatePerWeekSaving() {
    double remainingAmount = widget.goalAmount - widget.savedAmount;
    DateTime parsedDeadline = DateFormat('dd/MM/yyyy').parse(widget.deadline);
    DateTime currentDate = DateTime.now();
    int weeksRemaining = parsedDeadline.difference(currentDate).inDays ~/ 7;
    return remainingAmount / weeksRemaining;
  }

  double calculatePerMonthSaving() {
    double remainingAmount = widget.goalAmount - widget.savedAmount;
    DateTime parsedDeadline = DateFormat('dd/MM/yyyy').parse(widget.deadline);
    DateTime currentDate = DateTime.now();
    int monthsRemaining = (parsedDeadline.year * 12 + parsedDeadline.month) - (currentDate.year * 12 + currentDate.month);
    return remainingAmount / monthsRemaining;
  }
}

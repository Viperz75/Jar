import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_manager.dart';


class MyDropdownTextField extends StatefulWidget {
  final itemKey;
  final savedAmount;
  final void Function(double newValue, double enteredValues) onUpdateSavedAmount;

  const MyDropdownTextField({
    Key? key,
    required this.savedAmount,
    required this.itemKey,
    required this.onUpdateSavedAmount,
  }) : super(key: key);

  @override
  _MyDropdownTextFieldState createState() => _MyDropdownTextFieldState();
}

class _MyDropdownTextFieldState extends State<MyDropdownTextField>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  late TextEditingController enterred_value = TextEditingController();

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200), // Adjust the duration as needed
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }


  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  double addValue() {
    String enteredText = enterred_value.text.toString();
    if (enteredText.isNotEmpty) {
      double enteredValue = double.parse(enteredText);
      double addedValue = widget.savedAmount + enteredValue;

      // if (addedValue > widget.goalAmount) {
      //   showSnackBar("You can't add more than your goal amount");
      //   return widget.savedAmount;
      // }

      widget.onUpdateSavedAmount(addedValue, enteredValue);
      return addedValue;
    }

    // Handle case where entered text is empty
    return widget.savedAmount;
  }



  double minusValue() {
    String enteredText = enterred_value.text.toString();
    if (enteredText.isNotEmpty) {
      double enteredValue = double.parse(enteredText);
      double addedValue = widget.savedAmount - enteredValue;
      widget.onUpdateSavedAmount(addedValue, -enteredValue);
      return addedValue;
    }
    // Handle case where entered text is empty
    return widget.savedAmount;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ListTile(
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("Quick Edit"),
              Icon(Icons.arrow_drop_down),
            ],
          ),
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
              if (_isExpanded) {
                _controller.forward();
              } else {
                _controller.reverse();
              }
            });
          },
        ),
        SizeTransition(
          sizeFactor: _animation,
          axisAlignment: 1.0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                TextFormField(
                  controller: enterred_value,
                  decoration: InputDecoration(
                    labelText: "Amount",
                    // enabledBorder: OutlineInputBorder(
                    //   borderRadius: BorderRadius.circular(
                    //     10.0,
                    //   ),
                    // ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 145.0,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all(Colors.black),
                          backgroundColor: MaterialStateProperty.all(
                            const Color(0xffff9c96),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            minusValue();
                            enterred_value.text = '';
                          });
                        },
                        child: const Text('Minus'),
                      ),
                    ),
                    const SizedBox(
                      width: 2.0,
                    ),
                    SizedBox(
                      width: 145.0,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all(Colors.black),
                          backgroundColor: MaterialStateProperty.all(
                            const Color(
                              0xff8bde85,
                            ),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            addValue();
                            enterred_value.text = '';
                          });
                        },
                        child: const Text('Add'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

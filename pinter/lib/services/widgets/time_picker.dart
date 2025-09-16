import 'package:flutter/material.dart';

class TimePicker extends StatefulWidget {
  const TimePicker(
      {super.key, required this.onTimeSelected, required this.selectedTime});
  final void Function(TimeOfDay) onTimeSelected; // Callback function
  final TimeOfDay selectedTime;

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  TimeOfDay _time = TimeOfDay.now();

  bool init = false;

  @override
  Widget build(BuildContext context) {
    if (!init) {
      _time = widget.selectedTime;
      init = true;
    }

    return Row(
      children: [
        Text(
          _time.format(context),
          style: const TextStyle(
            fontFamily: "NotoSans-Light",
            fontSize: 20,
          ),
        ),
        IconButton(
          onPressed: () {
            _selectTime();
          },
          icon: const Icon(
            Icons.timer,
          ),
        ),
      ],
    );
  }

  void _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
      });

      // Call the callback function with the selected date
      widget.onTimeSelected(newTime);
    }
  }
}

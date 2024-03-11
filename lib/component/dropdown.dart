import 'package:flutter/material.dart';

class Dropdown<T> extends StatefulWidget {
  const Dropdown({
    super.key,
    required this.list,
    required this.onChanged,
    required this.value
  });

  final List<String> list;
  final ValueChanged<String?> onChanged;
  final String value;

  @override
  State<StatefulWidget> createState() {
    return _DropdownState<String>();
  }
}

class _DropdownState<T> extends State<Dropdown> {
  String dropdownValue = '';

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.list.first;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xffbfbfbf))
      ),
      child: Center(
        child: DropdownButton<String>(
          style: const TextStyle(fontSize: 14, color: Colors.black),
          borderRadius: BorderRadius.circular(20),
          underline: const SizedBox.shrink(),
          items: widget.list.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: widget.onChanged,
          value: widget.value,
        )
      )
    );
  }
}
import 'package:flutter/material.dart';

import '../style.dart';

class QuestionCard extends StatefulWidget {
  final String question;
  final List<String> options;
  final int? selectedOption;
  final ValueChanged<int?> onChanged;

  const QuestionCard({
    required this.question,
    required this.options,
    required this.selectedOption,
    required this.onChanged,
  });

  @override
  _QuestionCardState createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  int? selectedOption;

  @override
  void initState() {
    super.initState();
    selectedOption = widget.selectedOption;
  }

  @override
  void didUpdateWidget(covariant QuestionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedOption != widget.selectedOption) {
      setState(() {
        selectedOption = widget.selectedOption;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorStyle.bgColor1,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: ColorStyle.mainColor1, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.question,
              style: TextStyle(fontSize: 18, color: ColorStyle.mainColor1),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.options.length,
              itemBuilder: (context, i) {
                return RadioListTile<int>(
                  value: i,
                  groupValue: selectedOption,
                  title: Text(
                    widget.options[i],
                    style: TextStyle(color: ColorStyle.mainColor1),
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedOption = value;
                    });
                    widget.onChanged(value);
                  },
                  activeColor: ColorStyle.mainColor1,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

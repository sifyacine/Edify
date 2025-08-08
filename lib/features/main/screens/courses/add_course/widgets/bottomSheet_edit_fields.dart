import 'package:edify/features/main/screens/courses/add_course/widgets/text_form_field.dart';
import 'package:flutter/material.dart';

class EditFieldsSheet extends StatelessWidget {
  final String object;
  final TextEditingController editController;
  final int maxLength;
  final void Function()? onEdit;
  const EditFieldsSheet(
      {super.key,
      required this.object,
      required this.editController,
      required this.maxLength,
      this.onEdit});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text(
          "Edit $object",
          style: const TextStyle(fontSize: 18, fontFamily: "Rowdies"),
        ),
        TextFormFieldCourse(
          textController: editController,
          hintText: "Edit $object here ... ",
          maxLength: maxLength,
          autofocus: true,
          maxLines: 4,
          prefixIcon: const Icon(Icons.edit_calendar_outlined),
        ),
        const SizedBox(
          height: 20,
        ),
        TextButton(
            onPressed: editController.text.isEmpty ? null : onEdit,
            child: const Text("Upload"))
      ],
    );
  }
}

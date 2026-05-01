import 'package:core/dto/requests/edit_class_dto.dart';
import 'package:core/dto/responses/class_response_dto.dart';
import 'package:flutter/material.dart';

class EditClassDialog extends StatefulWidget {
  final ClassResponseDto classToEdit;
  final Function(EditClassDto) onAdd;

  const EditClassDialog({
    super.key,
    required this.classToEdit,
    required this.onAdd,
  });

  @override
  State<EditClassDialog> createState() => _EditClassDialogState();
}

class _EditClassDialogState extends State<EditClassDialog> {
  final _formKey = GlobalKey<FormState>();

  String _name = "";
  String? _description = "";
  int _maxParticipants = 50;
  String? _location = "";

  DateTime? _startDate;
  DateTime? _endDate;

  DateTime? _pickedDate;
  TimeOfDay? _pickedTime;

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final start = widget.classToEdit.startDate;

    _pickedDate = DateTime(start.year, start.month, start.day);
    _pickedTime = TimeOfDay(hour: start.hour, minute: start.minute);

    _startDateController.text =
    "${_pickedDate!.day}.${_pickedDate!.month}.${_pickedDate!.year}";

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startTimeController.text = _pickedTime!.format(context);
    });

    _rebuildDateTime();
  }

  Future<void> _pickStartDate(BuildContext context) async {
    final now = DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: _pickedDate ?? now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 1),
    );

    if (date == null) return;

    setState(() {
      _pickedDate = date;
      _startDateController.text =
      "${date.day}.${date.month}.${date.year}";
    });

    _rebuildDateTime();
    _formKey.currentState?.validate();
  }

  Future<void> _pickStartTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: _pickedTime ?? TimeOfDay.now(),
    );

    if (time == null) return;

    setState(() {
      _pickedTime = time;
      _startTimeController.text = time.format(context);
    });

    _rebuildDateTime();
    _formKey.currentState?.validate();
  }

  void _rebuildDateTime() {
    if (_pickedDate == null || _pickedTime == null) {
      _startDate = null;
      return;
    }

    _startDate = DateTime(
      _pickedDate!.year,
      _pickedDate!.month,
      _pickedDate!.day,
      _pickedTime!.hour,
      _pickedTime!.minute,
    );

    _endDate = _startDate!.add(const Duration(hours: 1));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Class"),
      content: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          child: Column(
            spacing: 12.0,
            children: [
              TextFormField(
                initialValue: widget.classToEdit.name,
                decoration: const InputDecoration(labelText: "Class Name"),
                onSaved: (val) => _name = val ?? "",
                validator: (val) =>
                val!.isEmpty ? "Enter a name" : null,
              ),
              TextFormField(
                initialValue: widget.classToEdit.description,
                decoration: const InputDecoration(labelText: "Description"),
                onSaved: (val) => _description = val ?? "",
              ),
              TextFormField(
                initialValue:
                widget.classToEdit.maxParticipants.toString(),
                decoration:
                const InputDecoration(labelText: "Max Participants"),
                keyboardType: TextInputType.number,
                onSaved: (val) =>
                _maxParticipants = int.tryParse(val ?? "0") ?? 0,
              ),
              TextFormField(
                initialValue: widget.classToEdit.location,
                decoration: const InputDecoration(labelText: "Location"),
                onSaved: (val) => _location = val ?? "",
              ),

              // START DATE
              TextFormField(
                controller: _startDateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Start Date",
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () => _pickStartDate(context),
                validator: (_) {
                  if (_pickedDate == null) {
                    return "Please select a start date";
                  }
                  return null;
                },
              ),

              // START TIME
              TextFormField(
                controller: _startTimeController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Start Time",
                  suffixIcon: Icon(Icons.access_time),
                ),
                onTap: () => _pickStartTime(context),
                validator: (_) {
                  if (_pickedTime == null) {
                    return "Please select a start time";
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();

              widget.onAdd(
                EditClassDto(
                  name: _name,
                  description: _description,
                  location: _location,
                  startDate: _startDate!,
                  endDate: _endDate!,
                  maxParticipants: _maxParticipants,
                ),
              );

              Navigator.pop(context);
            }
          },
          child: const Text("Edit"),
        ),
      ],
    );
  }
}



// import 'package:core/dto/requests/edit_class_dto.dart';
// import 'package:core/dto/responses/class_response_dto.dart';
// import 'package:flutter/material.dart';
//
//
// class EditClassDialog extends StatefulWidget {
//   final ClassResponseDto classToEdit;
//   final Function(EditClassDto) onAdd;
//
//
//   const EditClassDialog({super.key, required this.classToEdit, required this.onAdd});
//
//   @override
//   State<EditClassDialog> createState() => _EditClassDialogState();
// }
//
// class _EditClassDialogState extends State<EditClassDialog> {
//   final _formKey = GlobalKey<FormState>();
//
//    String _name="";
//    String? _description="";
//    final DateTime _startDate=DateTime.now();
//    final DateTime _endDate=DateTime.now();
//    int _maxParticipants=50;
//    String? _location="";
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text("Edit Class"),
//       content: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           child: Column(
//             spacing: 12.0,
//             children: [
//               TextFormField(
//                 controller: TextEditingController(text: widget.classToEdit.name),
//                 decoration: InputDecoration(labelText: "Class Name"),
//                 onSaved: (val) => _name = val ?? "",
//                 validator: (val) => val!.isEmpty ? "Enter a name" : null,
//               ),
//               TextFormField(
//                 controller: TextEditingController(text: widget.classToEdit.description),
//                 decoration: InputDecoration(labelText: "Description"),
//                 onSaved: (val) => _description = val ?? "",
//
//                ),
//               TextFormField(
//                 controller: TextEditingController(text: widget.classToEdit.maxParticipants.toString()),
//                 decoration: InputDecoration(labelText: "Max Participants"),
//                 keyboardType: TextInputType.number,
//                 onSaved: (val) => _maxParticipants = int.tryParse(val ?? "0") ?? 0,
//               ),
//               TextFormField(
//                 controller: TextEditingController(text: widget.classToEdit.location),
//                 decoration: InputDecoration(labelText: "Location"),
//                 onSaved: (val) => _location = val ?? "",
//               ),
//             ],
//           ),
//         ),
//       ),
//       actions: [
//         TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
//         ElevatedButton(
//           onPressed: () {
//             if (_formKey.currentState!.validate()) {
//               _formKey.currentState!.save();
//               widget.onAdd(EditClassDto(
//                 name: _name,
//                 description: _description,
//                 location: _location,
//                 startDate: _startDate,
//                 endDate: _endDate,
//                 maxParticipants: _maxParticipants,
//               ));
//               Navigator.pop(context);
//
//             }
//           },
//           child: Text("Edit"),
//         ),
//       ],
//     );
//   }
// }

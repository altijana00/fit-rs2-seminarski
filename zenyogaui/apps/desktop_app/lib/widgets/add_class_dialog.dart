import 'package:core/dto/requests/add_class_dto.dart';
import 'package:core/dto/responses/yoga_type_response_dto.dart';
import 'package:core/services/providers/yoga-type_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';


import '../core/theme.dart';

class AddClassDialog extends StatefulWidget {
  final Function(AddClassDto) onAddDto;

  const AddClassDialog({super.key, required this.onAddDto});

  @override
  State<AddClassDialog> createState() => _AddClassDialogState();
}

class _AddClassDialogState extends State<AddClassDialog> {
  final _formKey = GlobalKey<FormState>();

  int? _yogaTypeId;
  String _name="";
  String? _description="";
  DateTime? _startDate;
  DateTime? _pickedDate;
  TimeOfDay? _pickedTime;
  DateTime? _endDate;
  int _maxParticipants=50;
  String? _location="";
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();

  Future<void> _pickStartTime (BuildContext context) async {
     final time = await showTimePicker(
         context: context,
         initialTime: TimeOfDay.now(),
     );

     if(time == null) return;

     setState(() {
       _pickedTime = time;
       _startTimeController.text = time.format(context);
     });

     _rebuildDateTime();
     _formKey.currentState?.validate();

  }

  Future<void> _pickStartDate(BuildContext context) async {
    final now = DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 1)
    );

    if(date==null) return;

    setState(() {
      _pickedDate = date;
      _startDateController.text = "${date.day}.${date.month}.${date.year}";
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

    _endDate = DateTime(
      _pickedDate!.year,
      _pickedDate!.month,
      _pickedDate!.day,
      _pickedTime!.hour+1,
      _pickedTime!.minute,
    );
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add Class"),
      content: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          child: Column(
            spacing: 12.0,
            children: [
              FutureBuilder<List<YogaTypeResponseDto>>(
                  future: Provider.of<YogaTypeProvider>(
                    context,
                    listen: false,
                  ).repository.getAllYogaTypes(),
                builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(padding: EdgeInsets.symmetric(vertical: 12),
                      child: CircularProgressIndicator(),
                      );
                    }
                    if(snapshot.hasError) {
                      return const Text(
                        "Failed to load yoga types",
                        style: TextStyle(color: AppColors.darkRed),
                      );
                    }
                    final yogaTypes = snapshot.data!;

                    return DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        labelText: "Yoga Type",
                      ),
                      value: _yogaTypeId,
                      items: yogaTypes.map((y) {
                        return DropdownMenuItem<int>(value: y.id, child: Text(y.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _yogaTypeId = value!;
                        });
                      },
                      validator: (value) =>
                      value == null ? "Select a yoga type" : null,
                    );
                },
              ),

              TextFormField(
                decoration: InputDecoration(labelText: "Class Name"),
                onSaved: (val) => _name = val ?? "",
                validator: (val) => val!.isEmpty ? "Enter a name" : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Description"),
                onSaved: (val) => _description = val ?? "",
               ),

              TextFormField(
                decoration: InputDecoration(labelText: "Max Participants"),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                validator: (val) {
                  if(val == null || val.isEmpty) {
                    return 'Please enter a number';
                  }
                  final n = num.tryParse(val);
                  if (n != null && (n <= 0 || n > 50)) {
                    return 'Please enter a number between 1 and 50';
                  }
                  return null;
                },
                onSaved: (val) => _maxParticipants = int.tryParse(val!)!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Location"),
                onSaved: (val) => _location = val ?? "",
              ),
              TextFormField(
                controller: _startDateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Start Date",
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () => _pickStartDate(context),
                validator: (_) {
                  if(_pickedDate == null){
                    return "Please select a start date";
                  }
                  return null;
                },
              ),
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
                  if (_startDate!= null &&
                      _startDate!.isBefore(DateTime.now())) {
                    return "Start time must be in the future";
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              widget.onAddDto(AddClassDto(
                yogaTypeId: _yogaTypeId!,
                name: _name,
                description: _description,
                location: _location,
                startDate: _startDate!,
                endDate: _endDate!,
                maxParticipants: _maxParticipants,
              ));
              Navigator.pop(context);

            }
          },
          child: Text("Add"),
        ),
      ],
    );
  }
}

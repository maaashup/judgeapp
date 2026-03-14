import 'package:flutter/material.dart';
import 'package:mobile/core/utils/formatters.dart';
import 'package:mobile/core/widgets/section_label.dart';
import 'package:mobile/core/widgets/selection_chip_grid.dart';
import 'package:mobile/features/events/data/event.dart';
import 'package:mobile/features/events/data/event_options.dart';
import 'date_time_picker_tile.dart';

class EventForm extends StatefulWidget {
  final Event? existingEvent;
  final ValueChanged<Map<String, dynamic>> onSubmit;

  const EventForm({super.key, this.existingEvent, required this.onSubmit});

  @override
  State<EventForm> createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  DateTime? _date;
  TimeOfDay? _time;
  late String _format;
  late String _game;
  late String _country;

  bool get _editing => widget.existingEvent != null;

  @override
  void initState() {
    super.initState();
    final event = widget.existingEvent;
    _nameController.text = event?.eventName ?? '';
    _date = event?.eventDate;
    _time = event != null ? TimeOfDay.fromDateTime(event.eventDate) : null;
    _format = event?.format ?? eventFormats.first;
    _game = event?.game ?? eventGames.first;
    _country = event?.country ?? eventCountries.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (!mounted || picked == null) return;
    setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? TimeOfDay.now(),
    );

    if (!mounted || picked == null) return;
    setState(() => _time = picked);
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    if (_date == null || _time == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both date and time.')),
      );
      return;
    }

    widget.onSubmit({
      'eventName': _nameController.text.trim(),
      'format': _format,
      'game': _game,
      'country': _country,
      'eventDate': DateTime.utc(
        _date!.year,
        _date!.month,
        _date!.day,
        _time!.hour,
        _time!.minute,
      ).toIso8601String(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final inset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: inset),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _editing ? 'Edit event' : 'New event',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 32),
              const SectionLabel('Event name'),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                style: const TextStyle(fontSize: 16),
                decoration: const InputDecoration(
                  hintText: 'e.g., Regional Championship',
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 32),
              const SectionLabel('Game'),
              const SizedBox(height: 12),
              SelectionChipGrid(
                options: eventGames,
                selectedValue: _game,
                onSelected: (value) => setState(() => _game = value),
              ),
              const SizedBox(height: 32),
              const SectionLabel('Format'),
              const SizedBox(height: 12),
              SelectionChipGrid(
                options: eventFormats,
                selectedValue: _format,
                onSelected: (value) => setState(() => _format = value),
              ),
              const SizedBox(height: 32),
              const SectionLabel('Country'),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _country,
                isExpanded: true,
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: cs.onSurface.withValues(alpha: 0.5),
                ),
                style: TextStyle(fontSize: 16, color: cs.onSurface),
                items: eventCountries
                    .map(
                      (country) => DropdownMenuItem(
                        value: country,
                        child: Text(countryLabel(country)),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _country = value!),
              ),
              const SizedBox(height: 32),
              const SectionLabel('Date & time'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: DateTimePickerTile(
                      icon: Icons.calendar_today_rounded,
                      text: _date != null
                          ? formatPickerDate(_date!)
                          : 'Select date',
                      isFilled: _date != null,
                      onTap: _pickDate,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DateTimePickerTile(
                      icon: Icons.access_time_rounded,
                      text: _time != null
                          ? _time!.format(context)
                          : 'Select time',
                      isFilled: _time != null,
                      onTap: _pickTime,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: _handleSubmit,
                  child: Text(
                    _editing ? 'Update event' : 'Create event',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:booktracker/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  late final ApiService apiService;

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  int? _rating;
  String? _status;
  DateTime? _finishedDate;

  final List<String> _statusOptions = ['planned', 'in progress', 'completed'];

  bool get _showFinishedDate => _status == 'completed';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    apiService = Provider.of<ApiService>(context, listen: false);
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final book = {
        'title': _titleController.text,
        'author': _authorController.text,
        'status': _status,
        if (_rating != null) 'rating': _rating,
        if (_showFinishedDate && _finishedDate != null)
          'finishedDate': _finishedDate!.toIso8601String(),
      };

      final response = await apiService.postRequest('/books', book);

      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to add book")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Book")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _authorController,
                decoration: InputDecoration(labelText: 'Author'),
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
              ),
              DropdownButtonFormField<String>(
                value: _status,
                items:
                    _statusOptions
                        .map(
                          (status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    _status = value;
                    if (_status != 'completed') _finishedDate = null;
                  });
                },
                decoration: InputDecoration(labelText: 'Status'),
                validator: (value) => value == null ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Text("Rating:"),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < (_rating ?? 0) ? Icons.star : Icons.star_border,
                    ),
                    onPressed: () {
                      setState(() {
                        _rating = index + 1;
                      });
                    },
                  );
                }),
              ),
              if (_showFinishedDate)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Finished Date:"),
                    ElevatedButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1950),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setState(() {
                            _finishedDate = picked;
                          });
                        }
                      },
                      child: Text(
                        _finishedDate == null
                            ? 'Pick a date'
                            : _finishedDate!.toIso8601String().split('T').first,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: _submit, child: Text("Add Book")),
            ],
          ),
        ),
      ),
    );
  }
}

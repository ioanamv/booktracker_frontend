import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:booktracker/services/api_service.dart';

class EditBookScreen extends StatefulWidget {
  const EditBookScreen({super.key});

  @override
  State<EditBookScreen> createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  late ApiService apiService;
  bool _isApiServiceInitialized = false;
  bool _isInitialized = false;

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  int? _rating;
  String? _status;
  DateTime? _finishedDate;
  late int bookId;

  final List<String> _statusOptions = ['planned', 'in progress', 'completed'];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isApiServiceInitialized) {
      apiService = Provider.of<ApiService>(context, listen: false);
      _isApiServiceInitialized = true;
    }

    if (!_isInitialized) {
      final Map<String, dynamic> book =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

      bookId = book['bookId'];
      _titleController.text = book['title'] ?? '';
      _authorController.text = book['author'] ?? '';
      _status = book['status'];
      _rating = book['rating'];
      if (book['finishedDate'] != null) {
        _finishedDate = DateTime.tryParse(book['finishedDate']);
      }

      _isInitialized = true;
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final updatedBook = {
        'title': _titleController.text,
        'author': _authorController.text,
        'status': _status,
        'rating': _rating,
        'finishedDate': _finishedDate?.toIso8601String(),
      };

      updatedBook.removeWhere((key, value) => value == null);

      final response = await apiService.putRequest(
        '/books/$bookId',
        updatedBook,
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Failed to update book")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Book")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(labelText: 'Author'),
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
                  });
                },
                decoration: const InputDecoration(labelText: 'Status'),
                validator: (value) => value == null ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              const Text("Rating:"),
              Row(
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
              const SizedBox(height: 16),
              const Text("Finished Date:"),
              ElevatedButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _finishedDate ?? DateTime.now(),
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
                      : _finishedDate!.toIso8601String().split('T')[0],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                child: const Text("Update Book"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

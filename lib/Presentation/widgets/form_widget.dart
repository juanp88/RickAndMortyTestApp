import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final void Function(String) onNameChanged;
  final void Function(String) onSpeciesChanged;
  final void Function(String) onStatusChanged;
  final VoidCallback onSubmit;
  final bool isLoading;

  const FormWidget({
    super.key,
    required this.formKey,
    required this.onNameChanged,
    required this.onSpeciesChanged,
    required this.onStatusChanged,
    required this.onSubmit,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30.0),
      height: 400,
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
              onChanged: onNameChanged,
            ),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Species',
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a species';
                }
                return null;
              },
              onChanged: onSpeciesChanged,
            ),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Status',
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a status';
                }
                return null;
              },
              onChanged: onStatusChanged,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: ElevatedButton(
                  onPressed: isLoading ? null : onSubmit,
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Submit'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

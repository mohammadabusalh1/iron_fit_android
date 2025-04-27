import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../models/gym_model.dart';
import '../providers/gym_provider.dart';
import '../services/storage_service.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/internationalization.dart';

final storageServiceProvider =
    Provider<StorageService>((ref) => StorageService());

class AddGymScreen extends ConsumerStatefulWidget {
  const AddGymScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AddGymScreen> createState() => _AddGymScreenState();
}

class _AddGymScreenState extends ConsumerState<AddGymScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  final _nameController = TextEditingController();
  final _websiteController = TextEditingController();
  final _countryController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _instagramController = TextEditingController();
  final _facebookController = TextEditingController();
  final _facilityController = TextEditingController();
  List<XFile> _selectedPhotos = [];
  List<String> _photos = [];
  List<String> _facilities = [];
  Map<String, String> _workingHours = {
    'Monday': '',
    'Tuesday': '',
    'Wednesday': '',
    'Thursday': '',
    'Friday': '',
    'Saturday': '',
    'Sunday': '',
  };

  @override
  void dispose() {
    _nameController.dispose();
    _websiteController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _instagramController.dispose();
    _facebookController.dispose();
    _facilityController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final storageService = ref.read(storageServiceProvider);
    final images = await storageService.pickImages();
    if (images != null) {
      setState(() {
        _selectedPhotos = images;
      });
    }
  }

  void _removeSelectedPhoto(int index) {
    setState(() {
      _selectedPhotos.removeAt(index);
    });
  }

  void _addFacility() {
    if (_facilityController.text.isNotEmpty) {
      setState(() {
        _facilities.add(_facilityController.text);
        _facilityController.clear();
      });
    }
  }

  void _removeFacility(String facility) {
    setState(() {
      _facilities.remove(facility);
    });
  }

  void _updateWorkingHours(String day, String hours) {
    setState(() {
      _workingHours[day] = hours;
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final gymService = ref.read(gymServiceProvider);
        final storageService = ref.read(storageServiceProvider);

        // First create the gym to get the ID
        final gym = GymModel(
          name: _nameController.text,
          website: _websiteController.text,
          photos: [],
          country: _countryController.text,
          city: _cityController.text,
          address: _addressController.text,
          phoneNumber: _phoneController.text,
          email: _emailController.text,
          instagram: _instagramController.text,
          facebook: _facebookController.text,
          facilities: _facilities,
          workingHours: _workingHours,
        );

        final gymId = await gymService.createGym(gym);

        // Upload photos if any are selected
        if (_selectedPhotos.isNotEmpty) {
          _photos = await storageService.uploadImages(_selectedPhotos, gymId);

          // Update the gym with photo URLs
          final updatedGym = gym.copyWith(photos: _photos);
          await gymService.updateGym(gymId, updatedGym);
        }

        if (mounted) {
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error creating gym: $e')),
          );
        }
      }
    }
  }

  List<Step> _buildSteps() {
    return [
      Step(
        title: Text(FFLocalizations.of(context).getText('gymBasicInfo')),
        content: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: FFLocalizations.of(context).getText('gymName'),
                hintText: FFLocalizations.of(context).getText('enterGymName'),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return FFLocalizations.of(context).getText('fieldRequired');
                }
                return null;
              },
            ),
            TextFormField(
              controller: _websiteController,
              decoration: InputDecoration(
                labelText: FFLocalizations.of(context).getText('gymWebsite'),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _pickImages,
              icon: Icon(Icons.add_photo_alternate),
              label:
                  Text(FFLocalizations.of(context).getText('uploadGymPhotos')),
            ),
            if (_selectedPhotos.isNotEmpty) ...[
              SizedBox(height: 16),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedPhotos.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: Image.file(
                            File(_selectedPhotos[index].path),
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: IconButton(
                            icon: Icon(Icons.remove_circle),
                            color: Colors.red,
                            onPressed: () => _removeSelectedPhoto(index),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ],
        ),
        isActive: _currentStep >= 0,
      ),
      Step(
        title: Text(FFLocalizations.of(context).getText('gymLocation')),
        content: Column(
          children: [
            TextFormField(
              controller: _countryController,
              decoration: InputDecoration(
                labelText: FFLocalizations.of(context).getText('country'),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return FFLocalizations.of(context).getText('fieldRequired');
                }
                return null;
              },
            ),
            TextFormField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: FFLocalizations.of(context).getText('city'),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return FFLocalizations.of(context).getText('fieldRequired');
                }
                return null;
              },
            ),
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: FFLocalizations.of(context).getText('address'),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return FFLocalizations.of(context).getText('fieldRequired');
                }
                return null;
              },
            ),
          ],
        ),
        isActive: _currentStep >= 1,
      ),
      Step(
        title: Text(FFLocalizations.of(context).getText('gymContact')),
        content: Column(
          children: [
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: FFLocalizations.of(context).getText('phoneNumber'),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return FFLocalizations.of(context).getText('fieldRequired');
                }
                return null;
              },
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: FFLocalizations.of(context).getText('email'),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return FFLocalizations.of(context).getText('fieldRequired');
                }
                if (!value.contains('@')) {
                  return FFLocalizations.of(context).getText('invalidEmail');
                }
                return null;
              },
            ),
            TextFormField(
              controller: _instagramController,
              decoration: InputDecoration(
                labelText: 'Instagram',
              ),
            ),
            TextFormField(
              controller: _facebookController,
              decoration: InputDecoration(
                labelText: 'Facebook',
              ),
            ),
          ],
        ),
        isActive: _currentStep >= 2,
      ),
      Step(
        title: Text(FFLocalizations.of(context).getText('facilities')),
        content: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _facilityController,
                    decoration: InputDecoration(
                      labelText:
                          FFLocalizations.of(context).getText('addFacility'),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addFacility,
                ),
              ],
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: _facilities.map((facility) {
                return Chip(
                  label: Text(facility),
                  onDeleted: () => _removeFacility(facility),
                );
              }).toList(),
            ),
          ],
        ),
        isActive: _currentStep >= 3,
      ),
      Step(
        title: Text(FFLocalizations.of(context).getText('workingHours')),
        content: Column(
          children: _workingHours.entries.map((entry) {
            return Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: TextFormField(
                initialValue: entry.value,
                decoration: InputDecoration(
                  labelText:
                      '${entry.key} ${FFLocalizations.of(context).getText('hours')}',
                  hintText: '9:00 AM - 10:00 PM',
                ),
                onChanged: (value) => _updateWorkingHours(entry.key, value),
              ),
            );
          }).toList(),
        ),
        isActive: _currentStep >= 4,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(FFLocalizations.of(context).getText('addGym')),
        backgroundColor: FlutterFlowTheme.of(context).primary,
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          type: StepperType.vertical,
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep < _buildSteps().length - 1) {
              setState(() {
                _currentStep++;
              });
            } else {
              _submitForm();
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() {
                _currentStep--;
              });
            }
          },
          steps: _buildSteps(),
        ),
      ),
    );
  }
}

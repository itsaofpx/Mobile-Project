import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void addStadium(BuildContext context) {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final descriptionController = TextEditingController();
  final imageController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();

  bool isLoading = false;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Add New Stadium',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF091442),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Replace the GestureDetector in addStadium with this TextFormField
                      TextFormField(
                        controller: imageController,
                        decoration: InputDecoration(
                          labelText: 'Image URL',
                          hintText: 'Enter image URL',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.image),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter image URL';
                          }
                          if (!Uri.parse(value).isAbsolute) {
                            return 'Please enter a valid URL';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {}); // Trigger rebuild to update preview
                        },
                      ),
                      const SizedBox(height: 16),

                      // Add image preview
                      if (imageController.text.isNotEmpty)
                        Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              imageController.text,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Text('Invalid image URL'),
                                );
                              },
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),

                      const SizedBox(height: 24),

                      // Stadium Name
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Stadium Name',
                          hintText: 'Enter stadium name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.stadium),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter stadium name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Stadium Address
                      TextFormField(
                        controller: addressController,
                        decoration: InputDecoration(
                          labelText: 'Address',
                          hintText: 'Enter stadium address',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.location_on),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter stadium address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Stadium Location
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: latitudeController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              decoration: InputDecoration(
                                labelText: 'Latitude',
                                hintText: 'Enter latitude',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                prefixIcon: const Icon(Icons.location_on),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter latitude';
                                }
                                final latitude = double.tryParse(value);
                                if (latitude == null) {
                                  return 'Please enter a valid number';
                                }
                                if (latitude < -90 || latitude > 90) {
                                  return 'Latitude must be between -90 and 90';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: longitudeController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              decoration: InputDecoration(
                                labelText: 'Longitude',
                                hintText: 'Enter longitude',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                prefixIcon: const Icon(Icons.location_on),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter longitude';
                                }
                                final longitude = double.tryParse(value);
                                if (longitude == null) {
                                  return 'Please enter a valid number';
                                }
                                if (longitude < -180 || longitude > 180) {
                                  return 'Longitude must be between -180 and 180';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Stadium Description
                      TextFormField(
                        controller: descriptionController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          hintText: 'Enter stadium description',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.description),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter description';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              isLoading
                                  ? null
                                  : () async {
                                    if (formKey.currentState!.validate()) {
                                      setState(() => isLoading = true);
                                      try {
                                        final stadiumId =
                                            DateTime.now()
                                                .millisecondsSinceEpoch
                                                .toString();

                                        final stadiumData = {
                                          'stadium_id': stadiumId,
                                          'stadium_name':
                                              nameController.text.trim(),
                                          'stadium_address':
                                              addressController.text.trim(),
                                          'stadium_location': GeoPoint(
                                            double.parse(
                                              latitudeController.text.trim(),
                                            ),
                                            double.parse(
                                              longitudeController.text.trim(),
                                            ),
                                          ),
                                          'stadium_description':
                                              descriptionController.text.trim(),
                                          'stadium_image':
                                              imageController.text.trim(),
                                          'created_at':
                                            Timestamp.now(),
                                        };

                                        await FirebaseFirestore.instance
                                            .collection('stadiums')
                                            .doc(stadiumId)
                                            .set(stadiumData);

                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Stadium added successfully',
                                            ),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      } catch (e) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Error: ${e.toString()}',
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      } finally {
                                        setState(() => isLoading = false);
                                      }
                                    }
                                  },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF091442),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child:
                              isLoading
                                  ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                  : const Text(
                                    'Add Stadium',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

void updateStadium(BuildContext context, Map<String, dynamic> stadium) {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController(
    text: stadium['stadium_name'] ?? '',
  );
  final addressController = TextEditingController(
    text: stadium['stadium_address'] ?? '',
  );
  final GeoPoint stadiumLocation = stadium['stadium_location'] as GeoPoint;

  final longitudeController = TextEditingController(
    text: stadiumLocation.longitude.toString(),
  );
  final latitudeController = TextEditingController(
    text: stadiumLocation.latitude.toString(),
  );
  final descriptionController = TextEditingController(
    text: stadium['stadium_description'] ?? '',
  );
  final imageController = TextEditingController(
    text: stadium['stadium_image'] ?? '',
  );

  bool isLoading = false;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Update Stadium',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF091442),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Image URL Input
                      TextFormField(
                        controller: imageController,
                        decoration: InputDecoration(
                          labelText: 'Image URL',
                          hintText: 'Enter image URL',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.image),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter image URL';
                          }
                          if (!Uri.parse(value).isAbsolute) {
                            return 'Please enter a valid URL';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),

                      if (imageController.text.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              imageController.text,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Text('Invalid image URL'),
                                );
                              },
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),

                      // Stadium Name
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Stadium Name',
                          hintText: 'Enter stadium name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.stadium),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter stadium name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Stadium Address
                      TextFormField(
                        controller: addressController,
                        decoration: InputDecoration(
                          labelText: 'Address',
                          hintText: 'Enter stadium address',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.location_on),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter stadium address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Latitude and Longitude
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: latitudeController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              decoration: InputDecoration(
                                labelText: 'Latitude',
                                hintText: 'Enter latitude',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                prefixIcon: const Icon(Icons.location_on),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter latitude';
                                }
                                final latitude = double.tryParse(value);
                                if (latitude == null) {
                                  return 'Please enter a valid number';
                                }
                                if (latitude < -90 || latitude > 90) {
                                  return 'Latitude must be between -90 and 90';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: longitudeController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              decoration: InputDecoration(
                                labelText: 'Longitude',
                                hintText: 'Enter longitude',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                prefixIcon: const Icon(Icons.location_on),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter longitude';
                                }
                                final longitude = double.tryParse(value);
                                if (longitude == null) {
                                  return 'Please enter a valid number';
                                }
                                if (longitude < -180 || longitude > 180) {
                                  return 'Longitude must be between -180 and 180';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Stadium Description
                      TextFormField(
                        controller: descriptionController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          hintText: 'Enter stadium description',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.description),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter description';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Update Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              isLoading
                                  ? null
                                  : () async {
                                    if (formKey.currentState!.validate()) {
                                      setState(() => isLoading = true);
                                      try {
                                        final stadiumData = {
                                          'stadium_name':
                                              nameController.text.trim(),
                                          'stadium_address':
                                              addressController.text.trim(),
                                          'stadium_location': GeoPoint(
                                            double.parse(
                                              latitudeController.text.trim(),
                                            ),
                                            double.parse(
                                              longitudeController.text.trim(),
                                            ),
                                          ),
                                          'stadium_description':
                                              descriptionController.text.trim(),
                                          'stadium_image':
                                              imageController.text.trim(),
                                          'updated_at':
                                              Timestamp.now(),
                                        };

                                        await FirebaseFirestore.instance
                                            .collection('stadiums')
                                            .doc(stadium['stadium_id'])
                                            .update(stadiumData);

                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Stadium updated successfully',
                                            ),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      } catch (e) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Error: ${e.toString()}',
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      } finally {
                                        setState(() => isLoading = false);
                                      }
                                    }
                                  },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF091442),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child:
                              isLoading
                                  ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                  : const Text(
                                    'Update Stadium',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

import 'package:flutter/material.dart';
import 'package:layout/api/teams/matchday.dart'; // นำเข้า MatchdayApi

class AddMatchScreen extends StatefulWidget {
  const AddMatchScreen({Key? key}) : super(key: key);

  @override
  State<AddMatchScreen> createState() => _AddMatchScreenState();
}

class _AddMatchScreenState extends State<AddMatchScreen> {
  final MatchdayApi api = MatchdayApi(); // สร้าง Instance ของ MatchdayApi
  final _formKey = GlobalKey<FormState>();

  // Controllers สำหรับฟิลด์ต่างๆ
  final TextEditingController matchIdController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController leagueNameController = TextEditingController();
  final TextEditingController matchDateController = TextEditingController();
  final TextEditingController matchTimeController = TextEditingController();
  final TextEditingController stadiumNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController linkpicController = TextEditingController();

  final TextEditingController zoneAPriceController = TextEditingController();
  final TextEditingController zoneASeateController = TextEditingController();
  final TextEditingController zoneBPriceController = TextEditingController();
  final TextEditingController zoneBSeateController = TextEditingController();
  final TextEditingController zoneCPriceController = TextEditingController();
  final TextEditingController zoneCSeateController = TextEditingController();
  final TextEditingController zoneDPriceController = TextEditingController();
  final TextEditingController zoneDSeateController = TextEditingController();

  Future<void> addMatch() async {
    if (_formKey.currentState!.validate()) {
      try {
        await api.addMatch(
          matchId: matchIdController.text,
          title: titleController.text,
          leagueName: leagueNameController.text,
          matchDate: matchDateController.text,
          matchTime: matchTimeController.text,
          stadiumName: stadiumNameController.text,
          description: descriptionController.text,
          linkpic: linkpicController.text,
          zoneAPrice: double.parse(zoneAPriceController.text),
          zoneASeate: int.parse(zoneASeateController.text),
          zoneBPrice: double.parse(zoneBPriceController.text),
          zoneBSeate: int.parse(zoneBSeateController.text),
          zoneCPrice: double.parse(zoneCPriceController.text),
          zoneCSeate: int.parse(zoneCSeateController.text),
          zoneDPrice: double.parse(zoneDPriceController.text),
          zoneDSeate: int.parse(zoneDSeateController.text),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Match added successfully!')),
        );
        Navigator.pop(context); // กลับไปหน้าก่อนหน้า
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Match'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: matchIdController,
                  decoration: const InputDecoration(labelText: 'Match ID'),
                  validator: (value) => value!.isEmpty ? 'Please enter Match ID' : null,
                ),
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) => value!.isEmpty ? 'Please enter Title' : null,
                ),
                TextFormField(
                  controller: leagueNameController,
                  decoration: const InputDecoration(labelText: 'League Name'),
                  validator: (value) => value!.isEmpty ? 'Please enter League Name' : null,
                ),
                TextFormField(
                  controller: matchDateController,
                  decoration: const InputDecoration(labelText: 'Match Date (YYYY-MM-DD)'),
                  validator: (value) => value!.isEmpty ? 'Please enter Match Date' : null,
                ),
                TextFormField(
                  controller: matchTimeController,
                  decoration: const InputDecoration(labelText: 'Match Time (HH:MM)'),
                  validator: (value) => value!.isEmpty ? 'Please enter Match Time' : null,
                ),
                TextFormField(
                  controller: stadiumNameController,
                  decoration: const InputDecoration(labelText: 'Stadium Name'),
                  validator: (value) => value!.isEmpty ? 'Please enter Stadium Name' : null,
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (value) => value!.isEmpty ? 'Please enter Description' : null,
                ),
                TextFormField(
                  controller: linkpicController,
                  decoration: const InputDecoration(labelText: 'Link Picture'),
                  validator: (value) => value!.isEmpty ? 'Please enter Link Picture' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: zoneAPriceController,
                  decoration: const InputDecoration(labelText: 'Zone A Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Please enter Zone A Price' : null,
                ),
                TextFormField(
                  controller: zoneASeateController,
                  decoration: const InputDecoration(labelText: 'Zone A Seate'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Please enter Zone A Seate' : null,
                ),
                TextFormField(
                  controller: zoneBPriceController,
                  decoration: const InputDecoration(labelText: 'Zone B Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Please enter Zone B Price' : null,
                ),
                TextFormField(
                  controller: zoneBSeateController,
                  decoration: const InputDecoration(labelText: 'Zone B Seate'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Please enter Zone B Seate' : null,
                ),
                TextFormField(
                  controller: zoneCPriceController,
                  decoration: const InputDecoration(labelText: 'Zone C Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Please enter Zone C Price' : null,
                ),
                TextFormField(
                  controller: zoneCSeateController,
                  decoration: const InputDecoration(labelText: 'Zone C Seate'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Please enter Zone C Seate' : null,
                ),
                TextFormField(
                  controller: zoneDPriceController,
                  decoration: const InputDecoration(labelText: 'Zone D Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Please enter Zone D Price' : null,
                ),
                TextFormField(
                  controller: zoneDSeateController,
                  decoration: const InputDecoration(labelText: 'Zone D Seate'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Please enter Zone D Seate' : null,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: addMatch,
                  child: const Text('Add Match'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    matchIdController.dispose();
    titleController.dispose();
    leagueNameController.dispose();
    matchDateController.dispose();
    matchTimeController.dispose();
    stadiumNameController.dispose();
    descriptionController.dispose();
    linkpicController.dispose();
    zoneAPriceController.dispose();
    zoneASeateController.dispose();
    zoneBPriceController.dispose();
    zoneBSeateController.dispose();
    zoneCPriceController.dispose();
    zoneCSeateController.dispose();
    zoneDPriceController.dispose();
    zoneDSeateController.dispose();
    super.dispose();
  }
}

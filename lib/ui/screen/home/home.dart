/*
 * @Author GS
 */
import 'package:arduino_iot_v2/ui/screen/home/model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dbRef = FirebaseDatabase.instance.ref().child('GREEN_HOUSE');
  final dbRef1 = FirebaseDatabase.instance.ref().child('GREEN_HOUSE_SPRINKLER');

  int i = 0;
  List<GreenHouseModel> models = [
    GreenHouseModel(),
    GreenHouseModel(),
    GreenHouseModel(),
  ];

  @override
  void initState() {
    dbRef.onValue.listen(
      (event) {
        if (event.snapshot.value != null && event.snapshot.value is List) {
          setState(() {
            models = (event.snapshot.value! as List<dynamic>)
                .map((e) => GreenHouseModel.fromJson(
                    Map<String, dynamic>.from(e as Map<dynamic, dynamic>)))
                .toList();
          });
        } else {
          dbRef.set(models.map((e) => e.toJson()).toList());
        }
      },
    );
    super.initState();
  }

  Widget buildView(int index) {
    final model = models[index];
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              const Expanded(
                flex: 4,
                child: Text(
                  'Temperature',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const Text(' : '),
              Expanded(
                flex: 3,
                child: Text(
                  '${model.temp.isEmpty ? 'NA' : model.temp} °C',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              const Expanded(
                flex: 4,
                child: Text(
                  'Humidity',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const Text(' : '),
              Expanded(
                flex: 3,
                child: Text(
                  model.humidity.isEmpty ? 'NA' : model.humidity,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              const Expanded(
                flex: 4,
                child: Text(
                  'Soil Moisture',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const Text(' : '),
              Expanded(
                flex: 3,
                child: Text(
                  model.soil.isEmpty ? 'NA' : model.soil,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              const Expanded(
                flex: 4,
                child: Text(
                  'Light',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const Text(' : '),
              Expanded(
                flex: 3,
                child: Text(
                  !model.light ? 'ON' : 'OFF',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              const Expanded(
                flex: 4,
                child: Text(
                  'Sprinkler',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const Text(' : '),
              Expanded(
                flex: 3,
                child: Text(
                  !model.sprinkler ? 'ON' : 'OFF',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (model.sprinkler)
              ElevatedButton(
                onPressed: () {
                  dbRef1.child(index.toString()).set(true);
                },
                child: const Text('Sprinkler ON'),
              ),
            if (!model.sprinkler)
              ElevatedButton(
                onPressed: () {
                  dbRef1.child(index.toString()).set(false);
                },
                child: const Text('Sprinkler OFF'),
              ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Green Spaces',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.teal,
          bottom: const TabBar(
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                text: 'Green House 1',
              ),
              Tab(
                text: 'Green House 2',
              ),
              Tab(
                text: 'Green House 3',
              ),
            ],
          ),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              Expanded(
                child: TabBarView(
                  children: [
                    buildView(0),
                    buildView(1),
                    buildView(2),
                  ],
                ),
              ),
              const Text(
                'Project By: Archana, Chaitanya, Pavitra and Shalin',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

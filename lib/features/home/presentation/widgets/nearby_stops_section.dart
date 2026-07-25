import 'package:flutter/material.dart';

class NearbyStopsSection extends StatelessWidget {
  const NearbyStopsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final stops = [
      {'name': 'Edappadi Main Bus Stand', 'distance': '200m', 'walk': '3 mins', 'next': '5 mins'},
      {'name': 'Kamarajar Statue Stop', 'distance': '600m', 'walk': '8 mins', 'next': '12 mins'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text('Nearby Bus Stops', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        ...stops.map((stop) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.directions_walk, color: Colors.orange),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(stop['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('${stop['distance']} • ${stop['walk']} walk', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Next Bus in', style: TextStyle(fontSize: 10, color: Colors.grey)),
                    Text(stop['next']!, style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }
}

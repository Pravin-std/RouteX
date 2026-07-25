import 'package:flutter/material.dart';

class RecentTicketsSection extends StatelessWidget {
  const RecentTicketsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tickets = [
      {'from': 'Edappadi', 'to': 'Salem', 'date': 'Today, 08:30 AM', 'status': 'Completed'},
      {'from': 'Salem', 'to': 'Coimbatore', 'date': 'Yesterday, 10:15 AM', 'status': 'Completed'},
      {'from': 'Erode', 'to': 'Salem', 'date': '20 Jul, 04:45 PM', 'status': 'Completed'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text('Recent Tickets', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        ...tickets.map((ticket) => Padding(
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
                const Icon(Icons.receipt_long, color: Colors.blue),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${ticket['from']} to ${ticket['to']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(ticket['date']!, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(ticket['status']!, style: TextStyle(fontSize: 10, color: Colors.grey.shade700)),
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }
}

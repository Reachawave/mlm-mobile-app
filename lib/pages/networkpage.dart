import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: ReferralTreeWithScroll(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class ReferralTreeWithScroll extends StatelessWidget {
  // Example: columns with only 2 agent rows each
  final List<List<Map<String, String>>> treeData = [
    [
      {'name': 'Agent A1', 'id': '001'},
      {'name': 'Agent A2', 'id': '002'},
    ],
    [
      {'name': 'Agent B1', 'id': '003'},
      {'name': 'Agent B2', 'id': '004'},
      // 'image': 'lib/icons/decision-tree.png'},
    ],
    [
      {'name': 'Agent C1', 'id': '005'},
      {'name': 'Agent C2', 'id': '006'},
    ],
    [
      {'name': 'Agent D1', 'id': '007'},
      {'name': 'Agent D2', 'id': '008'},
    ],
    [
      {'name': 'Agent E1', 'id': '009'},
      {'name': 'Agent E2', 'id': '010'},
    ],
    [
      {'name': 'Agent F1', 'id': '011'},
      {'name': 'Agent F2', 'id': '012'},
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Referral Tree')),
      body: Center(
        child: Container(
          width: 500,
          height: 600, // fixed container height
          decoration: BoxDecoration(
            color: Colors.grey[200],
            border: Border.all(color: Colors.black26),
          ),
          child: Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: treeData.map((columnData) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 2.0,
                      ), // 15+15=30 gap
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AgentRow(
                            name: columnData[1]['name'] ?? 'Unknown',
                            id: columnData[1]['id'] ?? '-',
                            imagePath: columnData[1]['image'] ?? '',
                          ),
                          // Vertical line
                          Container(
                            width: 0.5,
                            height: 400, // long vertical line
                            color: Colors.grey,
                          ),
                          // Top agent
                          AgentRow(
                            name: columnData[0]['name'] ?? 'Unknown',
                            id: columnData[0]['id'] ?? '-',
                            imagePath: columnData[0]['image'] ?? '',
                          ),
                          SizedBox(height: 250), // space to bottom agent
                          // Bottom agent
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AgentRow extends StatelessWidget {
  final String name;
  final String id;
  final String imagePath;

  const AgentRow({
    Key? key,
    required this.name,
    required this.id,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundImage: imagePath.isNotEmpty ? AssetImage(imagePath) : null,
          child: imagePath.isEmpty ? Icon(Icons.person) : null,
        ),
        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
            Text('ID: $id', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ],
    );
  }
}

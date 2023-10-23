import 'package:flutter/material.dart';

import '../DB/DAL/DraaiDAL.dart';
import '../models/Bed.dart';
import '../models/Draai.dart';

class BedDetails extends StatefulWidget {
  final Bed bed;

  BedDetails({required this.bed});

  @override
  _BedDetailsState createState() => _BedDetailsState();
}

class _BedDetailsState extends State<BedDetails> {
  List<Draai> _draaiObjecten = [];

  @override
  void initState() {
    super.initState();
    _fetchDraaiObjecten();
  }

  Future<void> _fetchDraaiObjecten() async {
    DraaiDAL d = DraaiDAL();
    List<Draai> lDraaien = await d.read(widget.bed);
    setState(() {
      _draaiObjecten = lDraaien;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bed Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Bed: ${widget.bed.bed}'),
                Text('Grootte: ${widget.bed.afmeting}'),
                Text('kamer: ${widget.bed.kamer}'),
                Text('locatie: ${widget.bed.locatie}'),
                Text('Maximaal gewicht: ${widget.bed.maxGewicht}'),
              ],
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Draaien:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _draaiObjecten.length,
              itemBuilder: (context, index) {
                Draai draai = _draaiObjecten[index];
                return Container(
                  color: index % 2 == 0 ? Colors.grey[300] : Colors.grey[100],
                  child: ListTile(
                    title: Text('Draai'),
                    subtitle: Text(
                        'Moment: ${draai.displayMoment}, Kant: ${draai.kant}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

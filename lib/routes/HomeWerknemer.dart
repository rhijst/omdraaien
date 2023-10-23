import 'package:flutter/material.dart';
import '../DB/DAL/bedDAL.dart';
import '../models/Bed.dart';
import 'BedDetails.dart';

class HomeWerknemer extends StatefulWidget {
  const HomeWerknemer({Key? key}) : super(key: key);

  @override
  _HomeWerknemerState createState() => _HomeWerknemerState();
}

class _HomeWerknemerState extends State<HomeWerknemer> {
  List<Bed> _bedList = [];

  // Get the bed items on load
  @override
  void initState() {
    super.initState();
    _fetchBedList();
  }

  // get all the bed items
  Future<void> _fetchBedList() async {
    BedDAL bd = BedDAL();
    List<Bed> lBeds = await bd.read();
    setState(() {
      _bedList = lBeds;
    });
  }

  // Refresh the list
  void _refreshList() {
    _fetchBedList();
  }

  // Add a bed
  void _addBed() {
    Navigator.pushNamed(context, '/addBed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Overzicht bedden'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () {
              Uitloggen(context);
            },
          )
        ],
      ),
      body: Column(
        children: [
          // List view
          Expanded(
            child: ListView.builder(
              itemCount: _bedList.length,
              itemBuilder: (context, index) {
                return BedListItem(
                  bed: _bedList[index],
                  index: index,
                  refreshList: _refreshList,
                );
              },
            ),
          ),
          //  buttons on the bottom
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _addBed,
                child: const Text('Add Bed'),
              ),
              ElevatedButton(
                onPressed: _refreshList,
                child: const Text('Refresh'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void Uitloggen(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Uitloggen?'),
          content:
              const Text('Weet u zeker dat u wilt uitloggen?'),
          actions: [
            TextButton(
              child: const Text('Annuleren'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Uitloggen'),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, '/login',(route) => false);
              },
            ),
          ],
        );
      },
    );
  }
}

// BedListItem
class BedListItem extends StatelessWidget {
  final Bed bed;
  final int index;
  final Function refreshList; // Callback function

  const BedListItem({
    required this.bed,
    required this.index,
    required this.refreshList, // Function
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: index % 2 == 0 ? Colors.grey[300] : Colors.grey[100],
      child: ListTile(
        title: Text('Bed ${bed.bed}  --${bed.kamer}'),
        // Delete option menu icon
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_horiz),
          onSelected: (String option) {
            // Select logic
            _handleOptionSelected(context, option);
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'delete',
              child: Text('Verwijderen'),
            ),
          ],
        ),
        //  When the user clicks on the item go to the detail page
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BedDetails(bed: bed),
            ),
          );
        },
      ),
    );
  }

  // Logic if user clicked on "Verwijderen"
  void _handleOptionSelected(BuildContext context, String option) {
    if (option == 'delete') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Verwijderen'),
            content:
                const Text('Weet u zeker dat je dit bed wilt verwijderen?'),
            actions: [
              // close
              TextButton(
                child: const Text('Annuleren'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              // Delete
              TextButton(
                child: const Text('Verwijderen'),
                onPressed: () async {
                  try {
                    BedDAL bDAL = BedDAL();
                    bDAL.delete(bed);

                    Navigator.pop(context);
                    refreshList();
                  } catch (e) {
                    print('Error deleting bed: $e');
                  }
                },
              ),
            ],
          );
        },
      );
    }
  }
}

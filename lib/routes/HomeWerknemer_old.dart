import 'package:flutter/material.dart';
import 'package:omdraaien/DB/DAL/bedDAL.dart';
import '../models/Bed.dart';
// import 'BedDAL.dart';
import 'BedDetails.dart';
// BedDetails
class HomeWerknemer_old extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bed List'),
      ),
      body: FutureBuilder<List<Bed>>(
        future: fetchBedList(), // Fetch the list of beds
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final beds = snapshot.data;
            return ListView.builder(
              itemCount: beds?.length,
              itemBuilder: (context, index) {
                final bed = beds![index];
                // return ListTile(
                //   title: Text('Bed ${bed.bed}'),
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => BedDetailsRoute(bed: bed),
                //       ),
                //     );
                //   },
                // );
                return Container(
                  height: 50,
                  color: index % 2 == 0 ? Colors.grey[300] : Colors.grey[100],
                  child: ListTile(
                    // title: Text('Bed ${bedList[index].bed}'),
                    title: Text('Bed ${bed.bed}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        // MaterialPageRoute(
                        //   builder: (context) =>
                        //       BedDetailsRoute(bed: bedList[index]),
                        // ),
                        MaterialPageRoute(
                          builder: (context) => BedDetails(bed: bed),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Bed>> fetchBedList() async {
    // Fetch the list of beds using your BedDAL
    // Modify the code based on your implementation
    // Example code assuming you have a BedDAL object:
    // final bedDAL = BedDAL();
    // final patient = ...; // Provide the patient object
    // return bedDAL.readSingle(patient);

    BedDAL bd = BedDAL();
    List<Bed> lBeds = await bd.read();

    return lBeds;
  }
}

import 'package:flutter/material.dart';
import 'Database Helper.dart';
import 'Model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<Report> reports = [];
  List<Report> filteredReports = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadReports();
  }

  Future<void> loadReports() async {
    List<Map<String, dynamic>> reportMaps = await dbHelper.getReports();
    setState(() {
      reports = reportMaps.map((map) => Report.fromMap(map)).toList();
      filteredReports = reports;
    });
  }

  void filterReports(String query) {
    List<Report> results = reports.where((report) {
      return report.location.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredReports = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Search Reports",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search by location...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (query) => filterReports(query),
            ),
          ),
          Expanded(
            child: filteredReports.isNotEmpty
                ? ListView.builder(
              itemCount: filteredReports.length,
              itemBuilder: (context, index) {
                Report report = filteredReports[index];
                return Card(
                  color: Colors.purpleAccent,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(
                      report.location,
                      style: const TextStyle( color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Date: ${report.date}", style: TextStyle(color: Colors.white),),
                        Text("Description: ${report.description}", style: TextStyle(color: Colors.white),),
                        Text("Report Count: ${report.reportCount}", style: TextStyle(color: Colors.white),),
                      ],
                    ),
                  ),
                );
              },
            )
                : const Center(
              child: Text("No reports found",
                  style: TextStyle(color: Colors.grey)),
            ),
          ),
        ],
      ),
    );
  }
}

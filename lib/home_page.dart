import 'package:flutter/material.dart';
import 'package:enhanzer_practicle/models/api_response.dart'; // Adjust the import as needed
import 'package:enhanzer_practicle/database/db_manager.dart'; // Adjust the import for your DbManager

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  List<ResponseBody> responseData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final dbManager = DbManager();
    responseData = await dbManager.fetchAllResponses();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Data"),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : responseData.isEmpty
              ? const Center(
                  child: Text("No data available."),
                )
              : ListView.builder(
                  itemCount: responseData.length,
                  itemBuilder: (context, index) {
                    final response = responseData[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      elevation: 4,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          response.userDisplayName ?? 'No Name',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Email: ${response.email ?? 'Not available'}'),
                            Text(
                                'Employee Code: ${response.userEmployeeCode ?? 'N/A'}'),
                            Text(
                                'Company Code: ${response.companyCode ?? 'N/A'}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

import 'package:budgetbuddy/backup/upload_to_drive.dart';
import 'package:flutter/material.dart';

class BackupPage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Backup to Google Drive'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              // Call the updated upload function
              await uploadFileToGoogleDrive();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Backup successful')),
              );
            } catch (e) {
              print(e);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Backup failed')),
              );
            }
          },
          child: Text('Backup Now'),
        ),
      ),
    );
  }
}

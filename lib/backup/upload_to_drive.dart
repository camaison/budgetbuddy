import 'dart:io';
import 'package:budgetbuddy/backup/google_auth_client.dart';
import 'package:budgetbuddy/backup/google_authenticator.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:budgetbuddy/database/database_functions.dart';

Future<void> uploadFileToGoogleDrive() async {
  try {
    // Get the database file path from DatabaseFunctions
    String dbPath = await DatabaseFunctions.instance.databasePath;
    File dbFile = File(dbPath);

    final GoogleSignInAccount? account = await signInWithGoogle();
    final authHeaders = await account!.authHeaders;
    final authenticateClient = GoogleAuthClient(authHeaders);
    final driveApi = drive.DriveApi(authenticateClient);

    String fileName = 'budgetbuddy.db';
    // Search for the file in the Google Drive
    final fileList = await driveApi.files.list(
      q: "name = '$fileName' and 'appDataFolder' in parents",
      spaces: 'drive',
    );

    if (fileList.files != null && fileList.files!.isNotEmpty) {
      // File exists, so update it
      String fileId = fileList.files!.first.id!;
      var response = await driveApi.files.update(
        drive.File(),
        fileId,
        uploadMedia: drive.Media(dbFile.openRead(), dbFile.lengthSync()),
      );
      print(response.toJson());
    } else {
      // File doesn't exist, so create it
      drive.File fileToUpload = drive.File();
      fileToUpload.parents = ["appDataFolder"];
      fileToUpload.name = fileName;
      var response = await driveApi.files.create(
        fileToUpload,
        uploadMedia: drive.Media(dbFile.openRead(), dbFile.lengthSync()),
      );
      print(response.toJson());
    }
  } catch (e) {
    // Handle any errors here
    print('Error uploading file to Google Drive: $e');
  }
}

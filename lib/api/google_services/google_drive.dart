import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart' as signIn;
import 'package:path/path.dart' as p;
import 'package:scansquad/api/google_services/googleHTTPclient.dart';

class GoogleDriveServices {
  late GoogleSignInAccount googleUser;
  Future<signIn.GoogleSignIn> logInUser() async {
    final googleSignIn = signIn.GoogleSignIn.standard(scopes: [
      drive.DriveApi.driveFileScope,
      drive.DriveApi.driveReadonlyScope,
      drive.DriveApi.driveScope
    ]);
    return googleSignIn;
  }

  Future<signIn.GoogleSignInAccount> logInUserSilently() async {
    final googleSignIn = await logInUser();
    googleUser = (await googleSignIn.signInSilently())!;
    return googleUser;
  }

  Future<drive.DriveApi?> getDriveApi() async {
    if ((await (await logInUser()).isSignedIn()) == true) {
      googleUser = await logInUserSilently();
    } else {
      googleUser = (await (await logInUser()).signIn())!;
    }
    final headers = await googleUser.authHeaders;
    final client = GoogleHttpClient(headers);
    final driveApi = drive.DriveApi(client);
    return driveApi;
  }

  Future<void> logOutGoogle() async {
    if (await (await logInUser()).isSignedIn()) {
      await (await logInUser()).signOut();
      return;
    }
    return;
  }

  Future<String?> getFolderId(drive.DriveApi driveApi) async {
    const mimeType = "application/vnd.google-apps.folder";
    String folderName = "Scrypt";
    try {
      final found = await driveApi.files.list(
        q: "mimeType = '$mimeType' and name = '$folderName'",
        $fields: "files(id, name)",
      );
      final files = found.files;
      if (files == null) {
        return null;
      }
      // The folder already exists
      if (files.isNotEmpty) {
        return files.first.id;
      }
      // Creates a folder
      var folder = drive.File();
      folder.name = folderName;
      folder.mimeType = mimeType;
      final folderCreation = await driveApi.files.create(folder);

      return folderCreation.id;
    } catch (e) {
      return null;
    }
  }

  Future<bool> uploadToDrive(File file) async {
    bool isSucessful = false;
    try {
      final folderId = await getFolderId((await getDriveApi())!);
      if (folderId == null) {
        isSucessful = false;
        return isSucessful;
      }
      var driveFile = drive.File();
      driveFile.name = p.basename(file.absolute.path);
      driveFile.modifiedTime = DateTime.now().toUtc();
      driveFile.parents = [folderId];
      // Upload
      final response = await ((await getDriveApi())!).files.create(driveFile,
          uploadMedia: drive.Media(file.openRead(), file.lengthSync()));
      isSucessful = true;
      return isSucessful;
    } catch (e) {
      return isSucessful;
    }
  }

  Future<List<drive.File>> listGoogleDriveFiles() async {
    drive.FileList list;
    final folderId = await getFolderId((await getDriveApi())!);
    list = (await ((await getDriveApi())!).files.list(
          spaces: 'drive',
          q: "'$folderId' in parents",
        ));
    return list.files!;
  }
}

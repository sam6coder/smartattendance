import 'dart:io' ;
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:aws_common/vm.dart';
import 'package:camera/camera.dart';


class StorageRepository{
  Future<String> uploadFile(File file) async{
    final awsFile=AWSFilePlatform.fromFile(file);
    try{
      final fileName= DateTime.now().toIso8601String();

      final res=await Amplify.Storage.uploadFile(
        localFile: awsFile,
        key:fileName+'.jpg',
          options: StorageUploadFileOptions(
            accessLevel: StorageAccessLevel.guest,
          )

      ).result;
      print(res.uploadedItem.key);
      return res.uploadedItem.key;
    }catch(e){
      print(e);
      throw e;
    }
  }
}
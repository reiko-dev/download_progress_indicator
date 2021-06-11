import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class DownloadPage extends StatefulWidget {
  const DownloadPage({Key? key}) : super(key: key);

  @override
  _DownloadPageState createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  bool isDownloading = false;
  double? downloadPercentage;
  String downloadMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton.extended(
            onPressed: () async {
              downloadPercentage = 0;
              downloadMessage = 'Initializing ...';
              late var dir;
              switch (Theme.of(context).platform) {
                case TargetPlatform.windows:
                  dir = await getApplicationDocumentsDirectory();
                  break;
                default:
                  dir = await getExternalStorageDirectory();
              }

              print(dir!.path);
              final dio = Dio();
              dio.download(
                'https://wallpaperaccess.com/full/1579442.jpg',
                '${dir!.path}/sample.jpg',
                onReceiveProgress: (actualBytes, totalbytes) {
                  downloadPercentage = 100 * actualBytes / totalbytes;

                  if (downloadPercentage! < 100)
                    downloadMessage =
                        'Downloading... ${downloadPercentage!.toStringAsFixed(0)} %.';
                  else
                    downloadMessage = 'Successfully downloaded!';

                  setState(() {});
                },
              );
            },
            label: Text('Download'),
            icon: Icon(Icons.file_download),
          ),
          SizedBox(height: 32),
          Text(
            downloadMessage,
            style: Theme.of(context).textTheme.headline6,
          ),
          if (downloadPercentage != null)
            Center(
              child: SizedBox(
                width: 200,
                child: LinearProgressIndicator(
                  value: downloadPercentage! / 100,
                ),
              ),
            )
        ],
      ),
    ));
  }
}

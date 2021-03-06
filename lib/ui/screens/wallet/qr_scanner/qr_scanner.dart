import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:selendra_marketplace_app/all_export.dart';

class QrScanner extends StatefulWidget {
  final List portList;

  QrScanner({this.portList});

  @override
  State<StatefulWidget> createState() {
    return QrScannerState();
  }
}

class QrScannerState extends State<QrScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  QRViewController controller;

  void _onQrViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      controller.pauseCamera();
      Navigator.pop(context, scanData);
      // await Future.delayed(Duration(seconds: 2), () async {
      //   _backend.mapData = await Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //           builder: (context) =>
      //               SubmitTrx(scanData, false, [] /* widget.portList */)));
      // });
    });
  }

  @override
  dispose() {
    controller?.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: BodyScaffold(
      height: MediaQuery.of(context).size.height,
      bottom: 0,
      child: Column(
        children: [
          MyAppBar(
            title: "Transaction",
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Expanded(
              flex: 5,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQrViewCreated,
                overlay: QrScannerOverlayShape(
                    borderColor: Colors.red, borderRadius: 10, borderWidth: 10),
              )),
        ],
      ),
    ));
  }
}

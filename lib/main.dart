import 'dart:io';
import 'dart:typed_data';

import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';


void main(){
  runApp(
    MaterialApp(
      home: MyApp(),
    )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> _createPDF() async {
    //Create a new PDF document
    PdfDocument document = PdfDocument();

    final PdfImage image = PdfBitmap(await _readImageData('ApkLogo.png'));
    PdfPage page = document.pages.add();
    //Add a new page and draw text
    page.graphics
      ..drawString(
        'Brand Name', PdfStandardFont(PdfFontFamily.helvetica, 30,style: PdfFontStyle.bold),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: Rect.fromLTWH(120, 0, 500, 50))
      ..drawString(
          'TagLine', PdfStandardFont(PdfFontFamily.helvetica, 20),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)),
          bounds: Rect.fromLTWH(120, 50, 500, 50))
        ..drawImage(
        image,
        Rect.fromLTWH(0, 0, 100, 100))
      ..drawRectangle(
        brush: PdfBrushes.blue, bounds: Rect.fromLTWH(0, 120, document.pages[0].getClientSize().width*0.60, 50))
      ..drawString(
          'INVOICE', PdfStandardFont(PdfFontFamily.helvetica, 36),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)),
          bounds: Rect.fromLTWH(document.pages[0].getClientSize().width*0.62, 120, 140, 50))
      ..drawRectangle(
          brush: PdfBrushes.blue, bounds: Rect.fromLTWH(document.pages[0].getClientSize().width*0.62+143, 120,document.pages[0].getClientSize().width-document.pages[0].getClientSize().width*0.62+160 , 50))
      ..drawString(
          'Invoice to: \nName', PdfStandardFont(PdfFontFamily.helvetica, 30,style: PdfFontStyle.bold),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)),
          bounds: Rect.fromLTWH(0, 180, 500, 80))
      ..drawString(
          '401,city center \nyogichowk ,\n surat', PdfStandardFont(PdfFontFamily.helvetica, 20),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)),
          bounds: Rect.fromLTWH(0, 280, 500, 100));

    PdfGrid grid = PdfGrid();
    grid.style = PdfGridStyle(
        font: PdfStandardFont(PdfFontFamily.helvetica, 30),
        cellPadding: PdfPaddings(left: 5, right: 2, top: 2, bottom: 2));

    grid.columns.add(count: 3);
    grid.headers.add(1);

    PdfGridRow header = grid.headers[0];
    header.cells[0].value = 'Roll No';
    header.cells[1].value = 'Name';
    header.cells[2].value = 'Class';

    header.style = PdfGridRowStyle(
    backgroundBrush: PdfBrushes.black,
    textPen: PdfPens.white,
    font: PdfStandardFont(PdfFontFamily.helvetica, 20,style: PdfFontStyle.bold));
    PdfGridRow row = grid.rows.add();
    row.cells[0].value = '1';
    row.cells[1].value = 'Arya';
    row.cells[2].value = '6';

    row.style = PdfGridRowStyle(
        backgroundBrush: PdfBrushes.white,
        textPen: PdfPens.black,
        font: PdfStandardFont(PdfFontFamily.timesRoman, 12));
    PdfGridRow row1 = grid.rows.add();
    row1 = grid.rows.add();
    row1.cells[0].value = '2';
    row1.cells[1].value = 'John';
    row1.cells[2].value = '9';

    row1.style = PdfGridRowStyle(
        backgroundBrush: PdfBrushes.lightGray,
        textPen: PdfPens.black,
        font: PdfStandardFont(PdfFontFamily.timesRoman, 12));
    PdfGridRow row2 = grid.rows.add();
    row2 = grid.rows.add();
    row2.cells[0].value = '3';
    row2.cells[1].value = 'Tony';
    row2.cells[2].value = '8';

    row2.style = PdfGridRowStyle(
        backgroundBrush: PdfBrushes.white,
        textPen: PdfPens.black,
        font: PdfStandardFont(PdfFontFamily.timesRoman, 12));

    PdfStringFormat format = PdfStringFormat();
    format.alignment = PdfTextAlignment.center;
    format.lineAlignment = PdfVerticalAlignment.bottom;

    grid.columns[0].format=format;
    grid.columns[1].format=format;
    grid.columns[2].format=format;

    grid.draw(
        page: page, bounds: const Rect.fromLTWH(0, 380, 0, 0));


    ;

    //Save the document
    List<int> bytes = await document.save();
    document.dispose();
    var path = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
    Directory d=Directory('$path/myfolder');
    if(!await d.exists())
      {
        await d.create();
      }

//Create an empty file to write PDF data
    File file = File('${d.path}/Output.pdf');
//Write PDF data
    await file.writeAsBytes(bytes, flush: true);
//Open the PDF document in mobile
    OpenFile.open('${d.path}/Output.pdf');
    //Dispose the document

  }
  Future<List<int>> _readImageData(String name) async {
    final ByteData data = await rootBundle.load('assets/images/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ElevatedButton(onPressed: () {
        _createPDF();
      },child: Text("Save"),),
    );
  }
}


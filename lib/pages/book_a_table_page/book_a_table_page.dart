import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class TableBookingPage extends StatefulWidget {
  @override
  _TableBookingPageState createState() => _TableBookingPageState();
}

class _TableBookingPageState extends State<TableBookingPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<TableData> tables = [];
  int? selectedTableId;
 bool isSnackBarActive = false; 
 
  @override
  void initState() {
    super.initState();
    _initializeTables();
     _tabController = TabController(length: 3, vsync: this);
  }

  void _initializeTables() {
    tables = [
      TableData(
        id: 1,
        x: 50,
        y: 100,
        width: 80,
        height: 50,
        chairs: 3,
        status: TableStatus.reserved,
      ),
      TableData(
        id: 2,
        x: 180,
        y: 100,
        width: 80,
        height: 50,
        chairs: 6,
        status: TableStatus.available,
      ),
      TableData(
        id: 3,
        x: 50,
        y: 200,
        width: 100,
        height: 50,
        chairs: 8,
        status: TableStatus.available,
      ),
      TableData(
        id: 4,
        x: 200,
        y: 200,
        width: 50,
        height: 50,
        chairs: 4,
        status: TableStatus.reserved,
      ),
       TableData(
        id: 5,
        x: 300,
        y: 100,
        width: 50,
        height: 50,
        chairs: 4,
        status: TableStatus.reserved,
      ),
       TableData(
        id: 6,
        x: 300,
        y: 200,
        width: 50,
        height: 50,
        chairs: 4,
        status: TableStatus.reserved,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Book a Table'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Canvas для столів зі стільцями
          Column(
            children: [
               TabBar(
            controller: _tabController,
            indicatorColor:  Color(0xff5B4CBD),
            labelColor:  Color(0xff5B4CBD),
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: '1st Floor'),
              Tab(text: '2nd Floor'),
              Tab(text: '3rd Floor'),
            ],
          ),
          SizedBox(height: 8),
          // Legend
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLegendItem(Colors.red, 'Reserved'),
                _buildLegendItem(Colors.green, 'Available'),
                _buildLegendItem( Color(0xff5B4CBD), 'Selected'),
              ],
            ),
          ),
          SizedBox(height: 16),
              Container(
                color:  Color(0xffF6F6F6),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child:  SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                    child: GestureDetector(
                      onTapUp: (details) {
                        _handleTap(details.localPosition);
                      },
                      child: CustomPaint(
                        size: Size(600, 1600),
                        painter: TablePainter(
                          tables: tables,
                          selectedTableId: selectedTableId,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Кнопка бронювання
         Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding:
            EdgeInsets.only(top: 12, left: 24, right: 18, bottom: 24),
        height: 88,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
            boxShadow: [
              BoxShadow(
                  color: const Color.fromARGB(115, 192, 192, 192),
                  offset: Offset(0, -1),
                  blurRadius: 18)
            ]),
        child: ElevatedButton(
             onPressed: selectedTableId == null
                  ? null
                  : () {
                      setState(() {
                        tables
                            .firstWhere((table) => table.id == selectedTableId)
                            .status = TableStatus.reserved;
                        selectedTableId = null;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Table reserved successfully!'),
                        ),
                      );
                    },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff5B4CBD),
            ),
            child: Text(
              "Book a Table",
              style: TextStyle(color: Colors.white, fontSize: 18),
            )),
      ),
    )
        ],
      ),
    );
  }

   void _handleTap(Offset position) {
    for (var table in tables) {
      if (table.contains(position)) {
        // Check if table is reserved
        if (table.status == TableStatus.reserved) {
          // Show SnackBar only if one is not already active
          if (!isSnackBarActive) {
            isSnackBarActive = true;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('This table is already reserved!'),
                duration: Duration(seconds: 2),
              ),
            ).closed.then((_) {
              isSnackBarActive = false; // Reset flag when SnackBar is dismissed
            });
          }
          return;
        }

        // Allow selection for available tables
        setState(() {
          selectedTableId = table.id == selectedTableId ? null : table.id;
        });
        break;
      }
    }
  }
 Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(3),
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child:  Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        ),
        SizedBox(width: 8),
        Text(label, style: TextStyle(fontSize: 14)),
      ],
    );
  }
}
class TablePainter extends CustomPainter {
  final List<TableData> tables;
  final int? selectedTableId;

  TablePainter({required this.tables, this.selectedTableId});

  @override
  void paint(Canvas canvas, Size size) {
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke // Тільки контур
      ..strokeWidth = 1.0;
    final fillPaint = Paint()
      ..style = PaintingStyle.fill // Тільки заливка
      ..color = Colors.white; // Білий фон для всіх столів
    final chairPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Color(0xffDEDEDE);
    final chairFillPaint = Paint()
      ..style = PaintingStyle.fill // Тільки заливка
      ..color = Colors.white; // Білий фон для всіх стільців

    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    for (var table in tables) {
      // Колір контуру залежить від статусу
      if (table.id == selectedTableId) {
        borderPaint.color = Colors.purple;
      } else {
        borderPaint.color = Color(0xffDEDEDE);
      }

      // Малюємо білий фон столика
      final rect = Rect.fromLTWH(table.x, table.y, table.width, table.height);
      canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(8)), fillPaint);

      // Малюємо кольоровий контур столика
      canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(8)), borderPaint);

      // Розміщення стільців
      _drawChairs(canvas, table, chairPaint, chairFillPaint);

      // Додаємо текст із номером столика
      late Color colorText = Color(0xffDEDEDE);
      if (table.status == TableStatus.reserved) {
        colorText = Colors.red;
      } else if (table.id == selectedTableId) {
        colorText = Colors.purple;
      } else {
        colorText = Colors.green;
      }

      textPainter.text = TextSpan(
        text: 'T-${table.id}',
        style: TextStyle(color: colorText, fontSize: 14),
      );
      textPainter.layout(minWidth: table.width, maxWidth: table.width);
      textPainter.paint(canvas, Offset(table.x, table.y + table.height / 3));
    }
  }

  void _drawChairs(Canvas canvas, TableData table, Paint chairPaint, Paint chairFillPaint) {
  final chairWidth = 24.0;
  final chairHeight = 8.0;
  final chairSpacing = 6.0;

  // Верхня сторона
  int topChairs = (table.width / (chairWidth + chairSpacing)).floor();
  double topStartX = table.x + (table.width - (topChairs * (chairWidth + chairSpacing) - chairSpacing)) / 2;
  for (int i = 0; i < topChairs; i++) {
    final chairX = topStartX + i * (chairWidth + chairSpacing);
    final chairY = table.y - chairHeight - chairSpacing;
    _drawChair(canvas, chairX, chairY, chairWidth, chairHeight, chairPaint, chairFillPaint, 0);
  }

  // Нижня сторона
  int bottomChairs = (table.width / (chairWidth + chairSpacing)).floor();
  double bottomStartX = table.x + (table.width - (bottomChairs * (chairWidth + chairSpacing) - chairSpacing)) / 2;
  for (int i = 0; i < bottomChairs; i++) {
    final chairX = bottomStartX + i * (chairWidth + chairSpacing);
    final chairY = table.y + table.height + chairSpacing;
    _drawChair(canvas, chairX, chairY, chairWidth, chairHeight, chairPaint, chairFillPaint, 0);
  }

  // Ліва сторона
  int leftChairs = (table.height / (chairWidth + chairSpacing)).floor();
  double leftStartY = table.y + (table.height - (leftChairs * (chairWidth + chairSpacing) - chairSpacing)) / 2;
  for (int i = 0; i < leftChairs; i++) {
    final chairX = table.x - chairHeight - chairSpacing;
    final chairY = leftStartY + i * (chairWidth + chairSpacing);
    _drawChair(canvas, chairX, chairY, chairHeight, chairWidth, chairPaint, chairFillPaint, -90);
  }

  // Права сторона
  int rightChairs = (table.height / (chairWidth + chairSpacing)).floor();
  double rightStartY = table.y + (table.height - (rightChairs * (chairWidth + chairSpacing) - chairSpacing)) / 2;
  for (int i = 0; i < rightChairs; i++) {
    final chairX = table.x + table.width + chairSpacing;
    final chairY = rightStartY + i * (chairWidth + chairSpacing);
    _drawChair(canvas, chairX, chairY, chairHeight, chairWidth, chairPaint, chairFillPaint, 90);
  }
}

 void _drawChair(Canvas canvas, double x, double y, double width, double height, Paint chairPaint, Paint chairFillPaint, double rotation) {
  canvas.save(); // Зберігаємо стан Canvas
  canvas.translate(x + width / 2, y + height / 2); // Переміщаємо до центру стільця
  canvas.rotate(rotation * pi / 90); // Обертаємо Canvas на вказаний кут

  final rect = Rect.fromLTWH(-width / 2, -height / 2, width, height);
  canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(4)), chairFillPaint);
  canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(4)), chairPaint);

  canvas.restore(); // Відновлюємо стан Canvas
}


  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}


class TableData {
  final int id;
  final double x;
  final double y;
  final double width;
  final double height;
  final int chairs;
  TableStatus status;

  TableData({
    required this.id,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.chairs,
    required this.status,
  });

  bool contains(Offset point) {
    return point.dx >= x &&
        point.dx <= x + width &&
        point.dy >= y &&
        point.dy <= y + height;
  }
}

enum TableStatus { reserved, available }

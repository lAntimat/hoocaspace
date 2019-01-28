import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddServicePage extends StatefulWidget {
  @override
  _AddServiceState createState() => _AddServiceState();
}

class _AddServiceState extends State<AddServicePage> {

  final odometerController = TextEditingController();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final distanceController = TextEditingController();

  DateTime dateTime = DateTime.now();
  DateTime dateTimeToChange;
  int odometer = 0;
  String name = "";
  String description = "";
  int price = 0;
  int distance = 0;

  var choiceChip = ["distance", "date", "nothing"];
  String selectedChip = "";

  @override
  void initState() {
    super.initState();

    selectedChip = choiceChip[0];

    odometerController.addListener(() {
      odometer = int.parse(odometerController.text) ?? 0;
    });

    nameController.addListener(() {
      name = nameController.text;
    });

    descriptionController.addListener(() {
      description = descriptionController.text;
    });

    priceController.addListener(() {
      price = int.parse(priceController.text) ?? 0;
    });

    distanceController.addListener(() {
      distance = int.parse(distanceController.text) ?? 0;
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    // This also removes the _printLatestValue listener
    odometerController.dispose();
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    super.dispose();
  }

  String formatDate(DateTime dateTime) {
    if(dateTime==null) return null;
    var formatter = new DateFormat('dd.MM.yyyy');
    return formatter.format(dateTime);
  }

  void _confirmButtonClick() {

    if(selectedChip == choiceChip[0]) dateTimeToChange = null;
    else if(selectedChip == choiceChip[1]) distance = 0;
    else {
      dateTimeToChange = null;
      distance = 0;
    }

    Firestore.instance.collection('service').document()
      .setData({
      "date": dateTime?.millisecondsSinceEpoch?.toString() ?? 0,
      "odometer": odometer,
      "name": name,
      "description": description,
      "dateToChange": dateTimeToChange?.millisecondsSinceEpoch?.toString() ?? "",
      "distanceToChange": distance
    });
  }

  @override
  Widget build(BuildContext ctx) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Добавить"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 24.0),
            GestureDetector(
              onTap: () {
                showDatePicker(
                  context: ctx,
                  initialDate: dateTime,
                  firstDate: DateTime(2018),
                  lastDate: DateTime(2019),
                ).then<DateTime>((DateTime value) {
                  //debugger(when: value!=null);
                  if (value != null) {
                    dateTime = value;
                    setState(() {});
                  }
                });
              },
              child: AbsorbPointer(
                child: TextFormField(
                  initialValue: " ",
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                      enabled: false,
                      border: OutlineInputBorder(),
                      labelText: "Дата",
                      prefixText: formatDate(dateTime)),
                ),
              ),
            ),
            SizedBox(height: 24.0),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  enabled: false,
                  border: OutlineInputBorder(),
                  labelText: "Пробег",
                  suffixText: "км"),
              controller: odometerController,
            ),
            SizedBox(height: 24.0),
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Название",
                  hintText: "Например: масло"),
              controller: nameController,
            ),
            SizedBox(height: 24.0),
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Описание",
                  hintText: "Например: Замена масло двигателя"),
              maxLines: 3,
              controller: descriptionController,
            ),
            SizedBox(height: 24.0),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Цена",
                  suffixText: "руб"),
              controller: priceController,
            ),
            SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ChoiceChip(
                  label: Text("Дистанция"),
                  selected: selectedChip == choiceChip[0],
                  onSelected: (boolean) {
                    setState(() {
                      selectedChip = choiceChip[0];
                    });
                  },
                ),
                ChoiceChip(
                  label: Text("Дата"),
                  selected: selectedChip == choiceChip[1],
                  onSelected: (boolean) {
                    setState(() {
                      selectedChip = choiceChip[1];
                    });
                  },
                ),
                ChoiceChip(
                  label: Text("Ничего"),
                  selected: selectedChip == choiceChip[2],
                  onSelected: (boolean) {
                    setState(() {
                      selectedChip = choiceChip[2];
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 24.0),
            textFormFieldForChoice(),
            SizedBox(height: 24.0),
            OutlineButton(
              child: Text("Подтвердить"),
              onPressed: _confirmButtonClick,
            )
          ],
        ),
      ),
    );
  }

  Widget textFormFieldForChoice() {
    if(selectedChip == choiceChip[0]) {
      return TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Следующая замена через",
          suffixText: "км"
        ),
        controller: distanceController,
      );
    } else if(selectedChip == choiceChip[1]) {
      return GestureDetector(
        onTap: () {
          showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2018),
            lastDate: DateTime(2050),
          ).then<DateTime>((DateTime value) {
            if (value != null) {
              dateTimeToChange = value;
              setState(() {
              });
            }
          });
        },
        child: AbsorbPointer(
          child: TextFormField(
            keyboardType: TextInputType.datetime,
            decoration: InputDecoration(
                enabled: false,
                border: OutlineInputBorder(),
                hintText: formatDate(dateTimeToChange) ?? "Следующая замена",
            )
          ),
        ),
      );
    } else return Container();
  }
}




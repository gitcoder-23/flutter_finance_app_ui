import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_finance_app_ui/data/models/add_data.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final dataBox = Hive.box<AddData>('data');

  String? selectedItem;
  String? selectedItemi;
  DateTime date = DateTime.now();

  final TextEditingController expalinText = TextEditingController();
  FocusNode expalinTextFocus = FocusNode();
  final TextEditingController amountText = TextEditingController();
  FocusNode amountFocus = FocusNode();

  final List<String> item = [
    'Food',
    "Transfer",
    "Transportation",
    "Education",
  ];

  final List<String> _itemei = [
    'Income',
    "Expand",
  ];

  @override
  void initState() {
    expalinTextFocus.addListener(() {
      setState(() {});
    });

    amountFocus.addListener(() {
      setState(() {});
    });

    print('dataBox--> ${dataBox.length}');
    super.initState();
  }

  addDataSave() {
    if (selectedItem == null) {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        msg: "Select any one type of name!",
      );
    } else if (expalinText.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Explain required!",
        backgroundColor: Colors.red,
      );
    } else if (expalinText.text.length <= 3) {
      Fluttertoast.showToast(
        msg: "Explain min 3 letter required!",
        backgroundColor: Colors.red,
      );
    } else if (amountText.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Amount required!",
        backgroundColor: Colors.red,
      );
    } else if (selectedItemi == null) {
      Fluttertoast.showToast(
        msg: "Select how to add!",
        backgroundColor: Colors.red,
      );
    } else {
      // Arrange according to the DB NAME
      var formData = AddData(
        selectedItem!,
        expalinText.text,
        amountText.text,
        selectedItemi!,
        date,
      );
      print('formData=> ${formData.amount}.');

      dataBox.add(formData).then((value) => {
            {Navigator.of(context).pop()}
          });
    }
  }

  // clearTextField() {
  //   expalinText.clear();
  //   amountText.clear();
  //   selectedItem = null;
  //   selectedItemi = null;
  //   date = DateTime.now();
  // }

  // @override
  // void dispose() {
  //   expalinText.dispose();
  //   amountText.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
          child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          buildTopBackgroundContainer(context),
          Positioned(
            top: 120,
            child: mainPositionContainer(),
          )
        ],
      )),
    );
  }

  Container mainPositionContainer() {
    print('item--> $item');

    print('selectedItem-> $selectedItem');
    return Container(
      height: 550,
      width: 340,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Column(
        children: [
          const SizedBox(height: 50),
          listSelectFieldName(),
          const SizedBox(height: 30),
          explainTextBuilder(),
          const SizedBox(height: 30),
          amountTextBuilder(),
          const SizedBox(height: 30),
          howSelectListBuilder(),
          const SizedBox(height: 30),
          dateTimeBuilder(),
          const Spacer(),
          saveButton(),
          const SizedBox(height: 25),
        ],
      ),
    );
  }

  GestureDetector saveButton() {
    return GestureDetector(
      onTap: () => addDataSave(),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color(0xff368983),
        ),
        width: 120,
        height: 50,
        child: const Text(
          'Save',
          style: TextStyle(
            fontFamily: 'f',
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 17,
          ),
        ),
      ),
    );
  }

  Widget dateTimeBuilder() {
    return Container(
      alignment: Alignment.bottomLeft,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 2, color: const Color(0xffC5C5C5))),
      width: 300,
      child: TextButton(
        onPressed: () async {
          DateTime? newDate = await showDatePicker(
              context: context,
              initialDate: date,
              firstDate: DateTime(2020),
              lastDate: DateTime(2100));
          if (newDate == Null) return;
          setState(() {
            date = newDate!;
          });
        },
        child: Text(
          'Date : ${date.year} / ${date.day} / ${date.month}',
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Padding howSelectListBuilder() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 2,
            color: const Color(0xffC5C5C5),
          ),
        ),
        child: DropdownButton<String>(
          value: selectedItemi,
          onChanged: ((value) {
            setState(() {
              selectedItemi = value!;
            });
          }),
          items: _itemei
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Container(
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Text(
                            e,
                            style: const TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                    ),
                  ))
              .toList(),
          selectedItemBuilder: (BuildContext context) => _itemei
              .map((e) => Row(
                    children: [Text(e)],
                  ))
              .toList(),
          hint: const Padding(
            padding: EdgeInsets.only(top: 1),
            child: Text(
              'How',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          dropdownColor: Colors.white,
          isExpanded: true,
          underline: Container(),
        ),
      ),
    );
  }

  Padding amountTextBuilder() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        keyboardType: TextInputType.number,
        focusNode: amountFocus,
        controller: amountText,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          labelText: 'Amount',
          labelStyle: TextStyle(fontSize: 17, color: Colors.grey.shade500),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(width: 2, color: Color(0xffC5C5C5))),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(width: 2, color: Color(0xff368983))),
        ),
      ),
    );
  }

  Padding explainTextBuilder() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        focusNode: expalinTextFocus,
        controller: expalinText,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          labelText: 'Explain',
          labelStyle: TextStyle(
            fontSize: 17,
            color: Colors.grey.shade500,
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(width: 2, color: Color(0xffC5C5C5))),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              width: 2,
              color: Color(0xff368983),
            ),
          ),
        ),
      ),
    );
  }

  Padding listSelectFieldName() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 2,
            color: const Color(0xFFC5C5C5),
          ),
        ),
        child: DropdownButton(
          value: selectedItem,
          onChanged: ((value) {
            setState(() {
              selectedItem = value;
            });

            print('selectedItem-> $value, $selectedItem');
          }),
          items: item
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Container(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 40,
                          child: Image.asset('images/$e.png'),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          e,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
          selectedItemBuilder: (BuildContext context) => item
              .map((e) => Row(
                    children: [
                      SizedBox(
                        width: 42,
                        child: Image.asset('images/$e.png'),
                      ),
                      const SizedBox(width: 5),
                      Text(e),
                    ],
                  ))
              .toList(),
          hint: const Padding(
            padding: EdgeInsets.only(top: 1),
            child: Text(
              'Name',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          dropdownColor: Colors.white,
          isExpanded: true,
          underline: Container(),
        ),
      ),
    );
  }

  Widget buildTopBackgroundContainer(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 240,
          decoration: const BoxDecoration(
            color: Color(0xff368983),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'Adding',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const Icon(
                      Icons.attach_file_outlined,
                      color: Colors.white,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

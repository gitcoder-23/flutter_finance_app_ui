// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:flutter_finance_app_ui/data/listdata.dart';
import 'package:flutter_finance_app_ui/data/models/add_data.dart';
import 'package:flutter_finance_app_ui/data/utlity.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
// To get dynamic DB Hive Data
  var historyBox;
  final hiveBoxData = Hive.box<AddData>('data');
  final List<String> dayList = [
    'Monday',
    "Tuesday",
    "Wednesday",
    "Thursday",
    'friday',
    'saturday',
    'sunday'
  ];

  @override
  Widget build(BuildContext context) {
    print('hiveBoxData-l=> ${hiveBoxData.length}');
    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: hiveBoxData.listenable(),
          builder: (context, value, child) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(height: 340, child: buildHeader()),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          hiveBoxData.isEmpty
                              ? 'Static Tranasaction History'
                              : 'Live Tranasaction History',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 19,
                            color: Colors.black,
                          ),
                        ),
                        const Text(
                          'See all',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: hiveBoxData.isEmpty
                      ? SliverChildBuilderDelegate(
                          (context, index) {
                            return buildStaticSliverList(index);
                          },
                          childCount: geter().length,
                        )
                      : SliverChildBuilderDelegate(
                          (context, index) {
                            historyBox = hiveBoxData.values.toList()[index];
                            print('historyBox=> $historyBox');
                            return getDynamicSliverList(
                              index,
                              historyBox,
                            );
                          },
                          childCount: hiveBoxData.length,
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget getDynamicSliverList(
    int index,
    AddData historyBox,
  ) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        // delete hive DB Data
        historyBox.delete();
      },
      child: buildDynamicSliverList(index, historyBox),
    );
  }

  Widget buildDynamicSliverList(
    int index,
    AddData historyBox,
  ) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.asset(
          'images/${historyBox.name}.png',
          height: 40,
        ),
      ),
      title: Text(
        historyBox.name,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        '${dayList[historyBox.datetime.weekday - 1]}  ${historyBox.datetime.year}-${historyBox.datetime.day}-${historyBox.datetime.month}',
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Text(
        '\$ ${historyBox.amount}',
        style: TextStyle(
          color: historyBox.IN == "Income" ? Colors.green : Colors.red,
          fontSize: 19,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget buildStaticSliverList(int index) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.asset(
          'images/${geter()[index].image!}',
          height: 40,
        ),
      ),
      title: Text(
        geter()[index].name!,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        geter()[index].time!,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Text(
        '\$ ${geter()[index].fee!}',
        style: TextStyle(
          color: geter()[index].buy! ? Colors.red : Colors.green,
          fontSize: 19,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Stack(
      children: [
        // After adding Column get back
        Column(
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
              child: Stack(
                children: [
                  Positioned(
                    top: 35,
                    left: 340,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: Container(
                        height: 40,
                        width: 40,
                        color: const Color.fromRGBO(250, 250, 250, 0.1),
                        child: const Icon(
                          Icons.notification_add_outlined,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 35, left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good Afternoon',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Color.fromARGB(255, 224, 223, 223),
                          ),
                        ),
                        Text(
                          'Lara Croft',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 140,
          left: 37,
          child: Container(
            height: 170,
            width: 320,
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(47, 125, 121, 0.3),
                  offset: Offset(0, 6),
                  blurRadius: 12,
                  spreadRadius: 6,
                ),
                // BoxShadow(
                //   color: Colors.greenAccent,
                //   offset: Offset(
                //     5.0,
                //     5.0,
                //   ),
                //   blurRadius: 10.0,
                //   spreadRadius: 2.0,
                // ),
              ],
              color: const Color.fromARGB(255, 47, 125, 121),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Balance',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      Icon(
                        Icons.more_horiz,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 7),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      Text(
                        '\$ ${total()}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 13,
                            backgroundColor: Color.fromARGB(255, 85, 145, 141),
                            child: Icon(
                              Icons.arrow_downward,
                              color: Colors.white,
                              size: 19,
                            ),
                          ),
                          SizedBox(height: 7),
                          Text(
                            'Income',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Color.fromARGB(255, 216, 216, 216),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 13,
                            backgroundColor: Color.fromARGB(255, 85, 145, 141),
                            child: Icon(
                              Icons.arrow_upward,
                              color: Colors.white,
                              size: 19,
                            ),
                          ),
                          SizedBox(height: 7),
                          Text(
                            'Expenses',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Color.fromARGB(255, 216, 216, 216),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$ ${income()}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.white),
                      ),
                      Text(
                        '\$ ${expenses()}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.white),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_finance_app_ui/data/models/add_data.dart';
import 'package:flutter_finance_app_ui/data/top.dart';
import 'package:flutter_finance_app_ui/data/utlity.dart';
import 'package:flutter_finance_app_ui/widgets/chart.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Statistics extends StatefulWidget {
  const Statistics({super.key});

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  List day = ['Day', 'Week', 'Month', 'Year'];
  int index_color = 0;
  var historyBox;
  final hiveBoxData = Hive.box<AddData>('data');

  List<AddData> buildData = [];

  List hiveAllFunction = [
    today(),
    week(),
    month(),
    year(),
  ];
  final List<String> dayList = [
    'Monday',
    "Tuesday",
    "Wednesday",
    "Thursday",
    'friday',
    'saturday',
    'sunday'
  ];

  List<AddData> a = [];
  ValueNotifier valueNotify = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: valueNotify,
          builder: (BuildContext context, dynamic value, Widget? child) {
            List buildData = hiveAllFunction[value];
            return buildCustomScrollViewStat();
          },
          // child: ,
        ),
      ),
    );
  }

  CustomScrollView buildCustomScrollViewStat() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                'Statistics',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ...List.generate(
                      4,
                      (index) {
                        return GestureDetector(
                          onTap: () {
                            // index_color = index;
                            setState(() {
                              index_color = index;
                              valueNotify.value = index;
                            });
                          },
                          child: Container(
                            height: 40,
                            width: 80,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: index_color == index
                                    ? const Color.fromARGB(255, 47, 125, 121)
                                    : Colors.white),
                            alignment: Alignment.center,
                            child: Text(
                              day[index],
                              style: TextStyle(
                                color: index_color == index
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 120,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Expense',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.arrow_downward_sharp,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Chart(
                indexChart: index_color,
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Top Spending',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      Icons.swap_vert,
                      size: 25,
                      color: Colors.grey,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.asset(
                    'images/${buildData[index].name}.png',
                    height: 40,
                  ),
                ),
                title: Text(
                  buildData[index].name,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  '${buildData[index].datetime.year}-${buildData[index].datetime.day}-${buildData[index].datetime.month}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: Text(
                  '\$ ${buildData[index].amount}',
                  style: TextStyle(
                    color: buildData[index].IN == "Income"
                        ? Colors.green
                        : Colors.red,
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
            childCount: buildData.length,
          ),
        ),
      ],
    );
  }
}

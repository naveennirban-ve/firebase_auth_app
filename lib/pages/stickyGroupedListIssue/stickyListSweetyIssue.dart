import 'package:firebase_auth_app/constants/application.dart';
import 'package:flutter/material.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';


class Element {

  DateTime date;
  bool type;
  String hotelName;
  String subTitle;
  String heading;
  String buttonText;
  Element(
      this.date,
      this.type,
      this.hotelName,
      this.subTitle,
      this.heading,
      this.buttonText);
}

List<Element> _elements = <Element>[
  Element(
    DateTime(2020, 6, 25),
    false,
    "Hotel /1",
    "Jeudi",
    "Terminate",
    "Terminate",
  ),
  Element(
    DateTime(2020, 6, 25),
    false,
    "Hotel /2 ",
    "Jeudi",
    "Terminate",
    "Terminate",
  ),
  Element(
    DateTime(2020, 6, 25),
    false,
    "Hotel /3 ",
    "Jeudi",
    "Terminate",/**/
    "Terminate",
  ),
  Element(
      DateTime(2020, 6, 26),
      true,

      "Hotel /4",
      "Mercredi",
      "Waiting for validation",
      "Vair",
  ),
  Element(
    DateTime(2020, 6, 26),
    true,
    "Hotel /5 ",
    "Mercredi",
    "Waiting for validation",
    "Vair",
  ),

  Element(
    DateTime(2020, 6, 24),
    false,
    "Hotel /6",
    "Jeudi",
    "Hello",
    "Hello",
  ),
  Element(
    DateTime(2020, 6, 24),
    false,
    "Hotel /7",
    "Jeudi",
    "Hello",
    "Hello",
  ),
  Element(
    DateTime(2020, 6, 24),
    false,
    "Hotel /8",
    "Jeudi",
    "Hello",
    "Hello",
  ),
];

// List<Element> _elements = <Element>[
//   Element(DateTime(2020, 6, 24, 18), 'Got to gym', Icons.fitness_center),
//   Element(DateTime(2020, 6, 24, 9), 'Work', Icons.work),
//   Element(DateTime(2020, 6, 25, 8), 'Buy groceries', Icons.shopping_basket),
//   Element(DateTime(2020, 6, 25, 16), 'Cinema', Icons.movie),
//   Element(DateTime(2020, 6, 25, 20), 'Eat', Icons.fastfood),
//   Element(DateTime(2020, 6, 26, 12), 'Car wash', Icons.local_car_wash),
//   Element(DateTime(2020, 6, 27, 12), 'Car wash', Icons.local_car_wash),
//   Element(DateTime(2020, 6, 27, 13), 'Car wash', Icons.local_car_wash),
//   Element(DateTime(2020, 6, 27, 14), 'Car wash', Icons.local_car_wash),
//   Element(DateTime(2020, 6, 27, 15), 'Car wash', Icons.local_car_wash),
//   Element(DateTime(2020, 6, 28, 12), 'Car wash', Icons.local_car_wash),
//   Element(DateTime(2020, 6, 29, 12), 'Car wash', Icons.local_car_wash),
//   Element(DateTime(2020, 6, 29, 12), 'Car wash', Icons.local_car_wash),
//   Element(DateTime(2020, 6, 30, 12), 'Car wash', Icons.local_car_wash),
// ];

class StickyListIssue extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var safeHeight = size.height - MediaQuery.of(context).padding.top;
    var width = size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        /// AppBar
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(150.0),
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.baseLightBlueColor,
                // AppColors.blue,
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(30)),
              ),
              child: Material(
                color: AppColors.baseLightBlueColor,
                elevation: 15,
                shape: const RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.only(bottomRight: Radius.circular(30)),
                ),
                child: Column(
                  children: [
                    AppBar(
                      backgroundColor: AppColors.baseLightBlueColor,
                      elevation: 0.0,
                      actions: [
                        Container(
                            padding: const EdgeInsets.only(right: 20),
                            child: Image.asset(
                              "assets/images/rocket.png",
                              height: 5,
                              width: 22,
                              color: Colors.white,
                            )),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(left: 20),
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: const BoxDecoration(
                        color: AppColors.baseLightBlueColor,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Hello User123,",
                            style:
                            TextStyle(color: AppColors.blue, fontSize: 15),
                          ),
                          SizedBox(height: 10),
                          Text(
                            AppStrings.totalAmount,
                            // "Montant total :",
                            style:
                            TextStyle(color: AppColors.blue, fontSize: 11),
                          ),
                          Text(
                            "592,30 €",
                            style:
                            TextStyle(color: AppColors.blue, fontSize: 25),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )),
        /// FAB
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //openBottomDialog();
          },
          child: Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.blue,
                Colors.blue.shade900,
              ]),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
        body: Container(
          /// 70% of total available height
          height: safeHeight * 0.7,
          child: StickyGroupedListView<Element, DateTime>(
            elements: _elements,
            order: StickyGroupedListOrder.ASC,
            groupBy: (Element element) =>
                DateTime(element.date.year, element.date.month, element.date.day),
            groupComparator: (DateTime value1, DateTime value2) =>
                value2.compareTo(value1),
            itemComparator: (Element element1, Element element2) =>
                element1.date.compareTo(element2.date),
            floatingHeader: true,
            groupSeparatorBuilder: (Element element) => Container(
              height: 50,
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 220,
                  padding: const EdgeInsets.only(left: 20,),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 5),
                    child: Text( element.heading,
                        style: const TextStyle(color: Colors.blueGrey)
                    ),
                  ),
                ),
              ),
            ),
            itemBuilder: (_, Element element) {
              return element.type ?GestureDetector(
                onTap: (){
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=> WaitingForValidation()));
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 2.0,
                    left: 10,
                    right: 10,
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    elevation: 8.0,
                    margin:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                    child: Container(
                      child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          title: Text(
                            element.subTitle +
                                '${element.date.day}/${element.date.month}/'
                                    '${element.date.year}',
                            style: const TextStyle(
                              //color:AppColors.grey
                                color: Color(0xff919AAA),
                                fontSize: 12,
                                fontWeight: FontWeight.w300),
                          ),
                          subtitle: Text(
                            element.hotelName,
                            style: const TextStyle(
                              //color:AppColors.grey
                                color: Color(0xff243656),
                                fontSize: 15,
                                fontWeight: FontWeight.w300),
                          ),
                          trailing: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Card(
                              elevation: 20.0,
                              shadowColor: Colors.blue[100],
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                              child: Container(
                                height: 30,
                                width: 100,
                                decoration: BoxDecoration(
                                  // boxShadow: [BoxShadow(color: AppColors.grey, blurRadius: 20.0)],
                                    borderRadius: BorderRadius.circular(20.0),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.blue,
                                        Colors.blue.shade900,
                                      ],
                                    )),
                                child: MaterialButton(
                                  onPressed: () {},
                                  child: Text(
                                    element.buttonText,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          )
                           ),
                    ),
                  ),
                ),
              ):
              Padding(
                padding: const EdgeInsets.only(
                  top: 2.0,
                  left: 10,
                  right: 10,
                ),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  elevation: 8.0,
                  margin:
                  new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  child: Container(
                    child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        title: Text(
                          element.subTitle +
                              '${element.date.day}/${element.date.month}/'
                                  '${element.date.year}',
                          style: const TextStyle(
                            //color:AppColors.grey
                              color: Color(0xff919AAA),
                              fontSize: 12,
                              fontWeight: FontWeight.w300),
                        ),
                        subtitle: Text(
                          element.hotelName,
                          style: const TextStyle(
                            //color:AppColors.grey
                              color: Color(0xff243656),
                              fontSize: 15,
                              fontWeight: FontWeight.w300),
                        ),
                        trailing: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            height: 30,
                            width: 100,
                            child: MaterialButton(
                              onPressed: () {},
                              child: Text(
                                element.buttonText,
                                style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )
                      // :
                      //Text('${element.date.hour}:00')
                      /*element.date.day==true ?Text('${element.date.hour}:00'): */
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
//
// class Element {
//   DateTime date;
//   String name;
//   IconData icon;
//
//   Element(this.date, this.name, this.icon);
// }
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:jeminiborma/controller/controller.dart';
import 'package:jeminiborma/screen/order_detail_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class OrderList extends StatefulWidget {
  const OrderList({super.key});

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  DateTime selectedDate = DateTime.now();
  String? date;
  TextEditingController seacrh = TextEditingController();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        date = DateFormat('dd-MMM-yyyy').format(selectedDate);
        Provider.of<Controller>(context, listen: false).getorderList(date!);
      });
    } else {
      date = DateFormat('dd-MMM-yyyy').format(selectedDate);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    date = DateFormat('dd-MMM-yyyy').format(selectedDate);
    Provider.of<Controller>(context, listen: false).getorderList(date!);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Order List",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Consumer<Controller>(
        builder: (BuildContext context, Controller value, Widget? child) =>
            SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.calendar_month),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            date!,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 6, right: 6, top: 6, bottom: 6),
                child: TextFormField(
                  controller: seacrh,
                  //   decoration: const InputDecoration(,
                  onChanged: (val) {
                    Provider.of<Controller>(context, listen: false)
                        .searchOrder(val);
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.blue,
                    ),
                    suffixIcon: IconButton(
                      icon: new Icon(Icons.cancel),
                      onPressed: () {
                        seacrh.clear();
                        Provider.of<Controller>(context, listen: false)
                            .searchOrder("");
                      },
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 18, vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(color: Colors.blue, width: 1.0),
                    ),
                    // filled: true,
                    hintStyle: TextStyle(color: Colors.blue, fontSize: 13),
                    hintText: "Search here.. ",
                    // fillColor: Colors.grey[100]
                  ),
                ),
              ),
              value.isOrderLoading
                  ? SpinKitCircle(
                      color: Colors.black,
                    )
                  : value.orderlist.length == 0
                      ? Container(
                          height: size.height * 0.6,
                          child: Center(
                              child: LottieBuilder.asset(
                            "assets/noData.json",
                            height: size.height * 0.24,
                          )))
                      : ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: value.isSearch
                              ? value.filteredlist.length
                              : value.orderlist.length,
                          itemBuilder: (context, int index) {
                            return Card(
                                child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ListTile(
                                onTap: () {
                                  String ordNo;
                                  String total;

                                  if (value.isSearch) {
                                    ordNo =
                                        value.filteredlist[index]["OrderNo"];
                                    total = value.filteredlist[index]["Amount"]
                                        .toString();
                                  } else {
                                    ordNo = value.orderlist[index]["OrderNo"];
                                    total = value.orderlist[index]["Amount"]
                                        .toString();
                                  }
                                  Provider.of<Controller>(context,
                                          listen: false)
                                      .getorderDetails(ordNo);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OrderDetailScreen(
                                              ordNo: ordNo,
                                              total: total.toString(),
                                            )),
                                  );
                                },

                                // leading: CircleAvatar(
                                //   child: Icon(Icons.person),
                                // ),
                                title: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      value.isSearch
                                          ? value.filteredlist[index]
                                              ["Customer_Name"]
                                          : value.orderlist[index]
                                              ["Customer_Name"],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    // Text(
                                    //   value.orderlist[index]["Cust_ID"],
                                    //   style: TextStyle(
                                    //       fontWeight: FontWeight.w500,
                                    //       fontSize: 14,
                                    //       color: Colors.grey[600]),
                                    // ),
                                    Divider(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Ord No : ",
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            Text(
                                              value.isSearch
                                                  ? value.filteredlist[index]
                                                      ["OrderNo"]
                                                  : value.orderlist[index]
                                                      ["OrderNo"],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 17,
                                                  color: Colors.red),
                                            )
                                          ],
                                        ),
                                        value.isSearch
                                            ? value.filteredlist[index]
                                                        ["Billed"] ==
                                                    1
                                                ? Container(
                                                    // width: 60,
                                                    // height: 60,
                                                    child: Center(
                                                        child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        "B",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    )),
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.green),
                                                  )
                                                : Container()
                                            : value.orderlist[index]
                                                        ["Billed"] ==
                                                    1
                                                ? Container(
                                                    // width: 60,
                                                    // height: 60,
                                                    child: Center(
                                                        child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        "B",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    )),
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.green),
                                                  )
                                                : Container(),
                                        value.isSearch
                                            ? value.filteredlist[index]
                                                        ["cancelled"] ==
                                                    1
                                                ? Container(
                                                    // width: 60,
                                                    // height: 60,
                                                    child: Center(
                                                        child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        "C",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    )),
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.red),
                                                  )
                                                : Container()
                                            : value.orderlist[index]
                                                        ["cancelled"] ==
                                                    1
                                                ? Container(
                                                    // width: 60,
                                                    // height: 60,
                                                    child: Center(
                                                        child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        "C",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    )),
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.red),
                                                  )
                                                : Container(),
                                        Row(
                                          children: [
                                            Text(
                                              value.isSearch
                                                  ? "\u{20B9}${value.filteredlist[index]["Amount"].toString()}"
                                                  : "\u{20B9}${value.orderlist[index]["Amount"].toString()}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17),
                                            )
                                          ],
                                        ),
                                      ],
                                    )
                                    // Text("sfcnjhdbsfffffffffffffffffffffffffffffs jjjjjjjjjjjjdhjhdds bbbbbbbbbb")
                                  ],
                                ),
                              ),
                            ));
                          })
            ],
          ),
        ),
      ),
    );
  }
}

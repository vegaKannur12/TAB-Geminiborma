import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:jeminiborma/components/custom_snackbar.dart';
import 'package:jeminiborma/controller/controller.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class ItemWidget extends StatefulWidget {
  List<Map<String, dynamic>> list;
  String catId;
  ItemWidget({required this.list, required this.catId});
  @override
  State<ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  List<String> s = [];
  String? date;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    date = DateFormat('dd-MMM-yyyy').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Orientation ori = MediaQuery.of(context).orientation;
    return Consumer<Controller>(
      builder: (context, value, child) => Expanded(
          child: widget.list.length == 0
              ? Container(
                  // height: size.height * 0.7,
                  child: Center(
                      child: Lottie.asset(
                  "assets/noitem.json",
                  height: size.height * 0.34,
                )))
              : ResponsiveGridList(
                  minItemWidth: size.width / 1.2, //300
                  minItemsPerRow: 1, maxItemsPerRow: 2,
                  // crossAxisCount: ori == Orientation.portrait ? 1 : 2,
                  // childAspectRatio: ori == Orientation.portrait ? 4 : 3.5,   //tab
                  // childAspectRatio:2,
                  // shrinkWrap: true,
                  children: List.generate(widget.list.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 2.0, right: 2),
                      child: Card(
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            contentPadding:
                                EdgeInsets.only(left: 8.0, right: 0),
                            title: Text(
                              "${widget.list[index]["Product"].toString()} (${widget.list[index]["code"]})",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color:
                                      const Color.fromARGB(255, 3, 100, 180)),
                            ),
                            // leading: CircleAvatar(),
                            subtitle: Column(
                              children: [
                                Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    widget.list[index]["Pkg"] == null ||
                                            widget.list[index]["Pkg"] == ""
                                        ? Container()
                                        : Container(
                                            decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 235, 234, 234),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              // border: Border.all(
                                              //     color: Colors.red)
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0,
                                                  right: 8,
                                                  bottom: 4,
                                                  top: 4),
                                              child: Text(
                                                widget.list[index]["Pkg"],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                    widget.list[index]["Unit"] == null ||
                                            widget.list[index]["Unit"] == ""
                                        ? Container()
                                        : Container(
                                            decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 247, 208, 221),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              // border: Border.all(
                                              //     color: Colors.green)
                                              // color: Colors.yellow,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0,
                                                  right: 8,
                                                  bottom: 4,
                                                  top: 4),
                                              child: Text(
                                                "${widget.list[index]["Unit"]}",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                    Row(
                                      children: [
                                        // Text("Rs : "),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.yellow,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0,
                                                right: 8,
                                                bottom: 4,
                                                top: 4),
                                            child: Text(
                                              "\u{20B9}${widget.list[index]["Srate"].toStringAsFixed(2)}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: size.height * 0.01,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white),
                                        onPressed: value.response[index] > 0
                                            ? null
                                            : () {
                                                if (value.customerId == null) {
                                                  CustomSnackbar snackbar =
                                                      CustomSnackbar();
                                                  snackbar.showSnackbar(
                                                      context,
                                                      "Please choose a Customer",
                                                      "");
                                                } else {
                                                  Provider.of<Controller>(
                                                          context,
                                                          listen: false)
                                                      .updateCart(
                                                          context,
                                                          widget.list[index],
                                                          date!,
                                                          value.customerId
                                                              .toString(),
                                                          double.parse(value
                                                              .qty[index].text),
                                                          index,
                                                          "from itempage",
                                                          0,
                                                          widget.catId);
                                                  Provider.of<Controller>(
                                                          context,
                                                          listen: false)
                                                      .viewCart(
                                                    context,
                                                    value.customerId.toString(),
                                                  );
                                                }
                                              },
                                        icon: value.response[index] > 0
                                            ? Icon(Icons.done)
                                            : Icon(Icons.shopping_cart),
                                        label: value.isAdded[index]
                                            ? SpinKitThreeInOut(
                                                color: Colors.black,
                                                size: 12,
                                              )
                                            : value.response[index] > 0
                                                ? Text("Added")
                                                : Text("Add to Bag")),
                                    Row(
                                      children: [
                                        InkWell(
                                            onTap: () {
                                              value.response[index] = 0;

                                              Provider.of<Controller>(context,
                                                      listen: false)
                                                  .setQty(1.0, index, "dec");
                                            },
                                            child: Icon(
                                              Icons.remove,
                                              color: Colors.red,
                                            )),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 5,
                                              right: 5,
                                              top: 5,
                                              bottom: 5),
                                          width: size.width * 0.14,
                                          // height: size.height * 0.05,
                                          child: TextField(
                                            onTap: () {
                                              value.qty[index].selection =
                                                  TextSelection(
                                                      baseOffset: 0,
                                                      extentOffset: value
                                                          .qty[index]
                                                          .value
                                                          .text
                                                          .length);
                                            },
                                            onSubmitted: (val) {
                                              value.response[index] = 0;
                                              Provider.of<Controller>(context,
                                                      listen: false)
                                                  .updateCart(
                                                      context,
                                                      widget.list[index],
                                                      date!,
                                                      value.customerId
                                                          .toString(),
                                                      double.parse(val),
                                                      index,
                                                      "from itempage",
                                                      0,
                                                      widget.catId);
                                              Provider.of<Controller>(context,
                                                      listen: false)
                                                  .viewCart(
                                                context,
                                                value.customerId.toString(),
                                              );
                                            },
                                            onChanged: (val) {
                                              value.response[index] = 0;
                                            },
                                            controller: value.qty[index],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w600),
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.all(3),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color: Colors
                                                        .grey), //<-- SEE HERE
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color: Colors
                                                        .grey), //<-- SEE HERE
                                              ),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                            onTap: () {
                                              value.response[index] = 0;
                                              Provider.of<Controller>(context,
                                                      listen: false)
                                                  .setQty(1.0, index, "inc");
                                            },
                                            child: Icon(
                                              Icons.add,
                                              color: Colors.green,
                                            )),
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: size.height * 0.02,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                )),
    );
  }
}

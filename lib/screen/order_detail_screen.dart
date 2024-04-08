import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:jeminiborma/controller/controller.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class OrderDetailScreen extends StatefulWidget {
  String? ordNo;
  String total;
  OrderDetailScreen({super.key, required this.ordNo, required this.total});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () 
          {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.ordNo.toString(),
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white,),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "\u{20B9}${widget.total.toString()}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white,),
            ),
          )
        ],
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Consumer<Controller>(
        builder: (BuildContext context, Controller value, Widget? child) =>
            value.isOrderLoading
                ? SpinKitCircle(
                    color: Colors.black,
                  )
                : value.orderDetails.length == 0
                     ? Container(
                        height: size.height*0.8,
                        child: Center(child: LottieBuilder.asset("assets/noData.json",height: size.height*0.24,)))
                      
                    : ListView.builder(
                        itemCount: value.orderDetails.length,
                        itemBuilder: (context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: ListTile(
                                  title: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              "${value.orderDetails[index]["Item"]} ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: const Color.fromARGB(
                                                      255, 5, 135, 241)),
                                            ),
                                          ),
                                          // Flexible(
                                          //     child: Text(
                                          //         "dfknsjfns fs fkskfs faskkkkkkkkkk jnfjnsfjsfznsf sfjknsf")),
                                          Flexible(
                                            child: Text(
                                              "(${value.orderDetails[index]["Code"]} )",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: Colors.grey),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text("Qty : "),
                                              Text(
                                                "${value.orderDetails[index]["Qty"]} ",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                  "(${value.orderDetails[index]["Unit"]}) ")
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "\u{20B9}${value.orderDetails[index]["Rate"]} ",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      Divider(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text("Total : "),
                                          Text(
                                            "\u{20B9}${value.orderDetails[index]["Amount"]} ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red,
                                                fontSize: 18),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
      ),
    );
  }
}

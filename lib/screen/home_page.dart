import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:jeminiborma/components/custom_snackbar.dart';
import 'package:jeminiborma/controller/controller.dart';
import 'package:jeminiborma/model/customer_model.dart';
import 'package:jeminiborma/screen/cart_page.dart';
import 'package:jeminiborma/screen/order_form.dart';
import 'package:jeminiborma/screen/order_list.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? date;
  late CustomerModel selectedItem;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    date = DateFormat('dd-MMM-yyyy').format(DateTime.now());
    selectedItem = CustomerModel();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Controller>(context, listen: false).initDb(context, "");
      Provider.of<Controller>(context, listen: false).getOs();

      // Provider.of<Controller>(context, listen: false).getCategoryList(context);
      // Provider.of<Controller>(context, listen: false).getCustomerList(context);
    });
  }

  TextEditingController cusCon = TextEditingController();
  List customerList = ["haiiii", "hoyyyy", "hsbhbf"];
  String? selected;
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    Orientation ori=MediaQuery.of(context).orientation;
    print("Width=> ${size.width}");
    print("Height=> ${size.height}");

    // return OrientationBuilder(
    //   builder: (BuildContext context, Orientation orientation) { 
    //    final isPortrait=orientation==Orientation.portrait;
       return Scaffold(
        extendBody: true,
        appBar: AppBar(
          // leading: Consumer<Controller>(
          //     builder: (BuildContext context, Controller value, Widget? child) =>
          //         Text(
          //           value.os.toString(),
          //           style: TextStyle(
          //               fontWeight: FontWeight.bold, color: Colors.white,fontSize: 14),
          //         )),
          automaticallyImplyLeading: false,
          title: Consumer<Controller>(
              builder: (BuildContext context, Controller value, Widget? child) =>
                  Text(
                    value.os.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )),
          backgroundColor: Theme.of(context).primaryColor,
          actions: [
            TextButton(
                onPressed: () {
                  Provider.of<Controller>(context, listen: false)
                      .setIsSearch(false);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const OrderList()),
                  );
                },
                child: const Row(
                  children: [
                    Text(
                      "View Order History",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Icon(
                      Icons.history,
                      color: Colors.white,
                    )
                  ],
                ))
          ],
        ),
        // bottomNavigationBar: BottomNavigationBar(items: [
        //   BottomNavigationBarItem(
        //     icon: Icon(Icons.shopping_cart),
        //     tooltip: "jkdjdsj"
        //   )
        // ]),
        bottomNavigationBar: Container(
          height: size.height * 0.06,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Consumer<Controller>(
            builder: (context, value, child) => InkWell(
              onTap: () {
                if (value.customerId != null) {
                  Provider.of<Controller>(context, listen: false).viewCart(
                    context,
                    value.customerId.toString(),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartPage()),
                  );
                } else {
                  CustomSnackbar snackbar = CustomSnackbar();
                  snackbar.showSnackbar(
                      context, "Please choose a Customer!!! ", "");
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "View Order",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  badges.Badge(
                    position: badges.BadgePosition.topEnd(top: -10, end: -19),
                    showBadge: true,
                    badgeContent: Text(
                      value.cartCount == null ? "0" : value.cartCount.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                    child: Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                    ),
                  ),
      
                  // ElevatedButton.icon(
                  //     style: ElevatedButton.styleFrom(primary: Colors.green),
                  //     onPressed: () {
                  //       if (value.customerId != null) {
                  //         Provider.of<Controller>(context, listen: false).viewCart(
                  //           context,
                  //           value.customerId.toString(),
                  //         );
                  //         Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => const CartPage()),
                  //         );
                  //       } else {
                  //         CustomSnackbar snackbar = CustomSnackbar();
                  //         snackbar.showSnackbar(
                  //             context, "Please choose a Customer", "");
                  //       }
                  //     },
                  //     icon: Icon(
                  //       Icons.shopping_cart,
                  //       color: Colors.white,
                  //     ),
                  //     label: Text(
                  //       "View Cart",
                  //       style: TextStyle(color: Colors.white),
                  //     )),
                  // ElevatedButton.icon(
                  //     style: ElevatedButton.styleFrom(primary: Colors.green),
                  //     onPressed: () async {
                  //       await showDialog(
                  //           context: context,
                  //           builder: (context) {
                  //             return AlertDialog(
                  //               content: Text(
                  //                 'Save Order?',
                  //                 style: TextStyle(
                  //                     fontWeight: FontWeight.bold, fontSize: 16),
                  //               ),
                  //               actions: <Widget>[
                  //                 ElevatedButton(
                  //                     onPressed: () {
                  //                       Navigator.of(context, rootNavigator: true)
                  //                           .pop(false);
                  //                     },
                  //                     child: Text('No')),
                  //                 ElevatedButton(
                  //                     onPressed: () {
                  //                       // Provider.of<Controller>(context,
                  //                       //         listen: false)
                  //                       //     .viewCart(
                  //                       //   context,
                  //                       //   value.customerId.toString(),
                  //                       // );
                  //                       value.saveOrder(context, date.toString(),
                  //                           value.sum, value.cartItems.length);
                  //                       Navigator.pop(context);
                  //                     },
                  //                     child: Text("Yes"))
                  //               ],
                  //             );
                  //           });
                  //     },
                  //     icon: Icon(
                  //       Icons.save,
                  //       color: Colors.white,
                  //     ),
                  //     label: Text(
                  //       "SAVE",
                  //       style: TextStyle(color: Colors.white),
                  //     ))
                ],
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Consumer<Controller>(
            builder: (context, value, child) => Column(
              children: [
                SizedBox(
                  height: size.height * 0.02,
                ),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 8),
                      width: size.width * 0.87,
                      // height: size.height * 0.06,
                      child: IgnorePointer(
                        ignoring: value.isfreez ? true : false,
                        child: DropdownSearch<CustomerModel>(
                          dropdownBuilder: (context, selectedItem) {
                            return Text(
                              value.selected == null
                                  ? "Select Customer"
                                  : selectedItem!.accName.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            );
                          },
                          // selectedItem: _selected,
                          validator: (text) {
                            if (text == null) {
                              return 'Please Select Customer';
                            }
                            return null;
                          },
                          // key: _key1,
      
                          itemAsString: (item) => item.accName.toString(),
                          asyncItems: (filter) =>
                              Provider.of<Controller>(context, listen: false)
                                  .getCustomerList(context, filter),
                          popupProps: PopupProps.menu(
                            // showSelectedItems: true,
                            isFilterOnline: true,
                            showSearchBox: true,
                            searchFieldProps: TextFieldProps(
                              controller: cusCon,
                              decoration: InputDecoration(
                                  hintText: "Type Here",
                                  hintStyle: TextStyle(
                                      color: Colors.grey[500], fontSize: 17),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  )),
                            ),
                          ),
                          // items: ["anu", "shilpa", "danush"],
                          onChanged: (values) {
                            selectedItem = values!;
                            value.selected = values.accName;
                            value.setcustomerId(values.accId.toString(), context);
                          },
                          dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  // hintText: "Select Customer",
                                  hintStyle: TextStyle(
                                      color: Colors.grey[700], fontSize: 17),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ))),
                        ),
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                          color: const Color.fromARGB(255, 12, 67, 161),
                          onPressed: () {
                            selectedItem = CustomerModel();
                            value.selected = null;
                            value.freezeDropdown(false);
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.refresh,
                            size: 29,
                          )),
                    )
                  ],
                ),
                // Container(
                //   child: Text("Customer Slecetion"),
                // ),
                Container(
                  margin:
                      EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.calendar_month),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        date.toString(),
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                value.isCusLoading
                    ? SpinKitCircle(
                        color: Colors.black,
                      )
                    : OrderForm(ori: ori,),
              ],
            ),
          ),
        ),
      );
    
  }
}

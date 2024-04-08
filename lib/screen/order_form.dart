import 'package:flutter/material.dart';
import 'package:jeminiborma/components/custom_snackbar.dart';
import 'package:jeminiborma/controller/controller.dart';
import 'package:jeminiborma/screen/items_screen.dart';
import 'package:provider/provider.dart';

class OrderForm extends StatefulWidget {
  Orientation ori;
   OrderForm({
    required this.ori,
    super.key});

  @override
  State<OrderForm> createState() => _OrderFormState();
}

class _OrderFormState extends State<OrderForm> {
  
  // List<Map<String, dynamic>> categoryList = [
  //   {"cat": "Puffs", "image": ""},
  //   {"cat": "Puffs", "image": ""},
  //   {"cat": "Puffs", "image": ""},
  //   {"cat": "Puffs", "image": ""},
  //   {"cat": "Puffs", "image": ""},
  //   {"cat": "Puffs", "image": ""},
  // ];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Orientation ori=widget.ori;
    return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Consumer<Controller>(
      builder: (context, value, child) {
        // final port=widget.isPortrait;
        return Container(
        child: GridView.builder(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemCount: value.categoryList.length,
          gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: ori==Orientation.portrait?2:4,childAspectRatio: 1.4,
              crossAxisSpacing: 12, mainAxisSpacing: 12),
          itemBuilder: (context, index) {
            return categoryWidget(size, index, value.categoryList[index]);
          },
        ),
      );}
    ),
          );
  }

///////////////////////////////////////////////////////////////////////
  Widget categoryWidget(Size size, int index, Map map) {
    return Consumer<Controller>(
      builder: (context, value, child) => InkWell(
        onTap: () {
          if (value.customerId != null) {
            Provider.of<Controller>(context, listen: false)
                .getItemList(context, map["Cat_Id"]);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProductScreen(
                      catName: map["Cat_Name"].toString(),
                      catId: map["Cat_Id"])
                      ),
            );
          } else {
            CustomSnackbar snackbar = CustomSnackbar();
            snackbar.showSnackbar(context, "Please choose a Customer!!!", "");
          }
        },
        child: SizedBox(
          child: Card(
            color: Colors.grey[200],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Image.asset(
                    "assets/sweets.png",
                    height: size.height * 0.09,
                    width: size.width * 0.15,
                    // fit: BoxFit.contain,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  // width: size.width * 0.9,
                  decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(255, 53, 52, 52)),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                    child: Text(
                      map["Cat_Name"].toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                // // Padding(
                // //   padding: const EdgeInsets.all(12.0),
                // //   child: CircleAvatar(
                // //     radius: 30,
                // //     backgroundColor: Colors.transparent,
                // //     backgroundImage:AssetImage(
                // //       "assets/cake.png",
                // //       // height: 60,
                // //       // width: 60,
                // //       // fit: BoxFit.contain,
                // //     ),
                // //   ),
                // // ),
                // // SizedBox(
                // //   height: size.height * 0.03,
                // // ),
                // Expanded(
                //   child: Container(
                //     // alignment: Alignment.center,
                //     // width: size.width * 0.9,
                //     decoration: BoxDecoration(
                //         // borderRadius: BorderRadius.circular(20),
                //         color: const Color.fromARGB(255, 53, 52, 52)),
                //     child: Padding(
                //       padding: const EdgeInsets.only(
                //           left: 8.0, right: 8, top: 7, bottom: 7),
                //       child: Text(
                //         map["Cat_Name"].toString(),
                //         style: TextStyle(
                //             color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),
                //         overflow: TextOverflow.ellipsis,
                //       ),
                //     ),
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

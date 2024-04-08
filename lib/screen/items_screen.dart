import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:jeminiborma/controller/controller.dart';
import 'package:jeminiborma/db_helper.dart';
import 'package:jeminiborma/screen/item_widget.dart';
import 'package:jeminiborma/screen/table_list.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatefulWidget {
  String catName;
  String? catId;
  ProductScreen({required this.catName, required this.catId});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  TextEditingController seacrh = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: Consumer<Controller>(
          builder: (BuildContext context, Controller value, Widget? child)=> IconButton(
              onPressed: () {
                Provider.of<Controller>(context, listen: false).viewCart(
                  context,
                  value.customerId.toString(),
                );
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back,color: Colors.white,)),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "${widget.catName.toString().toUpperCase()}",
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<Controller>(
        builder: (context, value, child) => value.isLoading
            ? SpinKitCircle(
                color: Colors.black,
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: seacrh,
                      //   decoration: const InputDecoration(,
                      onChanged: (val) {
                        Provider.of<Controller>(context, listen: false)
                            .searchItem(val);
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
                                .searchItem("");
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
                          borderSide:
                              BorderSide(color: Colors.blue, width: 1.0),
                        ),
                        // filled: true,
                        hintStyle: TextStyle(color: Colors.blue, fontSize: 13),
                        hintText: "Search Item here.. ",
                        // fillColor: Colors.grey[100]
                      ),
                    ),
                  ),
                  value.isSearch
                      ? ItemWidget(
                          list: value.filteredlist,
                          catId: widget.catId.toString(),
                        )
                      : ItemWidget(
                          list: value.itemList, catId: widget.catId.toString())
                ],
              ),
      ),
    );
  }
}

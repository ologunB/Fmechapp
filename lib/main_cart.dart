import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'libraries/custom_button.dart';

class MainCart extends StatefulWidget {
  @override
  _MainCartState createState() => _MainCartState();
}

class _MainCartState extends State<MainCart> {
  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: primaryColor),
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: TabBar(
              isScrollable: true,
              unselectedLabelColor: primaryColor,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    primaryColor,
                    Colors.deepPurple,
                    Colors.blueAccent,
                  ]),
                  borderRadius: BorderRadius.circular(50),
                  color: primaryColor),
              tabs: [
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "My Cart",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("Cart History",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                ),
              ]),
          centerTitle: true,
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: TabBarView(children: [
            MyCart(),
            CartHistory(),
          ]),
        ),
      ),
    );
  }
}

class MyCart extends StatefulWidget {
  @override
  _MyCartState createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  var counter = 0;
  List<Item> _data = [Item(isExpanded: false)];

  List<Item> _data2 = [Item(isExpanded: false)];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    _data[index].isExpanded = !isExpanded;
                  });
                },
                children: _data.map<ExpansionPanel>((Item item) {
                  return ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return ListTile(
                          title: Text(
                            "Cart Items",
                            style: TextStyle(fontSize: 22),
                          ),
                        );
                      },
                      body: Container(
                        height: MediaQuery.of(context).size.height / 2,
                        child: ListView.builder(
                            itemCount: 7,
                            itemBuilder: (context, position) {
                              return Card(
                                child: Container(
                                  height: 110,
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                      "assets/images/placeholder.png"),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.0, vertical: 9),
                                            child: Container(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    "Gear Box",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    "Sold by: Alan Ray",
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                    ),
                                                  ),

                                                  Text(
                                                    "\₦" + "33",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        color:
                                                            Colors.deepPurple),
                                                  )
                                                  //CupertinoTextField()
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Align(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: InkWell(
                                                  onTap: () {},
                                                  child: Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                    size: 30,
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  IconButton(
                                                    icon: Icon(
                                                        Icons.remove_circle,
                                                        size: 35,
                                                        color: Colors.black38),
                                                    onPressed: () {
                                                      setState(
                                                        () {
                                                          if (counter != 0) {
                                                            counter--;
                                                          }
                                                        },
                                                      );
                                                    },
                                                  ),
                                                  Text(
                                                    "0".toString(),
                                                    style: TextStyle(
                                                        fontSize: 32,
                                                        color: Colors.black38),
                                                  ),
                                                  IconButton(
                                                    icon: Icon(Icons.add_circle,
                                                        size: 35,
                                                        color:
                                                            Colors.deepPurple),
                                                    onPressed: () {
                                                      setState(
                                                        () {
                                                          counter++;
                                                        },
                                                      );
                                                    },
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                      isExpanded: item.isExpanded,
                      canTapOnHeader: true);
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    _data2[index].isExpanded = !isExpanded;
                  });
                },
                children: _data2.map<ExpansionPanel>((Item item) {
                  return ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return ListTile(
                          title: Text(
                            "Local Address",
                            style: TextStyle(fontSize: 22),
                          ),
                        );
                      },
                      body: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CupertinoTextField(
                              placeholder: "Street Address",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CupertinoTextField(
                                    placeholder: "Phone Number",
                                    style: TextStyle(fontSize: 20),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CupertinoTextField(
                                    placeholder: "Zip code",
                                    style: TextStyle(fontSize: 20),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      isExpanded: item.isExpanded,
                      canTapOnHeader: true);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Sub-Total",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              Text("\₦" + "33", //widget.totalValue.toStringAsFixed(2),
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo)),
              Text("Charge and Delivery",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              Text("\₦" + "33", //widget.totalValue.toStringAsFixed(2),
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo)),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Total",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  Text("\₦" + "33", //widget.totalValue.toStringAsFixed(2),
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo)),
                ],
              ),
              Center(
                child: CustomButton(
                  title: "   PLACE TO ORDER   ",
                  onPress: () {},
                  icon: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                  iconLeft: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CartHistory extends StatefulWidget {
  @override
  _CartHistoryState createState() => _CartHistoryState();
}

class _CartHistoryState extends State<CartHistory>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  int counter = 0;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 4,
        itemBuilder: (context, position) {
          return Card(
            child: Container(
              height: 110,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image:
                                  AssetImage("assets/images/placeholder.png"),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10.0, vertical: 9),
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Gear Box",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Sold by: Alan Ray",
                                style: TextStyle(
                                  fontSize: 17,
                                ),
                              ),

                              Text(
                                "\₦" + "33",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.deepPurple),
                              )
                              //CupertinoTextField()
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerRight,
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "x ",
                                  style: TextStyle(
                                      fontSize: 28, color: Colors.black38),
                                ),
                                Text(
                                  "0".toString(),
                                  style: TextStyle(
                                      fontSize: 28, color: Colors.black38),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "En Route",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.red,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class Item {
  Item({this.isExpanded = false});

  bool isExpanded;
}

//onTap: () {
//setState(() {
//_data.removeWhere((currentItem) => item == currentItem);
//});
//}

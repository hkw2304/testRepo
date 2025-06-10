import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:teamfinalproject/model/cart.dart';
import 'package:teamfinalproject/model/jjiage.dart';
import 'package:teamfinalproject/model/jjiageTitle.dart';
import 'package:teamfinalproject/screens/pay/pay.dart';

class MenuDetailSelect extends StatefulWidget{


  final  List<JjiageModel> jjiageArr;
  final JjiageTitleModel jjiageTitleArr;
  final List<CartModel> cartArr;
  final List<int> ArrCnt;

  MenuDetailSelect({super.key, required this.jjiageArr, required this.jjiageTitleArr, required this.cartArr, required this.ArrCnt});

  @override
  State<MenuDetailSelect> createState() => _MenuDetailSelectState();
}

class _MenuDetailSelectState extends State<MenuDetailSelect> {


  bool _visibility = false;
  void _show() {
    setState(() {
      _visibility = true;
    });
  }
  void _hide() {
    setState(() {
      _visibility = false;
    });
  }

  Future<void> dbConnector(String select, int menu_id, int store_id) async {
    print("Connecting to mysql server...");
    // MySQL 접속 설정
      final conn = await MySQLConnection.createConnection(
        host: '172.31.9.38',
        port: 3306,
        userName: 'root',
        password: '1234',
        databaseName: 'delivery-data', // optional
      );

      await conn.connect();

      print("Connected");
      int id = Random().nextInt(500);

      if(select == 'add') {
        await conn.execute("INSERT INTO cart VALUES(:id, :add_time, :menu_id, :storeid, :user_id)",
          {
            'id': id,
            'add_time': DateTime.now(),
            'menu_id': menu_id,
            'storeid' : store_id,
            'user_id' : 1
          },
        );
      }
    else if(select == 'sub') {
      await conn.execute("delete from cart where menu_id = :menu_id ORDER BY add_time DESC LIMIT 1",
        {
          'menu_id': menu_id,
        },
      );
    }
      print('connect out...');
      await conn.close();
  }
  Widget build(BuildContext context){
    int totalAmount = 0;
    for(int i = 0; i < widget.ArrCnt.length; i++){
      totalAmount += widget.ArrCnt[i] * widget.jjiageArr[i].menu_amount;
    };
    return Scaffold(

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.white,
        onPressed: () {
          _visibility? _hide() : _show();
        },
        label: Text('장바구니'),
        icon: Icon(Icons.add_shopping_cart),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Expanded(
        child: Stack(
          children: [
            Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15.0,),
                      Row(
                        children: [
                         ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Image.network(
                                widget.jjiageTitleArr.url,
                                width: 170.0,
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.jjiageTitleArr.store_name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.0,
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                '최소주문: ${widget.jjiageTitleArr.store_min_amount}원'
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                '영업시간',
                                style: TextStyle(
                                  color: Colors.black38,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0,),
        
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                          '메뉴',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
                          ),
                      ),
                      Expanded(
                        child: GridView.builder(
                          itemCount: widget.jjiageArr.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              mainAxisSpacing: 20.0,
                          ),
                          itemBuilder: (BuildContext context, int index){
                            return Container(
                              margin: EdgeInsets.only(bottom: 10.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey.withOpacity(0.7),
                                  ),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.7),
                                    spreadRadius: 0,
                                    blurRadius: 5.0,
                                    offset: Offset(0, 4), // changes position of shadow
                                  )
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                     Image.network(
                                       widget.jjiageArr[index].url,
                                       width: 380.0,
                                       height: 180.0,
                                     ),
                                      SizedBox(height: 25.0,),
                                      Expanded(
                                        child: Text(
                                          widget.jjiageArr[index].menu_name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        '${widget.jjiageArr[index].menu_amount}원',
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
        
            Visibility(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Stack(
                  children: [
                    Opacity(
                      opacity: 0.90,
                      child: Container(
                        color: Colors.white,
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 100.0,
                        ),
                        Row(
                          children: [
                            Icon(
                                Icons.add_shopping_cart,
                                size: 38.0,
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            Text(
                              '장바구니',
                              style: TextStyle(
                                fontSize: 38,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0,),
                        Expanded(
                          child: GridView.builder(
                              itemCount: widget.jjiageArr.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1,
                                  childAspectRatio: 4
                              ),
                              itemBuilder: (BuildContext, int index) {
                                return Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('${widget.jjiageArr[index].menu_name}(${widget.jjiageArr[index].menu_amount})'),
                                        SizedBox(height: 5.0,),
                                        Expanded(
                                          child: Row(
                                            children: [
                                              SizedBox(width: 5.0,),
                                              OutlinedButton(onPressed: (){
                                                setState(() {
                                                  widget.ArrCnt[index]++;
                                                  dbConnector('add', widget.jjiageArr[index].id, widget.jjiageArr[index].store_id);
                                                  totalAmount += widget.ArrCnt[index] * widget.jjiageArr[index].menu_amount;
                                                });
                                              }, child: Text('+1'),
                                              ),
                                              SizedBox(width: 10.0,),
                                              OutlinedButton(onPressed: (){
                                                if(widget.ArrCnt[index] == 0){
                                                  widget.ArrCnt[index] = 0;
                                                  return;
                                                }
                                                  setState(() {
                                                    widget.ArrCnt[index]--;
                                                    dbConnector('sub', widget.jjiageArr[index].id, widget.jjiageArr[index].store_id);
                                                    totalAmount += widget.ArrCnt[index] * widget.jjiageArr[index].menu_amount;
                                                  });
                                                }, child: Text('-1'),
                                              ),
                                              SizedBox(width: 50.0,),
                                              Text('${widget.ArrCnt[index]} 개'),
                                              SizedBox(width: 20.0,),
                                              Text('${widget.ArrCnt[index] * widget.jjiageArr[index].menu_amount}원'),
                                              SizedBox(width: 5.0,),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                );
                              },
                          ),
                        ),

                      ],
                    ),
                    Positioned(
                      right: 50.0,
                      bottom: 85.0,
                      child: Column(
                        children: [
                          Text(
                              '총액 : ${totalAmount}원',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                          ),
                          SizedBox(height: 10.0,),
                          ElevatedButton(
                            onPressed: (){

                            },
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PayPage()
                                    ),
                                );
                              },
                              child: Text('결제하기'),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              visible: _visibility,
            ),
          ],
        ),
      ),
    );
  }
}
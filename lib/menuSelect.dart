import 'package:flutter/material.dart';
import 'package:teamfinalproject/model/cart.dart';
import 'package:teamfinalproject/model/jjiage.dart';
import 'package:teamfinalproject/model/jjiageTitle.dart';
import 'package:teamfinalproject/screens/menuPage.dart';

class MenuSelect extends StatelessWidget {

  final String menuTitle;
  final List<JjiageModel> jjiageArr;
  final List<JjiageTitleModel> jjiageTitleArr;
  final List<CartModel> cartArr;
  final List<int> ArrCnt;
  MenuSelect({super.key, required this.menuTitle, required this.jjiageArr, required this.jjiageTitleArr, required this.cartArr, required this.ArrCnt});

  Widget build(BuildContext context) {

    return Scaffold(

        body:GridView.builder(
            itemCount: jjiageTitleArr.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 0.9,

            ),

            itemBuilder: (BuildContext context, int index){
              return Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Container(
                    height: 450.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.grey),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.7),
                          spreadRadius: 0,
                          blurRadius: 5.0,
                          offset: Offset(0, 10), // changes position of shadow
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Image.network(
                                    jjiageTitleArr[index].url,
                                    width:100.0,
                                ),
                              ),
                              SizedBox(
                                width: 15.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    jjiageTitleArr[index].store_name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30.0,
                                    ),
                                  ),
                                  SizedBox(height: 25.0,),
                                  Text(
                                      '최소주문: ${jjiageTitleArr[index].store_min_amount}원',
                                      style: TextStyle(
                                        color: Colors.black45,
                                      ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          SizedBox(
                            height: 25.0,
                          ),
                          jjiageTitleArr[index].store_id == jjiageArr[0].store_id ?
                          GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => MenuDetailSelect(jjiageTitleArr : jjiageTitleArr[index], jjiageArr : jjiageArr,cartArr: cartArr , ArrCnt: ArrCnt),
                                ),
                              );
                            },
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Expanded(
                                child: Container(
                                  width: jjiageArr.length > 4  ? 1500.0 : 550.0,
                                  child: Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        for(int i = 0; i < jjiageArr.length; i++)
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Image.network(
                                                jjiageArr[i].url,
                                                width:120.0,
                                              ),
                                              SizedBox(
                                                height: 20.0,
                                              ),
                                              Text(
                                                '${jjiageArr[i].menu_name.length < 8 ? jjiageArr[i].menu_name : '${jjiageArr[i].menu_name.substring(0, 7)}...'}',
                                                style: TextStyle(
                                                  fontSize:15.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                '${jjiageArr[i].menu_amount}원'
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ) : Text('준비 중입니다.'),
                        ],
                      ),
                    ),
                  ),
              );
            }
        ),
    );
  }
}

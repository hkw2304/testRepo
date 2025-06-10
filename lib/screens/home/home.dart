import 'package:flutter/material.dart';
import 'package:kpostal/kpostal.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:teamfinalproject/menuSelect.dart';
import 'package:teamfinalproject/model/cart.dart';
import 'package:teamfinalproject/model/jjiage.dart';
import 'package:teamfinalproject/model/jjiageTitle.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String postCode = '-';
  String address = '-';
  String latitude = '-';
  String longitude = '-';
  String kakaoLatitude = '-';
  String kakaoLongitude = '-';

  List<JjiageModel> jjiageArr = []; // 보승
  List<JjiageModel> jjiageArr2 = []; // 백제
  List<JjiageTitleModel> JjiageTitleArr = []; // 찌개

  List<JjiageModel> CoffeeArr = [];
  List<JjiageTitleModel> CoffeeTitleArr = [];

  List<CartModel> cartArr = [];
  List<int> ArrCnt = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbConnector();
  }

  Future<void> dbConnector() async {
    print("Connecting to mysql server...");
    // MySQL 접속 설정
    if (JjiageTitleArr.length == 0) {
      final conn = await MySQLConnection.createConnection(
        host: '172.31.9.38',
        port: 3306,
        userName: 'root',
        password: '1234',
        databaseName: 'delivery-data', // optional
      );

      await conn.connect();

      print("Connected");

      IResultSet? result;
      IResultSet? storeTitle;
      IResultSet? cartResult;

      result = await conn.execute("SELECT * FROM store_menu");
      storeTitle = await conn.execute('SELECT * FROM store');
      cartResult = await conn.execute('SELECT * FROM cart');

      if (storeTitle != null && storeTitle.isNotEmpty) {

        for (final row in storeTitle.rows) {
          print('>>>>> ${row!.assoc()['store_id']!}');
          if (12345678 == int.parse(row!.assoc()['store_id']!)) {
            JjiageTitleArr.add(JjiageTitleModel(
              store_id: int.parse(row!.assoc()['store_id']!),
              store_min_amount: int.parse(row!.assoc()['store_min_amount']!),
              store_name: row!.assoc()['store_name']!,
              url: row!.assoc()['url']!,
            ),
            );
            //print(row.assoc()['id']);
          }
          else if(12121212 == int.parse(row!.assoc()['store_id']!)){
            CoffeeTitleArr.add(JjiageTitleModel(
              store_id: int.parse(row!.assoc()['store_id']!),
              store_min_amount: int.parse(row!.assoc()['store_min_amount']!),
              store_name: row!.assoc()['store_name']!,
              url: row!.assoc()['url']!,
            ),
            );
          }
        }
      }
      print('여기로 들어노아');
      if (result != null && result.isNotEmpty) {
        print('if문 들어오나...');
        for (final row in result.rows) {
          print('${row!.assoc()['store_id']!}');
          if(12345678 == int.parse(row!.assoc()['store_id']!)) {
            jjiageArr.add(JjiageModel(
                id: int.parse(row!.assoc()['id']!),
                menu_amount: int.parse(row!.assoc()['menu_amount']!),
                menu_name: row!.assoc()['menu_name']!,
                url: row!.assoc()['url']!,
                store_id: int.parse(row!.assoc()['store_id']!)
            ),
            );
          }
          else if(12121212 == int.parse(row!.assoc()['store_id']!)){
            CoffeeArr.add(JjiageModel(
                id: int.parse(row!.assoc()['id']!),
                menu_amount: int.parse(row!.assoc()['menu_amount']!),
                menu_name: row!.assoc()['menu_name']!,
                url: row!.assoc()['url']!,
                store_id: int.parse(row!.assoc()['store_id']!)
            ),
            );
          }


          print('데이터 잘 들어갔나...');
        }
        print('jjiageArr2의 길이 >> ${CoffeeArr.length}');
        ArrCnt = List.generate(jjiageArr.length, (_) => 0);
        print('ArrCnt => $ArrCnt');
      }

      if (cartResult != null && cartResult.isNotEmpty) {

        for (final row in cartResult.rows) {
          cartArr.add(CartModel(
            id: int.parse(row!.assoc()['id']!),
            add_time: row!.assoc()['add_time']!,
            menu_id: int.parse(row!.assoc()['menu_id']!),

          ),
          );
        }
      }
      for (final row in  jjiageArr) {
        print('result:  ${row.id}');
      }

      for (final row in storeTitle!.rows) {
        print('storeTitle:  ${row.assoc()}');
      }

      for (final row in cartArr!) {
        print('cartResult:  ${row.menu_id}');
      }

      for(int i = 0; i < ArrCnt.length; i++){
        for(int j = 0; j < cartArr.length; j++){
          if(jjiageArr[i].id == cartArr[j].menu_id){
            ArrCnt[i]++;
          }
        }
      }
      await conn.close();
    }
  }






  Widget build(BuildContext context){

    List<String> menuImg = [
      'images/menuIcons/bossam.png',
      'images/menuIcons/japanese.png',
      'images/menuIcons/meat.png',
      'images/menuIcons/pizza.png',
      'images/menuIcons/jjiage.png',
      'images/menuIcons/pasta.png',
      'images/menuIcons/chinese.png',
      'images/menuIcons/asian.png',
      'images/menuIcons/chicken.png',
      'images/menuIcons/korean.png',
      'images/menuIcons/burger.png',
      'images/menuIcons/bunsik.png',
      'images/menuIcons/cafe.png'
    ];
    List<String> menuTitle = [
      '족발/보쌈',
      '돈까스/회/일식',
      '고기/구이',
      '피자',
      '찜/탕/찌개',
      '양식',
      '중식',
      '아시안',
      '치킨',
      '백반/죽/국수',
      '버거',
      '분식',
      '카페/디저트'
    ];

    return Column(
      children: [
        SizedBox(
          height: 50.0,
        ),
        Column(
          children: [
            TextButton(
              onPressed: () async {
                await Navigator.push(
                  context,MaterialPageRoute(
                  builder: (_) => KpostalView(
                    useLocalServer: true,
                    localPort: 1024,
                    callback: (Kpostal result) {
                      setState(() {
                        this.postCode = result.postCode;
                        this.address = result.address;
                        this.latitude = result.latitude.toString();
                        this.longitude = result.longitude.toString();
                        this.kakaoLatitude = result.kakaoLatitude.toString();
                        this.kakaoLongitude = result.kakaoLongitude.toString();
                      });
                    },
                  ),
                ),
                );
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blue)
              ),
              child: Text(
                '주소찾기',
                style: TextStyle(
                    color: Colors.white
                ),
              ),
            ),
            Text('현재 주소 : ${address=='-' ? '주소를 등록하세요' : address}'),
          ],
        ),
        SizedBox(height: 5.0,),
        Container(
          child: Expanded(
            child: GridView.builder(
              itemCount: menuImg.length,
              gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    print(menuTitle[index]);
                    if(menuTitle[index] == '찜/탕/찌개') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MenuSelect(menuTitle: menuTitle[index],
                                  jjiageArr: jjiageArr,
                                  jjiageTitleArr: JjiageTitleArr,
                                  cartArr: cartArr,
                                  ArrCnt: ArrCnt),
                        ),
                      );
                    }
                    else if(menuTitle[index] == '카페/디저트') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MenuSelect(menuTitle: menuTitle[index],
                                  jjiageArr: CoffeeArr,
                                  jjiageTitleArr: CoffeeTitleArr,
                                  cartArr: cartArr,
                                  ArrCnt: ArrCnt),
                        ),
                      );
                    }
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.asset(
                          menuImg[index],
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Text(menuTitle[index]),
                      SizedBox(
                        height: 15.0,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
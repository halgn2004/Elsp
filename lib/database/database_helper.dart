// database/database_helper.dart
import 'dart:convert';
import 'package:elsobkypack/models/historyview.dart';
import 'package:elsobkypack/models/main_order.dart';
import 'package:elsobkypack/models/main_order_product.dart';
import 'package:elsobkypack/models/user.dart';
import 'package:elsobkypack/models/userlogin.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../models/android_update.dart';
import '../models/main_prod.dart';
import '../models/product.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  final version = 3;
  final filePath = 'app.db';

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB();
    return _database!;
  }

  Future<void> saveMainProds(List<MainProd> mainProds) async {
    for (var mainProd in mainProds) {
      await insertMainProd(mainProd);
    }
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: version, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE android_update (
      id INTEGER PRIMARY KEY,
      date TEXT
    )
    ''');

    await db.execute('''
    CREATE TABLE main_prod (
      id INTEGER PRIMARY KEY,
      ready REAL,
      img TEXT,
      show_name_ar TEXT,
      show_name_en TEXT
    )
    ''');

    await db.execute('''
    CREATE TABLE product (
      id INTEGER PRIMARY KEY,
      price REAL,
      start_quantity INTEGER,
      img TEXT,
      show_name_ar TEXT,
      show_name_en TEXT,
      details TEXT,
      main_prod_id INTEGER
    )
    ''');

    await db.execute('''
    CREATE TABLE main_image (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      url TEXT
    )
    ''');

    await db.execute('''
    CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userName TEXT NOT NULL,
        phone TEXT NOT NULL,
        iscash INTEGER NOT NULL,
        usersent INTEGER NOT NULL
      );
    ''');

    await db.execute('''
    CREATE TABLE userLogins (
        loginID INTEGER PRIMARY KEY AUTOINCREMENT,
        logindate TEXT NOT NULL,
        loginsent INTEGER NOT NULL
      );
    ''');

    await db.execute('''
    CREATE TABLE main_order (
      id INTEGER PRIMARY KEY,
      ready REAL,
      show_name_ar TEXT
    )
    ''');

    await db.execute('''
    CREATE TABLE main_Order_Product (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      price REAL,      
      quantity INTEGER,
      stratquantity INTEGER,
      show_name_ar TEXT,
      productIdApi INTEGER,
      main_order_id INTEGER     
    )
    ''');

    await db.execute('''
    CREATE TABLE historyview (
      id INTEGER PRIMARY KEY,
      date TEXT,
      checks INTEGER,
      total INTEGER
    )
    ''');

    await db.execute('''
    CREATE TABLE productview (
     id INTEGER PRIMARY KEY AUTOINCREMENT,
      ready REAL,
      show_name_ar TEXT,
      historyview_id INTEGER
    )
    ''');

    await db.execute('''
    CREATE TABLE productviewdetails (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      price REAL,      
      quantity INTEGER,
      stratquantity INTEGER,
      show_name_ar TEXT,
      productview_id INTEGER  
    )
    ''');

  }

  Future<void> insertAndroidUpdate(AndroidUpdate androidUpdate) async {
    final db = await instance.database;
    await db.insert(
        'android_update', {'id': androidUpdate.id, 'date': androidUpdate.date});
  }

  Future<AndroidUpdate?> fetchAndroidUpdate() async {
    final db = await instance.database;
    final maps = await db.query('android_update');

    if (maps.isNotEmpty) {
      final map = maps.first;
      return AndroidUpdate(
        id: map['id'] as int,
        date: map['date'] as String,
      );
    }
    return null;
  }

  Future<int> insertHistoryView(Map<String, dynamic> historyView) async {
    final db = await instance.database;
    return await db.insert('historyview', historyView);
  }

  Future<int> insertProductView(Map<String, dynamic> productView) async {
    final db = await instance.database;
    return await db.insert('productview', productView);
  }

  Future<int> insertProductViewDetails(
      Map<String, dynamic> productViewDetails) async {
    final db = await instance.database;
    return await db.insert('productviewdetails', productViewDetails);
  }

  Future<void> insertHistory(HistoryView history) async {
    await insertHistoryView({
      'id': history.id,
      'date': history.date.toIso8601String(),
      'checks': history.check ? 1 : 0,
      'total': history.total,
    });

    for (var product in history.products) {
      int productviewid = await insertProductView({
        'ready': product.ready,
        'show_name_ar': product.showNameAR,
        'historyview_id': history.id,
      });

      for (var orderproduct in product.orderproduct!) {
        await insertProductViewDetails({
          'price': orderproduct.price,
          'quantity': orderproduct.quantity,
          'stratquantity': orderproduct.stratquantity,
          'show_name_ar': orderproduct.showNameAR,
          'productview_id': productviewid,
        });
      }
    }
  }

  Future<List<HistoryView>> fetchHistoryViews() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> historyMaps =
        await db.query('historyview');
    List<HistoryView> historyViews = [];

    for (var historyMap in historyMaps) {
      final int historyId = historyMap['id'];
      final List<Map<String, dynamic>> productMaps = await db.query(
        'productview',
        where: 'historyview_id = ?',
        whereArgs: [historyId],
      );

      List<ProductView> products = [];

      for (var productMap in productMaps) {
        final int productId = productMap['id'];
        final List<Map<String, dynamic>> productDetailMaps = await db.query(
          'productviewdetails',
          where: 'productview_id = ?',
          whereArgs: [productId],
        );

        List<ProductViewDetails> productDetails =
            productDetailMaps.map((detailMap) {
          return ProductViewDetails(
            id: detailMap['id'],
            price: detailMap['price'],
            quantity: detailMap['quantity'],
            stratquantity: detailMap['stratquantity'],
            showNameAR: detailMap['show_name_ar'],
          );
        }).toList();

        products.add(ProductView(
          id: productMap['id'],
          ready: productMap['ready'],
          showNameAR: productMap['show_name_ar'],
          orderproduct: productDetails,
        ));
      }

      historyViews.add(HistoryView(
        id: historyMap['id'],
        date: DateTime.parse(historyMap['date']),
        check: historyMap['checks'] == 1,
        total: historyMap['total'],
        products: products,
      ));
    }

    return historyViews;
  }

  Future<List<int>> getUncheckedHistoryIds() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'historyview',
      columns: ['id'],
      where: 'checks = ?',
      whereArgs: [0],
    );

    if (maps.isNotEmpty) {
      return List<int>.from(maps.map((map) => map['id']));
    } else {
      return [];
    }
  }

  Future<void> updateCheckToTrue(List<int> ids) async {
    final db = await instance.database;

    for (int id in ids) {
      await db.update(
        'historyview',
        {'checks': 1},
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }

///////////////// orders

  Future<void> insertOrder(Mainorder mainOrder) async {
    final db = await instance.database;
    await db.insert('main_order', {
      'id': mainOrder.id,
      'ready': mainOrder.ready,
      'show_name_ar': mainOrder.showNameAR,
    });

    for (var orderproduct in mainOrder.orderproduct!) {
      await db.insert('main_Order_Product', {
        'price': orderproduct.price,
        'quantity': orderproduct.quantity,
        'stratquantity': orderproduct.stratquantity,
        'show_name_ar': orderproduct.showNameAR,
        'productIdApi': orderproduct.productIdApi,
        'main_order_id': mainOrder.id,
      });
    }
  }

  Future<void> insertOrderproduct(
      MainOrderProduct orderproduct, int mainOrderid) async {
    final db = await instance.database;
    await db.insert('main_Order_Product', {
      'price': orderproduct.price,
      'quantity': orderproduct.quantity,
      'stratquantity': orderproduct.stratquantity,
      'show_name_ar': orderproduct.showNameAR,
      'productIdApi': orderproduct.productIdApi,
      'main_order_id': mainOrderid,
    });
  }

  Future<int> countOrderProducts() async {
    final db = await instance.database;
    final count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM main_Order_Product'));
    return count ?? 0;
  }

  Future<void> removeOrderProduct(int orderProductId) async {
    final db = await instance.database;
    // الحصول على main_order_id المرتبط بالـ orderProduct
    final orderProduct = await db.query(
      'main_Order_Product',
      columns: ['main_order_id'],
      where: 'id = ?',
      whereArgs: [orderProductId],
    );

    if (orderProduct.isNotEmpty) {
      final mainOrderId = orderProduct.first['main_order_id'] as int;

      // حذف orderProduct
      await db.delete(
        'main_Order_Product',
        where: 'id = ?',
        whereArgs: [orderProductId],
      );

      // التحقق إذا كان هناك أي orderProducts مرتبطين بالـ mainOrder
      final remainingOrderProducts = await db.query(
        'main_Order_Product',
        where: 'main_order_id = ?',
        whereArgs: [mainOrderId],
      );

      // إذا لم يكن هناك أي orderProducts متبقية، قم بحذف mainOrder
      if (remainingOrderProducts.isEmpty) {
        await db.delete(
          'main_order',
          where: 'id = ?',
          whereArgs: [mainOrderId],
        );
      }
    }
  }

  Future<void> deleteAllOrders() async {
    final db = await instance.database;

    // حذف جميع البيانات من جداول 'main_Order_Product' و 'main_order'
    await db.delete('main_Order_Product');
    await db.delete('main_order');
  }

  Future<bool> getMainOrderId(int mainorderId) async {
    final db = await instance.database;
    final result = await db.query(
      'main_order',
      where: 'id = ?',
      whereArgs: [mainorderId],
    );
    if (result.isNotEmpty) {
      return true;
    }
    return false;
  }

  Future<List<Mainorder>> fetchOrders() async {
    final db = await instance.database;
    final orderMaps = await db.query('main_order');
    final List<Mainorder> mainOrders = [];

    for (var ordMap in orderMaps) {
      final productMaps = await db.query(
        'main_Order_Product',
        where: 'main_order_id = ?',
        whereArgs: [ordMap['id']],
      );

      final products = productMaps.map((productMap) {
        return MainOrderProduct(
          id: productMap['id'] as int,
          productIdApi: productMap['productIdApi'] as int,
          price: productMap['price'] as double,
          stratquantity: productMap['stratquantity'] as int,
          quantity: productMap['quantity'] as int,
          showNameAR: productMap['show_name_ar'] as String,
        );
      }).toList();

      mainOrders.add(Mainorder(
        id: ordMap['id'] as int,
        ready: ordMap['ready'] as double,
        showNameAR: ordMap['show_name_ar'] as String,
        orderproduct: products,
      ));
    }
    return mainOrders;
  }

  Future<void> insertMainProd(MainProd mainProd) async {
    final db = await instance.database;
    await db.insert('main_prod', {
      'id': mainProd.id,
      'ready': mainProd.ready,
      'img': mainProd.img,
      'show_name_ar': mainProd.showNameAR,
      'show_name_en': mainProd.showNameEN,
    });

    for (var product in mainProd.products) {
      await db.insert('product', {
        'id': product.id,
        'price': product.price,
        'start_quantity': product.startQuantity,
        'img': product.img,
        'show_name_ar': product.showNameAR,
        'show_name_en': product.showNameEN,
        'details': product.details,
        'main_prod_id': mainProd.id,
      });
    }
  }

  Future<void> insertMainImage(String url) async {
    final db = await instance.database;
    await db.insert('main_image', {'url': url});
  }

  Future<List<MainProd>> fetchMainProds() async {
    final db = await instance.database;
    final prodMaps = await db.query('main_prod');
    final List<MainProd> mainProds = [];

    for (var prodMap in prodMaps) {
      final productMaps = await db.query(
        'product',
        where: 'main_prod_id = ?',
        whereArgs: [prodMap['id']],
      );

      final products = productMaps.map((productMap) {
        return Product(
          id: productMap['id'] as int,
          price: productMap['price'] as double,
          startQuantity: productMap['start_quantity'] as int,
          img: productMap['img'] as String,
          showNameAR: productMap['show_name_ar'] as String,
          showNameEN: productMap['show_name_en'] as String,
          details: productMap['details'] as String,
        );
      }).toList();

      mainProds.add(MainProd(
        id: prodMap['id'] as int,
        ready: prodMap['ready'] as double,
        img: prodMap['img'] as String,
        showNameAR: prodMap['show_name_ar'] as String,
        showNameEN: prodMap['show_name_en'] as String,
        products: products,
      ));
    }

    return mainProds;
  }

  Future<List<String>> fetchMainImages() async {
    final db = await instance.database;
    final imageMaps = await db.query('main_image');

    return imageMaps.map((imageMap) => imageMap['url'] as String).toList();
  }

  Future<void> clearDatabase() async {
    final db = await instance.database;
    await db.delete('android_update');
    await db.delete('main_prod');
    await db.delete('product');
    await db.delete('main_image');
    await db.delete('main_order');
    await db.delete('main_Order_Product');
  }

  Future<void> saveImage(String url) async {
    String username = '11179567';
    String password = '60-dayfreetrial';
    String basicAuth =
        'Basic  ${base64Encode(utf8.encode('$username:$password'))}';

    final response = await http.get(Uri.parse(url),
        headers: <String, String>{'authorization': basicAuth});
    final documentDirectory = await getApplicationDocumentsDirectory();
    final file = File(join(documentDirectory.path, url.split('/').last));
    file.writeAsBytesSync(response.bodyBytes);
  }

  Future<String> getLocalPath(String url) async {
    final documentDirectory = await getApplicationDocumentsDirectory();
    return join(documentDirectory.path, url.split('/').last);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<User?> getUser() async {
    final db = await instance.database;
    final maps = await db.query('users');

    if (maps.isNotEmpty) {
      final user = User(
        id: maps.first['id'] as int,
        userName: maps.first['userName'] as String,
        phone: maps.first['phone'] as String,
        usersent: maps.first['usersent'] == 0 ? false : true,
        iscash: maps.first['iscash'] == 0 ? false : true,
      );

      final userLogins = await db.query('userLogins');
      user.userDats = userLogins.map((json) {
        return UserLogin(
          loginID: json['loginID'] as int,
          logindate: DateTime.parse(json['logindate'] as String),
          loginsent: json['loginsent'] == 1,
        );
      }).toList();

      return user;
    } else {
      return null;
    }
  }

  Future<void> insertUser(User user) async {
    final db = await instance.database;
    await db.insert('users', {
      'id': user.id,
      'userName': user.userName,
      'phone': user.phone,
      'usersent': user.usersent ? 1 : 0,
      'iscash': user.iscash ? 1 : 0,
    });
  }

//غير مستخدمة
  Future<void> updateUser(User user) async {
    final db = await instance.database;
    await db.update(
      'users',
      {
        'id': user.id,
        'userName': user.userName,
        'phone': user.phone,
        'iscash': user.iscash ? 1 : 0,
        'usersent': user.usersent ? 1 : 0,
      },
    );
  }

  Future<void> insertUserLogin(UserLogin userLogin) async {
    final db = await instance.database;
    if (await isTableUserLoginExists() == false) {
      await db.execute('''
    CREATE TABLE userLogins (
        loginID INTEGER PRIMARY KEY AUTOINCREMENT,
        logindate TEXT NOT NULL,
        loginsent INTEGER NOT NULL
      );
    ''');
    }

    await db.insert('userLogins', {
      'logindate': userLogin.logindate?.toIso8601String(),
      'loginsent': (userLogin.loginsent ?? false) ? 1 : 0,
    });
  }

// هشيلها وبدالها هعمل delete
  Future<void> updateUserLogin(UserLogin userLogin) async {
    final db = await instance.database;
    await db.update(
        'userLogins',
        {
          'logindate': userLogin.logindate?.toIso8601String(),
          'loginsent': (userLogin.loginsent ?? false) ? 1 : 0,
        },
        where: 'loginID = ?',
        whereArgs: [userLogin.loginID]);
  }

  Future<bool> isTableUserLoginExists() async {
    final Database db = await DatabaseHelper.instance.database;

    // استعلام SQL للتحقق مما إذا كان الجدول موجودًا
    final List<Map<String, dynamic>> tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='userLogins';",
    );

    // إذا كانت النتيجة غير فارغة، فالجدول موجود
    return tables.isNotEmpty;
  }

  Future delettableuserLogins() async {
    final db = await instance.database;
    await db.delete('userLogins');
  }
}

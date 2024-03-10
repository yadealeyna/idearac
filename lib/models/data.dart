import 'package:mysql1/mysql1.dart';

class Mysql{
  Mysql();

  Future<MySqlConnection> getConnection() async{
    var settings = ConnectionSettings(
      host: '31.186.11.151',
      port: 3306,
      user: 'idearacdata',
      password: 'EB?ide8495',
      db: 'idearac'
    );
    
    var conn;
    try{
      conn = await MySqlConnection.connect(settings);
    }catch (error) {
        print('Error: $error');
    }

    print(conn);
    return conn;
  }
  
}
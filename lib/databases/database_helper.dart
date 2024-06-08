import 'package:note_app/models/note.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // Sử dụng mẫu Singleton
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  // Biến lưu trữ đối tượng Database
  static Database? _database;

  // Getter để lấy đối tượng Database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Phương thức khởi tạo cơ sở dữ liệu
  Future<Database> _initDatabase() async {
    // Lấy đường dẫn đến thư mục lưu trữ cơ sở dữ liệu
    String path = join(await getDatabasesPath(), 'note_database.db');
    // Mở cơ sở dữ liệu và gọi _onCreate nếu cơ sở dữ liệu chưa tồn tại
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Phương thức được gọi khi cơ sở dữ liệu được tạo lần đầu tiên
  Future _onCreate(Database db, int version) async {
    // Tạo bảng notes với các cột id, title và content
    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        content TEXT
      )
    ''');
  }

  // Phương thức lấy danh sách tất cả các ghi chú từ cơ sở dữ liệu
  Future<List<Note>> getNotes() async {
    Database db = await database;
    // Truy vấn tất cả các bản ghi từ bảng notes
    List<Map<String, dynamic>> maps = await db.query('notes');
    // Chuyển đổi danh sách các bản đồ (Map) thành danh sách các đối tượng Note
    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
  }

  // Phương thức thêm một ghi chú mới vào cơ sở dữ liệu
  Future<int> insertNote(Note note) async {
    Database db = await database;
    // Chèn ghi chú vào bảng notes
    return await db.insert('notes', note.toMap());
  }

  // Phương thức cập nhật một ghi chú đã tồn tại trong cơ sở dữ liệu
  Future<int> updateNote(Note note) async {
    Database db = await database;
    // Cập nhật ghi chú trong bảng notes dựa trên id
    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  // Phương thức xóa một ghi chú từ cơ sở dữ liệu
  Future<int> deleteNote(int id) async {
    Database db = await database;
    // Xóa ghi chú trong bảng notes dựa trên id
    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

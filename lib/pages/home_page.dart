import 'package:flutter/material.dart';
import 'package:note_app/databases/database_helper.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/pages/add_edit_page.dart';
import 'package:note_app/search/note_search_delegate.dart';
import 'package:note_app/theme_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note> notes = [];

  // Phương thức hiển thị hộp thoại xác nhận xóa ghi chú
  void _deleteNoteConfirmation(BuildContext context, Note note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _deleteNote(note.id!);
              Navigator.pop(context);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  // Phương thức xóa ghi chú từ cơ sở dữ liệu và cập nhật danh sách ghi chú
  void _deleteNote(int id) async {
    await DatabaseHelper().deleteNote(id);
    _loadNotes();
  }

  // Phương thức tải danh sách ghi chú từ cơ sở dữ liệu
  void _loadNotes() async {
    List<Note> loadedNotes = await DatabaseHelper().getNotes();
    setState(() {
      notes = loadedNotes;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Note App'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Hiển thị thanh tìm kiếm ghi chú
              showSearch(
                context: context,
                delegate: NoteSearchDelegate(
                  notes, // Truyền danh sách ghi chú để tìm kiếm
                  _loadNotes, // Truyền callback để cập nhật danh sách ghi chú
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: () {
              // Thay đổi chủ đề ( sáng hoặc tối)
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          Note note = notes[index];
          return ListTile(
            title: Text(note.title),
            subtitle: Text(note.content),
            onTap: () async {
              // Chuyển đến trang chỉnh sửa ghi chú khi nhấp vào một ghi chú
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditPage(note: note),
                ),
              );
              _loadNotes(); // Cập nhật danh sách ghi chú sau khi quay lại từ trang chỉnh sửa
            },
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Hiển thị hộp thoại xác nhận xóa khi nhấn vào nút xóa
                _deleteNoteConfirmation(context, note);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Chuyển đến trang thêm mới ghi chú khi nhấp vào nút
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditPage(),
            ),
          );
          _loadNotes(); // Cập nhật danh sách ghi chú sau khi quay lại từ trang thêm mới
        },
        child: Icon(Icons.add), // Biểu tượng của nút
      ),
    );
  }
}

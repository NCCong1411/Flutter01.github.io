import 'package:flutter/material.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/pages/add_edit_page.dart';

//Lớp NoteSearchDelegate mở rộng từ SearchDelegate<Note>, quản lý tìm kiếm và hiển thị kết quả cho danh sách ghi chú
class NoteSearchDelegate extends SearchDelegate<Note> {
  final List<Note> notes;
  final Function onNoteUpdated;
  Note defaultNote;

  // Constructor của lớp NoteSearchDelegate
  NoteSearchDelegate(this.notes, this.onNoteUpdated)
      : defaultNote = notes
            .first; // Thiết lập defaultNote là ghi chú đầu tiên trong danh sách

  // Phương thức xây dựng widget ở phía trái của thanh tìm kiếm
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(
            context, defaultNote); // Đóng thanh tìm kiếm và trả về defaultNote
      },
    );
  }

  // Phương thức xây dựng các hành động ở phía bên phải của thanh tìm kiếm
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = ''; // Xóa nội dung của thanh tìm kiếm khi nhấn nút xóa
        },
      )
    ];
  }

  // Phương thức được gọi khi kết quả tìm kiếm đã được xác định
  @override
  Widget buildResults(BuildContext context) {
    final results = notes
        .where((note) =>
            note.title.toLowerCase().contains(query.toLowerCase()) ||
            note.content.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        Note note = results[index];
        return ListTile(
          title: Text(note.title),
          subtitle: Text(note.content),
          onTap: () async {
            close(context,
                note); // Đóng thanh tìm kiếm và trả về ghi chú được chọn
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddEditPage(
                    note:
                        note), // Mở trang chỉnh sửa ghi chú khi nhấp vào ghi chú
              ),
            );
            onNoteUpdated(); // Gọi hàm callback để cập nhật dữ liệu ghi chú
          },
        );
      },
    );
  }

  // Phương thức được gọi khi người dùng nhập nội dung vào thanh tìm kiếm và hiển thị gợi ý tìm kiếm
  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = notes
        .where((note) =>
            note.title.toLowerCase().contains(query.toLowerCase()) ||
            note.content.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        Note note = suggestions[index];
        return ListTile(
          title: Text(note.title), // Hiển thị tiêu đề của ghi chú
          subtitle: Text(note.content), // Hiển thị nội dung của ghi chú
          onTap: () {
            query = note
                .title; // Cập nhật nội dung trong thanh tìm kiếm bằng tiêu đề của ghi chú
            showResults(context); // Hiển thị kết quả tìm kiếm
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:note_app/models/note.dart';

// NoteProvider là lớp cung cấp dữ liệu ghi chú và thông báo cho các thành phần khác khi có sự thay đổi.
class NoteProvider extends ChangeNotifier {
  List<Note> _notes = [];

  // Phương thức getter notes để truy xuất danh sách ghi chú từ bên ngoài lớp.
  List<Note> get notes => _notes;

  // Phương thức updateNotes để cập nhật danh sách ghi chú và thông báo cho các thành phần khác.
  void updateNotes(List<Note> updatedNotes) {
    _notes = updatedNotes;
    notifyListeners();
  }
}

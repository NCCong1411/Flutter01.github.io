import 'package:flutter/material.dart';
import 'package:note_app/databases/database_helper.dart';
import 'package:note_app/models/note.dart';

// Màn hình để thêm hoặc chỉnh sửa ghi chú
class AddEditPage extends StatefulWidget {
  final Note? note;

  AddEditPage({this.note});

  @override
  _AddEditPageState createState() => _AddEditPageState();
}

class _AddEditPageState extends State<AddEditPage> {
  final _formKey = GlobalKey<FormState>(); // Global key cho Form widget
  late String _title; // Tiêu đề ghi chú
  late String _content; // Nội dung ghi chú

  // Khởi tạo trạng thái của widget
  @override
  void initState() {
    super.initState();
    // Nếu có ghi chú được truyền vào, sử dụng tiêu đề và nội dung của ghi chú đó, ngược lại, sử dụng chuỗi rỗng
    if (widget.note != null) {
      _title = widget.note!.title;
      _content = widget.note!.content;
    } else {
      _title = '';
      _content = '';
    }
  }

  // Phương thức để lưu ghi chú
  void _saveNote() async {
    // Kiểm tra xem dữ liệu nhập vào từ Form có hợp lệ không
    if (_formKey.currentState!.validate()) {
      // Lưu dữ liệu từ Form vào biến _title và _content
      _formKey.currentState!.save();
      // Tạo một đối tượng Note từ dữ liệu vừa nhập
      Note note = Note(
        id: widget.note
            ?.id, // Nếu ghi chú đã tồn tại (đang chỉnh sửa), giữ nguyên id, ngược lại, id sẽ được sinh tự động
        title: _title,
        content: _content,
      );
      // Nếu không có ghi chú được truyền vào (đang thêm mới ghi chú), thêm ghi chú mới vào cơ sở dữ liệu, ngược lại, cập nhật ghi chú hiện có
      if (widget.note == null) {
        await DatabaseHelper().insertNote(note);
      } else {
        await DatabaseHelper().updateNote(note);
      }
      // Đóng màn hình thêm/sửa ghi chú và quay lại màn hình trước đó
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null
            ? 'Add Note'
            : 'Edit Note'), // Hiển thị tiêu đề phù hợp với trạng thái (thêm mới hoặc chỉnh sửa)
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Sử dụng GlobalKey để tham chiếu đến Form
          child: Column(
            children: <Widget>[
              // TextFormFields để nhập tiêu đề và nội dung ghi chú
              TextFormField(
                initialValue: _title, // Giá trị mặc định cho tiêu đề
                decoration:
                    InputDecoration(labelText: 'Title'), // Mô tả cho tiêu đề
                validator: (value) {
                  // Validator để kiểm tra xem tiêu đề có được nhập hay không
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null; // Trả về null nếu không có lỗi
                },
                onSaved: (value) {
                  // Callback được gọi khi giá trị của TextFormField thay đổi
                  _title = value!; // Lưu giá trị của tiêu đề
                },
              ),
              TextFormField(
                initialValue: _content, // Giá trị mặc định cho nội dung
                decoration:
                    InputDecoration(labelText: 'Content'), // Mô tả cho nội dung
                validator: (value) {
                  // Validator để kiểm tra xem nội dung có được nhập hay không
                  if (value == null || value.isEmpty) {
                    return 'Please enter content';
                  }
                  return null; // Trả về null nếu không có lỗi
                },
                onSaved: (value) {
                  // Callback được gọi khi giá trị của TextFormField thay đổi
                  _content = value!; // Lưu giá trị của nội dung
                },
              ),
              SizedBox(
                  height: 16.0), // Khoảng cách giữa các TextFormField và Button
              ElevatedButton(
                onPressed: _saveNote, // Callback được gọi khi nhấn vào nút
                child: Text('Save'), // Hiển thị văn bản trên nút
              ),
            ],
          ),
        ),
      ),
    );
  }
}

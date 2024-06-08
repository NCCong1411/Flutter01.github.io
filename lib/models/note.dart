class Note {
  int? id;
  String title;
  String content;

  // Constructor của lớp Note
  Note({
    this.id,
    required this.title,
    required this.content,
  });

  // Chuyển đổi Note thành Map để lưu vào cơ sở dữ liệu
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
    };
  }

  // Tạo đối tượng Note từ Map lấy ra từ cơ sở dữ liệu
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
    );
  }
}

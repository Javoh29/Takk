class FileModel {
  int? id;
  String? file;

  FileModel({this.id, this.file});

  factory FileModel.fromJson(Map<String, dynamic> json) => FileModel(
        id: json['id'] as int?,
        file: json['file'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'file': file,
      };

  FileModel copyWith({
    int? id,
    String? file,
  }) {
    return FileModel(
      id: id ?? this.id,
      file: file ?? this.file,
    );
  }
}

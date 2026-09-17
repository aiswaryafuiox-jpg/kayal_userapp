class TermsDataModel {
  final String? id;
  final String title;
  final String content;
  final String type;
  final String? updatedAt;

  TermsDataModel({
    this.id,
    this.title = '',
    this.content = '',
    this.type = 'user',
    this.updatedAt,
  });

  bool get hasContent => content.trim().isNotEmpty;

  String get displayTitle =>
      title.isNotEmpty ? title : 'Terms & Conditions';

  String get displayContent => content;

  factory TermsDataModel.fromJson(dynamic json) {
    if (json is String) {
      return TermsDataModel(content: json);
    } else if (json is List) {
      final joined = json.map((e) => e.toString()).join('\n\n');
      return TermsDataModel(content: joined);
    } else if (json is Map) {
      final map = Map<String, dynamic>.from(json);
      final rawContent = map['content']?.toString() ??
          map['terms']?.toString() ??
          map['description']?.toString() ??
          map['text']?.toString() ??
          map['body']?.toString() ??
          '';

      final rawTitle = map['title']?.toString() ??
          map['heading']?.toString() ??
          map['name']?.toString() ??
          'Terms & Conditions';

      return TermsDataModel(
        id: map['id']?.toString(),
        title: rawTitle,
        content: rawContent,
        type: map['type']?.toString() ??
            map['role']?.toString() ??
            'user',
        updatedAt: map['updated_at']?.toString() ??
            map['date']?.toString(),
      );
    }

    return TermsDataModel();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'type': type,
      'updated_at': updatedAt,
    };
  }
}

class GetTermsResponseModel {
  final bool success;
  final String message;
  final TermsDataModel? data;
  final int? code;
  final dynamic errors;

  GetTermsResponseModel({
    this.success = true,
    this.message = '',
    this.data,
    this.code,
    this.errors,
  });

  String get content => data?.content ?? '';
  String get title => data?.title ?? '';

  factory GetTermsResponseModel.fromJson(Map<String, dynamic> json) {
    final rawSuccess = json['success'] ?? json['status'];
    final bool isSuccess = rawSuccess == true ||
        rawSuccess == 1 ||
        rawSuccess == '1' ||
        rawSuccess == 'true' ||
        rawSuccess == 'success';

    final rawCode = json['code'] ?? json['status_code'];
    final parsedCode = rawCode is int
        ? rawCode
        : int.tryParse(rawCode?.toString() ?? '');

    TermsDataModel? parsedData;
    if (json['data'] != null) {
      parsedData = TermsDataModel.fromJson(json['data']);
    } else if (json['terms'] != null) {
      parsedData = TermsDataModel.fromJson(json['terms']);
    } else if (json['content'] != null) {
      parsedData = TermsDataModel.fromJson(json['content']);
    }

    return GetTermsResponseModel(
      success: isSuccess,
      message: json['message']?.toString() ?? '',
      data: parsedData,
      code: parsedCode,
      errors: json['errors'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
      'code': code,
      'errors': errors,
    };
  }

  String get formattedErrorMessage {
    if (errors == null) return message;
    if (errors is String) return errors as String;
    if (errors is Map) {
      final map = errors as Map;
      final errorList = <String>[];
      map.forEach((key, value) {
        if (value is List) {
          errorList.addAll(value.map((e) => e.toString()));
        } else if (value is String) {
          errorList.add(value);
        }
      });
      if (errorList.isNotEmpty) {
        return errorList.join('\n');
      }
    }
    return message;
  }
}

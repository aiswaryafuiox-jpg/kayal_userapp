class NotificationItemModel {
  final String id;
  final String title;
  final String description;
  final String time;
  final String type;
  final String? imageUrl;
  final bool isRead;

  NotificationItemModel({
    required this.id,
    this.title = '',
    this.description = '',
    this.time = '',
    this.type = 'general',
    this.imageUrl,
    this.isRead = false,
  });

  bool get isOffer =>
      type.toLowerCase() == 'offer' ||
      title.toLowerCase().contains('offer') ||
      title.toLowerCase().contains('discount') ||
      description.toLowerCase().contains('off');

  bool get isOrder =>
      type.toLowerCase() == 'order' ||
      title.toLowerCase().contains('order') ||
      description.toLowerCase().contains('order #');

  factory NotificationItemModel.fromJson(Map<String, dynamic> json) {
    final rawType = json['type']?.toString() ??
        json['notification_type']?.toString() ??
        'general';

    final rawTime = json['time']?.toString() ??
        json['created_at']?.toString() ??
        json['date']?.toString() ??
        json['formatted_time']?.toString() ??
        '';

    final rawDescription = json['description']?.toString() ??
        json['message']?.toString() ??
        json['body']?.toString() ??
        '';

    return NotificationItemModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: rawDescription,
      time: rawTime,
      type: rawType,
      imageUrl: json['image_url']?.toString() ?? json['image']?.toString(),
      isRead: json['is_read'] == true ||
          json['is_read'] == 1 ||
          json['is_read'] == '1',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'time': time,
      'type': type,
      'image_url': imageUrl,
      'is_read': isRead,
    };
  }
}

class NotificationDataModel {
  final List<NotificationItemModel> notifications;
  final int currentPage;
  final int lastPage;
  final int total;

  NotificationDataModel({
    this.notifications = const [],
    this.currentPage = 1,
    this.lastPage = 1,
    this.total = 0,
  });

  factory NotificationDataModel.fromJson(Map<String, dynamic> json) {
    final rawList = json['notifications'] ?? json['data'] ?? json['items'];
    final items = <NotificationItemModel>[];

    if (rawList is List) {
      for (var element in rawList) {
        if (element is Map<String, dynamic>) {
          items.add(NotificationItemModel.fromJson(element));
        } else if (element is Map) {
          items.add(NotificationItemModel.fromJson(
              Map<String, dynamic>.from(element)));
        }
      }
    }

    final curPage = json['current_page'] is int
        ? json['current_page'] as int
        : int.tryParse(json['current_page']?.toString() ?? '') ?? 1;

    final lstPage = json['last_page'] is int
        ? json['last_page'] as int
        : int.tryParse(json['last_page']?.toString() ?? '') ?? 1;

    final totalCount = json['total'] is int
        ? json['total'] as int
        : int.tryParse(json['total']?.toString() ?? '') ?? items.length;

    return NotificationDataModel(
      notifications: items,
      currentPage: curPage,
      lastPage: lstPage,
      total: totalCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notifications': notifications.map((e) => e.toJson()).toList(),
      'current_page': currentPage,
      'last_page': lastPage,
      'total': total,
    };
  }
}

class GetNotificationsResponseModel {
  final bool success;
  final String message;
  final NotificationDataModel? data;
  final int? code;
  final dynamic errors;

  GetNotificationsResponseModel({
    this.success = true,
    this.message = '',
    this.data,
    this.code,
    this.errors,
  });

  List<NotificationItemModel> get notifications =>
      data?.notifications ?? [];

  factory GetNotificationsResponseModel.fromJson(Map<String, dynamic> json) {
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

    NotificationDataModel? parsedData;
    if (json['data'] != null && json['data'] is Map<String, dynamic>) {
      parsedData =
          NotificationDataModel.fromJson(json['data'] as Map<String, dynamic>);
    } else if (json['data'] != null && json['data'] is Map) {
      parsedData = NotificationDataModel.fromJson(
          Map<String, dynamic>.from(json['data']));
    } else if (json['notifications'] != null && json['notifications'] is List) {
      parsedData = NotificationDataModel.fromJson(json);
    }

    return GetNotificationsResponseModel(
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

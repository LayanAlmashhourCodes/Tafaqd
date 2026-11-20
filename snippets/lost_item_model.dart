// Tafaqd - Lost item data model (excerpt)
//
// Every item registered by airport staff is stored as a document in the
// `LostItems` Firestore collection. The `desc` and `category` fields are
// pre-filled by the AI service and can be reviewed by staff before saving.

import 'package:cloud_firestore/cloud_firestore.dart';

class LostItemModel {
  final String serialNum;
  final String imageUrl;
  final String desc;       // AI-generated caption, reviewed by staff
  final String category;   // AI-predicted category, reviewed by staff
  final String airport;
  String? id;
  final String? userId;
  String ownerId = "";
  final bool available;
  bool archived;
  final DateTime timestamp;

  LostItemModel({
    required this.serialNum,
    required this.imageUrl,
    required this.desc,
    required this.category,
    required this.airport,
    required this.available,
    this.archived = false,
    required this.timestamp,
    required this.userId,
    this.ownerId = "",
  });

  Map<String, dynamic> toMap() {
    return {
      'serialNum': serialNum,
      'imageUrl': imageUrl,
      'desc': desc,
      'category': category,
      'airport': airport,
      'available': available,
      'archived': archived,
      'timestamp': Timestamp.fromDate(timestamp),
      'userId': userId,
      'ownerId': ownerId,
    };
  }

  factory LostItemModel.fromFirestore(Map<String, dynamic> data) {
    return LostItemModel(
      serialNum: data['serialNum'],
      imageUrl: data['imageUrl'],
      desc: data['desc'],
      category: data['category'],
      airport: data['airport'] ?? "",
      available: data['available'],
      archived: data['archived'] ?? false,
      userId: data['userId'] ?? "",
      ownerId: data['ownerId'] ?? "",
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}

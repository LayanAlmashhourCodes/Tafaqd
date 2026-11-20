// Tafaqd - Registering a found item (staff side, excerpt)
//
// After the AI service returns a category and caption, the staff member
// reviews (and can edit) them, then the item is saved:
//   1. The image is uploaded to cloud storage.
//   2. A new document is added to the `LostItems` collection.

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'lost_item_model.dart';

Future<String?> uploadItemImage(File imageFile) async {
  final fileName = "uploads/${DateTime.now().millisecondsSinceEpoch}.jpg";
  try {
    await Supabase.instance.client.storage
        .from("Images")
        .upload(fileName, imageFile);
    return Supabase.instance.client.storage
        .from("Images")
        .getPublicUrl(fileName);
  } catch (_) {
    return null;
  }
}

Future<bool> registerFoundItem({
  required File imageFile,
  required String serialNum,
  required String reviewedCaption,
  required String reviewedCategory,
  required String airport,
  required bool available,
  required String staffId,
}) async {
  final imageUrl = await uploadItemImage(imageFile);
  if (imageUrl == null) return false;

  final item = LostItemModel(
    serialNum: serialNum,
    imageUrl: imageUrl,
    desc: reviewedCaption,
    category: reviewedCategory,
    airport: airport,
    available: available,
    timestamp: DateTime.now(),
    userId: staffId,
  );

  try {
    await FirebaseFirestore.instance
        .collection('LostItems')
        .add(item.toMap());
    return true;
  } catch (_) {
    return false;
  }
}

// Tafaqd - Descriptive search over registered items (excerpt)
//
// Active (non-archived) items are loaded from Firestore, then matched
// against the traveler's query. The query can be typed by the traveler
// or generated automatically from a photo by the AI captioning model.

import 'package:cloud_firestore/cloud_firestore.dart';

import 'lost_item_model.dart';

Future<List<LostItemModel>> fetchActiveItems() async {
  final QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('LostItems')
      .where('archived', isNotEqualTo: true)
      .get();

  return snapshot.docs.map((doc) {
    final item =
        LostItemModel.fromFirestore(doc.data() as Map<String, dynamic>);
    item.id = doc.id;
    return item;
  }).toList();
}

List<LostItemModel> filterItems(List<LostItemModel> items, String query) {
  if (query.isEmpty) return items;
  final q = query.toLowerCase();

  return items
      .where((item) =>
          item.category.toLowerCase().contains(q) ||
          item.desc.toLowerCase().contains(q) ||
          item.airport.toLowerCase().contains(q))
      .toList();
}

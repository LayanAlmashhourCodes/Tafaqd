# Code Excerpts

This folder contains selected excerpts from the Tafaqd mobile application. They show how the main parts of the system work together. They are not the complete source code.

| File | Description |
| --- | --- |
| [`lost_item_model.dart`](lost_item_model.dart) | Data model for a registered lost item, as stored in Cloud Firestore |
| [`ai_image_analysis.dart`](ai_image_analysis.dart) | Sends an item photo to the AI service and reads back the predicted category and caption |
| [`register_found_item.dart`](register_found_item.dart) | Staff workflow for saving a reviewed item, with image upload and database write |
| [`descriptive_search.dart`](descriptive_search.dart) | Traveler search over registered items using a typed or AI-generated description |

The excerpts were lightly edited for readability: UI code, logging and environment-specific configuration were removed, and service endpoints and credentials were replaced with placeholders.

The complete source code, including the AI models and the full Flutter application, is kept private by the project team.

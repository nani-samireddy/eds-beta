// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'section_item_model.dart';

class SectionItemsListModel {
  /// type is either carousel or grid or flex list
  final String type;

  /// axis is either horizontal or vertical
  final String axis;

  /// title is the title of the section
  final bool hasTitleImage;

  /// List of items in the section `SectionItemModel`
  final List<SectionItemModel> items;
  final String? titleImageURL;

  SectionItemsListModel({
    required this.type,
    required this.axis,
    required this.hasTitleImage,
    required this.items,
    this.titleImageURL,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'axis': axis,
      'hasTitleImage': hasTitleImage,
      'items': items.map((x) => x.toMap()).toList(),
      titleImageURL ?? 'titleImageURL': titleImageURL,
    };
  }

  factory SectionItemsListModel.fromMap(Map<String, dynamic> map) {
    return SectionItemsListModel(
      type: map['type'] as String,
      axis: map['axis'] as String,
      hasTitleImage: map['hasTitleImage'] as bool,
      titleImageURL: map['titleImageURL'] as String?,
      items: List<SectionItemModel>.from(
        (map['items']).map<SectionItemModel>(
          (x) => SectionItemModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory SectionItemsListModel.fromJson(String source) =>
      SectionItemsListModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SectionItemsListModel(type: $type, axis: $axis, hasTitleImage: $hasTitleImage, items: $items)';
  }
}

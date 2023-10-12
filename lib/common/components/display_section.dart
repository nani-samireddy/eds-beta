import 'package:eds_beta/common/components/common_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eds_beta/models/app_models.dart';


class DisplaySection extends ConsumerStatefulWidget {
  const DisplaySection({super.key, required this.sectionItemsListModel});
  final SectionItemsListModel sectionItemsListModel;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DisplaySectionState();
}

class _DisplaySectionState extends ConsumerState<DisplaySection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Wrap(
        children: [
          widget.sectionItemsListModel.hasTitleImage
            ? RoundedContainer(
                  child: Image.network(
                    widget.sectionItemsListModel.titleImageURL!,
                    width: MediaQuery.of(context).size.width,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                )
              : const SizedBox.shrink(),
          buildItems(
              items: widget.sectionItemsListModel.items,
              type: widget.sectionItemsListModel.type,
              axis: widget.sectionItemsListModel.axis),
        ],
      ),
    );
  }
}

Widget buildItems(
    {required List<SectionItemModel> items,
    required String type,
    required String axis}) {
  if (type == "carousel") {
    return SectionCarouselSlider(items: items);
  } else if (type == "list") {
    return SectionListView(items: items);
  } else {
    return const SizedBox.shrink();
  }
}

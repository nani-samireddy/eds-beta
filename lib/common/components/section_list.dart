import 'package:eds_beta/common/components/rounded_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eds_beta/models/app_models.dart';


class SectionListView extends ConsumerWidget {
  const SectionListView({super.key, required this.items});
  final List<SectionItemModel> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      children: [
        for (var item in items)
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                GestureDetector(
                    onTap: () {
                      //TODO: Add navigation
                    },
                    child:
                        RoundedContainer(child: Image.network(item.imageURL))),
              ],
            ),
          )
      ],
    );
  }
}

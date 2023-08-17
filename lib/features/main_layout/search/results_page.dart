import 'package:eds_beta/models/app_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResultsPage extends ConsumerStatefulWidget {
  const ResultsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ResultsPageState();
}

class _ResultsPageState extends ConsumerState<ResultsPage> {
  List<ProductModel> products = [];

  

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}
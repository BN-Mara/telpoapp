import 'package:telpoapp/utils/utilities.dart';
import 'package:flutter/material.dart';

import '../model/my_card_info.dart';
import 'StatCardView.dart';

class MyFiles extends StatelessWidget {
  final List<CloudStorageInfo> infos;
  const MyFiles({Key? key, required this.infos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        /* Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "My Commissions",
              style: Theme.of(context).textTheme.subtitle1,
            ),
            ElevatedButton.icon(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppUtils.defaultPadding * 1.5,
                  vertical:
                  AppUtils.defaultPadding / 2,
                ),
              ),
              onPressed: () {},
              icon: Icon(Icons.add),
              label: Text("Add New"),
            ),
          ],
        ),*/
        const SizedBox(height: AppUtils.defaultPadding),
        FileInfoCardGridView(
          infos: infos,
          crossAxisCount: _size.width < 650 ? 2 : 4,
          childAspectRatio: _size.width < 650 ? 1.3 : 1,
        ),
      ],
    );
  }
}

class FileInfoCardGridView extends StatelessWidget {
  const FileInfoCardGridView(
      {Key? key,
      this.crossAxisCount = 2,
      this.childAspectRatio = 1,
      required this.infos})
      : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;
  final List<CloudStorageInfo> infos;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: infos.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: AppUtils.defaultPadding,
        mainAxisSpacing: AppUtils.defaultPadding,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) => FileInfoCard(info: infos[index]),
    );
  }
}

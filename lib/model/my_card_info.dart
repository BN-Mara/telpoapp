
import 'package:flutter/material.dart';

import '../res/colors.dart';

class CloudStorageInfo {
  final String? svgSrc, title, totalStorage;
  final int? numOfFiles, percentage;
  final Color? color;
  final void Function()? onPress;

  CloudStorageInfo({
    this.svgSrc,
    this.title,
    this.totalStorage,
    this.numOfFiles,
    this.percentage,
    this.color,
    this.onPress
  });
}

List demoMyFiles = [
  CloudStorageInfo(
    title: "Today",
    numOfFiles: 3650,
    svgSrc: "assets/icons/Documents.svg",
    totalStorage: "18250",
    color: primaryColor,
    percentage: 35,
  ),
  CloudStorageInfo(
    title: "This week",
    numOfFiles: 3650,
    svgSrc: "assets/icons/google_drive.svg",
    totalStorage: "18250",
    color: const Color(0xFFFFA113),
    percentage: 35,
  ),
  CloudStorageInfo(
    title: "This month",
    numOfFiles: 18250,
    svgSrc: "assets/icons/one_drive.svg",
    totalStorage: "3650",
    color: const Color(0xFFA4CDFF),
    percentage: 10,
  ),
  CloudStorageInfo(
    title: "This year",
    numOfFiles: 3650,
    svgSrc: "assets/icons/drop_box.svg",
    totalStorage: "18250",
    color: const Color(0xFF007EE5),
    percentage: 78,
  ),
];

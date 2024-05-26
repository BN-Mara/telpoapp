class CardPay {
  String uid;
  DateTime time;
  int count = 0;
  CardPay({required this.uid, required this.time, required this.count});

  int checkTime(DateTime now) {
    Duration difference = now.difference(time);
    return difference.inSeconds;
  }

  void update() {
    count++;
    time = DateTime.now();
  }
}

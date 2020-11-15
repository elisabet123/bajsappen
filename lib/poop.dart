class Poop {
  final DateTime dateTime;
  final int hardness;
  final int rating;

  Poop(this.dateTime, this.hardness, this.rating);

  Map asMap() =>
      {
        'dateTime': dateTime.millisecondsSinceEpoch,
        'hardness': hardness,
        'rating': rating
      };
}

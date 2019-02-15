
import 'package:cloud_firestore/cloud_firestore.dart';

class Tobacco {

  String id;
  String categoryByName;
  String hardnessCategoryById;
  String imgUrl;
  String title;
  String subTitle;

  Tobacco(this.categoryByName, this.hardnessCategoryById, this.imgUrl, this.title, this.subTitle);

  Tobacco.withId(this.id, this.categoryByName, this.hardnessCategoryById, this.imgUrl, this.title, this.subTitle);


  factory Tobacco.fromDocument(DocumentSnapshot d) {
    return new Tobacco.withId(
        d.documentID, d["categoryByName"], d["hardnessCategory"], d["imgUrl"], d["title"], d["subTitle"]);
  }
}

List<Tobacco> books = [
  Tobacco("DarkSide", "level 1", 'https://hookah4you.ru/wp-content/uploads/2016/11/dark-icecream-400x225.jpg', 'Dark Icecream', 'by John Green and Rodrigo Corral'),
  Tobacco("DarkSide", "level 1", "https://hookah4you.ru/wp-content/uploads/2016/11/bananapapa-400x225.jpg", 'Bananapapa', 'by Stephen King'),
  Tobacco("DarkSide", "level 1", 'https://hookah4you.ru/wp-content/uploads/2016/11/mango-lassi-400x225.jpg', 'Mango Lassi', 'by Lauren Oliver'),
  Tobacco("DarkSide", "level 1", 'https://hookah4you.ru/wp-content/uploads/2016/11/bounty-hunter-400x225.jpg', 'Bounty Hunter', 'by Lauren Oliver'),
  //Book('assets/images/book4.gif', 'The 5th Wave', 'Rick Yancey')
];
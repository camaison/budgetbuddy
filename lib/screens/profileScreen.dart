import 'dart:ui';
import 'package:budgetbuddy/Theme/constants.dart';
import 'package:budgetbuddy/functions/sortData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatelessWidget {
  late double income;
  late double expense;

  ProfileScreen({super.key});
  static late String name = '';
  static late String email = '';
  Future<void> _launchUrl(_url) async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  Widget ProfilePic() {
    String picUrl = '';
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get()
            .asStream(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const SnackBar(
                content: Text('Something went wrong'),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 3),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: Shimmer(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFF4B860).withOpacity(0.3),

                  const Color(0xFF4A5859).withOpacity(0.3),
                  // Colors.orangeAccent.withOpacity(0.2),
                  // Colors.grey.withOpacity(0.1),
                ],
              ),
              child: Container(
                color: Colors.transparent,
                height: kSpacingUnit.w * 10,
                width: kSpacingUnit.w * 10,
                child: const CircleAvatar(
                  radius: 15,
                ),
              ),
            ));
          }
          Map data = snapshot.data!.data() as Map;
          picUrl = data['picURL'];

          return CircleAvatar(
            radius: kSpacingUnit.w * 4.5,
            backgroundImage: picUrl == ''
                ? const AssetImage('assets/images/placeholder.jpg')
                    as ImageProvider
                : NetworkImage(snapshot.data!['picURL']),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: const Size(414, 896), minTextAdapt: true);
    var profileInfo = Expanded(
        child: Column(children: <Widget>[
      Container(
          height: kSpacingUnit.w * 10,
          width: kSpacingUnit.w * 10,
          margin: EdgeInsets.only(top: kSpacingUnit.w * 3),
          child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection(FirebaseAuth.instance.currentUser!.uid)
                  .doc('transactions')
                  .get()
                  .asStream(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const SnackBar(
                      content: Text('Something went wrong'),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 3),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: Shimmer(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF4A5859).withOpacity(0.3),
                        Colors.orangeAccent.withOpacity(0.2),
                        Colors.grey.withOpacity(0.1),
                      ],
                    ),
                    child: Container(
                      color: Colors.transparent,
                      height: kSpacingUnit.w * 10,
                      width: kSpacingUnit.w * 10,
                      child: const CircleAvatar(
                          radius: 15,
                          backgroundImage:
                              AssetImage('assets/images/placeholder.jpg')),
                    ),
                  ));
                }
                Map data = snapshot.data!.data() as Map;
                income = data['income'].toDouble();
                expense = data['expense'].toDouble();

                double percent = income <= 0
                    ? 0
                    : (income - expense) / income <= 0
                        ? 0
                        : (income - expense) / income;

                late Color progressColor;

                if (percent < 0.25) {
                  progressColor = Colors.red;
                } else if (percent < 0.5) {
                  progressColor = Colors.orange;
                } else {
                  progressColor = Colors.lightGreen;
                }
                return Stack(
                  children: <Widget>[
                    Stack(
                      children: [
                        RotatedBox(
                          quarterTurns: -4,
                          child: CircularPercentIndicator(
                            circularStrokeCap: CircularStrokeCap.round,
                            backgroundColor: Colors.grey.withOpacity(0.3),
                            radius: kSpacingUnit.w * 5,
                            lineWidth: 6.0,
                            percent: percent,
                            progressColor: progressColor,
                            center: ProfilePic(),
                          ),
                        )
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        height: kSpacingUnit.w * 3,
                        width: kSpacingUnit.w * 3,
                        decoration: BoxDecoration(
                          color: progressColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          heightFactor: kSpacingUnit.w * 1.5,
                          widthFactor: kSpacingUnit.w * 1.5,
                          child: Text((percent * 100).round().toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontSize: 14,
                              )),

                          /* Icon( 
                        Icons.pending,
                        color: kDarkPrimaryColor,
                        size: ScreenUtil().setSp(kSpacingUnit.w * 1.5),
                      ),*/
                        ),
                      ),
                    ),
                  ],
                );
              }))
    ]));
    /* Container(
            height: kSpacingUnit.w * 10,
            width: kSpacingUnit.w * 38,
            child: Center(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xFF4A5859).withOpacity(0.2),
                      ),
                      child: /*Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                              child: Row(children: [
                            Text("Score:  ",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: 20,
                                )),
                            Text("20",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.orangeAccent,
                                  fontSize: 22,
                                )),
                          ])),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                              width: 180,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.1),
                              ),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("Status: ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          fontSize: 20,
                                        )),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Flexible(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Image.asset(
                                            'assets/images/Fun.png',
                                            height: 60),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                  ])),
                        ],
                      )),*/

                    )

          ])),
            ),
          ),*/

    var header = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        profileInfo,
      ],
    );

    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFF4B860).withOpacity(0.2),

                const Color(0xFF4A5859).withOpacity(0.3),
                //Color(0xFFC83E4D).withOpacity(0.1),
              ],
            ),
          ),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: kSpacingUnit.w * 15),
                header,
                SizedBox(height: kSpacingUnit.w * 2),
                Text(
                  name,
                  style: kTitleTextStyle.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: kSpacingUnit.w * 0.5),
                Text(
                  email,
                  style: kCaptionTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: kSpacingUnit.w * 2),
                const SizedBox(height: 30),
                GestureDetector(
                    child: Container(
                      height: kSpacingUnit.w * 5.5,
                      margin: EdgeInsets.symmetric(
                        horizontal: kSpacingUnit.w * 4,
                      ).copyWith(
                        bottom: kSpacingUnit.w * 2,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: kSpacingUnit.w * 2,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(kSpacingUnit.w * 3),
                        color: const Color(0xFF4A5859).withOpacity(0.2),
                      ),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.request_quote,
                            size: kSpacingUnit.w * 2.5,
                          ),
                          SizedBox(width: kSpacingUnit.w * 1.5),
                          Text(
                            'Feature Request',
                            style: kTitleTextStyle.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                    onTap: () {
                      Uri _url = Uri.parse(
                          'https://docs.google.com/forms/d/e/1FAIpQLSdjZWZsCKkFmWqtLZrGaerNKCIBXu6UdCJGZnkCZr2C8Yvfgg/viewform?usp=sf_link}');
                      _launchUrl(_url);
                    }),
                const SizedBox(height: 10),
                GestureDetector(
                  child: Container(
                    height: kSpacingUnit.w * 5.5,
                    margin: EdgeInsets.symmetric(
                      horizontal: kSpacingUnit.w * 4,
                    ).copyWith(
                      bottom: kSpacingUnit.w * 2,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: kSpacingUnit.w * 2,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kSpacingUnit.w * 3),
                      color: const Color(0xFF4A5859).withOpacity(0.2),
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons
                              .question_answer, //LineAwesomeIcons.question_circle,

                          size: kSpacingUnit.w * 2.5,
                        ),
                        SizedBox(width: kSpacingUnit.w * 1.5),
                        Text(
                          'Help & Support',
                          style: kTitleTextStyle.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                  onTap: () {
                    Uri _url = Uri.parse(
                        'https://docs.google.com/forms/d/e/1FAIpQLSfOr3ClKRy1PPzBlcttcOQCZbgQSHKobQPrGubsXXXnt-InWw/viewform?usp=sf_link');
                    _launchUrl(_url);
                  },
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  child: Container(
                    height: kSpacingUnit.w * 5.5,
                    margin: EdgeInsets.symmetric(
                      horizontal: kSpacingUnit.w * 4,
                    ).copyWith(
                      bottom: kSpacingUnit.w * 2,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: kSpacingUnit.w * 2,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kSpacingUnit.w * 3),
                      color: const Color(0xFF4A5859).withOpacity(0.2),
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.info, //LineAwesomeIcons.user_plus,
                          size: kSpacingUnit.w * 2.5,
                        ),
                        SizedBox(width: kSpacingUnit.w * 1.5),
                        Text(
                          'Info',
                          style: kTitleTextStyle.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                  onTap: () {
                    Uri _url =
                        Uri.parse('https://github.com/camaison/budgetbuddy');
                    _launchUrl(_url);
                  },
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    SortData.allData = {};
                    FirebaseAuth.instance.signOut();
                  },
                  child: Container(
                    height: kSpacingUnit.w * 5.5,
                    margin: EdgeInsets.symmetric(
                      horizontal: kSpacingUnit.w * 4,
                    ).copyWith(
                      bottom: kSpacingUnit.w * 2,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: kSpacingUnit.w * 2,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kSpacingUnit.w * 3),
                      color: const Color(0xFF4A5859).withOpacity(0.2),
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.logout,
                          size: kSpacingUnit.w * 2.5,
                        ),
                        SizedBox(width: kSpacingUnit.w * 1.5),
                        Text(
                          'Logout',
                          style: kTitleTextStyle.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

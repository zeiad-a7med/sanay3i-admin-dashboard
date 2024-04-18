import 'package:flutter/services.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maintenanceservices/Part2/Home.dart';
import 'package:maintenanceservices/Tools.dart';
import 'package:maintenanceservices/login.dart';
import 'CustomFormField.dart';
import 'Validator.dart';
import 'VerifyPhoneNumberScreen.dart';
import 'main.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late String code ;
  String coun = "" ;
  String photo = "${FirebaseAuth.instance.currentUser?.photoURL}";
  Validator validator = new Validator() ;
  String name = "${FirebaseAuth.instance.currentUser?.displayName}" ;
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                secColor,
                firstColor
              ],
              begin: FractionalOffset.bottomCenter,
              end: FractionalOffset.topCenter,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: RefreshIndicator(
            onRefresh: _loadData ,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 73),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_left,),
                          color: Colors.white,
                          onPressed: () {
                            new Tools().goToAnotherActivity(context, new HomePage());
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.logout ,),
                          color: Colors.white,
                          onPressed: () {
                            AwesomeDialog(
                              context: context,
                              title: "error",
                              body: Text('\tLogout ?'),
                              btnCancelOnPress: () {},
                              btnOkOnPress: () {
                                FirebaseAuth.instance.signOut();
                                new Tools().showDialoge(context);
                                new Tools().delay((){
                                  new Tools().disposeDialog(context);
                                  Navigator.pushReplacement( context , new MaterialPageRoute(builder: (context) => new login()) );
                                });

                              },
                            ).show();
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Your\nProfile',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Phudu" ,
                      ),
                    ),
                    SizedBox(
                      height: 22,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.43,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          double innerHeight = constraints.maxHeight;
                          double innerWidth = constraints.maxWidth;
                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: innerHeight * 0.42,
                                  width: innerWidth,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height:50,
                                      ),
                                      Text(
                                        "${name}",
                                        style: TextStyle(
                                          color: Color.fromRGBO(39, 105, 171, 1),
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Phudu" ,
                                          fontSize: 37,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),

                                    ],
                                  ),
                                ),
                              ),

                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: Container(
                                    child: CircleAvatar(
                                      radius: 90,
                                      backgroundColor: Colors.white ,
                                      child: CircleAvatar(
                                        radius: 88,
                                        backgroundColor: Colors.white ,
                                        backgroundImage: NetworkImage(photo),
                                        child : Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white ,
                                                borderRadius: BorderRadius.circular(100),
                                              ),
                                              child: IconButton(
                                                icon: FirebaseAuth.instance.currentUser?.emailVerified.toString() == "true" ?
                                                Icon(Icons.verified_user,color: Colors.green,) :
                                                Icon(Icons.not_interested,color: Colors.red),
                                                color: Colors.white,
                                                onPressed: () {

                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Your Information',
                              style: TextStyle(
                                color: Color.fromRGBO(39, 105, 171, 1),
                                fontSize: 27,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Phudu" ,
                              ),
                            ),
                            Divider(
                              thickness: 2.5,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text(
                                  "${FirebaseAuth.instance.currentUser!.email}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: firstColor ,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Phudu" ,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${name}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: firstColor ,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Phudu" ,
                                  ),
                                ),
                                Container(
                                  height: 35,
                                  width : 35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.black26,
                                  ),
                                  child: IconButton(
                                      iconSize: 20 ,
                                      onPressed: (){
                                        changeUserName(context);
                                      },
                                      icon: Icon(Icons.edit_outlined)
                                  ),
                                )
                              ],
                            ) ,
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  FirebaseAuth.instance.currentUser!.phoneNumber.toString().isEmpty || FirebaseAuth.instance.currentUser!.phoneNumber.toString() == "null" ? "Add Phone Number" : "${FirebaseAuth.instance.currentUser!.phoneNumber}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: firstColor ,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Phudu" ,
                                  ),
                                ),
                                Container(
                                  height: 35,
                                  width : 35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.black26,
                                  ),
                                  child: IconButton(
                                      iconSize: 20 ,
                                      onPressed: (){
                                        // addPhoneNumber(context);
                                        Navigator.pushReplacement( context , new MaterialPageRoute(builder: (context) => new VerifyPhoneNumberScreen()) );
                                      },
                                      icon: FirebaseAuth.instance.currentUser!.phoneNumber.toString().isEmpty || FirebaseAuth.instance.currentUser!.phoneNumber.toString() == "null" ? Icon(Icons.add) : Icon(Icons.edit_outlined)
                                  ),
                                )
                              ],
                            ) ,
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  FirebaseAuth.instance.currentUser?.emailVerified.toString() == "true" ? "Your Account is Verified" : "Your Account is not Verified",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: firstColor ,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Phudu" ,
                                  ),
                                ),
                                Container(
                                  height: 35,
                                  width : 35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.black26,
                                  ),
                                  child: IconButton(
                                    iconSize: 20 ,
                                    onPressed: (){
                                      if(FirebaseAuth.instance.currentUser?.emailVerified.toString() == "true") {
                                        AwesomeDialog(
                                          context: context,
                                          title: "DONE",
                                          body: Text(
                                            "\tYour Account Is Activated\n",
                                            style: TextStyle(
                                              color: firstColor ,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Phudu" ,
                                            ),
                                          ),
                                        ).show();
                                      }
                                      else{
                                        FirebaseAuth.instance.currentUser?.sendEmailVerification() ;
                                        AwesomeDialog(
                                          context: context,
                                          title: "DONE",
                                          body: Text(
                                            "\tgo to check your inbox's mail\n",
                                            style: TextStyle(
                                              color: firstColor ,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Phudu" ,
                                            ),
                                          ),
                                        ).show();
                                      }
                                    },
                                    icon: FirebaseAuth.instance.currentUser?.emailVerified.toString() == "true" ?
                                    Icon(Icons.verified_user,color: Colors.green,) :
                                    Icon(Icons.not_interested,color: Colors.red),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Change Your Password",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: firstColor ,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Phudu" ,
                                  ),
                                ),
                                Container(
                                  height: 35,
                                  width : 35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.black26,
                                  ),
                                  child: IconButton(
                                    iconSize: 20 ,
                                    onPressed: (){
                                      changePassword(context);
                                    },
                                    icon: Icon(Icons.edit_outlined)
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        )
      ],
    );
  }

  changeUserName(context){
    final TextEditingController _editController = TextEditingController();
    GlobalKey<FormState> formstate = new GlobalKey<FormState>();
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (sa) {
          return Dialog(
            backgroundColor: Colors.white,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Scaffold(
                body: Form(
                  key: formstate ,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Change Name',
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Phudu" ,
                          )
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CustomFormField(
                          controller: _editController,
                          icon: Icon(Icons.mail) ,
                          hintText: 'Name',
                          validator: (value) {
                            if (!validator.isValidName(value.toString()))
                              return 'Enter valid Name';
                          }
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: firstColor,
                              fixedSize: Size(150, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)
                              ),
                            ),
                            onPressed: () {
                              if(formstate.currentState!.validate()){
                                FirebaseAuth.instance.currentUser?.updateDisplayName(_editController.value.text);
                                setState(() {
                                  name = _editController.value.text ;
                                });
                                Navigator.of(context).pop();
                                AwesomeDialog(context: context, title: "error", body: Text('name updated successfully.\n\n')).show();
                              }
                            },
                            child: Text(
                              'Confirm',
                              style: TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Phudu" ,
                              )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
    );
  }

  changePassword(context){
    final TextEditingController _editController1 = TextEditingController();
    final TextEditingController _editController2 = TextEditingController();
    GlobalKey<FormState> formstate = new GlobalKey<FormState>();
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (sa) {
          return Dialog(
            backgroundColor: Colors.white,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Scaffold(
                body: Form(
                  key: formstate ,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Change Password',
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Phudu" ,
                          )
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CustomFormField(
                          controller: _editController1,
                          icon: Icon(Icons.mail) ,
                          hintText: 'Old Password',
                          validator: (value) {
                            if (!validator.isValidPassword(value.toString()))
                              return 'Enter valid Password';
                          }
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CustomFormField(
                          controller: _editController2,
                          icon: Icon(Icons.mail) ,
                          hintText: 'New Password',
                          validator: (value) {
                            if (!validator.isValidPassword(value.toString()))
                              return 'Enter valid Password';
                          }
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: firstColor,
                              fixedSize: Size(150, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)
                              ),
                            ),
                            onPressed: () async {
                              if(formstate.currentState!.validate()){
                                if(await changeOldPassword(_editController1.value.text , _editController2.value.text)) {
                                  Navigator.of(context).pop();
                                  AwesomeDialog(context: context, title: "error", body: Text('password updated successfully.\n\n')).show();
                                }
                              }
                            },
                            child: Text(
                              'Confirm',
                              style: TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Phudu" ,
                              )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
    );
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        // _todos = _loadedTodos;
      });
    } catch (err) {
      rethrow;
    }
  }

  String getCountryCodeFromText(String text){
    String val = text.split("]")[0].replaceAll("[", "") ;
    print('((: ${val}');
    setState(() {
      code = val ;
      coun = text ;
    });
    return val ;
  }

  Future<bool> changeOldPassword(String oldPassword , String newPassword) async{
    UserCredential userCredential ;
    try{
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: "${FirebaseAuth.instance.currentUser?.email}" ,
        password: oldPassword ,
      );
      userCredential.user?.updatePassword(newPassword);
      return true ;
    }
    on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        AwesomeDialog(context: context, title: "error", body: Text('Wrong password provided for that user.\n\n')).show();
      }
      return false ;
    }
  }

  List<String> country = [
    '[93]AFG', '[358]ALA', '[355]ALB', '[213]DZA', '[1]ASM', '[376]AND', '[244]AGO', '[1]AIA', '[672]ATA', '[1]ATG', '[54]ARG', '[374]ARM', '[297]ABW', '[61]AUS', '[43]AUT', '[994]AZE', '[1]BHS', '[973]BHR', '[880]BGD', '[1]BRB', '[375]BLR', '[32]BEL', '[501]BLZ', '[229]BEN', '[1]BMU', '[975]BTN', '[591]BOL', '[599]BES', '[387]BIH', '[267]BWA', '[47]BVT', '[55]BRA', '[246]IOT', '[246]UMI', '[1]VGB', '[1 340]VIR', '[673]BRN', '[359]BGR', '[226]BFA', '[257]BDI', '[855]KHM', '[237]CMR', '[1]CAN', '[238]CPV', '[1]CYM', '[236]CAF', '[235]TCD', '[56]CHL', '[86]CHN', '[61]CXR', '[61]CCK', '[57]COL', '[269]COM', '[242]COG', '[243]COD', '[682]COK', '[506]CRI', '[385]HRV', '[53]CUB', '[599]CUW', '[357]CYP', '[420]CZE', '[45]DNK', '[253]DJI', '[1]DMA', '[1]DOM', '[593]ECU', '[20]EGY', '[503]SLV', '[240]GNQ', '[291]ERI', '[372]EST', '[251]ETH', '[500]FLK', '[298]FRO', '[679]FJI', '[358]FIN', '[33]FRA', '[594]GUF', '[689]PYF', '[262]ATF', '[241]GAB', '[220]GMB', '[995]GEO', '[49]DEU', '[233]GHA', '[350]GIB', '[30]GRC',
    '[299]GRL', '[1]GRD', '[590]GLP', '[1]GUM', '[502]GTM', '[44]GGY', '[224]GIN', '[245]GNB', '[592]GUY', '[509]HTI', '[672]HMD', '[379]VAT', '[504]HND', '[36]HUN', '[852]HKG', '[354]ISL', '[91]IND', '[62]IDN', '[225]CIV', '[98]IRN', '[964]IRQ', '[353]IRL', '[44]IMN', '[972]ISR', '[39]ITA', '[1]JAM', '[81]JPN', '[44]JEY', '[962]JOR', '[76, 77]KAZ', '[254]KEN', '[686]KIR', '[965]KWT', '[996]KGZ', '[856]LAO', '[371]LVA', '[961]LBN', '[266]LSO', '[231]LBR', '[218]LBY', '[423]LIE', '[370]LTU', '[352]LUX', '[853]MAC', '[389]MKD', '[261]MDG', '[265]MWI', '[60]MYS', '[960]MDV', '[223]MLI', '[356]MLT', '[692]MHL', '[596]MTQ', '[222]MRT', '[230]MUS', '[262]MYT', '[52]MEX', '[691]FSM', '[373]MDA', '[377]MCO', '[976]MNG', '[382]MNE',
    '[1]MSR', '[212]MAR', '[258]MOZ', '[95]MMR', '[264]NAM', '[674]NRU', '[977]NPL', '[31]NLD', '[687]NCL', '[64]NZL', '[505]NIC', '[227]NER', '[234]NGA', '[683]NIU', '[672]NFK', '[850]PRK', '[1]MNP', '[47]NOR', '[968]OMN', '[92]PAK', '[680]PLW', '[970]PSE', '[507]PAN', '[675]PNG', '[595]PRY', '[51]PER', '[63]PHL', '[64]PCN', '[48]POL', '[351]PRT', '[1]PRI', '[974]QAT', '[383]UNK', '[262]REU', '[40]ROU', '[7]RUS', '[250]RWA', '[590]BLM', '[290]SHN', '[1]KNA', '[1]LCA', '[590]MAF', '[508]SPM', '[1]VCT', '[685]WSM', '[378]SMR', '[239]STP', '[966]SAU', '[221]SEN', '[381]SRB', '[248]SYC', '[232]SLE', '[65]SGP', '[1]SXM', '[421]SVK', '[386]SVN', '[677]SLB', '[252]SOM', '[27]ZAF', '[500]SGS', '[82]KOR',
    '[34]ESP', '[94]LKA', '[249]SDN', '[211]SSD', '[597]SUR', '[47]SJM', '[268]SWZ', '[46]SWE', '[41]CHE', '[963]SYR', '[886]TWN', '[992]TJK', '[255]TZA', '[66]THA', '[670]TLS', '[228]TGO', '[690]TKL', '[676]TON', '[1]TTO', '[216]TUN', '[90]TUR', '[993]TKM', '[1]TCA', '[688]TUV', '[256]UGA', '[380]UKR', '[971]ARE', '[44]GBR', '[1]USA', '[598]URY', '[998]UZB', '[678]VUT', '[58]VEN', '[84]VNM', '[681]WLF', '[212]ESH', '[967]YEM', '[260]ZMB', '[263]ZWE'];
}
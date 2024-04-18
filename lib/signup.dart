import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter/cupertino.dart';
import 'package:maintenanceservices/TakeAPhoto.dart';
import 'Models/Actor.dart';
import 'CustomFormField.dart';
import 'Firebase_.dart';
import 'Tools.dart';
import 'Validator.dart';
import 'login.dart';
import 'main.dart';

class signup extends StatefulWidget {
  Actor actor = new Actor();
  signup(this.actor);
  @override
  State<signup> createState() => _signupState(actor);
}

class _signupState extends State<signup> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController = TextEditingController() ;
  late TextEditingController _emailController = TextEditingController() ;
  late TextEditingController _passwordController = TextEditingController() ;
  late TextEditingController _phoneController = TextEditingController() ;
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();
  Icon icon = Icon(Icons.remove_red_eye_rounded);
  Validator validator = new Validator() ;
  Firebase_ firebase = new Firebase_();
  Tools tools = new Tools();
  Actor actor = new Actor();
  _signupState(this.actor);
  bool secure = true ;
  late String code ;
  String coun = "" ;

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: firstColor,
        body: Center(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Form(
              key: formstate,
              child: ListView(
                children: [
                  Container(
                    child: Row(
                      children: [
                        Text(
                          "Here's\nYour First\nStep With\nUs!" ,
                          style: TextStyle(
                            fontSize: 30.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Phudu" ,
                          ),
                        ),
                        SizedBox(width: 3,),
                        Expanded(
                          child: ClipPath(
                            clipper: RoundedDiagonalPathClipper(),
                            child: Container(
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(50.0)),
                                color: Colors.white,
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: 60,),
                                  Expanded(child: Image.asset("images/workersicon.png" ,scale: 5,)),
                                ],
                              )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 10,),
                        CustomFormField(
                          controller: _usernameController ,
                          icon: Icon(Icons.drive_file_rename_outline_outlined) ,
                          hintText: 'Name',
                          validator: (value) {
                            if (!validator.isValidName(value.toString()))
                              return 'Enter valid Name';
                          },
                        ),

                        CustomFormField(
                          controller: _emailController,
                          icon: Icon(Icons.mail) ,
                          hintText: 'Email',
                          validator: (value) {
                            if (!validator.isValidEmail(value.toString()))
                              return 'Enter valid email';
                          },
                        ),
                        CustomFormField(
                          controller: _phoneController,
                          icon: Icon(Icons.phone) ,
                          hintText: 'Phone',
                          validator: (value) {
                            if (!validator.isValidPhone(value.toString()))
                              return 'Enter valid phone';
                          },
                        ),
                        CustomFormField(
                          iconButton: IconButton(
                            icon: icon ,
                            onPressed: () {
                              if(secure){
                                setState(() {
                                  secure = false ;
                                  icon = Icon(Icons.remove_red_eye_outlined) ;
                                });
                              }
                              else{
                                setState(() {
                                  secure = true ;
                                  icon = Icon(Icons.remove_red_eye_rounded);
                                });
                              }
                            }
                          ),
                          controller: _passwordController,
                          icon: Icon(Icons.key) ,
                          textInputType: TextInputType.visiblePassword ,
                          hintText: 'Password',
                          obscureText : secure ,
                          validator: (value) {
                            if (!validator.isValidPassword(value.toString()))
                              return 'Minimum eight characters, at least one uppercase letter, one lowercase letter, one number and one special character';
                          },
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: firstColor,
                              fixedSize: Size(300, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)
                              ),
                          ),
                          onPressed: () {
                            if (formstate.currentState!.validate()) {
                              actor.name     = _usernameController.value.text ;
                              actor.email    = _emailController.value.text ;
                              actor.phone    = _phoneController.value.text ;
                              actor.password = _passwordController.value.text ;
                              actor.photo    = "EMPTY" ;
                              // actor.code     = code ;
                              tools.goToAnotherActivity(context, new TakeAPhoto(actor));
                            }
                          },
                          child: Text(
                            'Upload Your Photo',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Phudu" ,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Center(child: tools.check( context , new login() , "if you have Account" )),
                        Center(
                          child: GestureDetector(
                            child: Text("Contact Us" ,
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Phudu" ,
                                color: Colors.blue
                              ),
                            ),
                            onTap: () {
                              ContactUsDialog(context);
                            },
                          )
                        ),
                        SizedBox(height: 10,),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),

                ],
              ),
            ),
          ),
        )
      ),
    );
  }

  // getListOFCountry()async{
  //   List<Country>? countries = [] ;
  //   List<Country>? countries = await CountryProvider.instance.getAllCountries();
  //   setState(() {
  //     this.countries = countries ;
  //   });
  //   for(int i = 0 ; i < countries.length ; i++){
  //     print("'${countries[i].callingCodes}${countries[i].alpha3Code}',") ;
  //   }
  // }

  String getCountryCodeFromText(String text){
    String val = text.split("]")[0].replaceAll("[", "") ;
    print('((: ${val}');
    setState(() {
      code = val ;
      coun = text ;
    });
    return val ;
  }

  ContactUsDialog(BuildContext context ){
    return showDialog(context: context , builder: (context) {
      return AlertDialog(
        actionsPadding: EdgeInsets.all(10),
        scrollable: true,
        content: Form(
          key: _formKey,
          child: Column(
            children: [
              CircleAvatar(
                radius:50,
                backgroundColor: Colors.white,
                backgroundImage: AssetImage("images/workersicon.png"),
              ),
              SizedBox(height: 10),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter name';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                inputFormatters: [
                  FilteringTextInputFormatter.singleLineFormatter,
                ],
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color:Colors.black,width: 2 ),
                  ),
                  hintText: 'Name',
                  //errorText: error ? 'please enter Your Name' : null,
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 15),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color:Colors.black,width: 2 )
                  ),
                  hintText: 'PhoneNumber',
                  prefixIcon: Icon(Icons.phone),
                  filled: true,
                  fillColor: Colors.white
                ),
              ),
              SizedBox(height: 15),

              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
                inputFormatters: [
                  FilteringTextInputFormatter.singleLineFormatter,
                ],
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color:Colors.black,width: 2 )
                  ),
                  hintText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 15),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter message';
                  }
                  return null;
                },
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  //labelText: 'Enter Message',
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Message',
                  border: InputBorder.none,
                ),
                maxLines: 7, // <-- SEE HERE
              ),
              SizedBox(height: 30),
              MaterialButton(
                onPressed: (){
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                  }
                },
                minWidth:double.infinity,
                color: secColor,
                child: Text('SUBMIT',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 18),),
              ),
              IconButton(onPressed: (){
                showDialog(
                  context: context, builder: (Context){
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      content: Column(
                          children: [
                            Container(
                              child: Text("Contact Information",style: TextStyle(fontStyle:FontStyle.italic,fontSize: 25,),),
                              decoration: BoxDecoration(
                                color: firstColor,
                                border: Border.all(width: 2,color: Colors.black38),
                              ),
                            ),
                            SizedBox(height: 50),
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.fmd_good,color: secColor),
                                SizedBox(width: 20),
                                Text('7 st Mostafa elnahas, Cairo',style: TextStyle(fontSize: 15)),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(Icons.phone,color: secColor),
                                SizedBox(width: 20),
                                Text('01156366044',style: TextStyle(fontSize: 15)),

                              ],
                            ),
                            SizedBox(height: 20),

                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.email,color: secColor),
                                SizedBox(width: 20),
                                Text('Saiedmeligy83@gmail.com',style: TextStyle(fontSize: 15)),
                              ],
                            ),
                          ]
                      )
                    );
                  },
                );
              }, icon: Icon(Icons.help),color: Colors.white,)
            ],
          ),
        ),
        backgroundColor: firstColor,
        alignment: Alignment.center,
      );
    });
  }

  // List<String> country = [
  //   '[93]AFG', '[358]ALA', '[355]ALB', '[213]DZA', '[1]ASM', '[376]AND', '[244]AGO', '[1]AIA', '[672]ATA', '[1]ATG', '[54]ARG', '[374]ARM', '[297]ABW', '[61]AUS', '[43]AUT', '[994]AZE', '[1]BHS', '[973]BHR', '[880]BGD', '[1]BRB', '[375]BLR', '[32]BEL', '[501]BLZ', '[229]BEN', '[1]BMU', '[975]BTN', '[591]BOL', '[599]BES', '[387]BIH', '[267]BWA', '[47]BVT', '[55]BRA', '[246]IOT', '[246]UMI', '[1]VGB', '[1 340]VIR', '[673]BRN', '[359]BGR', '[226]BFA', '[257]BDI', '[855]KHM', '[237]CMR', '[1]CAN', '[238]CPV', '[1]CYM', '[236]CAF', '[235]TCD', '[56]CHL', '[86]CHN', '[61]CXR', '[61]CCK', '[57]COL', '[269]COM', '[242]COG', '[243]COD', '[682]COK', '[506]CRI', '[385]HRV', '[53]CUB', '[599]CUW', '[357]CYP', '[420]CZE', '[45]DNK', '[253]DJI', '[1]DMA', '[1]DOM', '[593]ECU', '[20]EGY', '[503]SLV', '[240]GNQ', '[291]ERI', '[372]EST', '[251]ETH', '[500]FLK', '[298]FRO', '[679]FJI', '[358]FIN', '[33]FRA', '[594]GUF', '[689]PYF', '[262]ATF', '[241]GAB', '[220]GMB', '[995]GEO', '[49]DEU', '[233]GHA', '[350]GIB', '[30]GRC',
  //   '[299]GRL', '[1]GRD', '[590]GLP', '[1]GUM', '[502]GTM', '[44]GGY', '[224]GIN', '[245]GNB', '[592]GUY', '[509]HTI', '[672]HMD', '[379]VAT', '[504]HND', '[36]HUN', '[852]HKG', '[354]ISL', '[91]IND', '[62]IDN', '[225]CIV', '[98]IRN', '[964]IRQ', '[353]IRL', '[44]IMN', '[972]ISR', '[39]ITA', '[1]JAM', '[81]JPN', '[44]JEY', '[962]JOR', '[76, 77]KAZ', '[254]KEN', '[686]KIR', '[965]KWT', '[996]KGZ', '[856]LAO', '[371]LVA', '[961]LBN', '[266]LSO', '[231]LBR', '[218]LBY', '[423]LIE', '[370]LTU', '[352]LUX', '[853]MAC', '[389]MKD', '[261]MDG', '[265]MWI', '[60]MYS', '[960]MDV', '[223]MLI', '[356]MLT', '[692]MHL', '[596]MTQ', '[222]MRT', '[230]MUS', '[262]MYT', '[52]MEX', '[691]FSM', '[373]MDA', '[377]MCO', '[976]MNG', '[382]MNE',
  //   '[1]MSR', '[212]MAR', '[258]MOZ', '[95]MMR', '[264]NAM', '[674]NRU', '[977]NPL', '[31]NLD', '[687]NCL', '[64]NZL', '[505]NIC', '[227]NER', '[234]NGA', '[683]NIU', '[672]NFK', '[850]PRK', '[1]MNP', '[47]NOR', '[968]OMN', '[92]PAK', '[680]PLW', '[970]PSE', '[507]PAN', '[675]PNG', '[595]PRY', '[51]PER', '[63]PHL', '[64]PCN', '[48]POL', '[351]PRT', '[1]PRI', '[974]QAT', '[383]UNK', '[262]REU', '[40]ROU', '[7]RUS', '[250]RWA', '[590]BLM', '[290]SHN', '[1]KNA', '[1]LCA', '[590]MAF', '[508]SPM', '[1]VCT', '[685]WSM', '[378]SMR', '[239]STP', '[966]SAU', '[221]SEN', '[381]SRB', '[248]SYC', '[232]SLE', '[65]SGP', '[1]SXM', '[421]SVK', '[386]SVN', '[677]SLB', '[252]SOM', '[27]ZAF', '[500]SGS', '[82]KOR',
  //   '[34]ESP', '[94]LKA', '[249]SDN', '[211]SSD', '[597]SUR', '[47]SJM', '[268]SWZ', '[46]SWE', '[41]CHE', '[963]SYR', '[886]TWN', '[992]TJK', '[255]TZA', '[66]THA', '[670]TLS', '[228]TGO', '[690]TKL', '[676]TON', '[1]TTO', '[216]TUN', '[90]TUR', '[993]TKM', '[1]TCA', '[688]TUV', '[256]UGA', '[380]UKR', '[971]ARE', '[44]GBR', '[1]USA', '[598]URY', '[998]UZB', '[678]VUT', '[58]VEN', '[84]VNM', '[681]WLF', '[212]ESH', '[967]YEM', '[260]ZMB', '[263]ZWE'];
}
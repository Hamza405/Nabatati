import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';

class SettingsScreenBody extends StatelessWidget {
  final Size size;
  SettingsScreenBody(this.size);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                height: 54,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 10),
                      blurRadius: 50,
                      color: kPrimaryColor.withOpacity(0.23),
                    ),
                  ],
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          hintText: "Search for a Settings...",
                          hintStyle: TextStyle(
                            color: kPrimaryColor.withOpacity(0.5),
                          ),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          // surffix isn't working properly  with SVG
                          // thats why we use row
                          // suffixIcon: SvgPicture.asset("assets/icons/search.svg"),
                        ),
                      ),
                    ),
                    SvgPicture.asset("assets/icons/search.svg"),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
              ),
              ListTile(
                leading: Icon(Icons.account_circle_outlined),
                title: Text('Acount'),
                trailing: Icon(Icons.arrow_forward),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.notifications_none_rounded),
                title: Text('Notifications'),
                trailing: Icon(Icons.arrow_forward),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.support_agent_rounded),
                title: Text('Help and Support'),
                trailing: GestureDetector(
                    child: Icon(Icons.arrow_forward),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => Container(
                                child: AlertDialog(
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Support',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 25),
                                      ),
                                      Icon(Icons.support_agent_sharp,
                                          color: Colors.white)
                                    ],
                                  ),
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  content: Container(
                                    width: size.width * 0.4,
                                    height: size.height*0.2,
                                    child: SingleChildScrollView(
                                                                          child: Column(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Nabatati Team',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: Colors.white),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'Contact support:\nnabtatiapp.help2021@gmail.com',
                                            style: TextStyle(color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ));
                    }),
              ),
              Divider(),
              ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('About'),
                  trailing: GestureDetector(
                    child: Icon(Icons.arrow_forward),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => Container(
                            
                                child: AlertDialog(
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'About',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 25),
                                      ),
                                      Icon(Icons.info_outline,
                                          color: Colors.white)
                                    ],
                                  ),
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  content: Container(
                                    width: size.width * 0.4,
                                    height: size.height*0.4,
                                    child: SingleChildScrollView(
                                                                          child: Column(
                                        children: [
                                          
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            '"Nabatati" is an app that communicate with an IoT Smart Irrigation System.\nThe app will help you to know the moisture ratio of your plants by setting a soil moisture sensor and sending notifications if the plants need a water and determining the appropriate amount for each plant type.',
                                            style: TextStyle(color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ));
                    },
                  )),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}

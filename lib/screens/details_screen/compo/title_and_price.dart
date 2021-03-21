import 'package:flutter/material.dart';
import 'package:planet_app/provider/planet_provider.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';

class TitleAndPrice extends StatelessWidget {
  const TitleAndPrice({
    Key key,
    this.title,
    this.description,
    this.isF,
    
  }) : super(key: key);

  final String title, description;
  final bool isF;
  

  @override
  Widget build(BuildContext context) {
    final a =Provider.of<PlantProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child:
      Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: RichText(
                  text: TextSpan(

                    children: [
                      TextSpan(
                        text: "$title\n",
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            .copyWith(color: kTextColor, fontWeight: FontWeight.bold),
                      ),
                      // TextSpan(
                      //   text: country,
                      //   style: TextStyle(
                      //     fontSize: 20,
                      //     color: kPrimaryColor,
                      //     fontWeight: FontWeight.w300,
                      //   ),
                      // ),
                    ],
                  ),
                ),
          ),
          SizedBox(height: 24,),
          Text(description==null?'The plant dose not has a description!!!':description,
          style: TextStyle(fontSize: 25),

          )
        ],
      ),
    );
  }
}

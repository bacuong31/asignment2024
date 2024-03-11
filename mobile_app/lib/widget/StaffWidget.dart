import 'package:flutter/material.dart';
import 'package:mobile_app/StaffDetails.dart';
import 'package:mobile_app/model/StaffModel.dart';
class StaffWidget extends StatelessWidget {
  final StaffModel model;
  StaffWidget( this.model, {super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.all(size.width*0.03),
        padding: EdgeInsets.all(size.width*0.03),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.amber[600]
          ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(model.imageURL),
              radius: 30.0,
            ),
            SizedBox(width: size.width*0.05,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
             
              children: [Text("Name: " + model.name), Text("Age: " + model.age.toString()), Text("Role: " + model.role)],),
          ],
        ),
        
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => StaffDetails(model: model,))
      ),
    );
  }
}
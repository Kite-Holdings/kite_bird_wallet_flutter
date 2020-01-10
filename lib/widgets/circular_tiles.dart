
import 'package:flutter/material.dart';

class CircularTiles extends StatelessWidget {
  CircularTiles({
    this.radius = 100,
    this.color = Colors.lightBlue,
    this.icon = Icons.mms,
    this.label = 'label',
    this.onPressed
  });

  final double radius;
  final String label;
  final IconData icon;
  final Color color;
  final Function onPressed;
  

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Stack(
        children: <Widget>[
          Container(
            height: radius,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // color: Colors.white
            ),
            child: Stack(
              children: <Widget>[
                Center(
                  child: Transform.rotate(
                    angle: 4,
                    origin: Offset(9 * radius/200, -20 * radius/200),
                    child: Icon(
                      icon,
                      color: Colors.grey,
                      size: 100 * radius/200,
                      
                    ),
                  ),
                ),

                Container(
                  width: radius,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withOpacity(.8)
                  ),
                  child: Center(
                    child: Text(
                      label,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26 * radius/200,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 1.5 * radius/200
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
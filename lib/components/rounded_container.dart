import 'package:flutter/material.dart';

class RoundedContainer extends StatelessWidget {
  final Widget child;

  const RoundedContainer({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20)
        )
      ),
      child: child,
    );
  }
  
}

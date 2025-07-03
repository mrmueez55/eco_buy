import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Ecotextfield extends StatefulWidget {
  String? hinttext;
  String? labeltext;
  TextEditingController? controller;
  String? Function(String?)? validate;
  bool? ispassword;
  Widget? icon;
  int? maxlines;
  int? minlines;
  TextInputAction? inputAction;
  FocusNode? focusNode;
  Ecotextfield({
    super.key,
    this.hinttext,
    this.labeltext,
    this.controller,
    this.validate,
    this.ispassword = false,
    this.icon,
    this.minlines,
    this.maxlines,
    this.inputAction,
    this.focusNode,
  });

  @override
  State<Ecotextfield> createState() => _EcotextfieldState();
}

class _EcotextfieldState extends State<Ecotextfield> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey.withOpacity(0.5),
      ),
      child: TextFormField(
        // minLines: ,
        // max,
        obscureText: widget.ispassword == false ? false : widget.ispassword!,
        textInputAction: widget.inputAction,
        //  focusNode: widget.focusNode,
        validator: widget.validate,
        controller: widget.controller,
        //   maxLines: widget.maxlines == 1 ? 1 : widget.maxlines,
        decoration: InputDecoration(
          hintText: widget.hinttext ?? "hint text.....",
          labelText: widget.labeltext ?? "Label text...",
          contentPadding: const EdgeInsets.all(10),
          border: InputBorder.none,
          suffixIcon: widget.icon,
        ),
      ),
    );
  }
}

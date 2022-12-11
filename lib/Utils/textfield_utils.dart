import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

textFieldWidget(
    String hint,
    TextEditingController controller,
    bool isObscureText,
    bool isDense,
    Color color,
    TextInputType textInputType,
    double horizontalPadding,
    Color focusedBorderColor,
    int maxLine) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
    child: TextFormField(
      obscureText: isObscureText,
      maxLines: maxLine,
      validator: (value) {
        if (value!.isEmpty) {
          return "Enter Value";
        }
      },
      keyboardType: textInputType,
      controller: controller,
      decoration: InputDecoration(
          suffixIcon: InkWell(
              onTap: () {
                controller.clear();
              },
              child: Icon(
                Icons.cancel,
                size: 25,
                color: Colors.grey.shade400,
              )),
          isDense: true,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          filled: true,
          fillColor: color,
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: focusedBorderColor),
              borderRadius: BorderRadius.circular(10))),
    ),
  );
}
import 'package:firebase_auth_app/controllers/validators.dart';
import 'package:flutter/material.dart';

Widget inputField(controller,focusNode,isObscure, labelText,isEmail,isPassword,checkPassVisibility){
  bool isObscureLocal=true;
  Widget? prefixIcon;

  /// Set Prefix Icon
  if(isEmail){
    prefixIcon = const Icon(Icons.email);
  }else if(isPassword){
    prefixIcon = const Icon(Icons.lock);
  }else{
    prefixIcon = null;
  }

  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26)
    ),
    child: Card(
      elevation: 5,
      shape:RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 5),
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          obscureText: isObscure ? isObscureLocal : false,
          decoration:  InputDecoration(
            prefixIcon: prefixIcon,
             // suffixIcon: IconButton(
             //    icon: Icon(
             //        isObscureLocal ? Icons.visibility : Icons.visibility_off),
             //    onPressed:(){
             //      checkPassVisibility(isObscureLocal);}
             //    ) ,
              border: InputBorder.none,
              labelText: labelText,
              labelStyle: const TextStyle(fontSize: 18)
          ),
          validator: (value) =>
          isEmail ?
              Validator.validateEmail(email: value.toString())
              : isPassword ? Validator.validatePassword(password: value.toString()) : null,
        ),
      ),
    ),
  );
}

Widget button(onTap,height,color,text){
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26)
    ),
    child: Card(
      elevation: 5,
      shape:RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap:
          onTap(),
        child: Container(
            height: height * 0.07,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: color
            ),
            child: Center(child: Text(text,style: const TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w600),))),),
    ),
  );
}
import 'package:flutter/material.dart';
import 'package:todo_list_app/shared_components.dart';

class Login extends StatefulWidget {

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var emailController=TextEditingController();
  var passwordController=TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool isPassword= true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
      ),
      body:
      SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            // color: Colors.teal,
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 80),
                child: Form(
                  key: formKey  ,
                  child: Column(
                    children: [
                      Center(
                        child: Text('LogIn',
                          style: TextStyle(
                            color: Colors.teal,
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      defaultFormField(
                        controller: emailController,
                        label: 'email',
                        prefix: Icons.email,
                        type: TextInputType.emailAddress,
                        validate: ( String value){
                          if(value.isEmpty){
                            return'email must not to be empty';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      defaultFormField(
                        controller: passwordController,
                        label: 'password',
                        prefix: Icons.lock,
                        suffix: isPassword? Icons.visibility : Icons.visibility_off,
                        isPassword : isPassword,
                        suffixPressed: (){
                          setState(() {
                            isPassword = !isPassword;}
                          );
                          },
                        type: TextInputType.visiblePassword,
                        validate: ( String value){
                          if(value.isEmpty){
                            return'password is too short';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      defaultButton(
                          background: Colors.teal,
                          radius: 5,
                          function: (){
                            if(formKey.currentState.validate()){
                              print(emailController.text);
                              print(passwordController.text);
                            }
                          },
                          text: 'Login')
                      // TextButton(onPressed:(){}, child:
                      // Text('You don\'t have account',
                      //   style: TextStyle(
                      //       color: Colors.teal
                      //   ),
                      // )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

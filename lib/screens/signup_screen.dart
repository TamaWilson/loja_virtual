import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _cepController = MaskedTextController(mask: '00000-000');
  final _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Criar conta"),
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model){
          if(model.isLoading)
            return Center(child: CircularProgressIndicator(),);
          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      hintText: "Nome"
                  ),
                  validator: (text){
                    if(text.isEmpty  ){
                      return "Nome inválido";
                    }
                  },
                ),
                SizedBox(height: 16.0,),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      hintText: "Email"
                  ),
                  validator: (text){
                    RegExp exp = new RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$");
                    if(text.isEmpty || !exp.hasMatch(text)){
                      return "Email inválido";
                    }
                  },
                ),
                SizedBox(height: 16.0,),
                TextFormField(
                  controller: _passController,
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: "Senha"
                  ),
                  validator: (text){
                    if(text.isEmpty || text.length < 6) {
                      return "A senha deve ter pelo menos 6 caracteres.";
                    }
                  },
                ),
                SizedBox(height: 16.0,),
                TextFormField(
                  controller: _cepController,
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly
                  ],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: "CEP"
                  ),
                  validator: (text){
                    if(text.isEmpty  ){
                      return "CEP inválido";
                    }
                  },
                ),
                SizedBox(height: 16.0,),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                      hintText: "Endereço"
                  ),
                  validator: (text){
                    if(text.isEmpty  ){
                      return "Endereço inválido";
                    }
                  },
                ),
                SizedBox(height: 16.0,),
                SizedBox(height: 44.0,
                  child:
                  RaisedButton(
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    child: Text("CRIAR", style: TextStyle(fontSize: 18.0),),
                    onPressed: (){
                      if(_formKey.currentState.validate()){

                        Map<String,dynamic> userData = {
                          "name" : _nameController.text,
                          "email": _emailController.text,
                          "address": _addressController.text,
                          "cep": _cepController,
                        };

                        model.signUp(
                            userData: userData,
                            pass: _passController.text,
                            onSuccess: _onSuccess,
                            onFail: _onFail
                        );
                      }
                    },
                  )
                  ,)
              ],
            ),
          );
        },
      ),
    );
  }


void _onSuccess(){
  _scaffoldKey.currentState.showSnackBar(
    SnackBar(content: Text("Usuário criado com sucesso"),
    backgroundColor: Theme.of(context).primaryColor,
    duration: Duration(seconds: 2),

    )
  );
 Future.delayed(Duration(seconds: 2)).then((_){
   Navigator.of(context).pop();
 });

  }

void _onFail(){
  _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text("Falha ao criar usuário"),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      )
  );
}

}
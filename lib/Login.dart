/*import 'package:flutter/material.dart';
class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  late String id; late String pass;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("Login", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),centerTitle: true,),
      body: Stack(children: [Positioned.fill(child: Container(decoration: const BoxDecoration(
        gradient: LinearGradient( begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [
          Color(0xff0E0716),
          Color(0xff41236B),
          Color(0xff7238C3),
        ])
      ),)),
        Column(children: [
        const SizedBox(width: double.infinity, height: 300,),
        const Align(alignment: Alignment.centerLeft, child:  Text("   Login", style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
        const Align(alignment: Alignment.bottomLeft, child: Text("      Please sign in to continue", style: TextStyle(fontSize: 25, color: Colors.white))),
        Padding(padding: const EdgeInsets.all(20) , child: Column(children: [
          TextField(style: const TextStyle(color: Colors.white,), onEditingComplete: (){

          }, decoration: const InputDecoration(
            icon: Icon(Icons.mail, color: Colors.white,), labelText: "Email", labelStyle: TextStyle(color: Colors.white),
            hoverColor: Colors.red,
          ),),
          const SizedBox(width: double.infinity, height: 10,),
          const TextField(style: TextStyle(color: Colors.white), decoration: InputDecoration(
            icon: Icon(Icons.lock, color: Colors.white,), labelText: "Password",labelStyle: TextStyle(color: Colors.white),
            hoverColor: Colors.red,))])),
        SizedBox(width: double.infinity, height: 30,),
        Align(alignment: Alignment.bottomRight, child: Container(decoration: BoxDecoration(
    color: Colors.white, borderRadius: BorderRadius.circular(80),
    ),child: TextButton(onPressed: (){

        },
          child: const Text("Login",
            style: TextStyle(color: Colors.black, fontSize: 20, backgroundColor: Colors.white),), ) ),)
      ],
      ),
      ],)
    );
  }
}
*/
//Before scroll
import 'package:flutter/material.dart';
import 'Home.dart';

class login extends StatefulWidget {
  const login({super.key});
  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  late TextEditingController tc1;
  late TextEditingController tc2;
  late String error;
  late String id; late String pass;
  @override
  void initState() {
    error = "";
    tc1 = TextEditingController();
    tc2 = TextEditingController();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("Login", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),centerTitle: true,),
        body: Stack(children: [Positioned.fill(child: Container(decoration: const BoxDecoration(
            color: Colors.black,
        ), child: const Column(children: [
          Align(alignment: Alignment.topLeft, child: Image(image: AssetImage("images/pro-table-top.png")),),
          SizedBox(width: double.infinity, height: 400,),
            Align(alignment: Alignment.bottomRight, child: Image(image: AssetImage("images/pro-table-bottom.png")),),
        ],),)),
          Column( children: [
            const SizedBox(width: double.infinity, height: 300,),
            const Align(alignment: Alignment.centerLeft, child:  Text("   Login", style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
            const Align(alignment: Alignment.bottomLeft, child: Text("      Please sign in to continue", style: TextStyle(fontSize: 25, color: Colors.white))),
            Padding(padding: const EdgeInsets.all(20) , child: Column(children: [
              TextField(controller: tc1, style: const TextStyle(color: Colors.white,), onSubmitted: (String value){
                setState(() {
                  id = tc1.text;
                });
              }, decoration: const InputDecoration(
                icon: Icon(Icons.mail, color: Colors.white,), labelText: "Email", labelStyle: TextStyle(color: Colors.white),
                hoverColor: Colors.red,
              ),),
              const SizedBox(width: double.infinity, height: 10,),
              TextField(controller: tc2, style: const TextStyle(color: Colors.white), onSubmitted: (String value){
                setState(() {
                  pass = tc2.text;
                });
              },decoration: const InputDecoration(
                icon: Icon(Icons.lock, color: Colors.white,), labelText: "Password",labelStyle: TextStyle(color: Colors.white),
                hoverColor: Colors.red,))])),
            SizedBox(width: double.infinity, height: 30,),
            Padding(padding: EdgeInsets.all(20), child: Align(alignment: Alignment.bottomRight, child: Container(decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(80),
            ),child: TextButton(onPressed: (){
              if (id == "abc"&& pass =="abc"){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const HomePage()));
              }
              else{
                tc1.clear();
                tc2.clear();
                setState(() {
                  error = "Incorrect Username/Password";
                });
              }
            },
              child: const Text("Login",
                style: TextStyle(color: Colors.black, fontSize: 20, backgroundColor: Colors.white),), ) ),),),
            if(error.isNotEmpty)
              Padding(padding: const EdgeInsets.all(10), child: Text(error, style: const TextStyle(
                color: Colors.red, fontWeight: FontWeight.bold, fontSize: 25,
              ),),)
          ],)

        ],)
    );
  }
}

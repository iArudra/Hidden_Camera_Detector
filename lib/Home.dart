/*import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:hidden_camera/Process.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class home extends StatefulWidget {
  const home({super.key});
  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  late List<CameraDescription> cameras;
  late CameraController CC;
  int current =0;
  bool loading = true;
  @override
  void initState() {
    startcam(0);
    super.initState();
  }
  void ccin(int n){
    CC = CameraController(cameras[n], ResolutionPreset.high, enableAudio: false);
  }
  void swap() async{
      current = (current+1)%2;
      await CC.dispose();
      startcam(current);
  }
  void startcam(int n) async{
    cameras =  await availableCameras();
    ccin(n);
    await CC.initialize().then((value){
      if(!mounted){
        return;
      }
      setState(() {
        loading =false;
      });
    }).catchError((e) {
      print(e);
    });
  }
  @override
  void dispose(){
    CC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      const spinkit = SpinKitSpinningLines(color: Colors.blue);
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: spinkit),
      );
    }
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(title: const Text("Hidden Camera Detector", style:
        TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
          backgroundColor: Colors.black,),
        body: Column(children: [
          Expanded(child: Stack(children: [CameraPreview(CC),
            Align(alignment: Alignment.bottomRight,
              child: Column(children: [
                InkWell(child: IconButton(color: Colors.black, onPressed: () {
                  swap();
                }, icon: const Icon(
                  Icons.swap_horiz_outlined, color: Colors.white, size: 50,)),),
                InkWell(
                  child: IconButton(color: Colors.black, onPressed: () async {
                    CC.setFlashMode(FlashMode.off);
                    XFile img = await CC.takePicture();
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => Process(image: img)));
                  }, icon: const Icon(
                    Icons.camera_alt, color: Colors.white, size: 50,)),),
              ])
              ,),
          ])),
          const Padding(padding: EdgeInsets.all(10),
            child: Text("No Hidden Camera detected",
              style: TextStyle(color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),),),
        ],),
      );
    }
  }
*/
import 'package:flutter/material.dart';
import 'package:hidden_camera/Search.dart';
import 'Home1.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  String getGreetingMessage() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return "Good Morning!";
    } else if (hour < 18) {
      return "Good Afternoon!";
    } else {
      return "Good Evening!";
    }
  }
  Future <void> launchWebsite() async {
    //final url = Uri.parse('https://rushi-praneeth.github.io/LiveLocation');
    final Uri url = Uri.parse('https://www.google.co.in/');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black,
        title: const Text("Home Page", style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(
            icon: const Icon(Icons.contact_page, color: Colors.white, size: 30,),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    padding: const EdgeInsets.all(16.0),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: Icon(Icons.email),
                          title: Text("Email"),
                          subtitle: Text("support@example.com"),
                        ),
                        ListTile(
                          leading: Icon(Icons.phone),
                          title: Text("Phone"),
                          subtitle: Text("+1 (123) 456-7890"),
                        ),
                        ListTile(
                          leading: Icon(Icons.location_on),
                          title: Text("Address"),
                          subtitle: Text("1234 Flutter Street, Code City"),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            alignment: Alignment.center,
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Colors.blue, Colors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: Text(
                getGreetingMessage(),
                style: const TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: double.infinity, height: 10,),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context, MaterialPageRoute(builder: (context) => const Home()),
              );
            },
            child: Container(
              height: 150,
              margin: const EdgeInsets.only(bottom: 16.0),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera,
                    size: 50,
                    color: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Hidden Camera Detector",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 26),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20,),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context, MaterialPageRoute(builder: (context) => const SearchPage()),
              );
            },
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.purpleAccent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search,
                    size: 50,
                    color: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Search Page",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 26),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 35,),
          GestureDetector(
            onTap: () async {
              try {
                await launchWebsite();
              } catch (e) {
                debugPrint('Error: $e');
              }
            },
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.pin_drop,
                    size: 50,
                    color: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Live Tracking",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 26),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:math';
import 'package:flutter/material.dart';
void main() => runApp(MyApp());

var x=0.0;
var y=0.0;
var h = 200.0;
var r = h / 2;
Offset offset = Offset.zero;
List<Color> cores = [
  Color.fromRGBO(61, 63, 76, 1),
  Color.fromRGBO(72, 81, 88, 1),
  Color.fromRGBO(88, 110, 107, 1),
  Color.fromRGBO(115, 142, 127, 1),
  Color.fromRGBO(149, 167, 145, 1),
  Color.fromRGBO(182, 194, 170, 1),
  Color.fromRGBO(228, 217, 197, 1),
  Color.fromRGBO(145, 114, 96, 1),
  Color.fromRGBO(124, 90, 80, 1),
  Color.fromRGBO(90, 58, 63, 1),
  Color.fromRGBO(51, 33, 49, 1),
  Color.fromRGBO(38, 16, 37, 1),
];

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '3d Menu Cube',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Menu()
    );
  }
}
class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final Matrix4 frente = Matrix4.identity()..setEntry(3, 2, 0.001)..translate(h * sin(pi) * cos(0),h * sin(pi) * sin(0),h * cos(pi) - 50);
  @override
  Widget build(BuildContext context) {
    x = offset.dx * 0.013;
    y = offset.dy * 0.013;

    List<Face> faces = [
      Face(Page('Perfil', Icons.account_circle, Container(), cores[2], context), x, 0, x, y),
      Face(Page('Configurações', Icons.settings, ConfigPage(), cores[3], context), -x + pi, pi, x, y),
      Face(Page('Flutter', Icons.backup, Container(), cores[4], context), x, pi, x - (pi/2), 0, y),
      Face(Page('Create', Icons.headset, Container(), cores[9], context), x, 0, x - (pi/2), 0, y),
      Face(Page('Home', Icons.home, Container(), cores[8], context), x, 0, x, y - (pi/2)),
      Face(Page('BRASIL', Icons.account_circle, Container(), cores[7], context), -x + pi, pi, x, y - (pi/2))
    ];
    faces..sort((a, b) => a.matriz.relativeError(frente).compareTo(b.matriz.relativeError(frente)));
    return GestureDetector(
      onPanUpdate: (dt) => setState(() { offset = Offset(offset.dx + dt.delta.dy, offset.dy - dt.delta.dx); }),
      onDoubleTap: () => setState(() { x=0;y=0; offset = Offset.zero; }),
      child: Scaffold(
        backgroundColor: cores[0],
        floatingActionButton: RaisedButton.icon(
          icon: Icon(faces[0].page.icon),
          label: Text(faces[0].page.tag),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Scaffold(backgroundColor: cores[6], body: faces[0].page.maior),))
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: Container(
                  height: h,
                  width: h,
                  child: Stack(
                    children: faces.reversed.map((face) => Transform(alignment: Alignment.center,transform: face.matriz,child: face.page.menor,)).toList().cast<Widget>(),
                  ),
                )
              )
            ),
          ],
        ),
      ),
    );
  }
}

class Page {
  String tag;
  var icon;
  Widget child;
  Color cor;
  Widget menor;
  Widget maior;
  var context;
  Page(this.tag, this.icon, this.child, this.cor, this.context) {
    menor = PHero(
      tag: tag,
      child: Container(
        height: h,
        width: h,
        color: this.cor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(tag, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
            Container(height: 15,),
            Icon(icon, size: 30,),
          ],
        ),)
      );
    maior = PHero(
      tag: tag,
      child:Scaffold(
        backgroundColor: cor,
        body: ListView(
          children: <Widget>[
            Container(height: 25,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Icon(icon, size: 30,),
                Text(tag, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                IconButton(icon: Icon(Icons.menu, size: 30), onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Menu())),)
              ],
            ),
          ],
    ),
      ));
  }
}

class PHero extends StatelessWidget {
  final String tag;
  final Widget child;
  const PHero({Key key, this.tag, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: child,
    );
  }
}

class Face {
  double teta;
  double fi;
  double rtX;
  double rtY;
  double rtZ;
  Matrix4 matriz;
  Page page;
  Face(this.page, this.teta, this.fi, [this.rtX = 0, this.rtY = 0, this.rtZ = 0]){
    matriz = Matrix4.identity()
    ..setEntry(3, 2, 0.001)
    ..rotateX(this.rtX)
    ..rotateY(this.rtY)
    ..rotateZ(this.rtZ)
    ..translate(
      r * sin(this.fi) * cos(this.teta),
      r * sin(this.fi) * sin(this.teta),
      r * cos(this.fi)
    );
  }
}

class PageHero extends StatelessWidget {
  final Widget child;
  final String tag;
  const PageHero({Key key, this.tag, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Hero(
      child: Scaffold(
        body: child, 
        floatingActionButton: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Menu())),
        ),
      ),
      tag: tag,
    );
  }
}

class ConfigPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageHero(
      tag: 'Config',
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 25, left: 20),
            child: Text('Configurações', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          )
        ],
      )
    );
  }
}
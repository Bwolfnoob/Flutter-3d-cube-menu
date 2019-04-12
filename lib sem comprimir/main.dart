import 'dart:math';import 'package:flutter/material.dart';
void main()=>runApp(MyApp());
var x=0.0;
var y=0.0;
var h=200.0;
var r=h/2;
Offset offset=Offset.zero;
List<Color> cores=[[61,63,76,1],[72,81,88,1],[88,110,107,1],[115,142,127,1],[149,167,145,1],[182,194,170,1],[228,217,197,1],[145,114,96,1],[124,90,80,1],[90,58,63,1],[51,33,49,1],[38,16,37,1]].map((c)=>Color.fromRGBO(c[0],c[1],c[2],c[3].toDouble())).toList().cast<Color>();
List<Face> faces=[Face(Page('Perfil',Icons.account_circle,cores[2]),calc1),Face(Page('Configurações',Icons.settings,cores[3]),calc2),Face(Page('Flutter',Icons.backup,cores[4]),calc3),
  Face(Page('Create',Icons.headset,cores[9]),calc4),Face(Page('Home',Icons.home,cores[8]),calc5),Face(Page('BRASIL',Icons.account_circle,cores[7]),calc6)];
calc6()=>[-x+pi,pi,x,y-(pi/2),0.0];
calc5()=>[x,0.0,x,y-(pi/2),0.0];
calc4()=>[x,0.0,x-(pi/2),0.0,y];
calc3()=>[x,pi,x-(pi/2),0.0,y];
calc2()=>[-x+pi,pi,x,y,0.0];
calc1()=>[x,0.0,x,y,0.0];
Matrix4 f=Matrix4.identity()..setEntry(3,2,0.001)..translate(0.0,0.0,-h);
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState()=>_MyAppState();
}
class _MyAppState extends State<MyApp> {
  @override
  Widget build(context)=>MaterialApp(title:'3d Menu Cube',home:Menu());
}
class Menu extends StatefulWidget {
  @override
  _MenuState createState()=>_MenuState();
}
class _MenuState extends State<Menu> {
  @override
  void initState() {
    super.initState();
    faces.forEach(((face){ face.page.configure(click);face.update(); }));
    faces..sort((a,b)=>a.matriz.relativeError(f).compareTo(b.matriz.relativeError(f)));
  }
  click()=>Navigator.of(context).pop();
  @override
  Widget build(context) {
    x=offset.dx*0.013;
    y=offset.dy*0.013;
    faces.forEach(((face)=>face.update()));
    faces..sort((a,b)=>a.matriz.relativeError(f).compareTo(b.matriz.relativeError(f)));
    return GestureDetector(
      onPanUpdate:(dt)=>setState(()=>offset=Offset(offset.dx+dt.delta.dy,offset.dy-dt.delta.dx)),
      onDoubleTap:()=>setState((){ x=0;y=0;offset=Offset.zero; }),
      child:Scaffold(
        backgroundColor:cores[0],
        floatingActionButton:RaisedButton.icon(
          icon:Icon(faces[0].page.icon),
          label:Text(faces[0].page.tag),
          onPressed:()=>Navigator.push(context,FacePageRoute(faces[0])),
        ),
        floatingActionButtonLocation:FloatingActionButtonLocation.centerFloat,
        body:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:<Widget>[
            Center(child: Container(
                height:h,width:h,
                child:Stack(children:faces.reversed.map((face)=>Transform(alignment:Alignment.center,transform:face.matriz,child:face.page.menor,)).toList().cast<Widget>(),),
              ),),
          ],
        ),
      ),
    );
  }
}
class Page {
  Widget menor,maior,child=Container();
  var context,icon,tag,cor;
  Function onPressed;
  Page(this.tag,this.icon,this.cor,[this.child]);
  void configure(Function click) {
    if(menor==null && maior==null) {
    menor=Container(height:h,width:h,color:this.cor,child:Icon(icon,size:h/3,),);
    maior=Container(
        height:double.infinity,width:double.infinity,
        child:Scaffold(
          backgroundColor:cor,
          body:ListView(
            children:<Widget>[
              Container(height:25,),
              Row(
                mainAxisAlignment:MainAxisAlignment.spaceAround,
                children:<Widget>[
                  Icon(icon,size:30,),
                  Text(tag,style:TextStyle(fontSize:24,fontWeight:FontWeight.bold),),
                  IconButton(icon:Icon(Icons.menu,size:30),onPressed:click,)
                ],
              ),
            ],
          ),
        ),
      );
    }
  }
}
class Face {
  double teta,fi,rtX,rtY,rtZ;
  Matrix4 matriz;
  Page page;
  Function calc;
  Face(this.page,this.calc);
  update() {
    List result=this.calc();
     matriz=Matrix4.identity()
    ..setEntry(3,2,0.001)
    ..rotateX(result[2])..rotateY(result[3])..rotateZ(result[4])
    ..translate(r*sin(result[1])*cos(result[0]),r*sin(result[1])*sin(result[0]),r*cos(result[1]));
  }
}
class FacePageRoute extends PageRouteBuilder{
  Face face;
  FacePageRoute(this.face):super(
    pageBuilder:(cxt,ani,sani) => Scaffold(backgroundColor:cores[6],body:face.page.maior),
    transitionsBuilder:(cxt,ani,sani,child)=>ScaleTransition(scale:ani,child:child,));
}
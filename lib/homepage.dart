import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minesweeper/bomb.dart';
import 'package:minesweeper/numberbox.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //variables
  Random random = new Random();
  int score = 0 ;
  int numberOfSqares = 9 * 9;
  int numberInEachRow = 9;
  var squareStatus = []; // [количество бомб в определнном квадрате,
  // revealed = true / false]

  //bomb locations
  var bombLocation =  [];

  int bombAmount = 3;

  bool bombsRevealed = false;

  @override
  void initState() {
    super.initState();
    // инициализация, у каждого квадрата 0 бомб вокруг,
    // и они не открыты revealed = false
    for(int i = 0; i < numberOfSqares; i++){
      squareStatus.add([0,false]);
    }
    bombAmount = random.nextInt(8) + 1;

    for(int i =0 ; i < bombAmount; i++){
      bombLocation.add(random.nextInt(81));

    }
    scanBombs();
  }
  void restartGame (){
    setState(() {
      bombAmount = random.nextInt(8) + 1;
      bombLocation.clear();
      for(int i =0 ; i < bombAmount; i++){

        bombLocation.add(random.nextInt(81));

      }
      bombsRevealed = false;
      for(int i = 0; i < numberOfSqares; i++){
        squareStatus[i][1] = false;
      }
      scanBombs();
    });
  }
  void revealBoxNumbers (int index){
    // меняет текущий квадрат если его номер: 1, 2, 3 и т.д.
    if(squareStatus[index][0] != 0 ) {
      setState(() {
        squareStatus[index][1] = true;
      });
    } else if (squareStatus[index][0] == 0)
      {
        //открываем текущий квадрат, и 8 его окружающих,
        //до тех пор пока не упремся в стенку
        setState(() {
          //открываем текущий квадрат
          squareStatus[index][1] = true;
          //открываем левый квадрат (до тех пор пока не упремся в левую стенку)
          if (index % numberInEachRow != 0){
            //есл иследующий за ним квадрат не отрыт и он 0, входим в рекурсию
            if(squareStatus[index-1][0] == 0 &&
                squareStatus[index-1][1]==false){
              revealBoxNumbers(index - 1);
            }
            // открываем левый квадрат
            squareStatus[index-1][1] = true;
          }
          // открывем верхний левый квадрат(до тех пор пока не окажемся
          // наверху или не упремся в левую стенку)
          if (index % numberInEachRow != 0 && index >= numberInEachRow) {
            //если иследующий за ним квадрат не отрыт и он 0, входим в рекурсию
            if (squareStatus[index - 1 - numberInEachRow][0] == 0 &&
                squareStatus[index - 1 - numberInEachRow][1] == false) {
              revealBoxNumbers(index - 1 - numberInEachRow);
            }
            squareStatus[index - 1 - numberInEachRow][1] = true;
          }

          // открывем верхний квадрат(до тех пор пока не окажемся
          // наверху или не упремся в левую стенку)
          if (index >= numberInEachRow) {
            //если иследующий за ним квадрат не отрыт и он 0, входим в рекурсию
            if (squareStatus[index - numberInEachRow][0] == 0 &&
                squareStatus[index - numberInEachRow][1] == false) {
              revealBoxNumbers(index - numberInEachRow);
            }
            squareStatus[index - numberInEachRow][1] = true;
          }

          // открывем верхний правый квадрат(до тех пор пока не окажемся
          // в верхем ряду или не упремся в правую стенку)
          if (index >= numberInEachRow &&
              index % numberInEachRow != numberInEachRow - 1) {
            //если иследующий за ним квадрат не отрыт и он 0, входим в рекурсию
            if (squareStatus[index + 1 - numberInEachRow][0] == 0 &&
                squareStatus[index + 1 - numberInEachRow][1] == false) {
              revealBoxNumbers(index + 1 - numberInEachRow);
            }
            squareStatus[index + 1 - numberInEachRow][1] = true;
          }

          // открывем верхний правый квадрат(до тех пор пока не окажемся
          // в верхем ряду или не упремся в правую стенку)
          if (index % numberInEachRow != numberInEachRow - 1) {
            //если иследующий за ним квадрат не отрыт и он 0, входим в рекурсию
            if (squareStatus[index + 1 - numberInEachRow][0] == 0 &&
                squareStatus[index + 1 - numberInEachRow][1] == false) {
              revealBoxNumbers(index + 1 - numberInEachRow);
            }
            squareStatus[index + 1 - numberInEachRow][1] = true;
          }
          // открывем нижний правый квадрат(до тех пор пока не окажемся
          // в нижнем ряду или не упремся в правую стенку)
          if ( index < numberOfSqares - numberInEachRow&&
          index % numberInEachRow != numberInEachRow - 1) {
            //если иследующий за ним квадрат не отрыт и он 0, входим в рекурсию
            if (squareStatus[index + 1 + numberInEachRow][0] == 0 &&
                squareStatus[index + 1 + numberInEachRow][1] == false) {
              revealBoxNumbers(index + 1 + numberInEachRow);
            }
            squareStatus[index + 1 + numberInEachRow][1] = true;
          }
          // открывем нижний квадрат(до тех пор пока не окажемся
          // в нижнем ряду )
          if ( index < numberOfSqares - numberInEachRow) {
            //если иследующий за ним квадрат не отрыт и он 0, входим в рекурсию
            if (squareStatus[index + numberInEachRow][0] == 0 &&
                squareStatus[index + numberInEachRow][1] == false) {
              revealBoxNumbers(index + numberInEachRow);
            }
            squareStatus[index + numberInEachRow][1] = true;
          }
          // открывем нижний левый квадрат(до тех пор пока не окажемся
          // в нижнем ряду или не упремся в левую стенку)
          if ( index < numberOfSqares - numberInEachRow&&
                index % numberInEachRow != 0) {
            //если иследующий за ним квадрат не отрыт и он 0, входим в рекурсию
            if (squareStatus[index - 1 + numberInEachRow][0] == 0 &&
                squareStatus[index - 1 + numberInEachRow][1] == false) {
              revealBoxNumbers(index - 1 + numberInEachRow);
            }
            squareStatus[index - 1 + numberInEachRow][1] = true;
          }
        });

      }
  }
  void scanBombs (){
    for (int i = 0; i < numberOfSqares; i++){
      //no bombs by default
      int numberOfBombsAround = 0;
      /*
       Нужно проверить каждый квадратик на предмет бомбы в его окружении,
       всего 8 квадратов для проверки вокруг одного

       */
      // Начинаем проверку влево, только не для тех
      // котрые находятся в первой колонке
      if (bombLocation.contains(i - 1) && numberInEachRow != 0){
        numberOfBombsAround++;
      }
      // проверяем квадрат слева сверху, только не для первой колонки
      // или первого ряда
      if(bombLocation.contains(i - 1 - numberInEachRow) &&
         i % numberInEachRow != 0
          && i >= numberInEachRow){
        numberOfBombsAround++;
      }
      // проверяем квадрат наверху, только не первый ряд
      if(bombLocation.contains(i - numberInEachRow) && i >= numberInEachRow){
        numberOfBombsAround++;
      }
      // Начинаем проверку сверху право, только не для тех
      // котрые находятся в последней колонке или первом ряду
      if (bombLocation.contains(i + 1 - numberInEachRow) &&
          i >= numberInEachRow &&
          i % numberInEachRow != numberInEachRow - 1){
        numberOfBombsAround++;
      }
      // проверяем квадрат право, только не для последней колонки
      // или первого ряда
      if(bombLocation.contains(i + 1) &&
          i % numberInEachRow != numberInEachRow - 1){
        numberOfBombsAround++;
      }
      // проверяем квадрат низ право, только не для последней колонки
      // или последнего ряда
      if (bombLocation.contains(i + 1 + numberInEachRow) &&
          i < numberOfSqares - numberInEachRow &&
          i % numberInEachRow != numberInEachRow - 1){
        numberOfBombsAround++;
      }
      // проверяем низ, только не для тех
      // котрые находятся в последнем ряду
      if (bombLocation.contains(i + numberInEachRow) &&
          i < numberOfSqares - numberInEachRow){
        numberOfBombsAround++;
      }
      // Проверяем квадрат снизу слева,
      // только не последний ряд первая колонка
      if (bombLocation.contains(i - 1 + numberInEachRow) &&
          i < numberOfSqares - numberInEachRow &&
          i % numberInEachRow != 0){
        numberOfBombsAround++;
      }

      // Добавляем итоговое количество бомб вокруг одного
      // квадратика в squareStatus
      setState(() {
        squareStatus[i][0] = numberOfBombsAround;
      });
    }
  }
  void playerLost(){
    showDialog(context: context,
        builder: (context){
      return AlertDialog(
        backgroundColor: Colors.grey[700],
        title: Center(child: Text('W A S T E D',
            style: TextStyle(color: Colors.white)),
            ),
          actions: [
            MaterialButton(
              color: Colors.grey[100],
                child: Icon(Icons.refresh),
                onPressed: (){
            restartGame();
            score = 0;
            Navigator.pop(context);
          })],
      );
    });
  }
  void playerWon(){
    showDialog(context: context,
        builder: (context){
          return AlertDialog(
            backgroundColor: Colors.grey[700],
            title: Center(child: Text('W I N !',
                style: TextStyle(color: Colors.white)),
            ),
            actions: [
              MaterialButton(
                  color: Colors.grey[100],
                  child: Icon(Icons.refresh),
                  onPressed: (){
                    restartGame();
                    Navigator.pop(context);
                    score = score + 100;
                  })],
          );
        });
  }
  void winnerMeter (){
    //Проверяем сколько квадратов уже открыто
    int unreveledBoxes = 0;
    for (int i = 0; i < numberOfSqares; i++){
      if(squareStatus[i][1] == false){
        unreveledBoxes++;
      }
    }
    // если их число совпадает с числом бомб, тогда игрок победил
    if (unreveledBoxes == bombLocation.length){
      playerWon();
    }
  }

  final bombTextFieldController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    bombTextFieldController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body:Column(
        children: [
          //start of a game, main menu
          Container(
            height: 300,
            color: Colors.grey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //display number of bombs
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Text(bombLocation.length.toString(), style: TextStyle(fontSize: 40)),
                    Text('K A B O O M')
                  ],
                ),

                //refresh the game, btn
                GestureDetector(
                  onTap: restartGame,
                  child: Card(
                      child: Icon(Icons.refresh, color: Colors.white, size: 40),
                      color: Colors.grey[700],
                  ),
                ),

                //display time taken
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(score.toString() , style: TextStyle(fontSize: 40)),
                    Text('S C O R E')
                  ],
                )
              ],
            )
          ),
          //grid
          Expanded(
            child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: numberOfSqares,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: numberInEachRow),
                itemBuilder: (context, index){
                 if (bombLocation.contains(index)){
                   return MyBomb(
                     revealed: bombsRevealed,
                     function: (){
                       // user tapped the bomb, lose
                       setState(() {
                         bombsRevealed = true;
                       });
                       playerLost();
                     },
                   );
                 } else{
                   return MyNumberBox(
                     child: squareStatus[index][0],
                     revealed: squareStatus[index][1],
                     function: (){
                       //reveal current box
                       revealBoxNumbers(index);
                       winnerMeter();
                     },
                   );
                 }
                }),
          ),
          //branding
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: Text('C R E A T E D B Y R O M A N K O Z H A R A'),
          )
        ],
      )
    );
  }
}

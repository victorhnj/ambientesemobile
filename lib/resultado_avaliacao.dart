import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ResultadosEmpresaScreen(companyName: '', screenData: [], exportPDF: (String nomeFantasia) {  }, onTap: (int ) {  },),
    );
  }
}

class ResultadosEmpresaScreen extends StatefulWidget {
  final Function(int) onTap;
  final String companyName;
  final List<Map<String, dynamic>> screenData;
  final void Function(String nomeFantasia)? exportPDF;

  ResultadosEmpresaScreen({required this.companyName, required this.screenData, required this.exportPDF, required this.onTap});

  @override
  _ResultadosEmpresaScreenState createState() => _ResultadosEmpresaScreenState();
}

class DynamicProgressCircle extends StatelessWidget {
  final num percentage;
  final String label;
  final Color color;

  const DynamicProgressCircle({
    Key? key,
    required this.percentage,
    required this.label,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularPercentIndicator(
          radius: 60.0,
          lineWidth: 10.0,
          percent: percentage / 100, // Valor de 0 a 1
          center: Text(
            "${percentage.toStringAsFixed(0)}%",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          progressColor: color,
          backgroundColor: color.withOpacity(0.3),
          circularStrokeCap: CircularStrokeCap.round,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _ResultadosEmpresaScreenState extends State<ResultadosEmpresaScreen> {
  int _currentIndex = 0;

  void exportPDF(String nomeFantasia) {
    if (widget.exportPDF != null) {
      widget.exportPDF!(nomeFantasia);
    }
  }

  late List<Map<String, dynamic>> _screenData;

  @override
  void initState() {
    super.initState();
    _screenData = widget.screenData;
  }

@override
  Widget build(BuildContext context) {
    final currentScreen = _screenData[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'Resultados da Empresa ${widget.companyName}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             DynamicProgressCircle(
              percentage: currentScreen['percentage'],
              label: "",
              color: currentScreen['color'],
            ),
            const SizedBox(height: 0),
            Text(
              currentScreen['title'],
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: currentScreen['color'],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: currentScreen['questions'].length,
                itemBuilder: (context, index) {
                  final question = currentScreen['questions'][index];
                  final statusColor = question['status'] == 'Não conforme'
                      ? Colors.red
                      : question['status'] == 'Conforme'
                          ? Colors.green
                          : Colors.black;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: currentScreen['color'].withOpacity(0.1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            question['question'],
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: statusColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              question['status'],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),
            // const SizedBox(height: height * 0.04),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [  
                Expanded(
                  child: ElevatedButton(
                    onPressed: _currentIndex > 0 ?
                      () => setState(() {
                        _currentIndex--;
                      }) :
                      null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                    child: Text(
                      'Voltar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => exportPDF(widget.companyName),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Fundo branco
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: Colors.black), // Borda preta
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                    child: Text(
                      'PDF',
                      style: TextStyle(
                        color: Colors.black, // Texto preto
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),


                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentIndex < _screenData.length - 1) {
                        setState(() {
                          _currentIndex++;
                        });
                      } else {
                        widget.onTap(6);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                    child: Text(
                      _currentIndex < _screenData.length - 1 ? 'Próximo' : 'Finalizar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
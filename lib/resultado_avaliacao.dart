import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ResultadosEmpresaScreen(companyName: '',),
    );
  }
}

class ResultadosEmpresaScreen extends StatefulWidget {
  final String companyName;

  ResultadosEmpresaScreen({required this.companyName});

  @override
  _ResultadosEmpresaScreenState createState() => _ResultadosEmpresaScreenState();
}

class _ResultadosEmpresaScreenState extends State<ResultadosEmpresaScreen> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _screenData = [
    {
      'title': 'Social',
      'color': Colors.orange,
      'questions': [
        "A empresa tem um histórico de iniciativas e projetos de conservação ambiental?",
        "A empresa realiza auditorias ambientais regulares?",
        "A empresa possui programas de treinamento ambiental para os funcionários?",
        "A empresa tem políticas para prevenir e mitigar a poluição ambiental?",
        "A empresa possui uma política de governança ambiental documentada?",
        "A empresa possui uma estratégia clara de sustentabilidade ambiental?",
        "A empresa divulga relatórios de sustentabilidade ambiental?",
        "A empresa divulga seu desempenho ambiental em relatórios públicos?",
        "A empresa possui estratégias para reduzir suas emissões de carbono?",
        "A empresa mede e gerencia seu consumo de recursos naturais?"
      ]
    },
    {
      'title': 'Governmental',
      'color': Colors.blue,
      'questions': [
        "A empresa tem um histórico de iniciativas e projetos de conservação ambiental?",
        "A empresa realiza auditorias ambientais regulares?",
        "A empresa possui programas de treinamento ambiental para os funcionários?",
        "A empresa tem políticas para prevenir e mitigar a poluição ambiental?",
        "A empresa possui uma política de governança ambiental documentada?",
        "A empresa possui uma estratégia clara de sustentabilidade ambiental?",
        "A empresa divulga relatórios de sustentabilidade ambiental?",
        "A empresa divulga seu desempenho ambiental em relatórios públicos?",
        "A empresa possui estratégias para reduzir suas emissões de carbono?",
        "A empresa mede e gerencia seu consumo de recursos naturais?"
      ]
    },
    {
      'title': 'Ambiental',
      'color': Colors.green,
      'questions': [
        "A empresa tem um histórico de iniciativas e projetos de conservação ambiental?",
        "A empresa realiza auditorias ambientais regulares?",
        "A empresa possui programas de treinamento ambiental para os funcionários?",
        "A empresa tem políticas para prevenir e mitigar a poluição ambiental?",
        "A empresa possui uma política de governança ambiental documentada?",
        "A empresa possui uma estratégia clara de sustentabilidade ambiental?",
        "A empresa divulga relatórios de sustentabilidade ambiental?",
        "A empresa divulga seu desempenho ambiental em relatórios públicos?",
        "A empresa possui estratégias para reduzir suas emissões de carbono?",
        "A empresa mede e gerencia seu consumo de recursos naturais?"
      ]
    },
  ];

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
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: currentScreen['color'],
              child: Text(
                '100%',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            SizedBox(height: 16),
            Text(
              currentScreen['title'],
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: currentScreen['color'],
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: currentScreen['questions'].length,
                itemBuilder: (context, index) {
                  return Card(
                    color: currentScreen['color'].withOpacity(0.7),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        currentScreen['questions'][index],
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentIndex > 0)
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _currentIndex--;
                        });
                      },
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
                  )
                else
                  SizedBox(width: 100),

                if (_currentIndex < _screenData.length - 1)
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _currentIndex++;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                      child: Text(
                        'Próximo',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  )
                else
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () {
                        // Implementar ação de finalização
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                      child: Text(
                        'Finalizar',
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
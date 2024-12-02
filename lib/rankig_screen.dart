import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ambientese/header.dart';
import 'package:ambientese/custon_drawer.dart'; // Certifique-se de que o caminho está correto
import 'package:url_launcher/url_launcher.dart';

class RankingScreen extends StatefulWidget {
  final bool finishList1;
  String? token;

  RankingScreen({required this.finishList1, required this.token});

  @override
  _RankingScreenState createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  int _currentIndex = 0;
  List rankingData = [];
  List filteredRankingData = [];
  List top3RankingData = [];
  int _currentPage = 0;
  final int _pageSize = 15;
  bool _hasMoreData = true;
  bool finishList1 = false;
  bool finishList = false;
  String? selectedRamo;
  String? selectedPorte;
  final TextEditingController searchController = TextEditingController();
  String? token;

  // final String token =
  //     'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJyb290IiwiY2FyZ28iOiJBZG1pbiIsImV4cCI6MTczMzA4NzM5OX0.WV_PTMbPyou3ko8rM--G-u_XNMSfcTKBZO0Q_0g4kic';

  @override
  void initState() {
    super.initState();
    fetchTop3RankingData().then((_) {
      fetchRankingData(_currentPage);
    });
    token = widget.token;
  }

  Future<void> fetchTop3RankingData() async {
    final url =
        Uri.parse('http://localhost:8080/ranking/pontuacao?page=0&size=3');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept-Charset': 'UTF-8',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          top3RankingData = json.decode(utf8.decode(response.bodyBytes));
        });
      } else {
        throw Exception('Erro ao carregar dados do top 3 do ranking');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchRankingData(int page) async {
    String url =
        'http://localhost:8080/ranking/pontuacao?page=$page&size=$_pageSize';

    if (selectedRamo != null) {
      url += '&ramo=${Uri.encodeComponent(selectedRamo!)}';
    }
    if (selectedPorte != null) {
      url += '&porte=${Uri.encodeComponent(selectedPorte!)}';
    }

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept-Charset': 'UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        finishList = data[0]['finishList'];

        setState(() {
          if (data.isEmpty) {
            _hasMoreData = false;
          } else {
            rankingData = data
                .where((item) => !top3RankingData
                    .any((topItem) => topItem['id'] == item['id']))
                .toList();
            filteredRankingData = rankingData;
            _hasMoreData = true;
          }
        });
      } else {
        throw Exception('Erro ao carregar dados do ranking');
      }
    } catch (e) {
      print(e);
    }
  }

  void _nextPage() {
    if (_hasMoreData) {
      setState(() {
        _currentPage++;
      });
      fetchRankingData(_currentPage);
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
        _hasMoreData = true;
      });
      fetchRankingData(_currentPage);
    }
  }

  Future<void> _launchPDF(int empresaId) async {
    final url = Uri.parse('http://localhost:8080/pdf/getPdf/$empresaId');
    if (await canLaunch(url.toString())) {
      await launch(url.toString());
    } else {
      throw 'Não foi possível abrir o PDF';
    }
  }

  void _filterRankingData(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredRankingData = rankingData;
      } else {
        filteredRankingData = rankingData
            .where((item) => item['empresaNome']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: rankingData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    'RANKING',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                if (top3RankingData.isNotEmpty)
                  Top3RankingDisplay(
                    top3RankingData: top3RankingData,
                    onTap: _launchPDF,
                  ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 50,
                                  child: DropdownButtonFormField<String>(
                                    value: selectedRamo,
                                    hint: Text("Ramo"),
                                    isExpanded: true,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 12),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(10),
                                            bottom: Radius.circular(10)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(10),
                                            bottom: Radius.circular(10)),
                                        borderSide: BorderSide(
                                            color: Colors.blue, width: 2),
                                      ),
                                    ),
                                    items: [
                                      'Automotivo',
                                      'Indústria',
                                      'Educação',
                                      'Comércio',
                                      'Agricultura'
                                    ]
                                        .map((ramo) => DropdownMenuItem(
                                              child: Text(ramo),
                                              value: ramo,
                                            ))
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        if (selectedRamo == value) {
                                          selectedRamo = null;
                                        } else {
                                          selectedRamo = value;
                                        }
                                      });
                                      fetchRankingData(0);
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Container(
                                  height: 50,
                                  child: DropdownButtonFormField<String>(
                                    value: selectedPorte,
                                    hint: Text("Porte"),
                                    isExpanded: true,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 12),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(10),
                                            bottom: Radius.circular(10)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(10),
                                            bottom: Radius.circular(10)),
                                        borderSide: BorderSide(
                                            color: Colors.blue, width: 2),
                                      ),
                                    ),
                                    items: ['Pequeno', 'Médio', 'Grande']
                                        .map((porte) => DropdownMenuItem(
                                              child: Text(porte),
                                              value: porte,
                                            ))
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        if (selectedPorte == value) {
                                          selectedPorte = null;
                                        } else {
                                          selectedPorte = value;
                                        }
                                      });
                                      fetchRankingData(0);
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  height: 50,
                                  child: TextField(
                                    controller: searchController,
                                    decoration: InputDecoration(
                                      hintText: "Pesquisar",
                                      prefixIcon: Icon(Icons.search),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(10),
                                            bottom: Radius.circular(10)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(10),
                                            bottom: Radius.circular(10)),
                                        borderSide: BorderSide(
                                            color: Colors.blue, width: 2),
                                      ),
                                    ),
                                    onChanged: (text) {
                                      _filterRankingData(text);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: filteredRankingData.length,
                            itemBuilder: (context, index) {
                              final item = filteredRankingData[index];
                              return Container(
                                color: index % 2 == 0
                                    ? Colors.blue[50]
                                    : Colors.white,
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${item['ranking']}° - ${item['empresaNome'] ?? ''}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          item['ramo'] ?? '',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: const Color.fromARGB(
                                                  255, 107, 107, 107)),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '${item['pontuacaoFinal']} pontos',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.picture_as_pdf,
                                              color: Colors.red),
                                          onPressed: () =>
                                              _launchPDF(item['id']),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: _currentPage > 0
                              ? Colors.blue.shade50
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(4.0),
                          border: Border.all(
                              color:
                                  _currentPage > 0 ? Colors.blue : Colors.grey,
                              width: 2.0),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.arrow_back,
                              color:
                                  _currentPage > 0 ? Colors.blue : Colors.grey),
                          onPressed: _currentPage > 0 ? _previousPage : null,
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: finishList != true
                              ? Colors.blue.shade50
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(4.0),
                          border: Border.all(
                              color: finishList != true
                                  ? Colors.blue
                                  : Colors.grey,
                              width: 2.0),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.arrow_forward,
                              color: finishList != true
                                  ? Colors.blue
                                  : Colors.grey),
                          onPressed: finishList ? null : _nextPage,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

class Top3RankingDisplay extends StatelessWidget {
  final List top3RankingData;
  final Function(int) onTap;

  Top3RankingDisplay({required this.top3RankingData, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.center, 
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (top3RankingData.length > 1)
            GestureDetector(
              onTap: () => onTap(top3RankingData[1]['id']),
              child: Container(
                width: 130,
                height: 165,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color.fromARGB(255, 99, 99, 99), width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: RankingCard(top3RankingData[1],
                    const Color.fromARGB(255, 192, 192, 192), 2),
              ),
            ),
          if (top3RankingData.length > 1)
            SizedBox(width: 8), 
          if (top3RankingData.isNotEmpty)
            GestureDetector(
              onTap: () => onTap(top3RankingData[0]['id']),
              child: Container(
                width: 130,
                height: 205,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.amber, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: RankingCard(top3RankingData[0],
                    const Color.fromARGB(255, 255, 216, 98), 1),
              ),
            ),
          if (top3RankingData.length > 2)
            SizedBox(width: 8), 
          if (top3RankingData.length > 2)
            GestureDetector(
              onTap: () => onTap(top3RankingData[2]['id']),
              child: Container(
                width: 130,
                height: 140,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.orange, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: RankingCard(top3RankingData[2],
                    const Color.fromARGB(255, 255, 185, 80), 3),
              ),
            ),
        ],
      ),
    );
  }
}

class RankingCard extends StatelessWidget {
  final dynamic rankingData;
  final Color color;
  final int rank;

  RankingCard(this.rankingData, this.color, this.rank);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 150,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(blurRadius: 5, color: Colors.grey)],
      ),
      padding: EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            rankingData['empresaNome'] ?? '',
            style: TextStyle(fontSize: 14, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          Text(
            '$rank',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4),
          Text(
            '${rankingData['pontuacaoFinal']} pontos',
            style: TextStyle(fontSize: 14, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          Text(
            rankingData['ramo'] ?? '',
            style: TextStyle(fontSize: 14, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

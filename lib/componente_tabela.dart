import 'package:flutter/material.dart';
import 'delete_confirmation_dialog.dart';
import 'cadastro_perguntas.dart';
import 'main_screen.dart';

class TabelaGenerica extends StatefulWidget {
  final List<String> colunas;
  final List<Map<String, dynamic>> dados;
  final String tituloDoFormulario;
  final Function(int) onEdit;
  final Function(int) onDelete;
  final VoidCallback onPageBack;
  final VoidCallback onPageForward;
  final int indexTelaFormulario;
  final Function(String) onSearchIconTap;
  final bool isSelectable;
  final Function(int) onTap;
  final Function(List<int>)? createFormulario;
  final String? searchStringParameter;
  final int currentPage;
  final bool finishList;

  TabelaGenerica({
    required this.colunas,
    required this.dados,
    required this.tituloDoFormulario,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
    required this.onPageBack,
    required this.onPageForward,
    required this.indexTelaFormulario,
    required this.onSearchIconTap,
    required this.isSelectable,
    this.createFormulario,
    this.searchStringParameter,
    required this.currentPage,
    required this.finishList,
  });

  @override
  _TabelaGenericaState createState() => _TabelaGenericaState();
}

class _TabelaGenericaState extends State<TabelaGenerica> {
  final TextEditingController _searchController = TextEditingController();
  final List<int> selectedIds = [];

  @override
  void didUpdateWidget(covariant TabelaGenerica oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Verifica se 'colunas' mudou de valor
    if (widget.tituloDoFormulario != oldWidget.tituloDoFormulario) {
      _searchController.clear(); // Limpa o valor do controlador
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      child: Column(
        children: [
          // Título da tabela
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            alignment: Alignment.center,
            child: Text(
              widget.tituloDoFormulario,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            // decoration: BoxDecoration(
            //   boxShadow: [
            //   BoxShadow(
            //     color: Colors.grey.withOpacity(0.5),
            //     spreadRadius: 2,
            //     blurRadius: 5,
            //     offset: Offset(0, 3), // changes position of shadow
            //   ),
            //   ],
            // ),
          ),



          // Área de botão e pesquisa
          Container(
            alignment: Alignment.centerLeft,
            // color: Colors.grey.shade100,
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5), // Cor da sombra
                  spreadRadius: 2, // Espalhamento da sombra
                  blurRadius: 7, // Suavização da sombra
                  offset: Offset(0, -3), // Desloca a sombra para cima
                ),
              ],
            ),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    widget.onTap(widget.indexTelaFormulario);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 12.0),
                    child: Text(
                      'Novo registro',
                      style: TextStyle(fontSize: 14.0, color: Colors.white),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0077C8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                Spacer(),
                SizedBox(
                  width: 150,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon: GestureDetector(
                        onTap: () {
                          widget.onSearchIconTap(_searchController.text !=
                                  widget.searchStringParameter
                              ? _searchController.text
                              : widget.searchStringParameter ?? '');
                        },
                        child: Icon(Icons.search, color: Colors.grey, size: 20),
                      ),
                      hintText: 'Pesquisar',
                      contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Tabela de dados
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 8.0,
                      headingRowColor: MaterialStateColor.resolveWith(
                          (states) => Colors.grey.shade200),
                      dataRowHeight: 40.0,
                      columns: [
                        if (widget.isSelectable)
                          DataColumn(
                            label: ConstrainedBox(
                              constraints: BoxConstraints(
                                  minWidth: 100.0),
                              child: Text(
                                'Selecionar',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0),
                              ),
                            ),
                          ),
                        ...widget.colunas.map(
                          (coluna) => DataColumn(
                            label: ConstrainedBox(
                              constraints: BoxConstraints(
                                  minWidth:
                                      150.0), 
                              child: Text(
                                coluna,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0),
                              ),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: ConstrainedBox(
                            constraints: BoxConstraints(
                                minWidth:
                                    100.0), 
                            child: Center(
                              child: Text(
                                'Ações',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                      rows: List<DataRow>.generate(
                        widget.dados.length,
                        (index) {
                          final linha = widget.dados[index];
                          final corDeFundo =
                              index.isEven ? Colors.white : Colors.blue.shade50;

                          return DataRow(
                            color: MaterialStateColor.resolveWith(
                                (states) => corDeFundo),
                            cells: [
                              if (widget.isSelectable)
                                DataCell(
                                  Checkbox(
                                    value: selectedIds.contains(linha['id']),
                                    onChanged: (bool? value) {
                                      setState(() {
                                        if (value == true) {
                                          selectedIds.add(linha['id']);
                                        } else {
                                          selectedIds.remove(linha['id']);
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ...widget.colunas
                                  .map((coluna) => DataCell(
                                        Text(
                                          linha[coluna]?.toString() ?? '',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ))
                                  .toList(),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      icon:
                                          Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () =>
                                          widget.onEdit(linha['id']),
                                    ),
                                    IconButton(
                                      icon:
                                          Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        showDeleteConfirmation(
                                          context,
                                          linha[widget.colunas[0]] ?? 'Item',
                                          () {
                                            widget.onDelete(linha['id']);
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Botões de paginação
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16.0, vertical: 8.0), 
            child: Row(
              children: [
                if (widget.isSelectable)
                  ElevatedButton(
                    onPressed: () {
                      widget.createFormulario!(selectedIds);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0077C8),
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'Criar Formulário',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: widget.currentPage > 0
                        ? Colors.blue.shade50
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4.0),
                    border: Border.all(
                        color:
                            widget.currentPage > 0 ? Colors.blue : Colors.grey,
                        width: 2.0),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: widget.currentPage > 0 ? Colors.blue : Colors.grey,
                    ),
                    onPressed: widget.onPageBack,
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: widget.finishList != true
                        ? Colors.blue.shade50
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4.0),
                    border: Border.all(
                        color: widget.finishList != true
                            ? Colors.blue
                            : Colors.grey,
                        width: 2.0),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.arrow_forward,
                        color: widget.finishList != true
                            ? Colors.blue
                            : Colors.grey),
                    onPressed: widget.onPageForward,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

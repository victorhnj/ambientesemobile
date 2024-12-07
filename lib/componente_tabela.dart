import 'package:flutter/material.dart';
import 'delete_confirmation_dialog.dart';

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
  int itemsToShow = 20;

  @override
  void didUpdateWidget(covariant TabelaGenerica oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Reseta a quantidade de itens quando trocar de tela
    if (widget.indexTelaFormulario != oldWidget.indexTelaFormulario) {
      setState(() {
        itemsToShow = 20; // Resetando a quantidade de itens ao trocar de tela
      });
    }

    if (widget.tituloDoFormulario != oldWidget.tituloDoFormulario) {
      _searchController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
return Scaffold(
floatingActionButton: selectedIds.isNotEmpty // Verifica se alguma checkbox foi marcada
    ? FloatingActionButton.extended(
        onPressed: () {
          // Ação do botão flutuante
          widget.createFormulario?.call(selectedIds);
        },
        backgroundColor: Color(0xFF0077C8),
        icon: Icon(Icons.add, color: Colors.white),
        label: Text(
          "Criar Formulário",
          style: TextStyle(color: Colors.white),
        ),
      )
    : null,
floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
  body: Container(
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
          ),
          // Área de botão e pesquisa
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: Offset(1, 1),
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
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
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
                          widget.onSearchIconTap(_searchController.text != widget.searchStringParameter
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
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Exibição dos dados como Cards
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                itemCount: itemsToShow < widget.dados.length
                    ? itemsToShow + 1 // Adiciona o botão de "Carregar mais"
                    : widget.dados.length,
                itemBuilder: (context, index) {
                  if (index == itemsToShow) {
                    // Botão para carregar mais itens
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (itemsToShow + 20 <= widget.dados.length) {
                            itemsToShow += 20;
                          } else {
                            itemsToShow = widget.dados.length;
                          }
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if (itemsToShow + 20 <= widget.dados.length) {
                                  itemsToShow += 20;
                                } else {
                                  itemsToShow = widget.dados.length;
                                }
                              });
                            },
                            child: Text('Carregar mais', style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF0077C8),
                              shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  final linha = widget.dados[index];
                  final corDeFundo = index.isEven ? Colors.white : Colors.blue.shade50;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      side: BorderSide(
                        color: corDeFundo == Colors.white
                            ? Colors.blue.shade700
                            : Colors.blue.shade700,
                        width: 1.0,
                      ),
                    ),
                    color: corDeFundo,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Exibição dos dados
                          for (var coluna in widget.colunas)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "$coluna: ",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          linha[coluna]?.toString() ?? '',
                                          overflow: TextOverflow.visible,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 8),
                          // Botões de ação
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (widget.isSelectable)
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
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => widget.onEdit(linha['id']),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
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
                        ],
                      ),
                    ),
                  );
                  
                },
              ),
            ),
          ),
        ],
      ),
    ),
  );
  }
}
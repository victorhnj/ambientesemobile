import 'package:flutter/material.dart';
import 'delete_confirmation_dialog.dart';
import 'cadastro_perguntas.dart';
import 'main_screen.dart';

class TabelaGenerica extends StatelessWidget {
  final List<String> colunas;
  final List<Map<String, dynamic>> dados;
  final String tituloDoFormulario;
  final Function(int) onEdit;
  final Function(int) onDelete;
  final VoidCallback onPageBack;
  final VoidCallback onPageForward;
  final int indexTelaFormulario;

  final Function(int) onTap;

  TabelaGenerica({
    required this.colunas,
    required this.dados,
    required this.tituloDoFormulario,
    required this.onEdit,
    required this.onDelete,
    required this.onTap, 
    required this.onPageBack, 
    required this.onPageForward,
    required this.indexTelaFormulario
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100, // Fundo acinzentado ao redor da tabela
      child: Column(
        children: [
          // Título da tabela
          Container(
            color: Colors.white, // Fundo branco
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                tituloDoFormulario,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Shadow effect above divider
          Container(
            height: 4, // Adjust the height of the shadow effect as needed
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5), // Grey shadow with opacity
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: Offset(0, -2), // Shadow positioned above
                ),
              ],
            ),
          ),

          // Área de botão e pesquisa
          Container(
            alignment: Alignment.centerLeft, // Align content to the left
            color: Colors.grey.shade100,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Adjust padding to align with the table
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    onTap(indexTelaFormulario);
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
                Spacer(), // Pushes the search bar to the far right
                SizedBox(
                  width: 150, // Set a fixed width for the TextField
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20),
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

          // Container com borda para a tabela
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0), // Padding on the sides
              child: Container(
                width: double.infinity, // Makes the table container occupy full width
                decoration: BoxDecoration(
                  color: Colors.white, // White background for the table
                  border: Border.all(color: Colors.grey), // Outer border
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical, // Enables horizontal scrolling for many columns
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal, // Enables horizontal scrolling for many columns
                      child: DataTable(
                        columnSpacing: 8.0, // Space between columns
                        headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey.shade200),
                        dataRowHeight: 40.0, // Row height
                        columns: [
                          ...colunas.map(
                            (coluna) => DataColumn(
                              label: Text(
                                coluna,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0), // Smaller font for headers
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Ações',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
                            ),
                          ),
                        ],
                        rows: List<DataRow>.generate(
                          dados.length,
                          (index) {
                            final linha = dados[index];
                            final corDeFundo = index.isEven ? Colors.white : Colors.blue.shade50;

                            return DataRow(
                              color: MaterialStateColor.resolveWith((states) => corDeFundo),
                              cells: [
                                ...colunas.map((coluna) => DataCell(
                                  Text(
                                    linha[coluna]?.toString() ?? '', // Safely access the data by key
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )).toList(),
                                DataCell(
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit, color: Colors.blue),
                                        onPressed: () => onEdit(linha['id']), // Passes ID to edit
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete, color: Colors.red),
                                        onPressed: () {
                                          showDeleteConfirmation(
                                            context,
                                            linha[colunas[0]] ?? 'Item', // Show the name or fallback identifier
                                            () {
                                              onDelete(linha['id']); // Passes ID to delete
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
                  )
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200, // Fundo para o botão desativado
                    borderRadius: BorderRadius.circular(4.0), // Borda quadrada com leve arredondamento
                    border: Border.all(
                      color: Colors.grey,
                      width: 2.0,
                    ), // Cor da borda para o botão desativado
                  ),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.grey), // Cor do ícone desativado
                    onPressed: onPageBack,
                  ),
                ),
                SizedBox(width: 8), // Espaçamento entre os botões
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50, // Fundo para o botão ativo
                    borderRadius: BorderRadius.circular(4.0), // Borda quadrada com leve arredondamento
                    border: Border.all(color: Colors.blue, width: 2.0), // Cor da borda para o botão ativo
                  ),
                  child: IconButton(
                    icon: Icon(Icons.arrow_forward, color: Colors.blue), // Cor do ícone ativo
                    onPressed: onPageForward,
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
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //variavel que recebe o valor digitado
  final valor = TextEditingController();
  final isValidade = GlobalKey<FormState>();
  // bool _isChecked = false;
  String novoItem = '';
  List<bool> checkboxStates = [];
  List compras = [];

//funções
  // void addItem(value, _isChecked) => {
  //       compras.add({
  //         "name": value,
  //         "isBought": _isChecked,
  //       })
  //     };

  void removeItem(value) => {
        setState(() {
          compras.removeAt(value);
        })
      };

  void addItem(value) {
    setState(() {
      compras.add({"name": value, "isBought": false});
      checkboxStates.add(false); // Adiciona o estado do checkbox
      valor.clear(); // Limpa o que foi digitado
    });
  }

  void editItem(int index, String name){
    setState(() {
    compras.setAll(index, [
      {
        "name": name
      }
    ]);   
    });
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lista de Compras',
          style: GoogleFonts.roboto(),
        ),
      ),
      body:
          //compras.map((e) => Text(e)).toList(), outro jeito de imprimir a lista na tela
          Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Form(
                  key: isValidade,
                  child: TextFormField(
                    //controla oq o  usuario vai digitar no campo de texto
                    controller: valor,
                    onFieldSubmitted: (value) {
                      addItem(value);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'nao pode';
                      }
                    },
                    decoration: const InputDecoration(
                        hintText: 'Digite um item',
                        border: OutlineInputBorder()),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 30,
                  margin: const EdgeInsets.all(8),
                  child: ElevatedButton(
                    onPressed: () {
                      if (isValidade.currentState!.validate()) {
                        setState(() {
                          addItem(valor.text);
                          valor.clear(); //limpa o que foi digitado para
                        });
                      }
                    },
                    child: const Text('Adicionar Item'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: compras.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Text(
                            compras[index]['name'],
                            style: checkboxStates[index]
                                ? const TextStyle(
                                    decoration: TextDecoration.lineThrough)
                                : null,
                          ),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Edição de item'),
                                content: TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Novo item',
                                  ),
                                  onChanged: (value) {
                                    novoItem = value; // Atualiza o novo item quando o texto é alterado
                                   
                                  },
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      editItem(index, novoItem);
                                      Navigator.of(context).pop(); // Fecha o diálogo
                                    },
                                    child: Text('Salvar'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Fecha o diálogo sem salvar
                                    },
                                    child: Text('Cancelar'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      const Spacer(),
                      // Checkbox(
                      //     value: _isChecked,
                      //     onChanged: (bool? newValue) {
                      //       setState(() {
                      //         _isChecked = newValue!;
                      //       });
                      //     }),
                      Checkbox(
                          value: checkboxStates[index], // Usa o estado correto
                          onChanged: (bool? newValue) {
                            setState(() {
                              checkboxStates[index] =
                                  newValue!; // Atualiza o estado do checkbox
                            });
                          }),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.delete_outlined),
                        onPressed: () {
                          removeItem(index);
                        },
                      )
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
import 'package:farmacio_app/controller/adressController.dart';
import 'package:farmacio_app/helper/databaseHelper.dart';
import 'package:farmacio_app/models/adressModel.dart';
import 'package:flutter/material.dart';

class EnderecosScreen extends StatefulWidget {
  final int userId;

  const EnderecosScreen({super.key, required this.userId});

  @override
  _EnderecosScreenState createState() => _EnderecosScreenState();
}

class _EnderecosScreenState extends State<EnderecosScreen> {
  late Future<List<Address>> futureEnderecos;

  @override
  void initState() {
    super.initState();
    futureEnderecos = Adresscontroller().getAddressesByUserId(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text(
          'Meus dados',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<List<Address>>(
        future: futureEnderecos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                Text(
                  'Endereços',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Text('Nenhum endereço cadastrado.'),
                SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () async {
                    try {
                      print("🛠️ Navegando para a tela de edição de endereço...");
                      final result = await Navigator.pushNamed(
                        context,
                        '/edit_enderecos',
                        arguments: {
                          'isEditing': false,
                          'userId': widget.userId, 
                        },
                      );

                      print("🔄 Voltou da tela de edição de endereço. Recarregando endereços...");

                      if (result == true) {
                        setState(() {
                          futureEnderecos = Adresscontroller().getAddressesByUserId(widget.userId);
                        });
                      }
                    } catch (e) {
                      print("❌ Erro ao adicionar endereço: $e");
                    }
                  },
                  icon: Icon(Icons.add),
                  label: Text('Adicionar endereço'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.blue),
                    padding: EdgeInsets.all(16),
                  ),
                ),
              ],
            );
          }

          final enderecos = snapshot.data!;
          return ListView(
            padding: EdgeInsets.all(16.0),
            children: [
              Text(
                'Endereços',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              for (var endereco in enderecos)
                _buildEnderecoCard(
                context,
                endereco: '${endereco.street}, ${endereco.number}, ${endereco.city} - ${endereco.state}',
                detalhes: 'CEP ${endereco.zipCode}${(endereco.complement?.isNotEmpty ?? false) ? ' - ${endereco.complement}' : ''}', 
                horario: (endereco.horario?.isNotEmpty ?? false) ? '⏰ ${endereco.horario}' : '', 
                observacao: (endereco.observacao?.isNotEmpty ?? false) ? '📝 ${endereco.observacao}' : '', 
                addressId: endereco.id!, 
                isPrimary: endereco.isPrimary == 1,
              ),
              SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () async {
                  // Navega para adicionar endereço
                  await Navigator.pushNamed(context, '/edit_enderecos',
                      arguments: {'isEditing': false, 'userId': widget.userId});
                  // Ao voltar, recarrega a lista
                  setState(() {
                    futureEnderecos = Adresscontroller().getAddressesByUserId(widget.userId);
                  });
                },
                icon: Icon(Icons.add),
                label: Text('Adicionar endereço'),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.blue),
                  padding: EdgeInsets.all(16),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEnderecoCard(BuildContext context,
    {required String endereco, required String detalhes, String horario = '', String observacao = '', required int addressId, required bool isPrimary}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.home, color: isPrimary ? Colors.green : Colors.grey),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    endereco, 
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) async {
                    if (value == 'Editar') {
                      await Navigator.pushNamed(
                        context,
                        '/edit_enderecos',
                        arguments: {
                          'isEditing': true,
                          'addressId': addressId,
                          'userId': widget.userId
                        },
                      );
                      setState(() {
                        futureEnderecos = Adresscontroller().getAddressesByUserId(widget.userId);
                      });
                    } else if (value == 'Remover') {
                      _removerEndereco(context, addressId);
                    } else if (value == 'Definir como Principal') {
                      await Adresscontroller().setPrimaryAddress(addressId, widget.userId);
                      setState(() {
                        futureEnderecos = Adresscontroller().getAddressesByUserId(widget.userId);
                      });
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return ['Editar', 'Remover','Definir como Principal'].map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              detalhes, 
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
            TextButton(
              onPressed: () {
                print("🛠️ Abrindo popup para adicionar horário...");
                _mostrarPopupAdicionarHorario(addressId);
              },
              child: Text(
                'Adicionar dados e horários do lugar',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            if (horario.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(horario, style: TextStyle(color: Colors.blue, fontSize: 14)),
              ),
            if (observacao.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(observacao, style: TextStyle(color: Colors.grey, fontSize: 14)),
              ),
          ],
        ),
      ),
    );
  }

  void _removerEndereco(BuildContext context, int addressId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remover endereço'),
          content: Text('Você tem certeza que deseja remover este endereço?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                // Lógica para remover endereço do banco
                await Adresscontroller().deleteAddress(addressId);
                Navigator.of(context).pop();
                setState(() {
                  futureEnderecos = Adresscontroller().getAddressesByUserId(widget.userId);
                });
              },
              child: Text(
                'Remover',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _salvarHorarioObservacao(int addressId, String horario, String observacao) async {
    try {
      final db = await DatabaseHelper.instance.database;

      // 🔹 Recupera os dados completos do endereço antes de atualizar
      final List<Map<String, dynamic>> result = await db.query(
        'addresses',
        where: 'id = ?',
        whereArgs: [addressId],
      );

      if (result.isEmpty) {
        print("❌ Erro: Endereço não encontrado no banco.");
        return;
      }

      final enderecoAtual = Address.fromMap(result.first); // 🔹 Mantém os dados originais

      final address = Address(
        id: addressId,
        userId: enderecoAtual.userId, // 🔹 Mantém userId correto
        street: enderecoAtual.street,
        number: enderecoAtual.number,
        complement: enderecoAtual.complement,
        city: enderecoAtual.city,
        state: enderecoAtual.state,
        zipCode: enderecoAtual.zipCode,
        bairro: enderecoAtual.bairro,
        telefone: enderecoAtual.telefone,
        horario: horario, // 🔹 Atualiza apenas horário
        observacao: observacao, // 🔹 Atualiza apenas observação
      );

      await Adresscontroller().updateAddress(address);
      print("✅ Horário e observação atualizados para o endereço ID: $addressId");

      // 🔹 Atualiza a tela para exibir os novos dados sem apagar o endereço
      setState(() {
        futureEnderecos = Adresscontroller().getAddressesByUserId(widget.userId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Dados adicionados com sucesso!")),
      );
    } catch (e) {
      print("❌ Erro ao atualizar horário e observação: $e");
    }
  }
  
  void _mostrarPopupAdicionarHorario(int addressId) {
    TimeOfDay? horarioAbertura;
    TimeOfDay? horarioFechamento;
    TextEditingController observacaoController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) { // 🔹 Permite atualizar dinamicamente o popup
            return AlertDialog(
              title: Text("Adicionar Horário e Observação"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Icon(Icons.access_time),
                    title: Text(horarioAbertura == null
                        ? "Selecionar horário de abertura"
                        : "Abertura: ${horarioAbertura!.format(context)}"),
                    onTap: () async {
                      TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (picked != null) {
                        setDialogState(() {
                          horarioAbertura = picked;
                        });
                      }
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.access_time),
                    title: Text(horarioFechamento == null
                        ? "Selecionar horário de fechamento"
                        : "Fechamento: ${horarioFechamento!.format(context)}"),
                    onTap: () async {
                      TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (picked != null) {
                        setDialogState(() {
                          horarioFechamento = picked;
                        });
                      }
                    },
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: observacaoController,
                    decoration: InputDecoration(
                      labelText: "Observação",
                      hintText: "Ex: Entregas até 17h",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancelar"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (horarioAbertura == null || horarioFechamento == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Selecione ambos os horários!")),
                      );
                      return;
                    }

                    String horario = "${horarioAbertura!.format(context)} - ${horarioFechamento!.format(context)}";

                    print("📌 Salvando horário: $horario");
                    print("📌 Salvando observação: ${observacaoController.text}");

                    _salvarHorarioObservacao(addressId, horario, observacaoController.text.trim());

                    Navigator.of(context).pop();
                  },
                  child: Text("Salvar"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
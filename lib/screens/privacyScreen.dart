import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({super.key});

  @override
  _TermsScreenState createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  bool _isAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Termos de Uso e Política de Privacidade'),
        backgroundColor: Colors.yellow[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Termos de Uso e Política de Privacidade",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "1. Introdução\n"
                      "Ao utilizar o aplicativo, você concorda com os termos estabelecidos abaixo. Caso não concorde, recomendamos que não utilize a plataforma.\n\n"
                      
                      "2. Aceitação dos Termos\n"
                      "O uso contínuo do aplicativo implica aceitação automática das atualizações destes Termos de Uso e Política de Privacidade.\n\n"

                      "3. Uso da Plataforma\n"
                      "O aplicativo serve como intermediador de compras e vendas. Não nos responsabilizamos por qualidade, entrega ou segurança dos produtos vendidos.\n\n"
                      
                      "4. Cadastro e Privacidade\n"
                      "Armazenamos informações como nome, e-mail, telefone e endereço. Suas informações são protegidas, mas não podemos garantir que não sofreremos ataques cibernéticos.\n\n"

                      "5. Compras e Pagamentos\n"
                      "Todas as transações são intermediadas por serviços de terceiros. Não nos responsabilizamos por fraudes ou problemas com pagamentos.\n\n"

                      "6. Limitação de Responsabilidade\n"
                      "O aplicativo é fornecido 'como está', sem garantias de funcionamento contínuo. Não nos responsabilizamos por perdas financeiras ou morais.\n\n"

                      "7. Alterações nos Termos\n"
                      "Nos reservamos o direito de modificar estes Termos e a Política de Privacidade a qualquer momento. O usuário será notificado sobre mudanças relevantes.\n\n"

                      "8. Contato e Suporte\n"
                      "Caso tenha dúvidas, entre em contato pelo e-mail: suporte@empoderaecommerce.com\n",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Checkbox(
                  value: _isAccepted,
                  onChanged: (bool? value) {
                    setState(() {
                      _isAccepted = value!;
                    });
                  },
                ),
                const Expanded(
                  child: Text("Eu li e aceito os Termos de Uso e a Política de Privacidade."),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _isAccepted
                  ? () {
                      Get.offAllNamed('/home'); 
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow[700],
                disabledBackgroundColor: Colors.grey,
              ),
              child: const Text(
                "Aceitar e Continuar",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Address {
  final int? id;
  final int? userId;
  final String street;
  final String number;
  final String city;
  final String state;
  final String zipCode;
  final String bairro;       
  final String telefone;      
  final String? complement;
  final String? horario; 
  final String? observacao; 
  final int? isPrimary;

  Address({
    this.id,
    required this.userId,
    required this.street,
    required this.number,
    required this.city,
    required this.state,
    required this.zipCode,
    this.bairro = '',
    this.telefone = '',
    this.complement = '',
    this.horario = '', 
    this.observacao = '', 
    this.isPrimary
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'street': street,
      'number': number,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'bairro': bairro,
      'telefone': telefone,
      'complement': complement,
      'horario': horario, 
      'observacao': observacao,
      'isPrimary': isPrimary,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      id: map['id'] is int ? map['id'] : int.tryParse(map['id'].toString()) ?? 0,
      userId: map['userId'] is int ? map['userId'] : int.tryParse(map['userId'].toString()) ?? 0, 
      street: map['street'] ?? '',
      number: map['number'] ?? '',
      complement: map['complement'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      zipCode: map['zipCode'] ?? '',
      bairro: map['bairro'] ?? '',
      telefone: map['telefone'] ?? '',
      horario: map['horario'] ?? '',
      observacao: map['observacao'] ?? '', 
      isPrimary: map['isPrimary'] ?? 0,
    );
  }
}

class carModels {
  final String Make;
  final String Model;

  carModels({
    this.Make,
    this.Model,
  });

  List<String> getBodyTypes() {
    List<String> BodyTypes = <String>[];
    BodyTypes = [
      'Body Type',
      'HatchBack',
      'Coupe',
      'Convertible',
      'SUV',
      'Saloon',
    ];
    return BodyTypes;
  }

  List<String> getModels(String make) {
    List<String> ModelList = <String>[];
    if (make.contains('MERCEDES-BENZ')) {
      ModelList = [
        'Model',
        'A-class',
        'B-class',
        'C-class',
        'CLA',
        'E-class',
        'G-class',
        'GLA',
        'GLB',
        'GLC',
        'GLE',
        'GLS',
        'S-class',
        'CLS',
        'SL',
        'Maybach-S-Class',
        'EQA',
        'EQB',
        'EQE',
        'EQS',
      ];
    } else if (make.contains('AUDI')) {
      ModelList = [
        'Model',
        'A1',
        'A3',
        'A4',
        'A5',
        'A6',
        'A7',
        'A8',
        'Q2',
        'Q3',
        'Q4-etron',
        'Q5',
        'Q7',
        'Q8',
        'TT',
        'R8',
        'e-tron GT',
        'e-tron',
      ];
    } else if (make.contains('BMW')) {}
    return ModelList;
  }
}

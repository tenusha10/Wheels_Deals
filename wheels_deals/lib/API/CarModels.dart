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

//need to make all model names uppercase
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
    } else if (make.contains('BMW')) {
      ModelList = [
        'Model',
        '1 Series',
        '2 Series',
        '3 Series',
        '4 Series',
        '5 Series',
        '7 Series',
        '8 Series',
        'X1',
        'X2',
        'X3',
        'X4',
        'X5',
        'X6',
        'X7',
        'iX',
        'Z4'
      ];
    } else if (make.contains('FORD')) {
      ModelList = [
        'Model',
        'Ecosport',
        'Puma',
        'Focus',
        'Fiesta',
        'Kuga',
        'Mustang',
        'Mondeo',
        'Mustang Mach-E',
        'Mustang',
        'S-Max',
        'Galaxy',
      ];
    } else if (make.contains('VOLKSWAGEN')) {
      ModelList = [
        'Model',
        'Arteon',
        'Beetle',
        'Eos',
        'Up!',
        'Golf',
        'ID.3',
        'ID.4',
        'Jetta',
        'Passat',
        'Polo',
        'Scirocco',
        'Sharan',
        'Tiguan',
        'Touran',
        'Touareg',
        'T-cross',
        'T-Roc'
      ];
    } else if (make.contains('TOYATA')) {
      ModelList = [
        'Model',
        'Aygo',
        'Yaris',
        'Corolla',
        'Hilux',
        'Rav4',
        'Prius',
        'Land Cruiser',
        'Supra',
        'Highlander',
        'Mirai'
      ];
    } else if (make.contains('TESLA')) {
      ModelList = ['Model', 'Model 3', 'Model S', 'Model X', 'Model Y'];
    } else if (make.contains('VOLVO')) {
      ModelList = ['Model', 'XC40', 'XC60', 'XC90', 'S60', 'S90', 'V60', 'V90'];
    } else if (make.contains('SUBARU')) {
      ModelList = [
        'XV',
        'Impreza',
        'Forester',
        'BRZ',
        'Levog',
        'Outback',
        'WRX'
      ];
    } else if (make.contains('SEAT')) {
      ModelList = ['Ibiza', 'Leon', 'Ateca', 'Arona', 'Tarraco', 'Mii'];
    } else if (make.contains('SKODA')) {
      ModelList = [
        'Model',
        'Kamiq',
        'Scala',
        'Fabia',
        'Octavia',
        'Superb',
        'Karoq',
        'Enyaq',
        'Citigo'
      ];
    } else if (make.toLowerCase() == 'cupra') {
      ModelList = ['Model', 'Formentor', 'Ateca', 'Leon'];
    } else if (make.contains('SMART')) {
      ModelList = ['Model', 'Smart Eq'];
    } else if (make.contains('RENAULT')) {
      ModelList = [
        'Model',
        'Clio',
        'Captur',
        'ZOE',
        'Kadjar',
        'Koleos',
        'Megane'
      ];
    } else if (make.contains('PORSCHE')) {
      ModelList = [
        'Model',
        '718',
        '911',
        'Taycan',
        'Panamera',
        'Macan',
        'Cayenne'
      ];
    } else if (make.toLowerCase() == ('Vauxhall')) {
      ModelList = [
        'Model',
        'Corsa',
        'Mokka',
        'Astra',
        'Combo',
        'CrossLand',
        'Vivaro',
        'Insignia'
      ];
    } else if (make.toLowerCase() == ('nissan').toLowerCase()) {
      ModelList = ['Model', 'Leaf', 'Ariya', 'Micra', 'Juke', 'Qashqai', 'GTR'];
    } else if (make.toLowerCase() == ('Mini')) {
      ModelList = [
        'Model',
        '3 Door Hatch',
        '5 Door Hatch',
        'Clubman',
        'CountryMan'
      ];
    } else if (make.toLowerCase() == ('Mitsubishi')) {
      ModelList = ['Model', 'Outlander', 'ASX', 'Mirage', 'Shogun', 'Eclipse'];
    } else if (make.toLowerCase() == ('Mazda')) {
      ModelList = [
        'Model',
        'CX-5',
        'Mazda 3',
        'Mazda 6',
        'MX-5',
        'CX-30',
        'Mazda 2',
        'MX-30',
        'MX-5'
      ];
    } else if (make.toLowerCase() == ('Maserati')) {
      ModelList = ['Quattroporte', 'Levante', 'GT', 'GranCabrio'];
    } else if (make.toLowerCase() == ('Lotus')) {
      ModelList = ['Elise', 'Exige', 'Evora'];
    } else if (make.toLowerCase() == ('Lexus')) {
      ModelList = ['UX', 'NX', 'ES', 'RX', 'RC', 'LC', 'LS', 'LFA'];
    } else if (make.toLowerCase() == ('Land Rover')) {
      ModelList = [
        'Range Rover',
        'Defender',
        'Discovery',
        'Discovery Sport',
        'Range Rover Evoque',
        'Range Rover Sport',
        'Range Rover Velar'
      ];
    } else if (make.toLowerCase() == ('Lamborghini')) {
    } else if (make.toLowerCase() == ('Kia')) {
    } else if (make.toLowerCase() == ('Jeep')) {
    } else if (make.toLowerCase() == ('Jaguar')) {
    } else if (make.toLowerCase() == ('Isuzu')) {
    } else if (make.contains('Infinity')) {
    } else if (make.contains('Hyundai')) {
    } else if (make.contains('Honda')) {
    } else if (make.contains('Fiat')) {
    } else if (make.contains('Ferrari')) {
    } else if (make.contains('Dacia')) {
    } else if (make.toLowerCase() == ('CITROEN')) {
      ModelList = [
        'Model',
        'C1',
        'C3',
        'C4',
        'C5',
        'DS3',
        'DS7',
      ];
    } else if (make.contains('Chevrolet')) {
    } else if (make.contains('Chrysler')) {
    } else if (make.contains('Bentley')) {
    } else if (make.contains('Aston Martin')) {
    } else if (make.contains('Alfa Romeo')) {
    } else if (make.contains('Abarth')) {}
    return ModelList;
  }
}

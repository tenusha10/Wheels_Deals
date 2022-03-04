class DVLACar {
  final String registrationNumber;
  final int co2Emissions, revenueWeight, yearOfManufacture;
  final int engineCapacity;
  final String euroStatus;
  final bool markedForExport;
  final String fuelType;
  final String make,
      taxDueDate,
      taxStatus,
      motStatus,
      monthOfFirstRegistration,
      colour,
      artEndDate,
      typeApproval,
      wheeelplan,
      realDrivingEmissions,
      dateOfLastV5CIssued;

  DVLACar(
      {this.registrationNumber,
      this.co2Emissions,
      this.engineCapacity,
      this.euroStatus,
      this.markedForExport,
      this.fuelType,
      this.make,
      this.colour,
      this.monthOfFirstRegistration,
      this.motStatus,
      this.taxDueDate,
      this.taxStatus,
      this.artEndDate,
      this.dateOfLastV5CIssued,
      this.realDrivingEmissions,
      this.revenueWeight,
      this.typeApproval,
      this.wheeelplan,
      this.yearOfManufacture});

  factory DVLACar.fromJson(Map<String, dynamic> json) {
    return DVLACar(
      registrationNumber: json['registrationNumber'],
      make: json['make'],
      co2Emissions: json['co2Emissions'],
      engineCapacity: json['engineCapacity'],
      euroStatus: json['euroStatus'],
      markedForExport: json['markedForExport'],
      fuelType: json['fuelType'],
      taxDueDate: json['taxDueDate'],
      taxStatus: json['taxStatus'],
      motStatus: json['motStatus'],
      monthOfFirstRegistration: json['monthOfFirstRegistration'],
      colour: json['colour'],
      artEndDate: json['artEndDate'],
      revenueWeight: json['revenueWeight'],
      typeApproval: json['typeApproval'],
      dateOfLastV5CIssued: json['dateOfLastV5CIssued'],
      realDrivingEmissions: json['realDrivingEmissions'],
      wheeelplan: json['wheeelplan'],
      yearOfManufacture: json['yearOfManufacture'],
    );
  }

  /*DVLACar.fromJson(Map<String, dynamic> json)
      : registrationNumber = json['registrationNumber'],
        co2Emissions = json['co2Emissions'],
        engineCapacity = json['engineCapacity'],
        euroStatus = json['euroStatus'],
        markedForExport = json['markedForExport'],
        fuelType = json['fuelType']; */
}

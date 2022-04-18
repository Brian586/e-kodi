class Service {
  final String? name;
  final String? description;
  final String? icon;

  Service({this.name, this.description, this.icon});
}

List<Service> services = [
  Service(
    name: "Dashboards & Reporting",
    icon: "assets/images/service_icon_01.png",
    description: "Customize your dashboards to track all the key performance indicators,  manage income and maintenance costs of your properties through key metrics. Know where your business stands at all times by aggregating your accounts into a single master statement. Our software flags any discrepancies, minimising the risk of errors and fraud.",
  ),
  Service(
    name: "Centralised Data",
    icon: "assets/images/service_icon_02.png",
    description: "Harmonize all your customer and property data into one location for quick generation of receipts, accessible in real time in and out of your office.",
  ),
  Service(
    name: "Free Rent Collection",
    icon: "assets/images/service_icon_04.png",
    description: "Automate your rent collection process with no additional transaction cost.",
  ),
  Service(
    name: "Analytics",
    icon: "assets/images/service_icon_03.png",
    description: "Remove the guess work, tiresome excel sheets and risk involved in poor record keeping. Our sophisticated software analyzes all your property records including but not limited to revenue, repair cost, and rent areas to give performance insight to your financial data.",
  ),
];
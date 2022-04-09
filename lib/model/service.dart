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
    description: "We offer fully customizable dashboards to track all the key performance indicators, manage income and maintenance costs for your properties through key metrics",
  ),
  Service(
    name: "Centralised Data",
    icon: "assets/images/service_icon_02.png",
    description: "We bring together all of your customer and property data into one location for a quick generation of receipts, accessible in real-time in the office or out.",
  ),
  Service(
    name: "Analytics",
    icon: "assets/images/service_icon_03.png",
    description: "We help you track your balance sheet figures like revenue, repair costs, and rent arrears to view performance insights of your financial data",
  ),
  Service(
    name: "Free online tenant payment",
    icon: "assets/images/service_icon_04.png",
    description: "We automate your rent collection process with with ZERO transaction cost, secure online rent payments for your tenants",
  )
];
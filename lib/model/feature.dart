
class Feature {
  final String? icon;
  final String? title;
  final String? description;

  Feature({this.icon, this.title, this.description});
}

List<Feature> features = [
  Feature(
    icon: "assets/images/re.jpeg",
    title: "Rent collection and receipt management",
    description: "Allow clients to pay rent from their mobile phones and generate electronic invoices"
  ),
  Feature(
      icon: "assets/images/sms.jpeg",
      title: "SMS alert services",
      description: "Send alerts via SMS to clients from the comfort of your office"
  ),
  Feature(
      icon: "assets/images/ts2.jpeg",
      title: "Tenant screening",
      description: "Discover the security of knowing the history of each tenant before placing into your property"
  ),
  Feature(
      icon: "assets/images/file1.jpeg",
      title: "Online File Management",
      description: "Securely store and share important files such as lease agreements with your renters"
  ),
];
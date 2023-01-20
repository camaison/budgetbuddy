class GetGreeting {
  String getGreeting() {
    String timeOfDay = '';
    if (DateTime.now().hour < 12) {
      timeOfDay = 'Good Morning,';
    } else if (DateTime.now().hour < 17) {
      timeOfDay = 'Good Afternoon,';
    } else {
      timeOfDay = 'Good Evening,';
    }
    return timeOfDay;
  }
}

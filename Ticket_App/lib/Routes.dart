import 'package:flutter/material.dart';
import 'package:tickets_app/Screens/customer_detail_screen.dart';
import 'package:tickets_app/Screens/customer_screen.dart';
import 'package:tickets_app/Screens/home_screen.dart';
import 'package:tickets_app/Screens/map_screen.dart';
import 'package:tickets_app/Screens/new_customer_screen.dart';
import 'package:tickets_app/Screens/new_ticket_screen.dart';
import 'package:tickets_app/Screens/ticket_detail_screen.dart';
import 'package:tickets_app/Screens/tickets_list.dart';


class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case '/AddNewCustomerScreen':
        return MaterialPageRoute(builder: (_) => AddNewCustomerScreen());
      case '/CustomerScreen':
        return MaterialPageRoute(builder: (_) => CustomerScreen(args));
      case '/CustomerDetailScreen':
        return MaterialPageRoute(builder: (_) => CustomerDetailScreen(args));
      case '/TicketsListScreen':
        return MaterialPageRoute(builder: (_) => TicketsListScreen(args));
      case '/TicketDetailScreen':
        return MaterialPageRoute(builder: (_) => TicketDetailScreen(args));
      case '/AddNewTicketScreen':
        return MaterialPageRoute(builder: (_) => AddNewTicketScreen(args));
      case '/MapScreen':
        return MaterialPageRoute(builder: (_) => MapScreen());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('Routing Error!'),
        ),
      );
    });
  }
}



import 'package:get_it/get_it.dart';
import 'package:tickets_app/Helper/URLServices.dart';

GetIt locator = GetIt();

void setupLocator() {
  locator.registerSingleton(CallsAndMessagesService());
}
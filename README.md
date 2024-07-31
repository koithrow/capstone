#Flutter Authentication and Booking App

#Overview
This Flutter application provides a simple authentication system (Login/Signup) and a booking feature for a resort. The app includes:

1.Login/Signup screen
2.Home screen for logged-in users
3.Date Picker for selecting booking dates
4.Room Selection for choosing a room
5.Guest Information form
6.Scenery Page to browse scenic images of the resort
7.Thank You screen after successful booking

#Installation
1.Clone the repository:
copy code:
git clone <repository_url>

2.Navigate to the project directory:
cd <project_directory>

3.Install dependencies:
flutter pub get

4.Run the app:
flutter run

#Code Structure
#Main Entry Point

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AuthScreen(),
    );
  }
}

#Authentication Screen
'AuthScreen' provides login and signup functionalities.

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // Form key and user credentials
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String confirmPassword = '';
  String username = '';
  bool isLogin = true;
  bool agreeToTerms = false;
  Map<String, Map<String, String>> users = {};

  // Sign In and Sign Up methods
  String? signIn(String email, String password) { ... }
  String? signUp(String email, String username, String password) { ... }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar, Background, and Form
      ...
    );
  }
}

#Home Screen
'HomePage' displays the user information and options to select dates, choose a room, or browse scenery.

class HomePage extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final String email;
  final String username;

  HomePage({this.startDate, this.endDate, required this.email, required this.username});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedRoom;

  @override
  void initState() {
    super.initState();
    _startDate = widget.startDate;
    _endDate = widget.endDate;
  }

  void _updateDates(DateTime? start, DateTime? end) {
    setState(() {
      _startDate = start;
      _endDate = end;
    });
  }

  void _selectRoom(String room) {
    setState(() {
      _selectedRoom = room;
    });
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => AuthScreen()),
      ModalRoute.withName('/'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar, Body, Buttons for navigating to other screens
      ...
    );
  }
}

#Additional Screens

DatePickerScreen: Allows users to select start and end dates for booking.
RoomSelectionScreen: Provides a grid view for room selection.
GuestInfoScreen: Form for entering guest information.
ThankYouScreen: Displays a thank you message after successful booking.
SceneryPage: Allows users to browse scenic images of the resort.

#Usage
#1.Authentication:
-Users can either login or sign up.
-Upon successful authentication, users are navigated to the Home screen.

#2.Home Screen:
-Users can select booking dates, choose a room, fill in guest information, and browse scenic images.

#3.Date Selection:
-Users can select a date range for their stay.

#4.Room Selection:
-Users can choose a room from a list of available options.

#5.Guest Information:
-Users fill in their personal details required for booking.

#6.Scenery Browsing:
-Users can browse various scenic images of the resort.

#Screenshots
![image](https://github.com/user-attachments/assets/0646c913-3443-4c1b-a35a-b85336afd24f)
![image](https://github.com/user-attachments/assets/70611fd8-2cc6-43aa-b87e-2e591cfb5ce0)


#License
This project is licensed under the MIT License - see the LICENSE file for details.

#Contact
For any questions or feedback, please contact [21-41574@g.batsate-u.edu.ph].

#Feel free to modify the above README template to suit your project's specific details and requirements.

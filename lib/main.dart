import 'package:flutter/material.dart';

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

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String confirmPassword = '';
  String username = ''; // Added username field
  bool isLogin = true;
  bool agreeToTerms = false;
  Map<String, Map<String, String>> users = {}; // Map to store users (email -> {username, password})

  // Simulate sign in
  String? signIn(String email, String password) {
    if (users.containsKey(email) && users[email]!['password'] == password) {
      return "Success";
    } else {
      return "Invalid email or password";
    }
  }

  // Simulate sign up
  String? signUp(String email, String username, String password) {
    if (users.containsKey(email)) {
      return "User already exists";
    } else {
      users[email] = {'username': username, 'password': password};
      return "Success";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLogin ? 'Login' : 'Sign Up'),
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(isLogin ? 'assets/login_bg.jpg' : 'assets/signup_bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Form
          Center(
            child: SingleChildScrollView(
              child: Container(
                width: 300,
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(height: 20.0),
                      if (!isLogin) // Show username field only for sign up
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Username',
                            prefixIcon: Icon(Icons.person), // Username icon
                          ),
                          validator: (val) =>
                          val!.isEmpty ? 'Enter a username' : null,
                          onChanged: (val) {
                            setState(() => username = val);
                          },
                        ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Email',
                          prefixIcon: Icon(Icons.email), // Email icon
                        ),
                        validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Password',
                          prefixIcon: Icon(Icons.lock), // Password icon
                        ),
                        obscureText: true,
                        validator: (val) =>
                        val!.length < 6 ? 'Enter a password 6+ chars long' : null,
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                      ),
                      if (!isLogin)
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Confirm Password',
                            prefixIcon: Icon(Icons.lock), // Confirm password icon
                          ),
                          obscureText: true,
                          validator: (val) =>
                          val != password ? 'Passwords do not match' : null,
                          onChanged: (val) {
                            setState(() => confirmPassword = val);
                          },
                        ),
                      if (!isLogin)
                        CheckboxListTile(
                          title: Text('I agree to the terms and conditions'),
                          value: agreeToTerms,
                          onChanged: (val) {
                            setState(() {
                              agreeToTerms = val!;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      SizedBox(height: 20.0),
                      ElevatedButton.icon(
                        icon: Icon(isLogin ? Icons.login : Icons.person_add),
                        label: Text(isLogin ? 'Login' : 'Sign Up'),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (!isLogin && !agreeToTerms) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    'You must agree to the terms and conditions'),
                              ));
                              return;
                            }
                            String? result;
                            if (isLogin) {
                              result = signIn(email, password);
                            } else {
                              result = signUp(email, username, password);
                            }

                            if (result == "Success") {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(isLogin
                                    ? 'Logged in successfully'
                                    : 'Signed up successfully'),
                              ));
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage(
                                      email: email,
                                      username: users[email]!['username']!,
                                    )),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(result!),
                              ));
                            }
                          }
                        },
                      ),
                      TextButton(
                        child: Text(
                            isLogin ? 'Create an account' : 'Have an account? Login'),
                        onPressed: () {
                          setState(() {
                            isLogin = !isLogin;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final String email;
  final String username; // Added username

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
      appBar: AppBar(
        title: Text('Home Page'),
        actions: <Widget>[
          Center(
            child: Text(
              '${widget.username} (${widget.email})',
              style: TextStyle(fontSize: 16),
            ),
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DatePickerScreen(
                        startDate: _startDate,
                        endDate: _endDate,
                      ),
                    ),
                  );

                  if (result != null) {
                    _updateDates(result['startDate'], result['endDate']);
                  }
                },
                child: Text('Select Dates'),
              ),
              if (_startDate != null && _endDate != null)
                _buildSelectedDatesBox(),
              if (_startDate != null && _endDate != null)
                ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RoomSelectionScreen(
                          onRoomSelected: _selectRoom,
                        ),
                      ),
                    );

                    if (result != null) {
                      _selectRoom(result);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GuestInfoScreen(),
                        ),
                      );
                    }
                  },
                  child: Text('Select Room'),
                ),
              if (_selectedRoom != null)
                Text('Selected Room: $_selectedRoom'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SceneryPage(),
                    ),
                  );
                },
                child: Text('Browse Scenery'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedDatesBox() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            'Selected Dates:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            'Start: ${_startDate!.toLocal()}',
          ),
          Text(
            'End: ${_endDate!.toLocal()}',
          ),
        ],
      ),
    );
  }
}

class DatePickerScreen extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;

  DatePickerScreen({this.startDate, this.endDate});

  @override
  _DatePickerScreenState createState() => _DatePickerScreenState();
}

class _DatePickerScreenState extends State<DatePickerScreen> {
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _startDate = widget.startDate;
    _endDate = widget.endDate;
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
    );

    if (picked != null && picked != DateTimeRange(start: _startDate ?? DateTime.now(), end: _endDate ?? DateTime.now())) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });

      Navigator.pop(context, {'startDate': _startDate, 'endDate': _endDate});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Dates'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _selectDateRange(context),
          child: Text('Select Date Range'),
        ),
      ),
    );
  }
}

class RoomSelectionScreen extends StatelessWidget {
  final Function(String) onRoomSelected;

  RoomSelectionScreen({required this.onRoomSelected});

  final List<Map<String, String>> rooms = [
    {'name': 'Single Room', 'image': 'assets/single_room.jpg'},
    {'name': 'Double Room', 'image': 'assets/double_room.jpg'},
    {'name': 'Suite', 'image': 'assets/suite.jpg'},
    {'name': 'Deluxe Suite', 'image': 'assets/deluxe_suite.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select a Room'),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(10.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: rooms.length,
        itemBuilder: (context, index) {
          final room = rooms[index];
          return GestureDetector(
            onTap: () {
              onRoomSelected(room['name']!);
              Navigator.pop(context, room['name']);
            },
            child: Card(
              elevation: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Image.asset(
                      room['image']!,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      room['name']!,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class GuestInfoScreen extends StatefulWidget {
  @override
  _GuestInfoScreenState createState() => _GuestInfoScreenState();
}

class _GuestInfoScreenState extends State<GuestInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  String fullName = '';
  String email = '';
  String phoneNumber = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guest Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Full Name'),
                validator: (val) =>
                val!.isEmpty ? 'Enter your full name' : null,
                onChanged: (val) {
                  setState(() => fullName = val);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Phone Number'),
                validator: (val) =>
                val!.isEmpty ? 'Enter your phone number' : null,
                onChanged: (val) {
                  setState(() => phoneNumber = val);
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ThankYouScreen(),
                      ),
                    );
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ThankYouScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thank You'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'You are now ready to enjoy your time in our beautiful resort.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              Text(
                'Thank you for choosing us and booking!',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                },
                child: Text('Back to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SceneryPage extends StatelessWidget {
  final List<Map<String, String>> sceneryImages = [
    {'name': 'Resort View', 'image': 'assets/resort_view.jpg'},
    {'name': 'Beachside', 'image': 'assets/beachside.jpg'},
    {'name': 'Mountain View', 'image': 'assets/mountain_view.jpg'},
    {'name': 'Pool Area', 'image': 'assets/pool_area.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Browse Scenery'),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(10.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: sceneryImages.length,
        itemBuilder: (context, index) {
          final scenery = sceneryImages[index];
          return Card(
            elevation: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Image.asset(
                    scenery['image']!,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    scenery['name']!,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

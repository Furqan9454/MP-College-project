import 'package:flutter/material.dart';

void main() {
  books = List<Book>.from(defaultBooks);

  runApp(const MyApp());
}

// ============================================================
// USER MODEL
// ============================================================

class User {
  String name;
  String email;
  String password;
  String category;

  User({
    required this.name,
    required this.email,
    required this.password,
    required this.category,
  });
}

// ============================================================
// BOOK MODEL
// ============================================================

class Book {
  String name;
  String category;
  String price;
  String condition;
  String description;
  String author;

  // These fields store whether the book is for Exchange or Sell,
  // the original selling price, and the discount percentage.
  String availableFor;
  double originalPrice;
  double discount;

  // Stores the email of the user who added/listed this book.
  // The existing User model already has a unique email, so we use it
  // as the owner identifier without changing the User structure.
  String ownerEmail;

  Book({
    required this.name,
    required this.category,
    required this.price,
    required this.condition,
    required this.description,
    this.author = "",

    // Default values keep all existing Book objects working.
    this.availableFor = "Exchange",
    this.originalPrice = 0,
    this.discount = 0,

    // Default is empty for the old/default books.
    this.ownerEmail = "",
  });
}

// ============================================================
// DEFAULT BOOKS
// ============================================================

List<Book> defaultBooks = [
  Book(
    name: "Data Structures",
    category: "IT",
    price: "₹150",
    condition: "Good",
    description:
    "Data Structures book in good condition. Useful for IT students and practical preparation.",
  ),
  Book(
    name: "C++ Programming",
    category: "IT",
    price: "₹120",
    condition: "Excellent",
    description:
    "C++ programming book covering OOP, arrays, pointers, functions and basic programming concepts.",
  ),
  Book(
    name: "Python Programming",
    category: "IT",
    price: "₹150",
    condition: "Good",
    description:
    "Python programming book covering basic Python, functions, lists, dictionaries and programming concepts.",
  ),
  Book(
    name: "Java Programming",
    category: "IT",
    price: "₹180",
    condition: "Excellent",
    description:
    "Java programming book covering classes, objects, inheritance, exceptions and basic Java programming.",
  ),
  Book(
    name: "Engineering Mathematics",
    category: "Maths",
    price: "₹200",
    condition: "Good",
    description:
    "Mathematics book containing important topics, solved examples and practice questions.",
  ),
  Book(
    name: "Discrete Mathematics",
    category: "Maths",
    price: "₹170",
    condition: "Excellent",
    description:
    "Discrete Mathematics book covering logic, sets, relations, functions and graphs.",
  ),
  Book(
    name: "The Alchemist",
    category: "Novel",
    price: "₹100",
    condition: "Good",
    description:
    "A popular inspirational novel about dreams, goals and following your journey.",
  ),
  Book(
    name: "Harry Potter",
    category: "Novel",
    price: "₹180",
    condition: "Good",
    description:
    "A fantasy novel following Harry Potter and his adventures in the wizarding world.",
  ),
];

// ============================================================
// GLOBAL DATA
// ============================================================

List<User> registeredUsers = [];

List<Book> books = List<Book>.from(defaultBooks);

// Currently logged-in user
User? currentUser;

// Runtime wishlist
List<Book> wishlistBooks = [];

// Runtime exchange requests
List<Book> exchangeRequests = [];

// Runtime buy requests
List<Book> buyRequests = [];

// App theme
ValueNotifier<ThemeMode> appThemeMode =
ValueNotifier(ThemeMode.light);

// Notifications
bool notificationsEnabled = true;

// ============================================================
// MAIN APP
// ============================================================

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: appThemeMode,
      builder: (context, themeMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "BOOKLOOP",
          themeMode: themeMode,

// --------------------------------------------------
// LIGHT THEME
// --------------------------------------------------

          theme: ThemeData(
            useMaterial3: true,
            primarySwatch: Colors.pink,

            scaffoldBackgroundColor: Colors.pink.shade50,

            appBarTheme: const AppBarTheme(
              centerTitle: true,
              backgroundColor: Colors.pink,
              foregroundColor: Colors.white,
            ),

            cardTheme: const CardThemeData(
              color: Colors.white,
            ),

            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.pink,
              brightness: Brightness.light,
            ),
          ),

// --------------------------------------------------
// DARK THEME
// --------------------------------------------------

          darkTheme: ThemeData(
            useMaterial3: true,

            scaffoldBackgroundColor:
            const Color(0xFF24151D),

            appBarTheme: const AppBarTheme(
              centerTitle: true,
              backgroundColor: Color(0xFFAD1457),
              foregroundColor: Colors.white,
            ),

            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.pink,
              brightness: Brightness.dark,
            ),
          ),

          home: const ScreenPage(),
        );
      },
    );
  }
}

// ============================================================
// SPLASH / LANDING PAGE
// ============================================================

class ScreenPage extends StatefulWidget {
  const ScreenPage({super.key});

  @override
  State<ScreenPage> createState() => ScreenPageState();
}

class ScreenPageState extends State<ScreenPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  bool moveBook = false;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void toggleBook() {
    setState(() {
      moveBook = !moveBook;
    });

    if (moveBook) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "asset/img.png",
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  "asset/img.png",
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.pink.shade100,
                    );
                  },
                );
              },
            ),
          ),

          Positioned.fill(
            child: Container(
              color: Colors.pink.withValues(alpha: 0.35),
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(
                        0,
                        -30 * animation.value,
                      ),
                      child: child,
                    );
                  },
                  child: const Icon(
                    Icons.menu_book,
                    size: 100,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "BOOKLOOP",
                  style: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 3,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Exchange • Sell • Discover Books",
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 40),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        const LoginPage(),
                      ),
                    );
                  },
                  child: const Text(
                    "ENTER",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                IconButton(
                  onPressed: toggleBook,
                  icon: const Icon(
                    Icons.menu_book,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// ============================================================
// LOGIN PAGE
// ============================================================

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formkey = GlobalKey<FormState>();

  String email = "";
  String password = "";

  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 500,
            ),
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  const Icon(
                    Icons.menu_book,
                    size: 80,
                    color: Colors.pink,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Welcome Back",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 30),

                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon:
                      const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType:
                    TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return "Please enter email";
                      }

                      if (!value.contains("@")) {
                        return "Enter valid email";
                      }

                      return null;
                    },
                    onSaved: (value) {
                      email = value!.trim();
                    },
                  ),

                  const SizedBox(height: 20),

                  TextFormField(
                    obscureText: !showPassword,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon:
                      const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            showPassword =
                            !showPassword;
                          });
                        },
                        icon: Icon(
                          showPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty) {
                        return "Please enter password";
                      }

                      return null;
                    },
                    onSaved: (value) {
                      password = value!;
                    },
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (!formkey.currentState!
                            .validate()) {
                          return;
                        }

                        formkey.currentState!.save();

                        User? user;

                        for (User registeredUser
                        in registeredUsers) {
                          if (registeredUser.email
                              .toLowerCase() ==
                              email.toLowerCase()) {
                            user = registeredUser;
                            break;
                          }
                        }

                        if (user == null) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Account not found. Please Sign Up first.",
                              ),
                              backgroundColor:
                              Colors.red,
                            ),
                          );
                          return;
                        }

                        if (user.password != password) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Incorrect password.",
                              ),
                              backgroundColor:
                              Colors.red,
                            ),
                          );
                          return;
                        }

// Set logged-in user
                        currentUser = user;

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const HomePage(),
                          ),
                        );
                      },
                      child: const Text(
                        "LOGIN",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Don't have an account?",
                  ),

                  const SizedBox(height: 10),

                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const SignupPage(),
                        ),
                      );
                    },
                    child: const Text("SIGN UP"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// SIGN UP PAGE
// ============================================================

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final formkey = GlobalKey<FormState>();

  String name = "";
  String email = "";
  String password = "";

  String? classname;

  bool valueFirst = false;
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Account"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 500,
            ),
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  const Icon(
                    Icons.person_add,
                    size: 75,
                    color: Colors.pink,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 30),

                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Name",
                      prefixIcon:
                      const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return "Please enter name";
                      }

                      return null;
                    },
                    onSaved: (value) {
                      name = value!.trim();
                    },
                  ),

                  const SizedBox(height: 20),

                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon:
                      const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType:
                    TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return "Please enter email";
                      }

                      if (!value.contains("@")) {
                        return "Enter valid email";
                      }

                      return null;
                    },
                    onSaved: (value) {
                      email = value!.trim();
                    },
                  ),

                  const SizedBox(height: 20),

                  TextFormField(
                    obscureText: !showPassword,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon:
                      const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            showPassword =
                            !showPassword;
                          });
                        },
                        icon: Icon(
                          showPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty) {
                        return "Please enter password";
                      }

                      if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }

                      return null;
                    },
                    onSaved: (value) {
                      password = value!;
                    },
                  ),

                  const SizedBox(height: 20),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Account Type",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  RadioGroup<String>(
                    groupValue: classname,
                    onChanged: (value) {
                      setState(() {
                        classname = value;
                      });
                    },
                    child: Column(
                      children: const [
                        RadioListTile<String>(
                          title: Text("Student"),
                          value: "Student",
                        ),
                        RadioListTile<String>(
                          title: Text("Other"),
                          value: "Other",
                        ),
                      ],
                    ),
                  ),

                  CheckboxListTile(
                    title: const Text(
                      "I agree to the terms and conditions",
                    ),
                    value: valueFirst,
                    onChanged: (value) {
                      setState(() {
                        valueFirst =
                            value ?? false;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (!formkey.currentState!
                            .validate()) {
                          return;
                        }

                        if (classname == null) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Please select Student or Other",
                              ),
                              backgroundColor:
                              Colors.red,
                            ),
                          );
                          return;
                        }

                        if (!valueFirst) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Please agree to the terms",
                              ),
                              backgroundColor:
                              Colors.red,
                            ),
                          );
                          return;
                        }

                        formkey.currentState!.save();

                        for (User registeredUser
                        in registeredUsers) {
                          if (registeredUser.email
                              .toLowerCase() ==
                              email.toLowerCase()) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "This email is already registered.",
                                ),
                                backgroundColor:
                                Colors.red,
                              ),
                            );
                            return;
                          }
                        }

                        User newUser = User(
                          name: name,
                          email: email,
                          password: password,
                          category: classname!,
                        );

                        registeredUsers.add(newUser);

// Set current user
                        currentUser = newUser;

                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Account created successfully!",
                            ),
                            backgroundColor:
                            Colors.green,
                          ),
                        );

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const HomePage(),
                          ),
                        );
                      },
                      child: const Text(
                        "CREATE ACCOUNT",
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// HOME PAGE
// ============================================================

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomeContent(),
      const BrowseBooks(),
      const AddBook(),
      const Wishlist(),
      const Profile(),
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        // If user is on another tab (Add, Browse, Wishlist, Profile),
        // Android back should return to Home instead of leaving HomePage.
        if (selectedIndex != 0) {
          setState(() {
            selectedIndex = 0;
          });
          return;
        }

        // On Home, ask before leaving the app. This prevents the app
        // from going back to LoginPage and looking like an auto logout.
        showDialog(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text("Exit BOOKLOOP?"),
            content: const Text("Do you want to exit the app?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text("CANCEL"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text("EXIT"),
              ),
            ],
          ),
        );
      },
      child: Scaffold(
        body: pages[selectedIndex],

        bottomNavigationBar:
        BottomNavigationBar(
          currentIndex: selectedIndex,
          selectedItemColor: Colors.pink,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: "Browse",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box),
              label: "Add",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: "Wishlist",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// HOME CONTENT
// ============================================================

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "BOOKLOOP",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            const Text(
              "Categories",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const CategoryBooksPage(
                            category: "IT",
                          ),
                        ),
                      );
                    },
                    child: categoryBox(
                      "IT",
                      Icons.computer,
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const CategoryBooksPage(
                            category: "Maths",
                          ),
                        ),
                      );
                    },
                    child: categoryBox(
                      "Maths",
                      Icons.calculate,
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const CategoryBooksPage(
                            category: "Novel",
                          ),
                        ),
                      );
                    },
                    child: categoryBox(
                      "Novel",
                      Icons.menu_book,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              "Recently Added",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

// ------------------------------------------------
// FIXED RECENTLY ADDED SECTION
// ------------------------------------------------

            SizedBox(
              height: 190,
              child: ListView.builder(
                scrollDirection:
                Axis.horizontal,
                itemCount: books.length,
                itemBuilder:
                    (context, index) {
                  Book book = books[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              BookDetailsPage(
                                book: book,
                              ),
                        ),
                      );
                    },
                    child: Container(
                      width: 170,
                      margin:
                      const EdgeInsets.only(
                        right: 15,
                      ),
                      padding:
                      const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(
                          15,
                        ),
                        border: Border.all(
                          color:
                          Colors.pink.shade200,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment
                            .center,
                        mainAxisSize:
                        MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.book,
                            size: 45,
                            color: Colors.pink,
                          ),

                          const SizedBox(height: 8),

                          Text(
                            book.name,
                            maxLines: 2,
                            overflow:
                            TextOverflow
                                .ellipsis,
                            textAlign:
                            TextAlign.center,
                            style:
                            const TextStyle(
                              fontSize: 15,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            book.price,
                            style:
                            const TextStyle(
                              color:
                              Colors.green,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Popular Books",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            ...books.take(4).map(
                  (book) => GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          BookDetailsPage(
                            book: book,
                          ),
                    ),
                  );
                },
                child: Card(
                  margin:
                  const EdgeInsets.only(
                    bottom: 12,
                  ),
                  child: ListTile(
                    leading:
                    const CircleAvatar(
                      child:
                      Icon(Icons.book),
                    ),
                    title: Text(
                      book.name,
                      style:
                      const TextStyle(
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "${book.category} • ${book.condition}",
                    ),
                    trailing: Text(
                      book.price,
                      style:
                      const TextStyle(
                        color:
                        Colors.green,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget categoryBox(
      String title,
      IconData icon,
      ) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(15),
        border: Border.all(
          color: Colors.pink.shade200,
        ),
      ),
      child: Column(
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 35,
            color: Colors.pink,
          ),

          const SizedBox(height: 8),

          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// CATEGORY BOOKS PAGE
// ============================================================

class CategoryBooksPage
    extends StatelessWidget {
  final String category;

  const CategoryBooksPage({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    List<Book> categoryBooks = books
        .where(
          (book) =>
      book.category.toLowerCase() ==
          category.toLowerCase(),
    )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("$category Books"),
        centerTitle: true,
      ),
      body: categoryBooks.isEmpty
          ? const Center(
        child: Text(
          "No books.jpeg available in this category.",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      )
          : ListView.builder(
        padding:
        const EdgeInsets.all(15),
        itemCount:
        categoryBooks.length,
        itemBuilder:
            (context, index) {
          Book book =
          categoryBooks[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      BookDetailsPage(
                        book: book,
                      ),
                ),
              );
            },
            child: Card(
              margin:
              const EdgeInsets.only(
                bottom: 15,
              ),
              child: Padding(
                padding:
                const EdgeInsets.all(
                  15,
                ),
                child: Row(
                  children: [
                    Container(
                      height: 75,
                      width: 75,
                      decoration:
                      BoxDecoration(
                        color: Colors
                            .pink.shade50,
                        borderRadius:
                        BorderRadius
                            .circular(
                          12,
                        ),
                      ),
                      child:
                      const Icon(
                        Icons.menu_book,
                        size: 40,
                        color:
                        Colors.pink,
                      ),
                    ),

                    const SizedBox(
                      width: 15,
                    ),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                        children: [
                          Text(
                            book.name,
                            style:
                            const TextStyle(
                              fontSize: 18,
                              fontWeight:
                              FontWeight
                                  .bold,
                            ),
                          ),

                          const SizedBox(
                            height: 5,
                          ),

                          Text(
                            "Category: ${book.category}",
                          ),

                          Text(
                            "Condition: ${book.condition}",
                          ),

                          const SizedBox(
                            height: 5,
                          ),

                          Text(
                            book.price,
                            style:
                            const TextStyle(
                              color:
                              Colors
                                  .green,
                              fontWeight:
                              FontWeight
                                  .bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Icon(
                      Icons
                          .arrow_forward_ios,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ============================================================
// SEARCH BOOKS PAGE
// ============================================================

class SearchBooksPage
    extends StatelessWidget {
  final String searchText;

  const SearchBooksPage({
    super.key,
    required this.searchText,
  });

  @override
  Widget build(BuildContext context) {
    List<Book> searchResults =
    books.where((book) {
      return book.name
          .toLowerCase()
          .contains(
        searchText.toLowerCase(),
      ) ||
          book.category
              .toLowerCase()
              .contains(
            searchText.toLowerCase(),
          );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Search: $searchText"),
      ),
      body: searchResults.isEmpty
          ? const Center(
        child: Text(
          "No books.jpeg found.",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      )
          : ListView.builder(
        padding:
        const EdgeInsets.all(15),
        itemCount:
        searchResults.length,
        itemBuilder:
            (context, index) {
          Book book =
          searchResults[index];

          return Card(
            child: ListTile(
              leading:
              const Icon(
                Icons.menu_book,
                color: Colors.pink,
              ),
              title:
              Text(book.name),
              subtitle:
              Text(book.category),
              trailing:
              Text(book.price),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        BookDetailsPage(
                          book: book,
                        ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// ============================================================
// BOOK DETAILS PAGE
// ============================================================

class BookDetailsPage extends StatefulWidget {
  final Book book;

  const BookDetailsPage({
    super.key,
    required this.book,
  });

  @override
  State<BookDetailsPage> createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  Book get book => widget.book;

  // Opens the Edit Book page and refreshes the details after saving.
  Future<void> editBook() async {
    final bool? updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => EditBookPage(book: book),
      ),
    );

    if (updated == true) {
      setState(() {});
    }
  }

  // Removes the book after asking the owner for confirmation.
  Future<void> removeBook() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Remove Book"),
          content: const Text(
            "Are you sure you want to remove this book?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("CANCEL"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text("REMOVE"),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      // Remove the same Book object from the main books list.
      books.remove(book);

      // Remove it from request/wishlist lists too, if it was there.
      exchangeRequests.remove(book);
      buyRequests.remove(book);
      wishlistBooks.remove(book);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Book removed successfully!"),
            backgroundColor: Colors.green,
          ),
        );

        // Go back from Book Details after removing the book.
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isOwner =
        currentUser?.email.toLowerCase() == book.ownerEmail.toLowerCase();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Details"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 180,
                width: 180,
                decoration: BoxDecoration(
                  color: Colors.pink.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.menu_book,
                  size: 100,
                  color: Colors.pink,
                ),
              ),
            ),

            const SizedBox(height: 25),

            Center(
              child: Text(
                book.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 25),

            detailRow("Category", book.category),

            // Show whether this book is available for Exchange or Sell.
            detailRow("Available For", book.availableFor),

            // If the book is for Sell, show its price information.
            if (book.availableFor == "Sell") ...[
              // Only show the crossed-out original price and discount
              // when a discount has actually been applied.
              if (book.discount > 0) ...[
                Row(
                  children: [
                    Text(
                      "₹${book.originalPrice.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 17,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "${book.discount.toStringAsFixed(0)}% OFF",
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],

              // Show the final price after applying the discount.
              detailRow(
                book.discount > 0 ? "Discount Price" : "Price",
                book.price,
              ),
            ],

            detailRow("Condition", book.condition),

            if (book.author.isNotEmpty)
              detailRow("Author", book.author),

            const SizedBox(height: 20),

            const Text(
              "Description",
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              book.description,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 30),

            // The owner sees Edit Book and Remove Book instead of
            // request/wishlist buttons.
            if (isOwner) ...[
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: editBook,
                  icon: const Icon(Icons.edit),
                  label: const Text("EDIT BOOK"),
                ),
              ),

              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: removeBook,
                  icon: const Icon(Icons.delete_outline),
                  label: const Text("REMOVE BOOK"),
                ),
              ),
            ],

            // Show purchase/exchange actions only when the logged-in
            // user is NOT the owner of this book.
            if (!isOwner) ...[
              // Exchange books show the REQUEST EXCHANGE button.
              if (book.availableFor == "Exchange")
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (!exchangeRequests.contains(book)) {
                        exchangeRequests.add(book);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Exchange request sent successfully!",
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Exchange request already sent.",
                            ),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.swap_horiz),
                    label: const Text("REQUEST EXCHANGE"),
                  ),
                ),

              // Sell books show the REQUEST TO BUY button.
              if (book.availableFor == "Sell")
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (!buyRequests.contains(book)) {
                        buyRequests.add(book);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Buy request sent successfully!",
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Buy request already sent.",
                            ),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.shopping_cart),
                    label: const Text("REQUEST TO BUY"),
                  ),
                ),

              const SizedBox(height: 15),

              // Other users can add both Sell and Exchange books
              // to their wishlist.
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () {
                    if (!wishlistBooks.contains(book)) {
                      wishlistBooks.add(book);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Book added to wishlist!"),
                          backgroundColor: Colors.pink,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Book is already in wishlist."),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.favorite_border),
                  label: const Text("ADD TO WISHLIST"),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Text(
            "$title: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 17),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// EDIT BOOK PAGE
// ============================================================

// This page uses the same Book object and pre-fills all existing
// information so the owner can edit the book without creating a new one.
class EditBookPage extends StatefulWidget {
  final Book book;

  const EditBookPage({
    super.key,
    required this.book,
  });

  @override
  State<EditBookPage> createState() => _EditBookPageState();
}

class _EditBookPageState extends State<EditBookPage> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  late TextEditingController bookNameController;
  late TextEditingController authorController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  late TextEditingController discountController;

  late String classCategory;
  late String classname;
  late String classn;

  double discountAmount = 0;
  double finalPrice = 0;

  @override
  void initState() {
    super.initState();

    // Put the existing book information into the text fields.
    bookNameController = TextEditingController(text: widget.book.name);
    authorController = TextEditingController(text: widget.book.author);
    descriptionController =
        TextEditingController(text: widget.book.description);
    priceController = TextEditingController(
      text: widget.book.availableFor == "Sell"
          ? widget.book.originalPrice.toString()
          : "",
    );
    discountController = TextEditingController(
      text: widget.book.availableFor == "Sell"
          ? widget.book.discount.toString()
          : "",
    );

    // Keep the existing selections.
    classCategory = widget.book.category;
    classname = widget.book.condition;
    classn = widget.book.availableFor;

    // Keep the existing calculated price for a Sell book.
    if (classn == "Sell") {
      finalPrice = widget.book.originalPrice -
          (widget.book.originalPrice * widget.book.discount / 100);
      discountAmount =
          widget.book.originalPrice * widget.book.discount / 100;
    }
  }

  @override
  void dispose() {
    bookNameController.dispose();
    authorController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    discountController.dispose();
    super.dispose();
  }

  void calculatePrice() {
    final double? price = double.tryParse(priceController.text.trim());
    final double? discount =
        double.tryParse(discountController.text.trim());

    if (price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a valid original price."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (discount == null || discount < 0 || discount > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Discount must be between 0 and 100."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      discountAmount = price * discount / 100;
      finalPrice = price - discountAmount;
    });
  }

  void saveChanges() {
    if (!formkey.currentState!.validate()) {
      return;
    }

    if (classCategory.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a category."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (classname.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select book condition."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (classn.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select Exchange or Sell."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Update the SAME Book object instead of creating a new book.
    widget.book.name = bookNameController.text.trim();
    widget.book.author = authorController.text.trim();
    widget.book.category = classCategory;
    widget.book.condition = classname;
    widget.book.description = descriptionController.text.trim();
    widget.book.availableFor = classn;

    if (classn == "Sell") {
      final double? price = double.tryParse(priceController.text.trim());
      final double? discount =
          double.tryParse(discountController.text.trim());

      if (price == null || price <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please enter a valid original price."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (discount == null || discount < 0 || discount > 100) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Discount must be between 0 and 100."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Calculate the final selling price directly while saving.
      final double calculatedPrice = price - (price * discount / 100);

      if (calculatedPrice <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Final price must be greater than 0."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      widget.book.originalPrice = price;
      widget.book.discount = discount;
      widget.book.price = "₹${calculatedPrice.toStringAsFixed(2)}";
    } else {
      // If changed to Exchange, price information is cleared.
      widget.book.originalPrice = 0;
      widget.book.discount = 0;
      widget.book.price = "Exchange";
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Book updated successfully!"),
        backgroundColor: Colors.green,
      ),
    );

    // true tells BookDetailsPage to refresh its display.
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Book"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: bookNameController,
                decoration: InputDecoration(
                  labelText: "Book Name",
                  prefixIcon:
                      const Icon(Icons.menu_book, color: Colors.pink),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter book name";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: authorController,
                decoration: InputDecoration(
                  labelText: "Author",
                  prefixIcon: const Icon(Icons.person, color: Colors.pink),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter author name";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: classCategory,
                decoration: InputDecoration(
                  labelText: "Category",
                  prefixIcon:
                      const Icon(Icons.category, color: Colors.pink),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: "IT", child: Text("IT")),
                  DropdownMenuItem(value: "Maths", child: Text("Maths")),
                  DropdownMenuItem(value: "Novel", child: Text("Novel")),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      classCategory = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: classname,
                decoration: InputDecoration(
                  labelText: "Book Condition",
                  prefixIcon:
                      const Icon(Icons.star, color: Colors.pink),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: "New", child: Text("New")),
                  DropdownMenuItem(value: "Excellent", child: Text("Excellent")),
                  DropdownMenuItem(value: "Good", child: Text("Good")),
                  DropdownMenuItem(value: "Fair", child: Text("Fair")),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      classname = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: classn,
                decoration: InputDecoration(
                  labelText: "Available For",
                  prefixIcon:
                      const Icon(Icons.swap_horiz, color: Colors.pink),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value: "Exchange",
                    child: Text("Exchange"),
                  ),
                  DropdownMenuItem(
                    value: "Sell",
                    child: Text("Sell"),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      classn = value;

                      // Clear price fields when switching to Exchange.
                      if (value == "Exchange") {
                        priceController.clear();
                        discountController.clear();
                        discountAmount = 0;
                        finalPrice = 0;
                      }
                    });
                  }
                },
              ),

              // Price fields are shown only for Sell.
              if (classn == "Sell") ...[
                const SizedBox(height: 20),

                TextFormField(
                  controller: priceController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: "Original Price",
                    prefixText: "₹ ",
                    prefixIcon:
                        const Icon(Icons.currency_rupee, color: Colors.pink),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (classn == "Sell" &&
                        (value == null || value.trim().isEmpty)) {
                      return "Please enter original price";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: discountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: "Discount (%)",
                    prefixIcon:
                        const Icon(Icons.percent, color: Colors.pink),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (classn == "Sell" &&
                        (value == null || value.trim().isEmpty)) {
                      return "Please enter discount";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 15),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: calculatePrice,
                    icon: const Icon(Icons.calculate),
                    label: const Text("CALCULATE PRICE"),
                  ),
                ),

                if (finalPrice > 0) ...[
                  const SizedBox(height: 15),
                  Text(
                    "Final Price: ₹${finalPrice.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],

              const SizedBox(height: 20),

              TextFormField(
                controller: descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: "Description",
                  prefixIcon:
                      const Icon(Icons.description, color: Colors.pink),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter description";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: saveChanges,
                  icon: const Icon(Icons.save),
                  label: const Text("SAVE CHANGES"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// ADD BOOK PAGE
// ============================================================

// ============================================================
// ADD BOOK
// ============================================================

class AddBook extends StatefulWidget {
  const AddBook({super.key});

  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  final formkey = GlobalKey<FormState>();

  final TextEditingController bookNameController =
  TextEditingController();
  final TextEditingController authorController =
  TextEditingController();
  final TextEditingController descriptionController =
  TextEditingController();
  final TextEditingController priceController =
  TextEditingController();
  final TextEditingController discountController =
  TextEditingController();

  String? classname;
  String? classn;
  String? classCategory;

  bool valuef = false;
  double discountAmount = 0;
  double finalPrice = 0;

  @override
  void dispose() {
    bookNameController.dispose();
    authorController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    discountController.dispose();
    super.dispose();
  }

  void resetCalculatedPrice() {
    if (finalPrice != 0 || discountAmount != 0) {
      setState(() {
        finalPrice = 0;
        discountAmount = 0;
      });
    }
  }

  // Calculates the discount amount and the final selling price.
  void calculatePrice() {
    final double? price = double.tryParse(priceController.text.trim());
    final double? discount =
    double.tryParse(discountController.text.trim());

    if (price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Enter a valid original price."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (discount == null || discount < 0 || discount > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Discount must be between 0 and 100."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      discountAmount = price * discount / 100;
      finalPrice = price - discountAmount;
    });
  }

  void addBook() {
    if (!formkey.currentState!.validate()) {
      return;
    }

    if (classCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a category."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (classname == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select book condition."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (classn == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select Exchange or Sell."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!valuef) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please confirm that the information is correct."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Default values are used for an Exchange book.
    String bookPrice = "Exchange";
    double originalPrice = 0;
    double bookDiscount = 0;

    // If the user selected Sell, calculate and store the selling details.
    if (classn == "Sell") {
      final double? price = double.tryParse(priceController.text.trim());
      final double? discount =
      double.tryParse(discountController.text.trim());

      if (price == null || price <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please enter a valid original price."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (discount == null || discount < 0 || discount > 100) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Discount must be between 0 and 100."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (finalPrice <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please click CALCULATE PRICE first."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Save the original price and discount so that
      // BookDetailsPage can display them later.
      originalPrice = price;
      bookDiscount = discount;

      // Store the final price after discount.
      bookPrice = "₹${finalPrice.toStringAsFixed(2)}";
    }

    // Create the Book object with all the information entered by the user.
    final Book newBook = Book(
      name: bookNameController.text.trim(),
      category: classCategory!,
      price: bookPrice,
      condition: classname!,
      description: descriptionController.text.trim(),
      author: authorController.text.trim(),

      // Save Sell/Exchange information inside the Book object.
      availableFor: classn!,
      originalPrice: originalPrice,
      discount: bookDiscount,

      // Save the currently logged-in user's email as the book owner.
      ownerEmail: currentUser?.email ?? "",
    );

    books.add(newBook);

    setState(() {
      discountAmount = 0;
      finalPrice = 0;
      bookNameController.clear();
      authorController.clear();
      descriptionController.clear();
      priceController.clear();
      discountController.clear();
      classname = null;
      classn = null;
      classCategory = null;
      valuef = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Book added successfully!"),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Book"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: bookNameController,
                decoration: InputDecoration(
                  labelText: "Book Name",
                  prefixIcon: const Icon(Icons.menu_book, color: Colors.pink),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter book name";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: authorController,
                decoration: InputDecoration(
                  labelText: "Author",
                  prefixIcon: const Icon(Icons.person, color: Colors.pink),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter author name";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: "Book Description",
                  hintText: "Enter details about the book...",
                  alignLabelWithHint: true,
                  prefixIcon: const Icon(Icons.description, color: Colors.pink),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter book description";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: classCategory,
                decoration: InputDecoration(
                  labelText: "Select Category",
                  prefixIcon: const Icon(Icons.category, color: Colors.pink),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: "IT", child: Text("IT")),
                  DropdownMenuItem(value: "Maths", child: Text("Maths")),
                  DropdownMenuItem(value: "Novel", child: Text("Novel")),
                ],
                onChanged: (value) {
                  setState(() {
                    classCategory = value;
                  });
                },
              ),

              const SizedBox(height: 20),

              const Text(
                "Book Condition",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),

              RadioGroup<String>(
                groupValue: classname,
                onChanged: (value) {
                  setState(() {
                    classname = value;
                  });
                },
                child: Column(
                  children: const [
                    RadioListTile<String>(title: Text("New"), value: "New"),
                    RadioListTile<String>(title: Text("Good"), value: "Good"),
                    RadioListTile<String>(
                      title: Text("Excellent"),
                      value: "Excellent",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Available For",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),

              RadioGroup<String>(
                groupValue: classn,
                onChanged: (value) {
                  setState(() {
                    classn = value;
                    if (value != "Sell") {
                      discountAmount = 0;
                      finalPrice = 0;
                      priceController.clear();
                      discountController.clear();
                    }
                  });
                },
                child: Column(
                  children: const [
                    RadioListTile<String>(
                      title: Text("Exchange"),
                      value: "Exchange",
                    ),
                    RadioListTile<String>(
                      title: Text("Sell"),
                      value: "Sell",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              if (classn == "Sell") ...[
                TextFormField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => resetCalculatedPrice(),
                  decoration: InputDecoration(
                    labelText: "Original Price",
                    prefixIcon: const Icon(
                      Icons.currency_rupee,
                      color: Colors.pink,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (classn != "Sell") return null;
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter price";
                    }
                    final double? price = double.tryParse(value.trim());
                    if (price == null || price <= 0) {
                      return "Enter valid price";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: discountController,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => resetCalculatedPrice(),
                  decoration: InputDecoration(
                    labelText: "Discount (%)",
                    prefixIcon: const Icon(Icons.discount, color: Colors.pink),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (classn != "Sell") return null;
                    if (value == null || value.trim().isEmpty) {
                      return "Enter discount";
                    }
                    final double? discount = double.tryParse(value.trim());
                    if (discount == null || discount < 0 || discount > 100) {
                      return "Enter discount between 0-100";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 15),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: calculatePrice,
                    child: const Text("CALCULATE PRICE"),
                  ),
                ),

                const SizedBox(height: 15),

                if (finalPrice > 0)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Discount: ₹${discountAmount.toStringAsFixed(2)}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Final Price: ₹${finalPrice.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 15),
              ],

              CheckboxListTile(
                title: const Text(
                  "I confirm that the information provided is correct.",
                ),
                value: valuef,
                onChanged: (value) {
                  setState(() {
                    valuef = value ?? false;
                  });
                },
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: addBook,
                  icon: const Icon(Icons.add),
                  label: const Text(
                    "ADD BOOK",
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}


// ============================================================
// BROWSE BOOKS
// ============================================================

class BrowseBooks
    extends StatefulWidget {
  const BrowseBooks({super.key});

  @override
  State<BrowseBooks> createState() =>
      _BrowseBooksState();
}

class _BrowseBooksState
    extends State<BrowseBooks> {
  final TextEditingController
  searchController =
  TextEditingController();

  String searchText = "";

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Book> filteredBooks =
    books.where((book) {
      return book.name
          .toLowerCase()
          .contains(
        searchText.toLowerCase(),
      ) ||
          book.category
              .toLowerCase()
              .contains(
            searchText.toLowerCase(),
          ) ||
          book.condition
              .toLowerCase()
              .contains(
            searchText.toLowerCase(),
          );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title:
        const Text("Browse Books"),
      ),
      body: Column(
        children: [
// ------------------------------------------------
// SEARCH BAR
// ------------------------------------------------

          Padding(
            padding:
            const EdgeInsets.all(15),
            child: TextField(
              controller:
              searchController,
              onChanged: (value) {
                setState(() {
                  searchText =
                      value.trim();
                });
              },
              decoration:
              InputDecoration(
                hintText:
                "Search books.jpeg...",
                prefixIcon:
                const Icon(
                  Icons.search,
                ),
                suffixIcon:
                searchText.isNotEmpty
                    ? IconButton(
                  icon:
                  const Icon(
                    Icons.clear,
                  ),
                  onPressed: () {
                    searchController
                        .clear();

                    setState(() {
                      searchText =
                      "";
                    });
                  },
                )
                    : null,
                filled: true,
                fillColor:
                Colors.white,
                border:
                OutlineInputBorder(
                  borderRadius:
                  BorderRadius
                      .circular(
                    15,
                  ),
                ),
              ),
            ),
          ),

// ------------------------------------------------
// BOOK LIST
// ------------------------------------------------

          Expanded(
            child: filteredBooks
                .isEmpty
                ? const Center(
              child: Text(
                "No books.jpeg found.",
                style:
                TextStyle(
                  fontSize: 18,
                ),
              ),
            )
                : ListView.builder(
              padding:
              const EdgeInsets
                  .symmetric(
                horizontal: 15,
              ),
              itemCount:
              filteredBooks
                  .length,
              itemBuilder:
                  (context, index) {
                Book book =
                filteredBooks[
                index];

                return Card(
                  margin:
                  const EdgeInsets
                      .only(
                    bottom: 15,
                  ),
                  child:
                  ListTile(
                    leading:
                    const CircleAvatar(
                      child:
                      Icon(
                        Icons.book,
                      ),
                    ),
                    title:
                    Text(
                      book.name,
                    ),
                    subtitle:
                    Text(
                      "${book.category} • ${book.condition}",
                    ),
                    trailing:
                    Text(
                      book.price,
                      style:
                      const TextStyle(
                        color:
                        Colors.green,
                        fontWeight:
                        FontWeight
                            .bold,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                              BookDetailsPage(
                                book:
                                book,
                              ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// WISHLIST
// ============================================================

class Wishlist
    extends StatefulWidget {
  const Wishlist({super.key});

  @override
  State<Wishlist> createState() =>
      _WishlistState();
}

class _WishlistState
    extends State<Wishlist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
        const Text("Wishlist"),
        centerTitle: true,
      ),
      body: wishlistBooks.isEmpty
          ? const Center(
        child: Text(
          "Your wishlist is empty.",
          style:
          TextStyle(
            fontSize: 18,
          ),
        ),
      )
          : ListView.builder(
        padding:
        const EdgeInsets.all(
          15,
        ),
        itemCount:
        wishlistBooks.length,
        itemBuilder:
            (context, index) {
          Book book =
          wishlistBooks[index];

          return Card(
            child: ListTile(
              leading:
              const Icon(
                Icons.menu_book,
                color:
                Colors.pink,
              ),
              title:
              Text(book.name),
              subtitle: Text(
                "${book.category} • ${book.condition}",
              ),
              trailing:
              ElevatedButton(
                onPressed: () {
                  if (!exchangeRequests
                      .contains(
                    book,
                  )) {
                    exchangeRequests
                        .add(book);
                  }

                  ScaffoldMessenger
                      .of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Exchange request sent!",
                      ),
                      backgroundColor:
                      Colors.green,
                    ),
                  );

                  setState(() {});
                },
                child:
                const Text(
                  "Exchange",
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ============================================================
// PROFILE
// ============================================================

class Profile
    extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() =>
      _ProfileState();
}

class _ProfileState
    extends State<Profile> {

  int get booksAdded {
    int count =
        books.length -
            defaultBooks.length;

    return count < 0 ? 0 : count;
  }

  void showMyBooks() {
    List<Book> myBooks = [];

    if (books.length > defaultBooks.length) {
      myBooks = books
          .skip(defaultBooks.length)
          .toList();
    }

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SizedBox(
          height: 500,
          child: Padding(
            padding:
            const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                const Text(
                  "My Books",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                Expanded(
                  child: myBooks.isEmpty
                      ? const Center(
                    child: Text(
                      "You have not added any books.jpeg yet.",
                      style:
                      TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  )
                      : ListView.builder(
                    itemCount:
                    myBooks.length,
                    itemBuilder:
                        (context, index) {
                      Book book =
                      myBooks[index];

                      return Card(
                        child: ListTile(
                          leading:
                          const Icon(
                            Icons.menu_book,
                            color:
                            Colors.pink,
                          ),
                          title:
                          Text(
                            book.name,
                            style:
                            const TextStyle(
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            "${book.category} • ${book.condition}\n${book.description}",
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing:
                          Text(
                            book.price,
                            style:
                            const TextStyle(
                              color:
                              Colors.green,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showExchangeRequests() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SizedBox(
          height: 500,
          child: Padding(
            padding:
            const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                const Text(
                  "Exchange Requests",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                Expanded(
                  child: exchangeRequests
                      .isEmpty
                      ? const Center(
                    child: Text(
                      "No exchange requests yet.",
                      style:
                      TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  )
                      : ListView.builder(
                    itemCount:
                    exchangeRequests
                        .length,
                    itemBuilder:
                        (context, index) {
                      Book book =
                      exchangeRequests[
                      index];

                      return Card(
                        child: ListTile(
                          leading:
                          const Icon(
                            Icons.swap_horiz,
                            color:
                            Colors.pink,
                          ),
                          title:
                          Text(
                            book.name,
                            style:
                            const TextStyle(
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            "${book.category} • ${book.condition}\n${book.description}",
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing:
                          const Text(
                            "Requested",
                            style:
                            TextStyle(
                              color:
                              Colors.orange,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showWishlist() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SizedBox(
          height: 500,
          child: Padding(
            padding:
            const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                const Text(
                  "My Wishlist",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                Expanded(
                  child: wishlistBooks
                      .isEmpty
                      ? const Center(
                    child: Text(
                      "Your wishlist is empty.",
                      style:
                      TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  )
                      : ListView.builder(
                    itemCount:
                    wishlistBooks
                        .length,
                    itemBuilder:
                        (context, index) {
                      Book book =
                      wishlistBooks[
                      index];

                      return Card(
                        child: ListTile(
                          leading:
                          const Icon(
                            Icons.favorite,
                            color:
                            Colors.pink,
                          ),
                          title:
                          Text(
                            book.name,
                            style:
                            const TextStyle(
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            "${book.category} • ${book.condition}\n${book.description}",
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing:
                          Text(
                            book.price,
                            style:
                            const TextStyle(
                              color:
                              Colors.green,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showExchangeHistory() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Exchange History",
          ),
          content: exchangeRequests.isEmpty
              ? const Text(
            "No previous exchange records are available yet.",
          )
              : Column(
            mainAxisSize:
            MainAxisSize.min,
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              const Text(
                "Current exchange requests:",
                style:
                TextStyle(
                  fontWeight:
                  FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ...exchangeRequests.map(
                    (book) => Padding(
                  padding:
                  const EdgeInsets.only(
                    bottom: 8,
                  ),
                  child: Text(
                    "• ${book.name}",
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(context),
              child: const Text("CLOSE"),
            ),
          ],
        );
      },
    );
  }

  void editProfile() {
    if (currentUser == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Please login first.",
          ),
        ),
      );
      return;
    }

    final nameController =
    TextEditingController(
      text: currentUser!.name,
    );

    final emailController =
    TextEditingController(
      text: currentUser!.email,
    );

    String selectedCategory =
        currentUser!.category;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder:
              (dialogContext, setDialogState) {
            return AlertDialog(
              title: const Text(
                "Edit Profile",
              ),
              content:
              SingleChildScrollView(
                child: Column(
                  mainAxisSize:
                  MainAxisSize.min,
                  children: [
                    TextField(
                      controller:
                      nameController,
                      decoration:
                      const InputDecoration(
                        labelText: "Name",
                        prefixIcon:
                        Icon(Icons.person),
                      ),
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    TextField(
                      controller:
                      emailController,
                      keyboardType:
                      TextInputType
                          .emailAddress,
                      decoration:
                      const InputDecoration(
                        labelText: "Email",
                        prefixIcon:
                        Icon(Icons.email),
                      ),
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    DropdownButtonFormField<
                        String>(
                      initialValue:
                      selectedCategory,
                      decoration:
                      const InputDecoration(
                        labelText:
                        "Account Type",
                        prefixIcon:
                        Icon(Icons.school),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: "Student",
                          child:
                          Text("Student"),
                        ),
                        DropdownMenuItem(
                          value: "Other",
                          child:
                          Text("Other"),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            selectedCategory =
                                value;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () =>
                      Navigator.pop(
                        dialogContext,
                      ),
                  child: const Text(
                    "CANCEL",
                  ),
                ),

                ElevatedButton(
                  onPressed: () {
                    String newName =
                    nameController.text
                        .trim();

                    String newEmail =
                    emailController.text
                        .trim();

                    if (newName.isEmpty ||
                        newEmail.isEmpty) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Name and email cannot be empty.",
                          ),
                          backgroundColor:
                          Colors.red,
                        ),
                      );
                      return;
                    }

                    if (!newEmail.contains(
                        "@")) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Enter a valid email.",
                          ),
                          backgroundColor:
                          Colors.red,
                        ),
                      );
                      return;
                    }

                    bool duplicateEmail =
                    registeredUsers.any(
                          (user) =>
                      user !=
                          currentUser &&
                          user.email
                              .toLowerCase() ==
                              newEmail
                                  .toLowerCase(),
                    );

                    if (duplicateEmail) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "This email is already registered.",
                          ),
                          backgroundColor:
                          Colors.red,
                        ),
                      );
                      return;
                    }

                    setState(() {
                      currentUser!.name =
                          newName;
                      currentUser!.email =
                          newEmail;
                      currentUser!.category =
                          selectedCategory;
                    });

                    Navigator.pop(
                      dialogContext,
                    );

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Profile updated successfully!",
                        ),
                        backgroundColor:
                        Colors.green,
                      ),
                    );
                  },
                  child: const Text(
                    "SAVE",
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void confirmLogout() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            "Logout",
          ),
          content: const Text(
            "Are you sure you want to logout?",
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(
                    dialogContext,
                  ),
              child: const Text(
                "CANCEL",
              ),
            ),

            ElevatedButton(
              onPressed: () {
                currentUser = null;

                Navigator.pop(
                  dialogContext,
                );

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const LoginPage(),
                  ),
                      (route) => false,
                );
              },
              child: const Text(
                "LOGOUT",
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String userName =
        currentUser?.name ??
            "Guest";

    String userEmail =
        currentUser?.email ??
            "No email";

    String userCategory =
        currentUser?.category ??
            "BookLoop User";

    return Scaffold(
      appBar: AppBar(
        title:
        const Text("Profile"),
        centerTitle: true,
      ),

      body: ListView(
        padding:
        const EdgeInsets.all(20),
        children: [
// ------------------------------------------------
// PROFILE HEADER
// ------------------------------------------------

          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor:
              Colors.pink.shade100,
              child: const Icon(
                Icons.person,
                size: 55,
                color: Colors.pink,
              ),
            ),
          ),

          const SizedBox(
            height: 15,
          ),

          Center(
            child: Text(
              userName,
              style:
              const TextStyle(
                fontSize: 25,
                fontWeight:
                FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(
            height: 5,
          ),

          Center(
            child: Text(
              userEmail,
              style:
              const TextStyle(
                fontSize: 15,
              ),
            ),
          ),

          const SizedBox(
            height: 5,
          ),

          Center(
            child: Text(
              userCategory,
              style:
              const TextStyle(
                color: Colors.pink,
                fontWeight:
                FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(
            height: 15,
          ),

          OutlinedButton.icon(
            onPressed: editProfile,
            icon: const Icon(
              Icons.edit,
            ),
            label: const Text(
              "EDIT PROFILE",
            ),
          ),

          const SizedBox(
            height: 25,
          ),

// ------------------------------------------------
// ACTIVITY DASHBOARD
// ------------------------------------------------

          const Text(
            "Activity",
            style:
            TextStyle(
              fontSize: 21,
              fontWeight:
              FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 15,
          ),

          Card(
            child: ListTile(
              onTap:
              showExchangeRequests,
              leading:
              const Icon(
                Icons.swap_horiz,
                color: Colors.pink,
              ),
              title:
              const Text(
                "Exchange Requests",
              ),
              subtitle:
              const Text(
                "View your current requests",
              ),
              trailing:
              Text(
                "${exchangeRequests.length}",
                style:
                const TextStyle(
                  fontWeight:
                  FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ),
          ),

          Card(
            child: ListTile(
              onTap:
              showMyBooks,
              leading:
              const Icon(
                Icons.book,
                color: Colors.pink,
              ),
              title:
              const Text(
                "My Books",
              ),
              subtitle:
              const Text(
                "Books added by you",
              ),
              trailing:
              Text(
                "$booksAdded",
                style:
                const TextStyle(
                  fontWeight:
                  FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ),
          ),

          Card(
            child: ListTile(
              onTap:
              showWishlist,
              leading:
              const Icon(
                Icons.favorite,
                color: Colors.pink,
              ),
              title:
              const Text(
                "My Wishlist",
              ),
              subtitle:
              const Text(
                "Books saved for later",
              ),
              trailing:
              Text(
                "${wishlistBooks.length}",
                style:
                const TextStyle(
                  fontWeight:
                  FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ),
          ),

          const SizedBox(
            height: 20,
          ),

// ------------------------------------------------
// HISTORY
// ------------------------------------------------

          const Text(
            "History",
            style:
            TextStyle(
              fontSize: 21,
              fontWeight:
              FontWeight.bold,
            ),
          ),

          Card(
            child: ListTile(
              onTap:
              showExchangeHistory,
              leading:
              const Icon(
                Icons.history,
                color: Colors.pink,
              ),
              title:
              const Text(
                "Exchange History",
              ),
              subtitle:
              const Text(
                "View exchange activity",
              ),
              trailing:
              const Icon(
                Icons.arrow_forward_ios,
                size: 17,
              ),
            ),
          ),

          const SizedBox(
            height: 20,
          ),

// ------------------------------------------------
// SETTINGS
// ------------------------------------------------

          const Text(
            "Settings",
            style:
            TextStyle(
              fontSize: 21,
              fontWeight:
              FontWeight.bold,
            ),
          ),

          RadioGroup<String>(
            groupValue:
            appThemeMode.value == ThemeMode.light ? "Light" : "Dark",
            onChanged: (value) {
              if (value == "Light") {
                appThemeMode.value = ThemeMode.light;
              } else if (value == "Dark") {
                appThemeMode.value = ThemeMode.dark;
              }
              setState(() {});
            },
            child: Column(
              children: const [
                RadioListTile<String>(
                  title: Text("Light"),
                  secondary: Icon(Icons.light_mode),
                  value: "Light",
                ),
                RadioListTile<String>(
                  title: Text("Dark"),
                  secondary: Icon(Icons.dark_mode),
                  value: "Dark",
                ),
              ],
            ),
          ),

          SwitchListTile(
            title:
            const Text(
              "Notifications",
            ),
            subtitle: Text(
              notificationsEnabled
                  ? "Notifications are enabled"
                  : "Notifications are disabled",
            ),
            secondary:
            const Icon(
              Icons.notifications,
            ),
            value:
            notificationsEnabled,
            onChanged: (value) {
              setState(() {
                notificationsEnabled =
                    value;
              });

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(
                SnackBar(
                  content: Text(
                    notificationsEnabled
                        ? "Notifications enabled"
                        : "Notifications disabled",
                  ),
                ),
              );
            },
          ),

          const SizedBox(
            height: 20,
          ),

// ------------------------------------------------
// LOGOUT
// ------------------------------------------------

          ElevatedButton.icon(
            onPressed:
            confirmLogout,
            icon:
            const Icon(
              Icons.logout,
            ),
            label:
            const Text(
              "LOGOUT",
            ),
          ),

          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

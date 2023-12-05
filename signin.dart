@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
        centerTitle: true,
        backgroundColor: cyan,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          )
        )
      ),

      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(

          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Image.asset(
                'assets/images/logo3.png',
                width: 100,
                fit: BoxFit.contain,
              ),
            ),

            Expanded(
            child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                       controller: _emailController,
                        style: TextStyle(
                         color: orange
                         ),
                        decoration: InputDecoration(
                         labelText: 'Email',
                         icon: Icon(
                             Icons.person,
                             color: orange
                         ),
                          labelStyle: TextStyle(
                              color: pink
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.pink),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                        TextField(
                          controller: _passwordController,
                          style: TextStyle(
                              color: orange
                          ),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            icon: Icon(
                                Icons.lock,
                                color: orange
                            ),
                            labelStyle: TextStyle(
                                color: pink
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.pink),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.0),
                        ElevatedButton(
                            style: buttonPrimary,
                            onPressed: _signIn,
                            child: const Text('Sign In.')
                        ),
                        SizedBox(height: 16.0),
                        CustomText(
                            text: _message,
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            )
                          ],
                         ),
                      ),
                    )
          ],
        ),
      ),
    );
  }
}

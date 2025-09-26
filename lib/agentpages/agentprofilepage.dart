import 'package:flutter/material.dart';

class prifilepage extends StatelessWidget {
  const prifilepage({super.key});

  @override
  Widget build(BuildContext context) {
    return  profilebody();
  }
}



class profilebody extends StatefulWidget {
  const profilebody({super.key});

  @override
  State<profilebody> createState() => _profilebodyState();
}

class _profilebodyState extends State<profilebody> {

  void showUserFormDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController fatherNameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController mobileController = TextEditingController();
    final TextEditingController pancardController = TextEditingController();
    final TextEditingController aadharController = TextEditingController();
    final TextEditingController accountnumController = TextEditingController();
    final TextEditingController ifsccodeController = TextEditingController();



    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(

              insetPadding: EdgeInsets.zero, // 👈 removes default margins
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: Column(

                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.black54),
                          iconSize: 20,
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Edit Your Profile",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Modify your personal and bank details.Critical",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.green, fontSize: 14.0),
                        ),
                        Text(
                          "changes will require OTP verification.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.green, fontSize: 14.0),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),

                    // 👇 scrollable form
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Name"),
                              SizedBox(height: 6.0),
                              TextField(
                                controller: nameController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors
                                          .green, // 👈 border color when clicked/focused
                                      width: 2.0,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, // 👈 height of TextField
                                    horizontal: 20,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10),
                              Text("Father's Name"),
                              SizedBox(height: 6.0),
                              TextField(
                                controller: fatherNameController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors
                                          .green, // 👈 border color when clicked/focused
                                      width: 2.0,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, // 👈 height of TextField
                                    horizontal: 20,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10),
                              Text("Email (Cannot be changed)"),
                              SizedBox(height: 6.0),
                              TextField(
                                controller: emailController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors
                                          .green, // 👈 border color when clicked/focused
                                      width: 2.0,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, // 👈 height of TextField
                                    horizontal: 20,
                                  ),
                                ),
                              ),

                              SizedBox(height: 10.0),
                              Text("Mobile"),
                              SizedBox(height: 6.0),
                              TextField(
                                controller: mobileController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors
                                          .green, // 👈 border color when clicked/focused
                                      width: 2.0,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, // 👈 height of TextField
                                    horizontal: 20,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10),
                              Text("PAN Card"),
                              SizedBox(height: 6.0),
                              TextField(
                                controller: pancardController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors
                                          .green, // 👈 border color when clicked/focused
                                      width: 2.0,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, // 👈 height of TextField
                                    horizontal: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text("Aadhar Number"),
                              SizedBox(height: 6.0),
                              TextField(
                                controller: aadharController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors
                                          .green, // 👈 border color when clicked/focused
                                      width: 2.0,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, // 👈 height of TextField
                                    horizontal: 20,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10),
                              Text("Bank Account Number"),
                              SizedBox(height: 6.0),
                              TextField(
                                controller: accountnumController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors
                                          .green, // 👈 border color when clicked/focused
                                      width: 2.0,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, // 👈 height of TextField
                                    horizontal: 20,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10),
                              Text("IFSC Code"),
                              SizedBox(height: 6.0),
                              TextField(
                                controller: ifsccodeController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors
                                          .green, // 👈 border color when clicked/focused
                                      width: 2.0,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, // 👈 height of TextField
                                    horizontal: 20,
                                  ),
                                ),
                              ),

                              SizedBox(height: 20),
                              SizedBox(
                                width:
                                double.infinity, // take full available width
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors
                                        .green, // 👈 button background color
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        12,
                                      ), // 👈 border radius
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ), // taller button
                                  ),
                                  onPressed: () {
                                    print("Name: ${nameController.text}");
                                    print(
                                      "Father Name: ${fatherNameController.text}",
                                    );
                                    print("Email: ${emailController.text}");
                                    print("Mobile: ${mobileController.text}");
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Save Changes"),
                                ),
                              ),
                              SizedBox(height: 10),
                              SizedBox(
                                width:
                                double.infinity, // take full available width
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors
                                        .white, // 👈 button background color
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        12,
                                      ), // 👈 border radius
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ), // taller button
                                  ),
                                  onPressed: () {
                                    print("Name: ${nameController.text}");
                                    print(
                                      "Father Name: ${fatherNameController.text}",
                                    );
                                    print("Email: ${emailController.text}");
                                    print("Mobile: ${mobileController.text}");
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Cancel",style: TextStyle(color: Colors.black),),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context); // Go back to previous page
                      },
                      child: Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12, width: 1.0),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            5.0,
                          ), // Uniform radius for all corners
                        ),
                        child: Container(
                          height: 8,
                          child: Image.asset(
                            'lib/icons/back-arrow.png',
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20.0),
                    Text(
                      "My Profile",
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30.0),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white, // background color
                    border: Border.all(
                      color: Colors.grey, // border color
                      width: 1, // border thickness
                    ),
                    borderRadius: BorderRadius.circular(20), // 👈 circular border radius
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Agent Information",style: TextStyle(color: Colors.black,fontSize: 26.0,fontWeight: FontWeight.bold),),
                        Text("Your personal and professional information",
                          style: TextStyle(color: Colors.green,fontSize: 16.0),),
                        SizedBox(height: 20.0),
                          Container(
                            height: 210,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white, // background color
                              border: Border.all(
                                color: Colors.grey, // border color
                                width: 1, // border thickness
                              ),
                              borderRadius: BorderRadius.circular(10), // 👈 circular border radius
                            ),
                            child:
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text("#",
                                              style: TextStyle(color: Colors.green,fontSize: 14.0),),
                                            SizedBox(width: 10.0),
                                            Text("Agent ID",
                                              style: TextStyle(color: Colors.green,fontSize: 14.0),),
                                          ],
                                        ),
                                        Text("svd-st-01",
                                          style: TextStyle(color: Colors.black,fontSize: 14.0,fontWeight: FontWeight.bold),),

                                      ],
                                    ),
                                     SizedBox(height: 10.0),
                                    Divider(
                                      thickness: 0.3,
                                      color: Colors.grey,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              height: 14,
                                              child: Image.asset(
                                                'lib/icons/profile.png',
                                                color: Colors.green,
                                              ),
                                            ),
                                            SizedBox(width: 10.0),
                                            Text("Name",
                                              style: TextStyle(color: Colors.green,fontSize: 14.0),),
                                          ],
                                        ),
                                        Text("chinnala srikanth",
                                          style: TextStyle(color: Colors.black,fontSize: 14.0,fontWeight: FontWeight.bold),),

                                      ],
                                    ),
                                    SizedBox(height: 10.0),
                                    Divider(
                                      thickness: 0.3,
                                      color: Colors.grey,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              height: 14,
                                              child: Image.asset(
                                                'lib/icons/profile.png',
                                                color: Colors.green,
                                              ),
                                            ),
                                            SizedBox(width: 10.0),
                                            Text("Father's Name",
                                              style: TextStyle(color: Colors.green,fontSize: 14.0),),
                                          ],
                                        ),
                                        Text("chinnala kistaiah",
                                          style: TextStyle(color: Colors.black,fontSize: 14.0,fontWeight: FontWeight.bold),),

                                      ],
                                    ),
                                    SizedBox(height: 10.0),
                                    Divider(
                                      thickness: 0.3,
                                      color: Colors.grey,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              height: 14,
                                              child: Image.asset(
                                                'lib/icons/telephone.png',
                                                color: Colors.green,
                                              ),
                                            ),
                                            SizedBox(width: 10.0),
                                            Text("Mobile Number",
                                              style: TextStyle(color: Colors.green,fontSize: 14.0),),
                                          ],
                                        ),
                                        Text("960329998",
                                          style: TextStyle(color: Colors.black,fontSize: 14.0,fontWeight: FontWeight.bold),),

                                      ],
                                    ),
                                    SizedBox(height: 10.0),
                                    Divider(
                                      thickness: 0.3,
                                      color: Colors.grey,
                                    ),

                                  ],

                                ),
                              ),

                          ),
                        SizedBox(height: 20.0),
                        Container(
                          height: 210,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white, // background color
                            border: Border.all(
                              color: Colors.grey, // border color
                              width: 1, // border thickness
                            ),
                            borderRadius: BorderRadius.circular(10), // 👈 circular border radius
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 14,
                                          child: Image.asset(
                                            'lib/icons/driving.png',
                                            color: Colors.green,
                                          ),
                                        ),
                                        SizedBox(width: 10.0),
                                        Text("Aadhar Number",
                                          style: TextStyle(color: Colors.green,fontSize: 14.0),),
                                      ],
                                    ),
                                    Text("456724548971",
                                      style: TextStyle(color: Colors.black,fontSize: 14.0,fontWeight: FontWeight.bold),),

                                  ],
                                ),
                                SizedBox(height: 10.0),
                                Divider(
                                  thickness: 0.3,
                                  color: Colors.grey,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 14,
                                          child: Image.asset(
                                            'lib/icons/card.png',
                                            color: Colors.green,
                                          ),
                                        ),
                                        SizedBox(width: 10.0),
                                        Text("PAN Card",
                                          style: TextStyle(color: Colors.green,fontSize: 14.0),),
                                      ],
                                    ),
                                    Text("ASIPC8975E",
                                      style: TextStyle(color: Colors.black,fontSize: 14.0,fontWeight: FontWeight.bold),),

                                  ],
                                ),
                                SizedBox(height: 10.0),
                                Divider(
                                  thickness: 0.3,
                                  color: Colors.grey,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 14,
                                          child: Image.asset(
                                            'lib/icons/rupee.png',
                                            color: Colors.green,
                                          ),
                                        ),
                                        SizedBox(width: 10.0),
                                        Text("Account Number",
                                          style: TextStyle(color: Colors.green,fontSize: 14.0),),
                                      ],
                                    ),
                                    Text("99996457998734",
                                      style: TextStyle(color: Colors.black,fontSize: 14.0,fontWeight: FontWeight.bold),),

                                  ],
                                ),
                                SizedBox(height: 10.0),
                                Divider(
                                  thickness: 0.3,
                                  color: Colors.grey,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 14,
                                          child: Image.asset(
                                            'lib/icons/rupee.png',
                                            color: Colors.green,
                                          ),
                                        ),
                                        SizedBox(width: 10.0),
                                        Text("IFSC Code",
                                          style: TextStyle(color: Colors.green,fontSize: 14.0),),
                                      ],
                                    ),
                                    Text("HDFC0000518",
                                      style: TextStyle(color: Colors.black,fontSize: 14.0,fontWeight: FontWeight.bold),),

                                  ],
                                ),
                                SizedBox(height: 10.0),
                                Divider(
                                  thickness: 0.3,
                                  color: Colors.grey,
                                ),

                              ],

                            ),
                          ),

                        ),

                        SizedBox(height: 20.0),
                        SizedBox(
                          width:
                          double.infinity, // take full available width
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors
                                  .lightGreen, // 👈 button background color
                              foregroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  5,
                                ), // 👈 border radius
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                              ), // taller button
                            ),
                            onPressed: () {

                                showUserFormDialog(context);

                            },
                            child:  Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 15.0,
                                  child: Image.asset(
                                    "lib/icons/edit-button.png",
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                Text("Edit Profile",style: TextStyle(color: Colors.black,fontSize: 15.0),),
                              ],
                            ),
                          ),
                        ),

                      ],

                    ),
                  ),

                ),



              ],
            ),
          ),
        ),
      ),
    );
  }
}

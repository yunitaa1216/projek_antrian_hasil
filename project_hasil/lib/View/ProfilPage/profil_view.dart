// profil_view.dart

import 'package:flutter/material.dart';
import 'package:project_hasil/View/Widget/sidebar_widget.dart';

class ProfilView extends StatefulWidget {
  const ProfilView({super.key});

  @override
  State<ProfilView> createState() => _ProfilViewState();
}

class _ProfilViewState extends State<ProfilView> {

  bool isSidebarOpen = true;

  final TextEditingController usernameController =
      TextEditingController();

  final TextEditingController alamatController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Row(
        children: [

          /// SIDEBAR
          if (isSidebarOpen)
            SidebarWidget(
              isSidebarOpen: isSidebarOpen,
              activeMenu: "Profil",
              onClose: () {
                setState(() {
                  isSidebarOpen = false;
                });
              },
            ),

          /// MAIN CONTENT
          Expanded(
            child: Container(
              color: const Color(0xFFF5F6FA),
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  /// HEADER
                  Row(
                    children: [

                      if (!isSidebarOpen)
                        IconButton(
                          icon:
                              SidebarWidget.customGridIcon(),
                          onPressed: () {
                            setState(() {
                              isSidebarOpen = true;
                            });
                          },
                        ),

                      const Text(
                        "Profil",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Spacer(),

                      const Icon(
                        Icons.notifications,
                        color: Colors.indigo,
                      ),

                      const SizedBox(width: 20),

                      const CircleAvatar(
                        radius: 18,
                        backgroundImage: NetworkImage(
                          "https://i.pravatar.cc/300",
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  /// BREADCRUMB
                  Row(
                    children: const [

                      Icon(
                        Icons.home,
                        size: 15,
                        color: Colors.indigo,
                      ),

                      SizedBox(width: 5),

                      Text(
                        "/",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),

                      SizedBox(width: 5),

                      Text(
                        "Profil",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  /// TITLE
                  const Text(
                    "Pengaturan Akun",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// FORM
                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      /// INPUT AREA
                      Expanded(
                        child: Row(
                          children: [

                            /// USERNAME
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [

                                  const Text(
                                    "Username",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  TextField(
                                    controller:
                                        usernameController,
                                    decoration:
                                        InputDecoration(
                                      hintText:
                                          "Username",

                                      prefixIcon: const Icon(
                                        Icons.person_outline,
                                      ),

                                      filled: true,
                                      fillColor:
                                          const Color(
                                        0xFFE9EEF9,
                                      ),

                                      border:
                                          OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius
                                                .circular(
                                                    10),
                                        borderSide:
                                            BorderSide
                                                .none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 25),

                            /// ALAMAT
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [

                                  const Text(
                                    "Alamat",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  TextField(
                                    controller:
                                        alamatController,
                                    decoration:
                                        InputDecoration(
                                      hintText:
                                          "Alamat",

                                      prefixIcon: const Icon(
                                        Icons.location_on_outlined,
                                      ),

                                      filled: true,
                                      fillColor:
                                          const Color(
                                        0xFFE9EEF9,
                                      ),

                                      border:
                                          OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius
                                                .circular(
                                                    10),
                                        borderSide:
                                            BorderSide
                                                .none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 50),

                      /// FOTO PROFILE
                      Column(
                        children: [

                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(
                                0xFF6777EF,
                              ),
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 18,
                              ),
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                        10),
                              ),
                            ),
                            child: const Text(
                              "Edit",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),

                          const SizedBox(height: 25),

                          Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(
                                      15),
                              image:
                                  const DecorationImage(
                                image: NetworkImage(
                                  "https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=400",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
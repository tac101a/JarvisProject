import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jarvis_project/services/auth_service.dart';
import '../models/user_model.dart';

class Sidebar extends StatefulWidget {
  final Function(int) onIconTap;
  final int currentIndex;

  const Sidebar(
      {super.key, required this.onIconTap, required this.currentIndex});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  // service
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return
      Container(
        width: 62,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 120, 212, 0.1),
              offset: Offset(0, 3),
              blurRadius: 25,
            ),
            BoxShadow(
              color: Color.fromRGBO(12, 145, 235, 0.1),
              offset: Offset(0, 1),
              blurRadius: 6,
            ),
          ],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  // Main icons
                  const SizedBox(height: 100),
                  _buildIcon(0, Icons.chat_bubble, 'Chat'),
                  _buildIcon(1, Icons.smart_toy, 'Assistant'),
                  _buildIcon(2, Icons.edit_note, 'Prompt'),
                  _buildIcon(3, Icons.menu_book, 'KB Store'),
                  _buildIcon(4, Icons.mail, 'AI Mail'),
                ],
              ),
            )),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Handle extra icon press
                      context.go('/account');
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F8FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.settings,
                          color: Color(0xFF475569),
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      )
    ;
  }

  Widget _buildIcon(int index, IconData icon, String label) {
    final bool isSelected = widget.currentIndex == index;

    return GestureDetector(
      onTap: () {
        widget.onIconTap(index);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.blue : Colors.grey,
              size: 22,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.blue : Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showOverlay(BuildContext context) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    void removeOverlay() {
      overlayEntry.remove();
    }

    overlayEntry = OverlayEntry(
        builder: (context) =>
            Stack(
              children: [
                // trans background to click outside and close overlay
                GestureDetector(
                  onTap: removeOverlay,
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
                Positioned(
                    bottom: 50.0,
                    right: 20.0,
                    child: GestureDetector(
                      onTap: () {},
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.0),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10.0,
                                      spreadRadius: 2.0)
                                ]),
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    CircleAvatar(
                                        radius: 20,
                                        backgroundImage: AssetImage(
                                            'lib/assets/avatar.jpg')),
                                    SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "AI Jarvis",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        Text(
                                          "myjarvischat@gmail.com",
                                          style: TextStyle(color: Colors.grey),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      removeOverlay();
                                      context.go('/account');
                                    },
                                    child: const Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Account & Billing"),
                                        Icon(Icons.chevron_right),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: GestureDetector(
                                      onTap: () async {
                                        await _authService.signOut();
                                        removeOverlay();
                                        if (!User.isSignedIn &&
                                            context.mounted) {
                                          context.go('/loading');
                                        }
                                      },
                                      child: const Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Sign Out",
                                              style:
                                              TextStyle(color: Colors.red)),
                                          Icon(Icons.chevron_right),
                                        ],
                                      ),
                                    )),
                              ],
                            )),
                      ),
                    ))
              ],
            ));

    overlay.insert(overlayEntry); // Thêm overlay vào màn hình
  }

  Widget _buildChevronButton(IconData icon) {
    return GestureDetector(
      onTap: () {
        // Handle chevron button press
      },
      child: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: const Color(0xFFE2E8F0),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Icon(
            icon,
            color: const Color(0xFF334155),
            size: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildExtraIcon(IconData icon) {
    return GestureDetector(
      onTap: () {
        // Handle extra icon press
      },
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F8FF),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Icon(
            icon,
            color: const Color(0xFF475569),
            size: 18,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserTile extends StatefulWidget {
  final String text;
  final String lastMessage;
  final String sender;
  final String time;
  final void Function()? onTap;
  final int unseenCount;
  final bool isLastMessageUnseen;

  const UserTile({
    Key? key,
    required this.text,
    required this.lastMessage,
    required this.sender,
    required this.time,
    required this.onTap,
    required this.unseenCount,
    required this.isLastMessageUnseen,
  }) : super(key: key);

  @override
  _UserTileState createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            color: _isHovered
                ? Theme.of(context).colorScheme.tertiary
                : Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/icons.png', 
                    width: 40, 
                    height: 40, 
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.text,
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: _isHovered
                                  ? Colors.white
                                  : Theme.of(context).colorScheme.inversePrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          widget.lastMessage,
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: _isHovered
                                  ? Colors.white
                                  : const Color.fromARGB(255, 111, 105, 105),
                              fontSize: 13,
                              fontWeight: widget.isLastMessageUnseen
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        widget.time,
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: _isHovered ? Colors.white : Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      if (widget.unseenCount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            widget.unseenCount.toString(),
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

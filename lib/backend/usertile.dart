import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserTile extends StatefulWidget {
  final String text;
  final void Function()? onTap; 

  const UserTile({
    Key? key, 
    required this.text, 
    required this.onTap,
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
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // icon
              const Icon(Icons.person),
              const SizedBox(width: 20),
              // username
              Text(
                widget.text,
                style: GoogleFonts.poppins( 
                  textStyle: TextStyle(
                    color: _isHovered ? Colors.white : Colors.black, // Change font color when hovering
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

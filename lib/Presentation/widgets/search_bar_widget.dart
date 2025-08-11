import 'package:flutter/material.dart';

class CharacterSearchBar extends StatefulWidget {
  final Function(String) onChanged;
  final String hintText;

  const CharacterSearchBar({
    super.key,
    required this.onChanged,
    this.hintText = 'Search characters...',
  });

  @override
  CharacterSearchBarState createState() => CharacterSearchBarState();
}

class CharacterSearchBarState extends State<CharacterSearchBar>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showClearButton = false;
  bool _isFocused = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  void _onTextChanged() {
    setState(() {
      _showClearButton = _controller.text.isNotEmpty;
    });
    widget.onChanged(_controller.text);
  }

  void _onFocusChanged() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });

    if (_isFocused) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _clearSearch() {
    _controller.clear();
    widget.onChanged('');
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: _isFocused
                    ? const LinearGradient(
                        colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : LinearGradient(
                        colors: [Colors.white, const Color(0xFFF8FAFF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                boxShadow: _isFocused
                    ? [
                        BoxShadow(
                          color: const Color(0xFF6BE9F8).withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                        BoxShadow(
                          color: Colors.white.withOpacity(0.8),
                          blurRadius: 10,
                          offset: const Offset(0, -2),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                border: Border.all(
                  color: _isFocused
                      ? const Color(0xFF6BE9F8).withOpacity(0.3)
                      : Colors.white.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
                    fontWeight: FontWeight.w400,
                  ),
                  prefixIcon: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: _isFocused
                            ? const LinearGradient(
                                colors: [Color(0xFF6BE9F8), Color(0xFF7185F6)],
                              )
                            : LinearGradient(
                                colors: [
                                  Colors.grey.shade400,
                                  Colors.grey.shade300,
                                ],
                              ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  suffixIcon: _showClearButton
                      ? AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          child: IconButton(
                            icon: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.clear,
                                size: 16,
                                color: Colors.grey,
                              ),
                            ),
                            onPressed: _clearSearch,
                          ),
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  filled: false,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
                onChanged: widget.onChanged,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    _controller.dispose();
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AISearchBar extends StatefulWidget {
  const AISearchBar({super.key});

  @override
  State<AISearchBar> createState() => _AISearchBarState();
}

class _AISearchBarState extends State<AISearchBar> {
  bool isKeywordMode = false;
  String displayText = 'Poser moi une question';
  Timer? _timer;
  final TextEditingController _controller = TextEditingController();
  final List<String> keywords = [];
  bool _isLoading = false;
  List<dynamic> _results = [];

  @override
  void initState() {
    super.initState();
    _setDisplayText(isKeywordMode);
  }
  
  void _startTypewriterEffect(String newText) {
    int charIndex = 0;
    setState(() {
      displayText = '';
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (charIndex < newText.length) {
        setState(() {
          displayText += newText[charIndex];
        });
        charIndex++;
      } else {
        _timer?.cancel();
      }
    });
  }

  void _setDisplayText(bool keywordMode) {
    String newText = keywordMode ? 'Entrer des mots clés' : 'Poser moi une question';
    _startTypewriterEffect(newText);
  }

  void _handleInput(String input) {
    List<String> words = input.trim().split(' ');
    for (var word in words) {
      if (word.isNotEmpty && !keywords.contains(word)) {
        setState(() {
          keywords.add(word);
        });
      }
    }
    _controller.clear();
  }
  Future<void> _searchByKeywords() async {
  if (keywords.isEmpty) return;

  final url = Uri.parse('http://10.0.2.2:5000/recherche_motscles'); // replace with your IP

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'keywords': keywords}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // TODO: handle `data`, e.g., display results or pass to parent
       setState(() {
          _results = data;
        });
      print('Documents trouvés : $data');
    } else {
      print('Erreur serveur : ${response.statusCode}');
    }
  } catch (e) {
    print('Erreur de connexion : $e');
  }
  setState(() => _isLoading = false);
}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 6,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FlutterSwitch(
                  width: 48.0,
                  height: 28.0,
                  toggleSize: 20.0,
                  value: isKeywordMode,
                  borderRadius: 20.0,
                  padding: 4.0,
                  activeColor: const Color(0xFFAA33FF),
                  inactiveColor: Colors.grey.shade300,
                  onToggle: (val) {
                    setState(() {
                      isKeywordMode = val;
                      _controller.clear();
                      keywords.clear();
                      _setDisplayText(isKeywordMode);
                    });
                  },
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: displayText,
                    hintStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  onChanged: (input) {
                    if (isKeywordMode && input.endsWith(' ')) {
                      _handleInput(input);
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/microphone-2.svg',
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
  onTap: _searchByKeywords,
  child: SvgPicture.asset(
    'assets/send.svg',
    width: 24,
    height: 24,
  ),
),

                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        if (keywords.isNotEmpty)
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: keywords
                .map((keyword) => PressChip(
                      label: keyword,
                      onDelete: () {
                        setState(() {
                          keywords.remove(keyword);
                        });
                      },
                    ))
                .toList(),
          ),
  
        const SizedBox(height: 10),

        // Loading spinner
        if (_isLoading) const CircularProgressIndicator(),

        // Results list
        if (_results.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _results
                .map((doc) => ListTile(
                      leading: const Icon(Icons.description),
                      title: Text(doc.toString()), // Customize display as needed
                    ))
                .toList(),
          ),
      ],
    );
  }
}

class PressChip extends StatefulWidget {
  final String label;
  final VoidCallback? onDelete;

  const PressChip({super.key, required this.label, this.onDelete});

  @override
  State<PressChip> createState() => _PressChipState();
}

class _PressChipState extends State<PressChip> {
  bool _isPressed = false;

  final Color defaultBackgroundColor = const Color(0xFF5B2682);
  final Color pressedBackgroundColor = const Color(0xFFAA33FF);
  final Color defaultTextColor = const Color(0xFFAA33FF);
  final Color pressedTextColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onDelete?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: Chip(
        label: Text(
          widget.label,
          style: TextStyle(
            color: _isPressed ? pressedTextColor : defaultTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor:
            _isPressed ? pressedBackgroundColor : defaultBackgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui';

void main() {
  runApp(const MemoryMatchApp());
}

class MemoryMatchApp extends StatelessWidget {
  const MemoryMatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Match',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: '.SF Pro Display',
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF2F2F7),
      ),
      home: const GameScreen(),
    );
  }
}

class CardModel {
  final int id;
  final String emoji;
  bool isFaceUp;
  bool isMatched;

  CardModel({
    required this.id,
    required this.emoji,
    this.isFaceUp = false,
    this.isMatched = false,
  });
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  List<CardModel> cards = [];
  int? firstSelectedIndex;
  int? secondSelectedIndex;
  bool isProcessing = false;
  int matchedPairs = 0;
  int totalPairs = 8;
  int moves = 0;

  final List<String> emojis = [
    '🍎', '🦋', '🌸', '🎸', '🚀', '🎨', '🐬', '🌈'
  ];

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    List<String> gameEmojis = [...emojis, ...emojis];
    gameEmojis.shuffle(Random());
    cards = List.generate(
      gameEmojis.length,
      (index) => CardModel(id: index, emoji: gameEmojis[index]),
    );
    firstSelectedIndex = null;
    secondSelectedIndex = null;
    isProcessing = false;
    matchedPairs = 0;
    moves = 0;
  }

  void _onCardTap(int index) {
    if (isProcessing) return;
    if (cards[index].isFaceUp || cards[index].isMatched) return;

    setState(() {
      cards[index].isFaceUp = true;

      if (firstSelectedIndex == null) {
        firstSelectedIndex = index;
      } else {
        secondSelectedIndex = index;
        moves++;
        isProcessing = true;
        _checkMatch();
      }
    });
  }

  void _checkMatch() {
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        if (cards[firstSelectedIndex!].emoji ==
            cards[secondSelectedIndex!].emoji) {
          cards[firstSelectedIndex!].isMatched = true;
          cards[secondSelectedIndex!].isMatched = true;
          matchedPairs++;
          if (matchedPairs == totalPairs) {
            _showWinDialog();
          }
        } else {
          cards[firstSelectedIndex!].isFaceUp = false;
          cards[secondSelectedIndex!].isFaceUp = false;
        }
        firstSelectedIndex = null;
        secondSelectedIndex = null;
        isProcessing = false;
      });
    });
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AlertDialog(
          backgroundColor: Colors.white.withValues(alpha: 0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Congratulations!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
          ),
          content: Text(
            'You matched all pairs in $moves moves!',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(_initGame);
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF007AFF),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Play Again',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildProgressBar(),
            Expanded(child: _buildGrid()),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Memory Match',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                'Find all matching pairs',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.touch_app_rounded,
                    size: 16, color: Color(0xFF007AFF)),
                const SizedBox(width: 6),
                Text(
                  '$moves',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$matchedPairs / $totalPairs pairs',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              Text(
                '${((matchedPairs / totalPairs) * 100).toInt()}%',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF007AFF),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: matchedPairs / totalPairs,
              backgroundColor: Colors.grey.shade200,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xFF007AFF)),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          const crossAxisCount = 4;
          const spacing = 10.0;
          final availableWidth =
              constraints.maxWidth - (crossAxisCount - 1) * spacing;
          final cardWidth = availableWidth / crossAxisCount;
          final rows = (cards.length / crossAxisCount).ceil();
          final availableHeight =
              constraints.maxHeight - (rows - 1) * spacing;
          final cardHeight = availableHeight / rows;
          final childAspectRatio = cardWidth / cardHeight;

          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
              childAspectRatio: childAspectRatio.clamp(0.6, 1.2),
            ),
            itemCount: cards.length,
            itemBuilder: (context, index) => _buildCard(index),
          );
        },
      ),
    );
  }

  Widget _buildCard(int index) {
    final card = cards[index];
    final isRevealed = card.isFaceUp || card.isMatched;

    return GestureDetector(
      onTap: () => _onCardTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: card.isMatched
              ? const Color(0xFF34C759).withValues(alpha: 0.15)
              : isRevealed
                  ? Colors.white
                  : _getCardColor(index),
          borderRadius: BorderRadius.circular(16),
          border: card.isMatched
              ? Border.all(color: const Color(0xFF34C759), width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: isRevealed
                  ? Colors.black.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.15),
              blurRadius: isRevealed ? 8 : 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: isRevealed
                ? Text(
                    card.emoji,
                    key: ValueKey('emoji_${card.id}'),
                    style: const TextStyle(fontSize: 32),
                  )
                : Text(
                    '?',
                    key: ValueKey('question_${card.id}'),
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Color _getCardColor(int index) {
    final colors = [
      const Color(0xFFFF9500),
      const Color(0xFFFF2D55),
      const Color(0xFF5856D6),
      const Color(0xFF007AFF),
      const Color(0xFF34C759),
      const Color(0xFFFF9500),
      const Color(0xFFAF52DE),
      const Color(0xFF00C7BE),
      const Color(0xFFFF3B30),
      const Color(0xFF5AC8FA),
      const Color(0xFFFFCC00),
      const Color(0xFF007AFF),
      const Color(0xFFFF6482),
      const Color(0xFF30D158),
      const Color(0xFF5856D6),
      const Color(0xFFFF9F0A),
    ];
    return colors[index % colors.length];
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () => setState(_initGame),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF007AFF),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.refresh_rounded, size: 20),
              SizedBox(width: 8),
              Text(
                'Restart',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

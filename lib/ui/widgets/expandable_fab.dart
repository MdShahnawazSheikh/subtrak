import 'package:flutter/material.dart';

class ExpandableFab extends StatefulWidget {
  final VoidCallback onAddManual;
  final VoidCallback onScanScreenshot;

  const ExpandableFab({
    super.key,
    required this.onAddManual,
    required this.onScanScreenshot,
  });

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _expanded = !_expanded;
      if (_expanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        if (_expanded) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 128, right: 8),
            child: ScaleTransition(
              scale: CurvedAnimation(
                parent: _controller,
                curve: Curves.easeOutBack,
              ),
              child: FloatingActionButton.extended(
                heroTag: 'scan',
                onPressed: () {
                  _toggle();
                  widget.onScanScreenshot();
                },
                icon: const Icon(Icons.image_search),
                label: const Text('Scan Screenshot'),
              ),
            ),
          ),
          // Add spacing between the two options
          SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.only(bottom: 72, right: 8),
            child: ScaleTransition(
              scale: CurvedAnimation(
                parent: _controller,
                curve: Curves.easeOutBack,
              ),
              child: FloatingActionButton.extended(
                heroTag: 'manual',
                onPressed: () {
                  _toggle();
                  widget.onAddManual();
                },
                icon: const Icon(Icons.edit),
                label: const Text('Add Manually'),
              ),
            ),
          ),
        ],
        Padding(
          padding: const EdgeInsets.only(right: 8, bottom: 8),
          child: FloatingActionButton(
            heroTag: 'main',
            onPressed: _toggle,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                _expanded ? Icons.close : Icons.add,
                key: ValueKey(_expanded),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

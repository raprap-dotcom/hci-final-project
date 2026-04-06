import 'package:flutter/material.dart';
import '../models/quiz_problem.dart';

class DragDropQuestion extends StatefulWidget {
  final QuizProblem problem;
  final String? initialAnswer;
  final void Function(String) onAnswerDropped; // Callback to notify parent

  const DragDropQuestion({
    super.key,
    required this.problem,
    this.initialAnswer,
    required this.onAnswerDropped,
  });

  @override
  State<DragDropQuestion> createState() => _DragDropQuestionState();
}

class _DragDropQuestionState extends State<DragDropQuestion> {
  late final int _slotCount;
  late final List<String?> _droppedAnswers;

  @override
  void initState() {
    super.initState();

    _slotCount = widget.problem.answer
        .split(',')
        .where((part) => part.trim().isNotEmpty)
        .length
        .clamp(1, 99)
        .toInt();

    _droppedAnswers = List<String?>.filled(_slotCount, null);

    if (widget.initialAnswer != null &&
        widget.initialAnswer!.trim().isNotEmpty) {
      final initialParts = widget.initialAnswer!
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      for (var i = 0; i < _slotCount && i < initialParts.length; i++) {
        _droppedAnswers[i] = initialParts[i];
      }
    }
  }

  void _notifyAnswer() {
    final joined = _droppedAnswers.map((e) => e?.trim() ?? '').join(',').trim();
    widget.onAnswerDropped(joined);
  }

  List<String> get _availableOptions {
    final options = List<String>.from(widget.problem.options ?? const []);
    for (final dropped in _droppedAnswers) {
      if (dropped == null) continue;
      options.remove(dropped);
    }
    return options;
  }

  @override
  Widget build(BuildContext context) {
    final problem = widget.problem;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(problem.question, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 24),
        // Draggable options
        if (problem.options != null)
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: _availableOptions.map((option) {
              return Draggable<String>(
                data: option,
                feedback: Material(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    color: Colors.blue,
                    child: Text(
                      option,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                childWhenDragging: Container(
                  padding: const EdgeInsets.all(12),
                  color: Colors.grey,
                  child: Text(option),
                ),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  color: Colors.blue,
                  child: Text(
                    option,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            }).toList(),
          ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: List.generate(_slotCount, (index) {
            return DragTarget<String>(
              onAcceptWithDetails: (details) {
                setState(() {
                  _droppedAnswers[index] = details.data;
                });
                _notifyAnswer();
              },
              builder: (context, candidateData, rejectedData) {
                final slotValue = _droppedAnswers[index];

                return GestureDetector(
                  onTap: slotValue == null
                      ? null
                      : () {
                          setState(() {
                            _droppedAnswers[index] = null;
                          });
                          _notifyAnswer();
                        },
                  child: Container(
                    width: 120,
                    height: 72,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: candidateData.isEmpty
                          ? Theme.of(context).colorScheme.surfaceVariant
                          : Colors.yellow[200],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.onSurface,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      slotValue ?? 'Drop #${index + 1}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ),
        const SizedBox(height: 8),
        Text(
          'Tip: tap a filled box to clear it.',
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}

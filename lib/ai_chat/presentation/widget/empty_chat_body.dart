import 'package:ai_chat/ai_chat/presentation/widget/ai_avatar.dart';
import 'package:ai_chat/ai_chat/presentation/widget/chat_colors.dart';
import 'package:ai_chat/ai_chat/presentation/widget/suggestion_card.dart';
import 'package:flutter/material.dart';

class EmptyChatBody extends StatelessWidget {
  const EmptyChatBody({
    super.key,
    required this.colors,
    required this.onSuggestionTap,
  });

  final ChatColors colors;
  final ValueChanged<String> onSuggestionTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AiAvatar(colors: colors, size: 120, iconSize: 56),
                const SizedBox(height: 16),
                Text(
                  'AI BEK',
                  style: TextStyle(
                    color: colors.title,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Чем я могу вам помочь сегодня?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colors.text,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 21),
                SuggestionCard(
                  colors: colors,
                  emoji: '🧠',
                  title: 'Как развить память?',
                  subtitle: 'Упражнения для детей 5-7 лет',
                  color: colors.suggestionOne,
                  onTap: () => onSuggestionTap('Как развить память?'),
                ),
                const SizedBox(height: 12),
                SuggestionCard(
                  colors: colors,
                  emoji: '📅',
                  title: 'План занятий на неделю',
                  subtitle: 'Индивидуальное расписание',
                  color: colors.suggestionTwo,
                  onTap: () => onSuggestionTap('План занятий на неделю'),
                ),
                const SizedBox(height: 12),
                SuggestionCard(
                  colors: colors,
                  emoji: '🔥',
                  title: 'Мотивация к учебе',
                  subtitle: 'Советы по поддержке интереса',
                  color: colors.suggestionThree,
                  onTap: () => onSuggestionTap('Мотивация к учебе'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

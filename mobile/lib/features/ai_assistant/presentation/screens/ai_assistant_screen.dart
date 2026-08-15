import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/ai_assistant_controller.dart';
import '../../domain/entities/chat_message.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class AiAssistantScreen extends GetView<AiAssistantController> {
  const AiAssistantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final inputCtrl = TextEditingController();
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(title: Text('ai_title'.tr)),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.messages.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Text(
                      'Ask about your spending, budgets, or upcoming bills.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.lg),
                itemCount: controller.messages.length,
                itemBuilder: (_, i) {
                  final m = controller.messages[i];
                  final isUser = m.role == ChatRole.user;
                  return Align(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.78),
                      decoration: BoxDecoration(
                        color: isUser ? colors.primary : colors.surfaceAlt,
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                      ),
                      child: Text(
                        m.text,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: isUser ? colors.onPrimary : colors.textPrimary),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          Obx(() => controller.isThinking.value
              ? Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: colors.primary),
                  ),
                )
              : const SizedBox.shrink()),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: inputCtrl,
                    decoration: InputDecoration(hintText: 'ai_placeholder'.tr),
                    onSubmitted: (v) {
                      controller.ask(v);
                      inputCtrl.clear();
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                IconButton.filled(
                  onPressed: () {
                    controller.ask(inputCtrl.text);
                    inputCtrl.clear();
                  },
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Text(
              'ai_disclaimer'.tr,
              style: Theme.of(context).textTheme.labelSmall,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

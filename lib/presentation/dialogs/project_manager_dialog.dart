import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_app/domain/models/project.dart';
import 'package:flutter_chat_app/domain/models/user_settings.dart';
import 'package:flutter_chat_app/presentation/providers/settings_provider.dart';
import 'package:flutter_chat_app/core/theme/app_colors.dart';
import 'package:flutter_chat_app/core/utils/id_generator.dart';

/// プロジェクト/Gems管理ダイアログ
class ProjectManagerDialog extends ConsumerStatefulWidget {
  const ProjectManagerDialog({super.key});

  @override
  ConsumerState<ProjectManagerDialog> createState() => _ProjectManagerDialogState();
}

class _ProjectManagerDialogState extends ConsumerState<ProjectManagerDialog> {
  Project? _selectedProject;

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);

    return Dialog(
      child: Container(
        width: 900,
        height: 700,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: settingsAsync.when(
          data: (settings) => _buildContent(settings),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('エラー: $error')),
        ),
      ),
    );
  }

  Widget _buildContent(UserSettings settings) {
    return Column(
      children: [
        // ヘッダー
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          child: Row(
            children: [
              const Icon(Icons.folder, color: AppColors.primary),
              const SizedBox(width: 12),
              const Text(
                'プロジェクト / Gems',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => _createNewProject(settings),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('新規作成'),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),

        // 本体
        Expanded(
          child: Row(
            children: [
              // プロジェクト一覧
              _buildProjectList(settings),
              // プロジェクト詳細
              Expanded(
                child: _selectedProject != null
                    ? _buildProjectDetails(settings, _selectedProject!)
                    : _buildEmptyState(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProjectList(UserSettings settings) {
    return Container(
      width: 300,
      decoration: const BoxDecoration(
        color: AppColors.surfaceAlt,
        border: Border(right: BorderSide(color: AppColors.border)),
      ),
      child: settings.projects.isEmpty
          ? const Center(
              child: Text(
                'プロジェクトなし',
                style: TextStyle(color: AppColors.textTertiary),
              ),
            )
          : ListView.builder(
              itemCount: settings.projects.length,
              itemBuilder: (context, index) {
                final project = settings.projects[index];
                final isSelected = _selectedProject?.id == project.id;

                return ListTile(
                  leading: const Icon(Icons.folder, size: 20),
                  title: Text(
                    project.name,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(
                    project.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12),
                  ),
                  selected: isSelected,
                  selectedTileColor: Colors.white.withOpacity(0.5),
                  onTap: () {
                    setState(() {
                      _selectedProject = project;
                    });
                  },
                );
              },
            ),
    );
  }

  Widget _buildProjectDetails(UserSettings settings, Project project) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 名前
          TextField(
            decoration: const InputDecoration(
              labelText: 'プロジェクト名',
              border: OutlineInputBorder(),
            ),
            controller: TextEditingController(text: project.name),
            onChanged: (value) => _updateProject(
              settings,
              project.copyWith(name: value),
            ),
          ),

          const SizedBox(height: 16),

          // 説明
          TextField(
            decoration: const InputDecoration(
              labelText: '説明',
              border: OutlineInputBorder(),
            ),
            controller: TextEditingController(text: project.description),
            maxLines: 2,
            onChanged: (value) => _updateProject(
              settings,
              project.copyWith(description: value),
            ),
          ),

          const SizedBox(height: 24),

          // カスタムインストラクション
          const Text(
            'カスタムインストラクション',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'このプロジェクトでAIに与える特定のペルソナや指示',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: const InputDecoration(
              hintText: '例: あなたはPythonの専門家です...',
              border: OutlineInputBorder(),
            ),
            controller: TextEditingController(text: project.customInstruction),
            maxLines: 5,
            onChanged: (value) => _updateProject(
              settings,
              project.copyWith(customInstruction: value),
            ),
          ),

          const SizedBox(height: 24),

          // 知識ベース
          const Text(
            '知識ベース',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'このプロジェクトに関する蓄積された知識やコンテキスト',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: const InputDecoration(
              hintText: 'プロジェクトに関する重要な情報を記録...',
              border: OutlineInputBorder(),
            ),
            controller: TextEditingController(text: project.knowledge),
            maxLines: 8,
            onChanged: (value) => _updateProject(
              settings,
              project.copyWith(knowledge: value),
            ),
          ),

          const SizedBox(height: 24),

          // アクションボタン
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () => _deleteProject(settings, project),
                icon: const Icon(Icons.delete),
                label: const Text('削除'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: 64,
            color: AppColors.textTertiary,
          ),
          SizedBox(height: 16),
          Text(
            'プロジェクトを選択してください',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  void _createNewProject(UserSettings settings) {
    final newProject = Project(
      id: IdGenerator.generate(),
      name: '新規プロジェクト',
      description: '',
      customInstruction: '',
      knowledge: '',
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );

    final newSettings = settings.copyWith(
      projects: [...settings.projects, newProject],
    );

    ref.read(settingsProvider.notifier).updateSettings(newSettings);

    setState(() {
      _selectedProject = newProject;
    });
  }

  void _updateProject(UserSettings settings, Project updatedProject) {
    final newProjects = settings.projects.map((p) {
      return p.id == updatedProject.id ? updatedProject : p;
    }).toList();

    final newSettings = settings.copyWith(projects: newProjects);
    ref.read(settingsProvider.notifier).updateSettings(newSettings);

    setState(() {
      _selectedProject = updatedProject;
    });
  }

  void _deleteProject(UserSettings settings, Project project) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('プロジェクトを削除'),
        content: Text('「${project.name}」を削除してもよろしいですか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              final newProjects = settings.projects
                  .where((p) => p.id != project.id)
                  .toList();

              final newSettings = settings.copyWith(projects: newProjects);
              ref.read(settingsProvider.notifier).updateSettings(newSettings);

              setState(() {
                _selectedProject = null;
              });

              Navigator.pop(context);
            },
            child: const Text('削除'),
          ),
        ],
      ),
    );
  }
}

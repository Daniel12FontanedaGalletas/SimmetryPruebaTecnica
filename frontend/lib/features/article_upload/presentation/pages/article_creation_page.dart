import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_app_clean_architecture/features/article_upload/domain/entities/article_entity.dart';
import '../bloc/article_creation_cubit.dart';
import '../bloc/article_creation_state.dart';

final sl = GetIt.instance;

class ArticleCreationPage extends StatelessWidget {
  final ArticleEntity? articleToEdit;

  const ArticleCreationPage({Key? key, this.articleToEdit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ArticleCreationCubit>(),
      child: ArticleCreationView(articleToEdit: articleToEdit),
    );
  }
}

class ArticleCreationView extends StatefulWidget {
  final ArticleEntity? articleToEdit;
  const ArticleCreationView({Key? key, this.articleToEdit}) : super(key: key);

  @override
  State<ArticleCreationView> createState() => _ArticleCreationViewState();
}

class _ArticleCreationViewState extends State<ArticleCreationView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.articleToEdit != null) {
      _titleController.text = widget.articleToEdit!.title;
      _contentController.text = widget.articleToEdit!.content;
      _categoryController.text = widget.articleToEdit!.category;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _submitArticle(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final isEditing = widget.articleToEdit != null;

      if (!isEditing && _selectedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('⚠️ Por favor selecciona una imagen'),
              backgroundColor: Colors.orange),
        );
        return;
      }

      final newArticle = ArticleEntity(
        articleId: isEditing
            ? widget.articleToEdit!.articleId
            : DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        content: _contentController.text,
        authorName: "Periodista Genio",
        authorUID: "user_123_pro",
        category: _categoryController.text.isNotEmpty
            ? _categoryController.text
            : "General",
        datePublished: DateTime.now(),
        thumbnailURL: isEditing && _selectedImage == null
            ? widget.articleToEdit!.thumbnailURL
            : "",
        isPublished: true,
      );

      context.read<ArticleCreationCubit>().submitArticle(
            article: newArticle,
            imagePath: _selectedImage?.path,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.articleToEdit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Noticia' : 'Crear Noticia',
            style: const TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: BlocListener<ArticleCreationCubit, ArticleCreationState>(
        listener: (context, state) {
          if (state.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(isEditing
                      ? '✅ Editado correctamente'
                      : '🌟 Publicado correctamente'),
                  backgroundColor: Colors.green),
            );
            Navigator.pop(context);
          }
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Error: ${state.errorMessage}'),
                  backgroundColor: Colors.red),
            );
          }
        },
        child: BlocBuilder<ArticleCreationCubit, ArticleCreationState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                          image: _selectedImage != null
                              ? DecorationImage(
                                  image: FileImage(_selectedImage!),
                                  fit: BoxFit.cover)
                              : (isEditing &&
                                      widget.articleToEdit!.thumbnailURL
                                          .isNotEmpty)
                                  ? DecorationImage(
                                      image: NetworkImage(
                                          widget.articleToEdit!.thumbnailURL),
                                      fit: BoxFit.cover)
                                  : null,
                        ),
                        child: (_selectedImage == null &&
                                (!isEditing ||
                                    widget.articleToEdit!.thumbnailURL.isEmpty))
                            ? const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.camera_alt,
                                      size: 50, color: Colors.grey),
                                  Text("Añadir Portada",
                                      style: TextStyle(color: Colors.grey)),
                                ],
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                          labelText: 'Título', border: OutlineInputBorder()),
                      validator: (v) => v!.isEmpty ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _categoryController,
                      decoration: const InputDecoration(
                          labelText: 'Categoría', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _contentController,
                      maxLines: 6,
                      decoration: const InputDecoration(
                          labelText: 'Contenido',
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true),
                      validator: (v) => v!.isEmpty ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => _submitArticle(context),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black),
                        child: Text(
                            isEditing ? 'GUARDAR CAMBIOS' : 'PUBLICAR AHORA',
                            style: const TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

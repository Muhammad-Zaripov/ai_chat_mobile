import 'dart:io';

import 'package:ai_chat/ai_chat/data/repository/ai_chat_backend_service.dart';
import 'package:ai_chat/ai_chat/data/repository/chat_upload_service.dart';
import 'package:ai_chat/ai_chat/domain/models/chat_message.dart';
import 'package:ai_chat/ai_chat/presentation/screen/chat_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final ImagePicker imagePicker = ImagePicker();
  final ChatUploadService uploadService = ChatUploadService();
  final AiChatBackendService aiChatService = AiChatBackendService();

  final List<ChatMessage> messages = <ChatMessage>[];

  XFile? pickedImage;
  bool isPickingImage = false;
  bool isUploadingFile = false;
  bool isSendingMessage = false;

  bool get canSend =>
      !isUploadingFile &&
      !isSendingMessage &&
      (messageController.text.trim().isNotEmpty || pickedImage != null);

  @override
  void initState() {
    super.initState();
    messageController.addListener(_onMessageChanged);
  }

  @override
  void dispose() {
    messageController
      ..removeListener(_onMessageChanged)
      ..dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _onMessageChanged() => setState(() {});

  Future<void> pickImageFromGallery() async {
    await _pickImage(ImageSource.gallery);
  }

  Future<void> pickImageFromCamera() async {
    await _pickImage(ImageSource.camera);
  }

  Future<void> pickFile() async {
    if (isPickingImage) return;

    setState(() => isPickingImage = true);

    try {
      final hasPermission = await _requestFilePermission();
      if (!hasPermission) {
        if (!mounted) return;
        _showSnackBar('File uchun ruhsat berilmadi');
        return;
      }

      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      final file = result?.files.single;
      final path = file?.path;
      if (path == null || !mounted) return;

      setState(() => pickedImage = XFile(path, name: file?.name));
    } finally {
      if (mounted) {
        setState(() => isPickingImage = false);
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    if (isPickingImage) return;

    setState(() => isPickingImage = true);

    try {
      final hasPermission = source == ImageSource.camera
          ? await _requestCameraPermission()
          : await _requestPhotoPermission();
      if (!hasPermission) {
        if (!mounted) return;
        _showSnackBar(
          source == ImageSource.camera
              ? 'Kameraga ruhsat berilmadi'
              : 'Galareyaga ruhsat berilmadi',
        );
        return;
      }

      final image = await imagePicker.pickImage(
        source: source,
        imageQuality: 88,
        maxWidth: 2200,
      );

      if (image == null || !mounted) return;

      setState(() => pickedImage = image);
    } finally {
      if (mounted) {
        setState(() => isPickingImage = false);
      }
    }
  }

  Future<bool> _requestPhotoPermission() async {
    if (Platform.isIOS || Platform.isMacOS) {
      return _requestPermission(Permission.photos);
    }

    if (Platform.isAndroid) {
      final photosGranted = await _requestPermission(Permission.photos);
      if (photosGranted) return true;

      return _requestPermission(Permission.storage);
    }

    return true;
  }

  Future<bool> _requestCameraPermission() async {
    if (Platform.isIOS || Platform.isAndroid || Platform.isMacOS) {
      return _requestPermission(Permission.camera);
    }

    return true;
  }

  Future<bool> _requestFilePermission() async {
    if (Platform.isAndroid) {
      return _requestPermission(Permission.storage);
    }

    return true;
  }

  Future<bool> _requestPermission(Permission permission) async {
    final currentStatus = await permission.status;
    if (currentStatus.isGranted) return true;

    final requestedStatus = await permission.request();
    if (requestedStatus.isGranted) return true;

    if (requestedStatus.isPermanentlyDenied) {
      await openAppSettings();
    }

    return false;
  }

  void removePickedImage() {
    if (pickedImage == null) return;
    setState(() => pickedImage = null);
  }

  Future<void> sendMessage() async {
    if (isUploadingFile || isSendingMessage) return;

    final text = messageController.text.trim();
    if (text.isEmpty && pickedImage == null) return;

    final selectedImage = pickedImage;
    String? uploadedUrl;

    if (selectedImage != null) {
      setState(() => isUploadingFile = true);
      try {
        uploadedUrl = await uploadService.uploadImage(File(selectedImage.path));
      } catch (error) {
        if (!mounted) return;
        _showSnackBar('File upload bo‘lmadi: $error');
        setState(() => isUploadingFile = false);
        return;
      }
    }

    final userMessage = ChatMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      createdAt: DateTime.now(),
      text: text.isEmpty ? null : text,
      imagePath: selectedImage?.path,
      imageUrl: uploadedUrl,
    );

    setState(() {
      messages.add(userMessage);
      pickedImage = null;
      messageController.clear();
      isUploadingFile = false;
      isSendingMessage = true;
    });

    _scrollToBottom();

    try {
      final reply = await aiChatService.sendMessage(
        text: text,
        imageUrl: uploadedUrl,
      );
      if (!mounted) return;
      if (reply.trim().isEmpty) return;

      setState(() {
        messages.add(
          ChatMessage(
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            createdAt: DateTime.now(),
            text: reply.trim(),
            isMine: false,
          ),
        );
      });
      _scrollToBottom();
    } catch (error) {
      if (!mounted) return;
      final message = 'AI chat javob bermadi: $error';
      _showSnackBar(message);
      setState(() {
        messages.add(
          ChatMessage(
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            createdAt: DateTime.now(),
            text: message,
            isMine: false,
          ),
        );
      });
      _scrollToBottom();
    } finally {
      if (mounted) {
        setState(() => isSendingMessage = false);
      }
    }
  }

  Future<void> sendSuggestionMessage(String text) async {
    messageController.text = text;
    await sendMessage();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 360),
        curve: Curves.easeOutCubic,
      );
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

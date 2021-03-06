import 'dart:io';

import 'package:banderablanca/core/core.dart';

import '../abstract/abstract.dart';
import '../models/models.dart';
import 'base_model.dart';

class MessageModel extends BaseModel {
  MessageRepositoryAbs _repository;
  List<Message> _messages = [];
  List<Message> get messages => _messages;
  UserApp _currentUser;

  set repository(repo) {
    _repository = repo;
  }

  set currentUser(UserApp user) {
    if (_currentUser != user) {
      _currentUser = user;
    }
  }

  UserApp get currentUser => _currentUser;

  Stream<List<Message>> streamMessage(String flagId) =>
      _repository.livechatMessages(flagId);

  fetchMessages(String flagId) {
    _repository.livechatMessages(flagId).listen((livechatMessages) {
      _messages = livechatMessages;
      notifyListeners();
    });
  }

  sendMessage(String flagId, Message newMessage, String filePath) async {
    if (!newMessage.text.trim().isNotEmpty) return;
    setState(ViewState.Busy);
    await _repository.sendMessage(flagId, newMessage, filePath);
    setState(ViewState.Idle);
  }


  @override
  void dispose() {
    _messages = [];
    super.dispose();
  }
}

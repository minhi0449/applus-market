import 'package:applus_market/data/model/auth/token_manager.dart';
import 'package:applus_market/data/model/data_responseDTO.dart';
import 'package:applus_market/data/repository/auth/auth_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../_core/utils/dio.dart';
import '../../../_core/utils/logger.dart';
import 'tokens.dart';
/*
 2025.1.28 하진희 - 로그인 상태관리
 */

class SessionUser {
  int? id;
  String? uid;
  String? nickname;
  bool isLoggedIn;
  String? profileImg;
  String? accessToken;

  SessionUser({
    required this.id,
    required this.uid,
    required this.nickname,
    required this.isLoggedIn,
    required this.profileImg,
    required this.accessToken,
  });

  SessionUser copyWith({
    int? id,
    String? uid,
    String? nickname,
    bool? isLoggedIn,
    String? profileImg,
    String? accessToken,
  }) {
    return SessionUser(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      nickname: nickname ?? this.nickname,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      profileImg: profileImg ?? this.profileImg,
      accessToken: accessToken ?? this.accessToken,
    );
  }
}

# ApplusMarket - 전자제품 중고거래 플랫폼

> **Flutter & Spring Boot 기반 중고 전자제품 거래 시스템 구축**  
**사용자 편의성**, **거래 안정성**, **모듈화된 백엔드 구조**를 중심으로 설계된 중고 전자기기 통합 거래 플랫폼입니다.  
Flutter로 앱을 개발하고, Spring Boot로 API 서버 및 결제 로직을 구현하였으며, 실시간 채팅, 애쁠페이 결제 시스템, 상품 관리 기능 등을 제공합니다.

---

## ✦ 주요 기능 (Core Features)

| 구분 | 기능 |
|------|------|
| **상품 관리** | 상품 등록, 수정, 삭제, 판매 상태 변경, 카테고리 분류 |
| **회원 기능** | 이메일 기반 회원가입, 로그인, 마이페이지 |
| **실시간 채팅** | WebSocket 기반 구매자-판매자 간 1:1 채팅 |
| **애쁠페이 결제 시스템** | 자체 포인트 기반 결제 모듈 구현 |
| **관심 상품** | 찜하기 및 찜 목록 관리 |
| **관리자 기능** | 회원/상품/채팅 모니터링, 신고 내역 확인 등 |

---

## ✦ 기술 스택 (Tech Stack)

| 구분 | 기술 스택 |
|------|-----------|
| **Language** | ![Java](https://img.shields.io/badge/Java%2017-007396?style=flat&logo=java) ![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat&logo=dart&logoColor=white) |
| **Backend** | ![Spring Boot](https://img.shields.io/badge/Spring%20Boot%203.1-6DB33F?style=flat&logo=spring-boot) ![Spring Security](https://img.shields.io/badge/Spring%20Security-6DB33F?style=flat&logo=spring) ![JPA/Hibernate](https://img.shields.io/badge/JPA%20%2F%20Hibernate-59666C?style=flat&logo=hibernate) |
| **Frontend (Mobile)** | ![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter) ![Android Studio](https://img.shields.io/badge/Android%20Studio-3DDC84?style=flat&logo=android-studio) |
| **Database** | ![MySQL](https://img.shields.io/badge/MySQL%208.0-4479A1?style=flat&logo=mysql) ![MongoDB](https://img.shields.io/badge/MongoDB-4EA94B?style=flat&logo=mongodb) |
| **Realtime** | ![WebSocket](https://img.shields.io/badge/WebSocket-enabled-blue?style=flat) |
| **Documentation** | ![Spring RestDocs](https://img.shields.io/badge/Spring%20RestDocs-used-brightgreen?style=flat) |
| **DevOps / 배포** | ![AWS EC2](https://img.shields.io/badge/AWS%20EC2-deployed-orange?style=flat&logo=amazon-aws) ![GitHub Actions](https://img.shields.io/badge/GitHub%20Actions-CI%2FCD-blue?style=flat&logo=github-actions) ![Docker](https://img.shields.io/badge/Docker-used-2496ED?style=flat&logo=docker) |

---

## ✦ 프로젝트 구조 (Architecture)

```plaintext
📱 Flutter App
  └─ 로그인, 상품 등록/조회, 결제, 채팅 등 UI/UX 기능 구현

🌐 Spring Boot API Server
  ├─ UserController (회원 인증, 마이페이지)
  ├─ ProductController (상품 CRUD)
  ├─ ChatController (MongoDB + WebSocket 채팅)
  ├─ PaymentController (애쁠페이 결제 처리)
  └─ RestDocs + Spring Security + Exception 처리

# 소스코드

[CBO 프로그램 권한체크 구현 가이드](../)에서 사용한 오브젝트의 실제 소스다.
시스템의 활성 버전을 그대로 추출했다.

## 오브젝트

| 파일 | 오브젝트 | 유형 | 패키지 | 설명 |
| --- | --- | --- | --- | --- |
| [ZCMS0070.tabl.txt](ZCMS0070.tabl.txt) | ZCMS0070 | 구조 | ZCM00 | 체크 요청 1행 (오브젝트+필드+값) |
| [ZCMS0070T.ttyp.md](ZCMS0070T.ttyp.md) | ZCMS0070T | 테이블 타입 | ZCM00 | 체크 요청 목록 |
| [ZCMCL_AUTH_CHECK.clas.abap](ZCMCL_AUTH_CHECK.clas.abap) | ZCMCL_AUTH_CHECK | 클래스 | ZCM00 | 공통 권한 체크 |
| [YCM_AUTH_DEMO5.prog.abap](YCM_AUTH_DEMO5.prog.abap) | YCM_AUTH_DEMO5 | 프로그램 | $TMP | 데모 1 — 단일 파라미터 차단형 |
| [YCM_AUTH_DEMO5_TOP.prog.abap](YCM_AUTH_DEMO5_TOP.prog.abap) | YCM_AUTH_DEMO5_TOP | 인클루드 | $TMP | 전역 선언 |
| [YCM_AUTH_DEMO5_SCR.prog.abap](YCM_AUTH_DEMO5_SCR.prog.abap) | YCM_AUTH_DEMO5_SCR | 인클루드 | $TMP | 선택화면 |
| [YCM_AUTH_DEMO5_F01.prog.abap](YCM_AUTH_DEMO5_F01.prog.abap) | YCM_AUTH_DEMO5_F01 | 인클루드 | $TMP | 서브루틴 |
| [YCM_AUTH_DEMO6.prog.abap](YCM_AUTH_DEMO6.prog.abap) | YCM_AUTH_DEMO6 | 프로그램 | $TMP | 데모 2 — 범위값 차단형 |
| [YCM_AUTH_DEMO6_TOP.prog.abap](YCM_AUTH_DEMO6_TOP.prog.abap) | YCM_AUTH_DEMO6_TOP | 인클루드 | $TMP | 전역 선언 |
| [YCM_AUTH_DEMO6_SCR.prog.abap](YCM_AUTH_DEMO6_SCR.prog.abap) | YCM_AUTH_DEMO6_SCR | 인클루드 | $TMP | 선택화면 |
| [YCM_AUTH_DEMO6_F01.prog.abap](YCM_AUTH_DEMO6_F01.prog.abap) | YCM_AUTH_DEMO6_F01 | 인클루드 | $TMP | 서브루틴 |
| [TEXT_ELEMENTS.md](TEXT_ELEMENTS.md) | — | 텍스트 풀 | — | 텍스트 심볼·선택화면 텍스트 |

데모 프로그램은 참조용이므로 $TMP에 두었다. 실제 CBO는 프로젝트 명명 규칙을
따른다.

## 생성 순서

1. 메시지 클래스 `ZCMM01`에 메시지 080·081·082 등록 (아래 참조)
2. 구조 `ZCMS0070` 생성·활성화
3. 테이블 타입 `ZCMS0070T` 생성·활성화
4. 클래스 `ZCMCL_AUTH_CHECK` 생성·활성화 (SE24)
5. 데모 프로그램은 SE38에서 메인 생성 후 인클루드 3개 생성
6. SE38 → Goto → Text Elements에서 텍스트 심볼 입력

클래스 소스를 SE38에, 프로그램 소스를 SE24에 붙여넣으면
"Each ABAP program can contain only one REPORT" 오류가 난다. 생성 위치를 구분한다.

## 의존 오브젝트

메시지 클래스 `ZCMM01`은 이 저장소에 포함하지 않았다. 사용하는 번호는 다음과 같다.

| 번호 | EN | KO | 사용처 |
| --- | --- | --- | --- |
| 080 | No authorization for organizational unit &1 | 조직 단위 &1에 대한 권한이 없습니다 | 클래스, 실패 1건 |
| 081 | No authorization for organizational unit &1 and &2 more | 조직 단위 &1 외 &2건에 대한 권한이 없습니다 | 클래스, 실패 복수 |
| 082 | No authorized data found | 권한이 있는 데이터가 없습니다 | 필터링형 전량 제거 |
| 057 | (기존 재사용) 필수 입력 | | 데모5 화면 검증 |
| 033 | (기존 재사용) 조회 결과 없음 | | 데모6 조회 결과 없음 |

057·033은 기존 메시지를 재사용한 것이므로, 각자 시스템의 메시지 번호로 바꾼다.

권한 오브젝트 `F_BKPF_BUK`, `M_MATE_WRK`, `K_CSKS`는 SAP 표준이다. 별도 생성이
필요 없고 PFCG Role에 값만 부여하면 된다.

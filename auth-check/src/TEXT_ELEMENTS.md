# Text Elements

텍스트 심볼과 선택화면 텍스트는 ABAP 소스에 포함되지 않고 프로그램 텍스트 풀에
별도로 저장된다. SE38 → 프로그램 → Goto → Text Elements에서 입력한다.
EN 로그온에서 원본을 입력한 뒤 Goto → Translation에서 KO를 등록한다.

## YCM_AUTH_DEMO5

### Text Symbols

| ID | EN | KO |
| --- | --- | --- |
| F01 | Company Code | 회사코드 |
| T01 | Authorization check passed | 권한 체크 통과 |
| T02 | Missing authorizations: | 권한 부족: |
| T03 | OK : | 통과: |
| T04 | MISS: | 부족: |

### Selection Texts

| 파라미터 | EN | KO |
| --- | --- | --- |
| P_BUKRS | Company Code | 회사코드 |
| P_WERKS | Plant | 플랜트 |
| P_KOSTL | Cost Center | 코스트센터 |

## YCM_AUTH_DEMO6

선택화면은 DDIC 참조 텍스트를 그대로 사용한다(Company Code / Plant / Cost Center).
텍스트 심볼은 소스가 참조하는 ID 기준으로 아래와 같다. KO 값은 실행 화면에서
확인한 것이고, EN 값은 각자 시스템에서 SE38 텍스트 요소로 확인·입력한다.

| ID | 사용 위치 | KO |
| --- | --- | --- |
| T04 | check_authority, 부족 행 접두 | 제외: |
| T06 | check_authority, 부족 건수 | 권한으로 제외된 수: |
| T11 | display_result, 회사코드 건수 | 회사코드: |
| T12 | display_result, 플랜트 건수 | 플랜트: |
| T13 | display_result, 코스트센터 건수 | 코스트센터: |

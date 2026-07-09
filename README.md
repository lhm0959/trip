# 동유럽 커플여행 공유 가이드

2026.09.11 ~ 2026.09.22, 11박 12일 동유럽 커플 여행 계획을 HTML 앱 형태로 정리한 저장소입니다.

## 공개 페이지

| 버전 | 설명 | GitHub Pages |
|---|---|---|
| 오리지널 버전 | 부다페스트 3박, 비엔나 4박, 9/18 고사우·할슈타트·체스키 샌딩투어, 프라하 4박 | https://lhm0959.github.io/trip/ |
| GPT V2 버전 | 부다페스트 2박, 비엔나 3박, 린츠 픽업/반납 렌트카로 고사우 2박, 프라하 4박 | https://lhm0959.github.io/trip/gpt-v2.html |

## 파일 구조

```text
travel/
├── index.html          오리지널 버전
├── gpt-v2.html         GPT가 재구성한 V2 버전
├── assets/             홈 화면 아이콘 이미지
└── README.md           공유/수정 안내
```

## 같이 수정하는 방법

수정 전에는 항상 최신 상태를 먼저 받습니다.

```bash
git pull origin main
```

수정할 파일을 고릅니다.

- 오리지널 버전 수정: `index.html`
- GPT V2 버전 수정: `gpt-v2.html`
- 공유 설명 수정: `README.md`

각 HTML 파일 안의 아래 영역을 수정하면 화면 내용이 바뀝니다.

```html
<script id="trip-data">
const TRIP = {
  ...
};
</script>
```

수정 후 저장하고 커밋/푸시합니다.

```bash
git add index.html gpt-v2.html README.md
git commit -m "여행 일정 수정"
git push origin main
```

GitHub Pages는 보통 수십 초~몇 분 뒤 반영됩니다. 바로 확인할 때는 브라우저 새로고침을 하거나 URL 뒤에 `?v=날짜` 같은 값을 붙이면 캐시를 피할 수 있습니다.

## 아이폰 홈 화면에 추가

1. Safari에서 원하는 버전의 GitHub Pages URL을 엽니다.
2. 공유 버튼을 누릅니다.
3. `홈 화면에 추가`를 선택합니다.

오프라인용으로 쓰려면 여행 전 페이지를 한 번 열어두고, 지도는 별도로 Google Maps 오프라인 지도 또는 Organic Maps에 저장해두는 것을 권장합니다.

## 주의사항

- 두 사람이 동시에 같은 파일을 수정하면 충돌이 날 수 있습니다.
- 수정하기 전 `git pull origin main`을 먼저 실행하세요.
- 같이 수정할 사람이 GitHub 웹에서 직접 편집해도 됩니다. 이 경우에도 파일은 `index.html` 또는 `gpt-v2.html` 중 하나를 골라 수정하면 됩니다.
- 여행 중 체크박스/지출 기록은 각 기기 브라우저의 localStorage에 저장되므로, 다른 사람 기기와 자동 동기화되지는 않습니다.

## 레포

https://github.com/lhm0959/trip

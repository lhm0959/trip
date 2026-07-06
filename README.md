# 🚂 동유럽 커플여행 (부다페스트 · 비엔나 · 프라하)

**2026.09.11 ~ 09.22 · 11박 12일** — 부다페스트 3박 → 비엔나 4박 → (9/18 고사우·할슈타트·체스키 샌딩투어) → 프라하 4박.
기존에 만들어 둔 `eastern_europe_revised_budapest3_vienna4_prague4.html`의 실제 일정을 넣어 채웠습니다.

이 폴더 하나가 **여행 계획 + 실제 여행 중 폰 가이드**입니다.
핵심 파일은 **`index.html`** — 인터넷 없이도 열리는 단일 HTML 여행 저널이에요.

```
travel/
├── index.html   ← 이거 하나가 전부. 열면 여행 앱처럼 보임. (편집 = 계획 수정)
└── README.md    ← 지금 이 문서 (사용법)
```

---

## 1. 왜 HTML 파일인가? (리서치 결론)

당신의 조건 3가지에 가장 잘 맞아서입니다:

| 조건 | HTML 단일 파일 | Notion | Google Sheets | Wanderlog |
|---|---|---|---|---|
| **이 폴더에서 유지** | ✅ 파일 그대로 | ☁️ 클라우드 | ☁️ 클라우드 | ☁️ 클라우드 |
| **여행 중 오프라인** | ✅ 가장 확실 | △ 기기별 수동 지정 | △ 설정 필요 | △ 유료(Pro) |
| **앱·로그인 불필요** | ✅ | 계정 필요 | 계정 필요 | 계정 필요 |

> Notion은 오프라인이 **기기별로 페이지를 따로 지정**해야 해서 여행 중 사고가 나기 쉽습니다.
> Google Maps 오프라인도 **자동차 내비만** 되고 대중교통·도보 길찾기는 안 됩니다.
> → 그래서 **HTML(정보 허브) + 지도앱(동선)** 조합이 가장 안전합니다.

**단점 하나:** HTML은 오프라인에서 *살아있는 지도*는 못 띄웁니다.
→ 지도는 아래 3번처럼 **Google My Maps + Google Maps 오프라인 / Organic Maps**로 보완하세요.

---

## 2. 📱 폰에서 오프라인으로 쓰기 (제일 중요)

1. `index.html`을 폰으로 보냅니다 → **AirDrop**(아이폰) 또는 **카톡 나에게 보내기**
2. 폰에서 파일을 열면 Safari/브라우저로 뜹니다
3. **공유 버튼 → "홈 화면에 추가"**
4. 끝! 이제 **인터넷 없이** 홈 화면 아이콘으로 열립니다. 앱처럼 전체화면으로 뜹니다.

- 체크박스(준비물·예약완료)를 누르면 **그 폰에 저장**됩니다 (오프라인).
- 밤에는 우측 상단 **☾ 버튼**으로 다크 모드(야간 열차 테마)로 바꿀 수 있어요.

> 💡 계획을 수정할 때마다 파일을 다시 폰으로 보내면 최신본으로 갱신됩니다.
> (원본은 항상 이 컴퓨터 폴더의 `index.html` — 여기가 "진짜"입니다.)

---

## 3. 🗺️ 지도는 이렇게 (계획 & 현지)

- **계획할 때:** [Google My Maps](https://mymaps.google.com)에 여행 지도를 만들고
  가고 싶은 곳을 **동네별 레이어**로 핀 찍기 → 핀이 **밀집한 곳부터** 동선을 짭니다.
  (도시 안에서 지그재그로 왔다갔다 하지 않게 — 전문 블로거 공통 방식)
- **현지에서(오프라인):**
  - **Google Maps** → 프로필 → *오프라인 지도* → 3개 도시 영역 미리 다운로드
  - **Organic Maps** (무료·광고 없음, 도보 내비에 강함) 앱도 함께 설치

`index.html`의 각 장소에 있는 **◎ 지도** 링크는 인터넷이 있을 때 구글 지도로 바로 연결됩니다.

---

## 4. ✏️ 계획 수정하는 법 (코딩 몰라도 OK)

`index.html`을 텍스트 편집기(또는 이 Claude Code)로 열면
아래쪽에 **`const TRIP = { ... }`** 블록이 있습니다. **값만 바꾸면** 화면이 전부 바뀝니다.

- 날짜: `startDate`, `endDate`
- 경로: `route: ["프라하", "빈", "부다페스트"]`
- 하루 일정: `days` 안에 `{ time, place, type, note, map }` 추가/수정
  - `area`로 묶으면 그 날의 "동네 그룹"이 됩니다
- 예산: `budget.categories`의 `planned`(목표)·`actual`(실제 쓴 돈)
- 준비물/서류/짐: `prep`
- 비상연락처·링크·회화: `info`

바꾸고 저장 → 브라우저 새로고침 → 반영. (폰은 다시 전송)

---

## 5. 🧭 여행 계획 순서 (전문가 방식)

리서치로 확인한 **전문 여행 블로거들의 공통 순서**입니다:

1. **목적지 · 기간** 정하기 → 대략 **예산** 조사
2. **저축 / 예산 확보**
3. 지도에 **가고 싶은 곳 핀** 찍기
4. 핀 **밀집 지역부터**, **동네별로 묶어** 동선 만들기
5. 동선이 나오면 그때 **항공 · 숙소 · 기차 예약** *(예약은 후반부!)*
6. 예약 확인 메일은 **오프라인에서도 보이게** 저장

---

## 6. 🖨️ 종이 백업 (배터리 대비)

데스크톱 브라우저에서 `index.html`을 열고 **⌘P (인쇄) → PDF로 저장**하면
일정 전체가 깔끔한 인쇄본으로 나옵니다. 폰 배터리가 죽었을 때를 대비한 안전장치예요.

---

## 참고 출처 (리서치)

- 계획 프레임워크: [Nomadic Matt — 16단계](https://www.nomadicmatt.com/travel-blogs/planning-a-trip/),
  [지도 우선 여정 짜기](https://noplacelikeanywhere.com/how-can-i-help/planning/a-step-by-step-guide-to-using-google-maps-for-travel-itinerary-planning/)
- 도구 비교: [TripIt vs Wanderlog vs Google Trips (2026)](https://monkeyeatingmango.com/blog/tripit-vs-wanderlog-vs-google-trips-2026/)
- 오프라인 지도: [Google Maps 공식 — 오프라인 한계](https://support.google.com/maps/answer/6291838),
  [Organic Maps](https://organicmaps.app/)
- Notion 오프라인: [Notion 공식 가이드](https://www.notion.com/help/guides/working-offline-in-notion-everything-you-need-to-know)
- 동유럽 루트/기차: [Prague–Vienna–Budapest by train](https://everyrail.com/blog/eastern-europe-by-train/),
  [프라하·빈·부다페스트 국민 루트](https://hotel-monkey.com/eastern-europe-travel-itinerary/)

> ⚠️ 기차 소요시간·요금은 블로그 참고값입니다. 예약 전 RegioJet / ÖBB 공식 사이트에서 확인하세요.

# Supabase 공동 편집 설정

## 1. 데이터베이스 만들기

1. [Supabase Dashboard](https://supabase.com/dashboard/project/bilrspsenkemhbzqnrlp/sql/new)의 **SQL Editor**를 엽니다.
2. 프로젝트의 `supabase-setup.sql` 내용을 전부 붙여 넣습니다.
3. **Run**을 눌러 한 번 실행합니다.

이 SQL은 `devjjinny@gmail.com`, `lhm0959@gmail.com` 두 계정만 `europe-2026` 여행의 체크 상태를 읽고 수정하도록 제한합니다.

## 2. 로그인 이동 주소 등록

1. Supabase Dashboard에서 **Authentication → URL Configuration**을 엽니다.
2. **Site URL**을 아래 주소로 설정합니다.

   ```text
   https://lhm0959.github.io/trip/gpt-v2.html
   ```

3. **Redirect URLs**에도 같은 주소를 추가합니다.

## 3. 사용하기

1. GitHub Pages의 `gpt-v2.html`을 엽니다.
2. 상단 **로그인** 버튼을 누릅니다.
3. 등록된 이메일을 입력하고 **로그인 링크 받기**를 누릅니다.
4. 받은 이메일의 링크를 열면 상단 상태가 **동기화 ✓**로 바뀝니다.

기존 브라우저의 체크 상태는 첫 로그인 때 Supabase에 병합됩니다. 이후 두 사람이 체크한 내용은 항목별로 실시간 반영됩니다. 인터넷이 잠시 끊기면 기기에 먼저 저장하고 연결이 돌아왔을 때 재전송합니다.

## 보안

- HTML에 포함된 Publishable key는 브라우저 공개용 키입니다.
- Secret key와 `service_role` key는 HTML이나 Git 저장소에 넣으면 안 됩니다.
- 이메일 접근 제한은 화면 코드뿐 아니라 Supabase RLS 정책에서 다시 검사합니다.

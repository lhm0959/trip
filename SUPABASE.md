# Supabase 공동 편집 설정

## 1. 데이터베이스 만들기

1. [Supabase Dashboard](https://supabase.com/dashboard/project/bilrspsenkemhbzqnrlp/sql/new)의 **SQL Editor**를 엽니다.
2. 프로젝트의 `supabase-setup.sql` 내용을 전부 붙여 넣습니다.
3. **Run**을 눌러 실행합니다. 이메일 로그인 버전을 이미 설치한 경우에도 전체를 다시 실행하면 공유 코드 방식으로 전환됩니다.

공유 코드 원문은 DB에 저장하지 않고 bcrypt 해시만 저장합니다. 테이블 직접 접근은 차단되며 코드 검증 RPC를 통해서만 체크 상태를 읽고 수정할 수 있습니다.

## 2. 사용하기

1. GitHub Pages의 `gpt-v2.html`을 엽니다.
2. 처음 표시되는 공동 편집 창에 두 사람이 정한 공유 코드를 입력합니다.
3. 연결되면 상단 상태가 **동기화 ✓**로 바뀝니다.

기존 브라우저의 추천 선택과 체크 상태는 첫 연결 때 Supabase에 병합됩니다. 이후 두 사람의 상태는 약 5초 간격으로 반영됩니다. 인터넷이 잠시 끊기면 기기에 먼저 저장하고 연결이 돌아왔을 때 재전송합니다.

## 보안

- HTML에 포함된 Publishable key는 브라우저 공개용 키입니다.
- Secret key와 `service_role` key는 HTML이나 Git 저장소에 넣으면 안 됩니다.
- 공유 코드 원문은 HTML과 Git 저장소에 포함되지 않습니다.
- 링크와 공유 코드를 모두 아는 사람은 데이터를 수정할 수 있으므로 코드를 외부에 공개하지 마세요.

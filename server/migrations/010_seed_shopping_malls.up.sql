-- shopping_malls 초기 데이터 시드 (쿠팡·네이버는 002_seed_data에서 이미 삽입됨)
-- ON CONFLICT (code) DO NOTHING 으로 중복 실행 안전
INSERT INTO shopping_malls (name, code, base_url) VALUES
    ('G마켓',    'gmarket',     'https://www.gmarket.co.kr'),
    ('옥션',     'auction',     'https://www.auction.co.kr'),
    ('11번가',   '11st',        'https://www.11st.co.kr'),
    ('티몬',     'tmon',        'https://www.tmon.co.kr'),
    ('위메프',   'wemakeprice', 'https://www.wemakeprice.com'),
    ('SSG닷컴', 'ssg',          'https://www.ssg.com')
ON CONFLICT (code) DO NOTHING;

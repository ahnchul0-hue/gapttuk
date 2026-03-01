-- 시드 데이터: shopping_malls (2건) + categories (18건)

INSERT INTO shopping_malls (name, code, base_url) VALUES
    ('쿠팡', 'coupang', 'https://www.coupang.com'),
    ('네이버쇼핑', 'naver', 'https://shopping.naver.com');

INSERT INTO categories (name, slug, parent_id, sort_order) VALUES
    ('패션의류/잡화', 'fashion', NULL, 1),
    ('뷰티', 'beauty', NULL, 2),
    ('출산/유아동', 'baby', NULL, 3),
    ('식품', 'food', NULL, 4),
    ('주방용품', 'kitchen', NULL, 5),
    ('생활용품', 'living', NULL, 6),
    ('홈인테리어', 'interior', NULL, 7),
    ('가전디지털', 'electronics', NULL, 8),
    ('스포츠/레저', 'sports', NULL, 9),
    ('자동차용품', 'auto', NULL, 10),
    ('도서/음반/DVD', 'books', NULL, 11),
    ('완구/취미', 'toys', NULL, 12),
    ('문구/오피스', 'office', NULL, 13),
    ('반려동물용품', 'pets', NULL, 14),
    ('헬스/건강식품', 'health', NULL, 15),
    ('가구', 'furniture', NULL, 16),
    ('여행/티켓', 'travel', NULL, 17),
    ('컴퓨터/노트북', 'computer', NULL, 18);

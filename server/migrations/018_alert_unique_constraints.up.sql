-- 동일 사용자+카테고리 중복 알림 방지
ALTER TABLE category_alerts
  ADD CONSTRAINT uq_category_alerts_user_category
  UNIQUE (user_id, category_id);

-- 동일 사용자+키워드 중복 알림 방지
ALTER TABLE keyword_alerts
  ADD CONSTRAINT uq_keyword_alerts_user_keyword
  UNIQUE (user_id, keyword);

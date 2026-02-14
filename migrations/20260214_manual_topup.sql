-- Manual topup migration (safe baseline)
CREATE TABLE IF NOT EXISTS pending_deposits (
  topup_id TEXT PRIMARY KEY,
  unique_code TEXT,
  user_id INTEGER NOT NULL,
  amount INTEGER NOT NULL,
  created_at INTEGER NOT NULL,
  status TEXT NOT NULL DEFAULT 'PENDING',
  approved_by INTEGER,
  approved_at INTEGER,
  note TEXT,
  qr_message_id INTEGER
);

-- Untuk database lama, jalankan ALTER berikut satu per satu.
-- Jika muncul error "duplicate column name", abaikan dan lanjutkan.
ALTER TABLE pending_deposits ADD COLUMN unique_code TEXT;
ALTER TABLE pending_deposits ADD COLUMN topup_id TEXT;
ALTER TABLE pending_deposits ADD COLUMN created_at INTEGER;
ALTER TABLE pending_deposits ADD COLUMN approved_by INTEGER;
ALTER TABLE pending_deposits ADD COLUMN approved_at INTEGER;
ALTER TABLE pending_deposits ADD COLUMN note TEXT;
ALTER TABLE pending_deposits ADD COLUMN qr_message_id INTEGER;

UPDATE pending_deposits
SET topup_id = COALESCE(topup_id, unique_code, ('TP-' || user_id || '-' || created_at)),
    created_at = COALESCE(created_at, CAST(strftime('%s','now') AS INTEGER) * 1000),
    status = CASE WHEN status IS NULL OR status = '' THEN 'PENDING' ELSE UPPER(status) END;

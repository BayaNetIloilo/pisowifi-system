CREATE TABLE IF NOT EXISTS vouchers (
  id INT AUTO_INCREMENT PRIMARY KEY,
  code VARCHAR(32) UNIQUE,
  minutes INT,
  status TINYINT, -- 1=new, 2=used, 3=paused, 4=expired
  used_at DATETIME,
  paused_at DATETIME,
  mac VARCHAR(64)
);

CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(64) UNIQUE,
  password VARCHAR(128),
  role VARCHAR(32),
  email VARCHAR(128)
);
-- Add tables for payments, logs, etc.

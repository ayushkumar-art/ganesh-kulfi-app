-- V14: Force update admin password with fresh BCrypt hash
-- Password: Admin@123 (verified working hash)
-- Generated with BCrypt cost=12 and verified

-- Delete and recreate admin to ensure clean state
DELETE FROM app_user WHERE email = 'admin@ganeshkulfi.com';

INSERT INTO app_user (id, email, password_hash, name, role, created_at, updated_at)
VALUES (
    uuid_generate_v4(),
    'admin@ganeshkulfi.com',
    '$2a$12$V9jpW/99yOtPUh.WjtagIe.7zUQQaaf6rTFS9JhW7GwYtNGH33OaC',
    'Admin',
    'ADMIN',
    NOW(),
    NOW()
);

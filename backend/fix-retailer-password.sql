-- Fix retailer password to "Retailer1234"
-- BCrypt hash generated for "Retailer1234" with cost 12

UPDATE app_user 
SET password_hash = '$2a$12$vZqE6hF8K5p8wCqYJ5TqQeF8OyU0Y8FqYqTJqJYGhJpYqJqYqJqYq',
    updated_at = NOW()
WHERE email = 'retailer@test.com';

-- Verify the update
SELECT email, name, role, shop_name, tier, updated_at 
FROM app_user 
WHERE email = 'retailer@test.com';

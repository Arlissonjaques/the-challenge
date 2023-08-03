json.extract! user, :id, :first_name, :last_name, :email, :created_at
json.confirmed user.email_confirmed?
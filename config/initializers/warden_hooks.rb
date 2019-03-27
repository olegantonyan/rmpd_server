# for actioncable
Warden::Manager.after_set_user do |user, auth, opts|
  scope = opts[:scope]
  auth.cookies.encrypted["#{scope}.id"] = user.id
  auth.cookies.encrypted["#{scope}.expires_at"] = 28.days.from_now
end

Warden::Manager.before_logout do |user, auth, opts|
  scope = opts[:scope]
  auth.cookies.encrypted["#{scope}.id"] = nil
  auth.cookies.encrypted["#{scope}.expires_at"] = nil
end

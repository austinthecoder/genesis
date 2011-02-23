When /^(.+) within (.+)$/ do |step, scope_str|
  with_scope(scope_to(scope_str)) { When step }
end
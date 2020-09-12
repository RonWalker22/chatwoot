json.undone do
  json.now @now_groups
  json.next @next_groups
  json.later @later_groups
end
json.done @done_groups
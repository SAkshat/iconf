task :winner1 do
  puts User.last.name
end

desc "Select a random winner"
task winner: [:environment, :winner1] do
  puts User.first.name
end

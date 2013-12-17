task :spec => "db:test:prepare" do
  sh "rspec spec"
end

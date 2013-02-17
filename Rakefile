desc "Build jar"
task :jar do
  puts `rm -f build/Nitro.jar`
  puts `warble`
  puts `mv Nitro.jar build/`
end

desc "Build mac app bundle"
task :mac => [:jar] do
  puts `cp -vf build/Nitro.jar build/Nitro.app/Contents/Resources/Java/Nitro.jar`
end

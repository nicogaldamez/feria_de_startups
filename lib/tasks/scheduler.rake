# encoding: UTF-8

desc "Envío de mail diario notificando los votos que recibieron tus apps"
task :send_votes_email => :environment do
  puts "Enviando mail con votos a usuarios..."
  User.send_voted_products
  puts "Listo :)"
end

task :send_daily_email => :environment do
  puts "Enviando destacado a usuarios..."
  User.send_daily
  puts "Listo :)"
end
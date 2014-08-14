# encoding: UTF-8

desc "Envío de mail diario notificando los votos que recibieron tus apps"
task :send_daily_email => :environment do
  puts "Enviando mail a usuarios..."
  User.send_daily_email
  puts "Listo :)"
end
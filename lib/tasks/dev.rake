namespace :dev do
  desc "TODO"
  task setup: :environment do
    if Rails.env.development?
      puts("Dropando Banco...")
      %x(rails db:drop)
      puts("Criando Banco...")
      %x(rails db:create)
      puts("Gerando migrates...")
      %x(rails db:migrate)
    else
      puts "Você não está no ambiente de DEV..."
    end
  end
end

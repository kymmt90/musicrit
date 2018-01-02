namespace :factory_bot do
  desc 'Check all factory_bot factories are valid'
  task lint: :environment do
    if Rails.env.test?
      DatabaseRewinder.cleaning do
        FactoryBot.lint
      end
    else
      system('RAILS_ENV=test bin/rails factory_bot:lint')
      exit $?.exitstatus
    end
  end
end

namespace :block do
  desc "Update zip codes of existing blocks"
  task :update_zip_codes => :environment do |t, args|
    Block.find_each do |block|
      block.update_zip_code!
    end
  end
end

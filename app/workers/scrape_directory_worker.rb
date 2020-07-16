class ScrapeDirectoryWorker
  include Sidekiq::Worker

  def perform(url = 'https://www.eapteka.ru/goods/drugs/', from_page = 1)
    browser = Watir::Browser.new
    browser.goto url
    pages_count = browser.div(id: 'section_nav_top').ul.lis.last.a.text.to_i - from_page + 1

    pages_count.times do |i|
      puts "page #{i + from_page}"
      browser.goto "https://www.eapteka.ru/goods/drugs/?PAGEN_1=#{i + from_page}"
      # browser.goto "https://www.eapteka.ru/goods/bytovaya_khimiya/?PAGEN_1=#{i + from_page}"
      drug_blocks = browser.divs(class: 'cc-item--info')
      drug_blocks.each do |drug_block|
        vendor_code = drug_block.span(class: 'rate--article').text.split(" ").last
        ScrapeItemWorker.perform_async(drug_block.a.href) unless Drug.find_by(vendor_code: vendor_code)
        # ScrapeHouseholdWorker.perform_async(drug_block.a.href) unless Household.find_by(vendor_code: vendor_code)
        # puts "=============="
        # puts vendor_code
        vendor_code = nil
      end
    end

    browser.close
  end
end

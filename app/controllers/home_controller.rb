class HomeController < ApplicationController

  def index; end

  def scrape
    ScrapeDirectoryWorker.perform_async(params[:url], params[:from_page].to_i)
    # ScrapeItemWorker.perform_async('https://www.eapteka.ru/goods/id216234/')
    redirect_to root_path
  end

end

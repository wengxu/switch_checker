require 'nokogiri'
require 'open-uri'
require 'mechanize'
require 'json'

class CheckController < ApplicationController
  protect_from_forgery except: :get_status
  def switch
    @time = Time.now
    @best_buy_status = 'na'
    @status_hash = get_status_hash
    @tz = 'hello'
  end

  def get_status 
    @status_hash = get_status_hash
    respond_to do |format|
      format.js   {render json: @status_hash }
    end
  end 

  private 

  def get_status_hash 
    bestbuy_html = "http://www.bestbuy.com/site/nintendo-nintendo-switch-32gb-console-gray-joy-con/5670003.p?skuId=5670003"
    bestbuy_3ds_html = "http://www.bestbuy.com/site/nintendo-new-galaxy-style-new-nintendo-3ds-xl/5588518.p?skuId=5588518"

    result_hash = {}
    not_available_keywords = ["coming soon", "not available"]

    agent = Mechanize.new
    bestbuy_available_link = "http://www.bestbuy.com/availability/api/v4/availability/locations/p;skuId=5670003;locationId=292;availabilityType=SHELFDISPLAY;requestedQuantity=1"
    page = agent.get bestbuy_html
    keyword = page.search('//span[@class="label-add-to-cart"]').text.downcase
    not_avail = not_available_keywords.include? keyword
    result_hash['Bestbuy'] = !not_avail

    gamestop_html = "http://www.gamestop.com/nes/consoles/nintendo-switch-with-gray-joy-con/141820"
    gamestop_zelda_html = "http://www.gamestop.com/games/the-legend-of-zelda-breath-of-the-wild-nintendo-switch/141904"
    doc = Nokogiri::HTML(open(gamestop_html))
    not_avail = doc.xpath('//div[@class="buttonna"]/a/span[contains(text(), "Not Available")]').count == 1
    result_hash['Gamestop'] = !not_avail

    target_html = "http://www.target.com/p/nintendo-switch-with-gray-joy-con/-/A-52052007"
    # target page use ajax 
    target_ajax_url = "http://redsky.target.com/v2/pdp/tcin/52052007?excludes=taxonomy&storeId=2086"
    page = agent.get target_ajax_url
    response_hash = JSON.parse page.body
    not_avail = response_hash['product']['available_to_promise_network']['availability_status'] == 'PRE_ORDER_UNSELLABLE'
    result_hash['Target'] = !not_avail

    amazon_html = "https://www.amazon.com/Nintendo-Switch/dp/B01LTHP2ZK/ref=sr_tnr_p_1_720018_1?s=videogames&ie=UTF8&qid=1486341811&sr=1-1&keywords=nintendo+switch"
    amazon_ps4_html = "https://www.amazon.com/Legend-Zelda-Breath-Wild-Switch/dp/B01MS6MO77/ref=pd_sim_63_1?_encoding=UTF8&refRID=3NY3W9RECPWXF72ZGA0D&th=1"
    begin 
      page = agent.get amazon_html
      not_avail = page.search('//div[@id="outOfStock"]').count == 1
      result_hash['Amazon'] = !not_avail
    rescue 
      result_hash['Amazon'] = 'unknown'
    end 

    walmart_html = "https://www.walmart.com/ip/Nintendo-Switch-Gaming-Console/52901821"
    walmart_zelda_html = "https://www.walmart.com/ip/The-Legend-of-Zelda-Breath-of-the-Wild-Nintendo-Switch/52901830"
    doc = Nokogiri::HTML(open(walmart_html))
    #puts doc.xpath('//span[contains(@class, "copy-mini")]').count
    not_avail = doc.xpath('//span[contains(text(), "Out of stock")]').count == 1
    result_hash['Walmart'] = !not_avail

    toysRus_html = "http://www.toysrus.com/product/index.jsp?productId=119513636&cp=2255974.119659196&parentPage=family"
    toysRus_zelda_html = "http://www.toysrus.com/product/index.jsp?productId=119513686&cp=&parentPage=search"
    doc = Nokogiri::HTML(open(toysRus_html))
    not_avail = doc.xpath('//div[@id="productOOS"]').count == 1
    result_hash['ToysRus'] = !not_avail

    puts result_hash.to_s
    result_hash
  end 
end

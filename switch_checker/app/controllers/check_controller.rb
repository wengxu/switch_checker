require 'nokogiri'
require 'open-uri'
require 'mechanize'
require 'json'

class CheckController < ApplicationController
  def switch
    @time = Time.now
    @best_buy_status = 'na'
    @status_hash = {}
  end

  private 

  def get_status_hash 
    
  end 
end

# Coding: UTF-8
require 'twitter'
require 'open-uri'
require 'json'
require 'time'

pc_name = [
  "i5-Server",
  "CeleronG1820"
  ]
@reqest_url = "http://csd.hoge.com"
reply_id = "@hoge"

@rest_client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ""
  config.consumer_secret     = ""
  config.access_token        = ""
  config.access_token_secret = ""
end

def get_status(name)
  return JSON.parse(open(URI.encode("#{@reqest_url}/servers/statues?count=1&NAME=#{name}")).read, symbolize_names: true)
end

def time_parse(sec)
  day = sec.to_i / 86400
  return (Time.parse("1/1") + (sec - day * 86400)).strftime("#{day}日%H時間%M分%S秒")
end

def convert_mem(mem)
  return (mem.to_i * 0.001).round(2)
end

arr = []
pc_name.each do |name|
  arr << get_status(name)
end

arr.each do |pc|
  text = ".#{reply_id} "
  text << pc[0][:NAME] << "\n"
  text << "CPU_Usage:" << pc[0][:CPU].to_f.round(2).to_s << "\n"
  text << "used/swpd/free\n"
  text << convert_mem(pc[0][:MEM_USED]).to_s << "/" << convert_mem(pc[0][:MEM_SWAP]).to_s << "/" << convert_mem(pc[0][:MEM_FREE]).to_s << "MB\n"
  text << "連続稼働時間:"
  text << time_parse(pc[0][:Operating_time].to_i)
  @rest_client.update(text)
end
#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'net/http'
require 'uri'
require 'json'

# WebStorageのアクセスURI
WEB_STORAGE_URI = "https://api.webstorage.jp/v1/devices/current"

# WebStorageへの認証情報のファイルパス
WEB_STORAGE_ACCESS_INFO_PATH = "/var/tmp/webstorage.json"
=begin
認証情報はJSON形式
{
    "api_key":"おんどとりWebStorageから取得したAPI-KEY",
    "user_id" : "rbacxxxx",
    "user_pass" : "password"
}
=end

# WebStorage APIにアクセスするための情報をファイルから読み込みます
def load_webstorage_settings()
  begin
    File.open(WEB_STORAGE_ACCESS_INFO_PATH) do |file|
      storage_info = file.read
      load_info = JSON.parse(storage_info)

      # 読み込んだ情報をWSS APIのKeyにコンバート
      wss_access_info = {}
      wss_access_info["api-key"]    = load_info["api_key"]
      wss_access_info["login-id"]   = load_info["user_id"]
      wss_access_info["login-pass"] = load_info["user_pass"]
      return wss_access_info
    end
  rescue SystemCallError => e
    puts %Q(class=[#{e.class}] message=[#{e.message}])
  rescue IOError => e
    puts %Q(class=[#{e.class}] message=[#{e.message}])
  end
end

# 現在値データを取得します
def get_current_data()
  begin
    # 接続パラメータを読み込み
    params = load_webstorage_settings()
    if params.nil? then
      return nil
    end

    uri = URI.parse(WEB_STORAGE_URI)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme === "https"
    headers = { "Content-Type" => "application/json", "X-HTTP-Method-Override" => "GET" }
    response = http.post(uri.path, params.to_json, headers)

    case response
    when Net::HTTPSuccess
      json = response.body
      return JSON.parse(json)
    else
      puts [uri.to_s, response.value].join(" : ")
    end

  rescue Net::HTTPBadResponse => e
    puts "Bad Response #{e}"
  rescue Net::HTTPHeaderSyntaxError => e
    puts "Header Syntax Error #{e}"
  rescue Net::HTTPClientException => e
    puts "Client Exception #{e}"
  rescue Net::HTTPServerException => e
    puts "Server Exception #{e}"
  rescue Net::HTTPError => e
    puts "Error #{e}"
  rescue Net::HTTPFatalError => e
    puts "Fatal Error #{e}"
  rescue Net::HTTPRetriableError => e
    puts "Retriable Error #{e}"
  rescue => e
    puts [uri.to_s, e.class, e].join(" : ")
  end

 return nil
end

# __main__

current_data = get_current_data()
if current_data.nil? then
  return 1
end

# こんな感じで取得可能
puts current_data["devices"][0]



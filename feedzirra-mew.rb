# -*- coding: utf-8 -*-
require_relative './sanitize_title.rb'
require 'feedzirra'
require 'pp'
require 'reverse_markdown'
require 'yaml'
require 'set'
require 'fileutils'

folder = ARGV[0]
#pp folder
feed = Feedzirra::Feed.fetch_and_parse("http://127.0.0.1/mew.xml")
arr = feed.entries
pp "共有#{arr.size}篇文章"
title = []; arr.each {|i| title << i.title}
#pp title.any? {|t| t.nil?}
date = []; arr.each {|i| date << i.published.strftime("%F")} # yyyy-mm-dd
html = []; arr.each {|i| html << (i.content || "内容丢失了")}
pp html.any?{|t| t.nil?}
cat_raw = []; arr.each {|i| cat_raw << (i.categories || "没有分类")}
cat = cat_raw.flatten
# 用unless i.nil? 这个方法是错的，因为该逻辑是如果是nil就不存到content中了，后面的就都错位啦！！
# 因此还是用 i || "default value" 这种短路的方法好，如果i是nil，那么就存入"default value"
# 这个bug引入之后很难发现的。花费了近20分钟
# 我开始认为是某个地方引入了nil，就疯狂打印 pp cat.any? {|c| c.nil?}
# 但是没有任何数组中有nil
# 最后才想到可能是错位了
# content = []; html.each { |i| content << ReverseMarkdown.parse(i) unless i.nil? } # 如果不加上i.nil? 总会抛异常并说没有 text? 方法
content = []; html.each { |i| content << ((ReverseMarkdown.parse(i) unless i.nil?) || "内容丢失了") } # 
slug = title.map {|t| (sanitize t || "no-title") }
pp slug.any? {|t| t.nil?}
# let's make the output dir and categories dir
FileUtils.mkdir folder unless File.directory? folder
cat.to_set { |dir| FileUtils.mkdir_p "#{folder}/#{dir}" unless File.directory? "#{folder}/#{dir}"}

# let's zip them up
# date, cat, slug, title, content
#=begin
date.zip(cat, slug, title, content) do |d, c, s, t, con|
  File.open("#{folder}/#{c}/#{d}-#{s}.md", 'w') do |f|
    yaml_sep = "---\n"
    f.puts yaml_sep
    f.puts "title: #{t}"
    f.puts yaml_sep
    f.puts "\n"
    f.puts con
  end
end
#=end

#p title.reduce([]) {|yf, t| h ={}; yf << (h[title] = t).to_yaml; }
#yaml_front = yf.map { |i| i.to_yaml}
#pp yaml_front # without ending ---\n
#pp slug
#pp ReverseMarkdown.parse('<b>ha</b>')
#pp title
#pp cat.flatten
#pp cat.to_set
#pp date
#pp html
#pp content[33]
#pp yf
#>> sep = ["---\n"].cycle
#=> #<Enumerator: ["---\n"]:cycle>
#>> [1,2,3,4].zip sep
#=> [[1, "---\n"], [2, "---\n"], [3, "---\n"], [4, "---\n"]]


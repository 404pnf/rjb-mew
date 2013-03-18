# -*- coding: utf-8 -*-
require 'fileutils'
def sanitize(title)
  # 不要替换 / 否则路径分割符号也被替换了
  # 因为下面的file是含有路径的
  # 也不要替换英文句号，因为作为文件后缀分割符号
  # 例子： "source//TLF/PBS自由选择/PBS.自由选择_2_/_PBS自由选择_PBS.Free_to_Choose_1990.Vol.4"
  title = title.tr(' \'’•`~!@#$%^&*()_+=\|][{}"\';:>,<-', '_')
  title = title.tr('？ －·～！@#￥%……&*（）——+、|】』【『‘“”；：。》，《', '_')
  title = title.gsub(/_+/, '_').gsub(/^_/, '').gsub(/_$/, '') # 对开头，结尾和多个 _ 做处理
  title = title.gsub('_/', '/') #如果路径分割前后有下划线也不要
  title = title.gsub('/_', '/')
  # 不知何时引入了多个连续的 // 可这 连续的 // 给我伤害
  # 哦，我知道何时引入的了，是ARGV[0]没有chomp掉目录的结尾 /
  title = title.gsub(/\/\/+/, '/')
  # 文件后缀前的下划线不要 text_.txt不对，应该是text.txt
  title = title.gsub(/_\./, '.')
  title = title.downcase
#  title = title.gsub(/srt$/i,'srt' ) # 为了后面匹配文件名后缀方便，都换成小写
#  title = title.gsub(/ass$/i,'ass' )
end

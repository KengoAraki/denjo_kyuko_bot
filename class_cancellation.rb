require 'mechanize'

def get_text(id)
  agent = Mechanize.new
  page = agent.get('https://sougou.isee.kyushu-u.ac.jp/sougou/unibbs/view/bbsv-view-article.php?bbs_id=34&art_id=' + id)
  table = page.at('body table')
  text = table.at('tr td font').inner_text
  puts text
end

agent = Mechanize.new
contents = []
current_page = agent.get("https://sougou.isee.kyushu-u.ac.jp/sougou/unibbs/view/bbsv-list-view.php?bbs_id=34")
table = current_page.search('body table')[1]
trs = table.search('tr')

#art_id(休講通知のNo)を取得
art_ids = []
trs.each do |tr|
  art_id = tr.search('td')[0].at('font').inner_text
  if !art_id.nil? then
    art_ids << art_id
  end
end

#get_textを実行(通知内容の取得)
art_ids_num = art_ids.length.to_i
art_ids_num.times do |i|
  #art_ids[0]は”No”なので、それ以外に対してget_textを実行
  if i != 0 then
    get_text(art_ids[i])
  end
end

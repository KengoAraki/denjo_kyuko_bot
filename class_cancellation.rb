require 'mechanize'

def get_text(id)
  agent = Mechanize.new
  page = agent.get('https://sougou.isee.kyushu-u.ac.jp/sougou/unibbs/view/bbsv-view-article.php?bbs_id=34&art_id=' + id)
  table = page.at('body table')
  text = table.at('tr td font').inner_text
  puts text
  return text
end

#学年・課程情報の取得
def get_target(text)
  # 【】の中身を抽出
  target =  text.match(/【[^】]*】/)
  # puts target
  return target
end

def get_content(text)
  #詳細(講義、日時等)を取得
  content = text.match(/】/)
  # puts content.post_match
  return content.post_match
end

def third_grade?(text)
  if /3年/ === text then
    return true
  else
    return false
  end
end

agent = Mechanize.new
contents = []
current_page = agent.get("https://sougou.isee.kyushu-u.ac.jp/sougou/unibbs/view/bbsv-list-view.php?bbs_id=34")
table = current_page.search('body table')[1]
trs = table.search('tr')

#art_id(休講通知のNo)を取得
$art_ids = []
trs.each do |tr|
  art_id = tr.search('td')[0].at('font').inner_text
  if !art_id.nil? then
    $art_ids << art_id
  end
end

def tweet_information(client)
  #get_textを実行(通知内容の取得)
  art_ids_num = $art_ids.length.to_i
  art_ids_num.times do |i|
    #art_ids[0]は”No”なので、それ以外に対してget_textを実行
    if i != 0 then
      #休講通知内容を取得
      text = get_text($art_ids[i])
      #通知対象(学年・課程)を取得
      target = get_target(text)
      #通知内容を取得
      content = get_content(text)

      #対象が3年であれば投稿
      if third_grade?(text) then
        client.update("#休講情報\n#{target}\n#{content}")
      end
    end
  end
end

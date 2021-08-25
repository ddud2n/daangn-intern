require 'json'

class AlertJob < ApplicationJob
  queue_as :alert

  def perform(data)
	parsed = JSON.parse(data)  
	post_username = parsed["post_username"]
	post_title = parsed["post_title"]
	  
			  
	  # 알람받을 대상 선정 알고리즘

	  # 1) 게시글 제목에 키워드를 포함하는 "키워드-유저" keyword객체 조회 
	  keywords = Keyword.where( 'INSTR("'<< post_title << '", word) != 0  and "keywords"."username" != "'<< post_username << '"'  ).all

	  # 2) alert_user 해시 생성 : ueser => [keyword1, keyword2,,] 
	  alert_user = Hash.new([])
	  keywords.each do |keyword|
		 alert_user[keyword.username] += [keyword.word]    
	  end

	  # 3) 알람 전송
	  alert_user.each do |key,value|
		alarm = Alarm.new()
		alarm.username = key
		alarm.word = value*","
		alarm.title = '['+(value*",")+' 키워드알람]'
		alarm.description = ""<< post_username << "님의 글제목:"<< post_title 
		alarm.save
	  end

	  
  end
end

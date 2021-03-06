
require 'rest-client'
require 'date'


QUERY_COOKIE_URL = 'http://bgy.gd.cn/mis/info/menu_info.asp' \
                   '?type=%D1%A7%C9%FA%CD%F8%D2%B3'
QUERY_LOGIN_URL = 'http://bgy.gd.cn/mis/info/list.asp'
QUERY_BOOKING_URL = 'http://bgy.gd.cn/mis/info/dc_info/dc3_new.asp'

def bookmeal(card_no, password)
  cookie = RestClient.get(QUERY_COOKIE_URL).cookies.to_a.first.join('=')

  RestClient.post(QUERY_LOGIN_URL, {
                    :tbarno => card_no.to_s,
                    :passwd => password.to_s,
                    :hd => '002',
                    :B1 => "\xc8\xb7\xb6\xa8"
                  }, :cookie => cookie)

  next_monday = Date.today
  next_monday += 1 until next_monday.monday?

  candidates = [('1'..'7').to_a, ('a'..'c').to_a]

  fields = []
  candidates[0].each do |a|
    candidates[1].each do |b|
      fields << ["D#{a}#{b}", '11']
      fields << ["D#{a}#{b}j", 'A']
    end
  end

  RestClient.post(QUERY_BOOKING_URL, {
                    :m_date => next_monday.strftime('%Y%m%d'),
                    :hd => '002',
                    :size => 'A',
                    :B1 => "\xb1\xa3\xb4\xe6",
                  }.merge(fields.map {|a,b| {a=>b} }.inject({}, &:merge)),
                  :cookie => cookie)

#  return true


rescue Exception
  return false
end


if __FILE__ == $0
  require 'ap'
  ap bookmeal('11111341', '111112').net_http_res.body
end

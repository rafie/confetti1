
require 'Bento'

db = Bento.DB(path: "global.db")
%w(ucgw-7.7 mcu-8.0 mcu-8.3).each do |ver|
	db.execute("update projects set cspec=? where name=?", File.read("../../views/.project_#{ver}/nbu.meta/confetti/initial.cspec"), ver)
end


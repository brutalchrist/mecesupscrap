# encoding: ISO-8859-1

require 'mecesupscrap/version'
require 'active_support/inflector'
require 'mechanize'

module Mecesupscrap
  class Scraper
  	def say_hi
  		puts 'Hola!'
  	end
  	def scrap
  		url = 'http://www.mecesup.cl/index2.php?id_seccion=5005&id_portal=59&id_contenido=28740'
      agent = Mechanize.new
      page = agent.get url
      table = page.search('//table').first
      headers = table.search('./thead/tr/th').map{|th| th.text.split.join(" ").parameterize}
      rows = table.search('./tbody/tr')
      common_details = {'Origin' => url}
      rows.each do |row|
        data = Hash[headers.zip row.search('./td').map{|th| th.text.split.join(" ")}]
        attributes = {
          date: data['fecha-publicacion'],
          call: data['llamado'],
          date_limit: data['fecha-limite-postulacion'],
          result: data['resultado']
        }
        puts attributes
      end
  	end
  end
end

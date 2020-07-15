class ScrapeItemWorker
  include Sidekiq::Worker

  def perform(url)
    browser = Watir::Browser.new
    browser.goto url
    name = browser.h1.text
    vendor_code = browser.span(data_action: 'article').text
    barcode = browser.div(class: 'i-instruction--row', visible_text: /Штрих-код:\s\d*/).text.scan(/\s\d*/).last.to_i

    unless Drug.find_by(barcode: barcode)
      prescription = false
      params = {name: name, vendor_code: vendor_code, barcode: barcode}
      columns = {'Действующее вещество' => 'substance', 'Лекарственная форма' => 'form', 'Количество в упаковке' => 'num', 'Производитель' => 'vendor', 'Состав' => 'composition', 'Срок годности' => 'shelf_life', 'Бренд' => 'brand', 'Фармакологическое действие' => 'pharm_effect', 'Показания' => 'indications', 'Противопоказания' => 'contraindications', 'Побочные действия' => 'side_effects', 'Взаимодействие' => 'interaction', 'Как принимать, курс приема и дозировка' => 'cours', 'Передозировка' => 'overdose', 'Специальные указания' => 'special_instruction', 'Форма выпуска' => 'release_form', 'Условия хранения' => 'storage', 'Применение при беременности и кормлении грудью' => 'pregnancy'}
      f = File.open(Rails.root + "public/#{barcode}.html", 'w')
      f.write("<!DOCTYPE html>\n<html lang='en'>\n<head>\n<meta charset='UTF-8'>\n<title>Title</title>\n</head>\n<body>\n")
      f.write "<h1>Штрих-код: #{barcode}</h1>\n"
      f.write "<h2>Артикул: #{vendor_code}</h2>"
      f.write "<h2>Наименование: #{name}</h2>"
      browser.h3s(class: 'i-instruction--item-title').each do |h3|
        f.write "<h3>#{h3.text}</h3>\n"
        f.write "<p alt='#{h3.text}'>#{h3.next_sibling(index: 0).text}</p>"
        params[columns[h3.text]] = h3.next_sibling(index: 0).text if columns.has_key? h3.text
        # case h3.text
        #   when "Действующее вещество"
        #     f.write "<p alt='Действующее вещество'>" + h3.next_sibling(index: 0).text + "</p>\n"
        #   when "Количество в упаковке"
        #     f.write "<p alt='Количество'>" + h3.next_sibling(index: 0).text + "</p>\n"
        #   when "Лекарственная форма"
        #     f.write "<p alt='Лекарственная форма'>" + h3.next_sibling(index: 0).text + "</p>\n"
        #   when "Производитель"
        #     f.write "<p alt='Производитель'>" + h3.next_sibling(index: 0).text + "</p>\n"
        #   when "Производитель"
        #     f.write "<p alt='Производитель'>" + h3.next_sibling(index: 0).text + "</p>\n"
        #   when "Производитель"
        #     f.write "<p alt='Производитель'>" + h3.next_sibling(index: 0).text + "</p>\n"
        #   when "Состав"
        #     f.write "<p alt='Состав'>" + h3.next_sibling(index: 0).text + "</p>\n"
        #   else
        #     f.write "<p>" + h3.next_sibling(index: 0).text + "</p>\n"
        # end
      end
      puts params
      f.write("\n</body>\n</html>")
      f.close
      html_file = File.open(Rails.root + "public/#{barcode}.html")
      params[:description_file] = html_file

      prescription = browser.h3(class: 'i-instruction--item-title', text: 'Условия отпуска из аптек').text
      params[:prescription] = prescription == 'По рецепту' ? true : false

      Drug.create(params)
      html_file.close

      File.delete(Rails.root + "public/#{barcode}.html") if File.exist?(Rails.root + "public/#{barcode}.html")
    end
    sleep 3
    browser.close
  end
end

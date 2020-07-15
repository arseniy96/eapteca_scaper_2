class ScrapeHouseholdWorker
  include Sidekiq::Worker

  def perform(url)
    browser = Watir::Browser.new
    browser.goto url
    name = browser.h1.text
    vendor_code = browser.span(data_action: 'article').text
    barcode = browser.div(class: 'i-instruction--row', visible_text: /Штрих-код:\s\d*/).text.scan(/\s\d*/).last.to_i

    unless Household.find_by(barcode: barcode)
      params = {name: name, vendor_code: vendor_code, barcode: barcode}
      # columns = {'Действующее вещество' => 'substance', 'Лекарственная форма' => 'form', 'Количество в упаковке' => 'num', 'Производитель' => 'vendor', 'Состав' => 'composition', 'Срок годности' => 'shelf_life', 'Бренд' => 'brand', 'Фармакологическое действие' => 'pharm_effect', 'Показания' => 'indications', 'Противопоказания' => 'contraindications', 'Побочные действия' => 'side_effects', 'Взаимодействие' => 'interaction', 'Как принимать, курс приема и дозировка' => 'cours', 'Передозировка' => 'overdose', 'Специальные указания' => 'special_instruction', 'Форма выпуска' => 'release_form', 'Условия хранения' => 'storage', 'Применение при беременности и кормлении грудью' => 'pregnancy'}
      columns = {'Назначение' => 'purpose',
                 'Производитель' => 'vendor',
                 'Свойства' => 'properties',
                 'Состав' => 'composition',
                 'Как принимать, курс приема и дозировка' => 'course',
                 'Описание' => 'description',
                 'Функциональные особенности' => 'functional',
                 'Бренд' => 'brand',
                 'Специальные указания' => 'special_notice',
                 'Рекомендации по применению' => 'recommendation',
                 'Размер' => 'size',
                 'Форма выпуска' => 'release_form',
                 'Характеристики' => 'characteristics'}

      f = File.open(Rails.root + "public/#{barcode}.html", 'w')
      f.write("<!DOCTYPE html>\n<html lang='en'>\n<head>\n<meta charset='UTF-8'>\n<title>Title</title>\n</head>\n<body>\n")
      f.write "<h1>Штрих-код: #{barcode}</h1>\n"
      f.write "<h2>Артикул: #{vendor_code}</h2>"
      f.write "<h2>Наименование: #{name}</h2>"
      browser.h3s(class: 'i-instruction--item-title').each do |h3|
        f.write "<h3>#{h3.text}</h3>\n"
        f.write "<p alt='#{h3.text}'>#{h3.next_sibling(index: 0).text}</p>"
        params[columns[h3.text]] = h3.next_sibling(index: 0).text if columns.has_key? h3.text
      end
      f.write("\n</body>\n</html>")
      f.close
      html_file = File.open(Rails.root + "public/#{barcode}.html")
      params[:description_file] = html_file

      Household.create(params)
      html_file.close

      File.delete(Rails.root + "public/#{barcode}.html") if File.exist?(Rails.root + "public/#{barcode}.html")
    end
    sleep 3
    browser.close
  end
end

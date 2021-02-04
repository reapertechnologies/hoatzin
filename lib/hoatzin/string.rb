# encoding: utf-8

class String

  def stem
    #raise "Please send text to external stemmer before classification"
    lang = :en
    lang = :ru if self.scan(/[а-яА-ЯёЁ]+/).size > 2 # very naive language detection
    Lingua.stemmer self, lang: lang
  end

end
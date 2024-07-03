a = YAML.load_file('config/locales/en.yml')

@results = []

def squash(previous_key = '', h)\
  h.each do |key,value|\
    this_key = "#{previous_key}.#{key.to_s}"\
    if value.is_a? Hash\
      squash(this_key, value) \
    elsif value.is_a? Array\
      @results << "#{this_key}: #{value.inspect}"\
    else\
      @results << "#{this_key}: #{value}"\
    end\
  end \
end

squash 'en', a

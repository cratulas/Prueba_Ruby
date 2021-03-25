require 'uri'
require 'net/http'
require 'openssl'
require 'json'

def request(url_requested,api_key)
    url = URI(url_requested + api_key)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    request = Net::HTTP::Get.new(url)
    response = http.request(request)
    return JSON.parse(response.body)
end


def buid_web_page(hash)
    array = []
    hash.each do |k,v|
        v.each do |im|
            array.push(im['img_src'])
        end
    end

    archivo = File.open('index.html','w')
    stringInicio ="<html>\n<head>\n</head>\n<body>\n<ul>"
    stringFinal ="</ul>\n</body>\n</html>"
    stringVacio = ""

    archivo.write(stringInicio)
    archivo.write("\n")

    largo = array.count
    i = 0
    while i < largo
        stringVacio = ""
        stringVacio = "\t<li><img src='" + array[i] +"'></li>"
        archivo.write(stringVacio)
        archivo.write("\n")
        i = i + 1
    end
    archivo.write(stringFinal)
    archivo.write("\n")

end


def photos_count(hash)
    nuevo_hash = {}
    contadores = []

    camaras = ['FHAZ','RHAZ','MAST','CHEMCAM','MAHLI','MARDI','NAVCAM','PANCAM','MINITES']

    contador0 = 0
    contador1 = 0
    contador2 = 0
    contador3 = 0
    contador4 = 0
    contador5 = 0
    contador6 = 0
    contador7 = 0
    contador8 = 0
    
    hash.each do |k,v|
        v.each do |im|
            if im['camera']['name'] == 'FHAZ'
                contador0 = contador0 + 1
            elsif im['camera']['name'] == 'RHAZ'
                contador1 = contador1 + 1
            elsif im['camera']['name'] == 'MAST'
                contador2 = contador2 + 1
            elsif im['camera']['name'] == 'CHEMCAM'
                contador3 = contador3 + 1
            elsif im['camera']['name'] == 'MAHLI'
                contador4 = contador4 + 1
            elsif im['camera']['name'] == 'MARDI'
                contador5 = contador5 + 1
            elsif im['camera']['name'] == 'NAVCAM'
                contador6 = contador6 + 1
            elsif im['camera']['name'] == 'PANCAM'
                contador7 = contador7 + 1
            elsif im['camera']['name'] == 'MINITES'
                contador8 = contador8 + 1
            end
        end
        contadores.push(contador0,contador1,contador2,contador3,contador4,contador5,contador6,contador7,contador8)
    end
    
    i = 0
    largo = camaras.count
    while i < largo
        nuevo_hash[camaras[i]] = contadores[i]
        i = i +1
    end
    nuevo_hash
end


data = request('https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=0&api_key=','1htADkqIOg8a5exaCtqyEYjLjjtWQCyZefMADdzN')
buid_web_page(data)
print photos_count(data)
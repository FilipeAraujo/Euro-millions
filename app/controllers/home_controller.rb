class HomeController < ApplicationController
  
  def html_safe(text)
         return text if text.nil?
         return text.html_safe if defined?(ActiveSupport::SafeBuffer)
         return text.html_safe! if text.respond_to?(:html_safe!)
         text
  end
  
  def search
    @stuff = {:name => "dsadaadsa"}
    puts params
    respond_to do |format|
      format.html { render :html => @stuff}
      format.xml  { render :xml => @stuff }
      format.json { render :json => @stuff }
    end
    
  end
  
  def index
    
    if(params[:name] == nil)
        return 
    end
        
    @resposta = String::new
    
    a = params[:name].split.collect! { |i| i.to_i }
    
    xml = 'EuroMilhoesAno.xml'
    
    url = 'http://services.sapo.pt/Sport/Score/'+xml
    xml_data = Net::HTTP.get_response(URI.parse(url)).body

    data = XmlSimple.xml_in(xml_data)

    premios = {
      "5,2" => "1",
      "5,1" => "2",
      "5,0" => "3",
      "4,2" => "4",
      "4,1" => "5",
      "4,0" => "6",
      "3,2" => "7",
      "3,1" => "8",
      "2,2" => "9",
      "3,0" => "10",
      "1,2" => "11",
      "2,1" => "12"

    }


    data['Item'].each do |item|

      keys = ["Num_1", "Num_2", "Num_3", "Num_4", "Num_5", "Est_1", "Est_2"]

      b = Array.new

      keys.each do |key|
        b.push(item[key][0].to_i)
      end

      numeros = (a[0..4] & b[0..4]).count 
      estrelas = (a[5..6] & b[5..6]).count 
      comb = numeros.to_s + "," + estrelas.to_s
      resultado = premios[comb]

      if( resultado != nil)
         @resposta += "<p>"
         @resposta += "Concurso => " + item["Concurso"][0] + " Premio: " + resultado  + " Valor - " + item['Pre_'+resultado+'_Val'][0] + " " + comb + "</hr>"
         @resposta += "</p>"
      end  
end   
 
    #@euro = { :name => "ola"}
    
    respond_to do |format|
      format.html { render :html => @resposta }# show.html.erb
    end
    
  end
end

#Programa de conexion con flickr
#Gemas
	# rubygems
	# Flickraw
	# json
#Versionde Ruby 1.8

#Bibliotecas a importar
require 'rubygems'
require 'json'
require 'flickraw'

#Clase de control de Flickr
class Flickr

	#Variables globales de la clase
	$Foto 				#Variable para imagen de la foto
	$Titulo				#Variable de texto de la foto
	$Contador = 1 		#Contador para imprimir
	$Albun = []			#Contenedor de todas las fotos
	$Fotografia = []	#Contador de una foto
	$Siguiente = 0		#Contador para imagenes	
	$Largo				#Largo de $Albun
	$Total				#Contador de muestra
	$Actual				#Variable para llevar el conteo de fotos

	#Constructor de la clase, se  conecta a Flickr
	#Tendra como valores
		# 1- API_KEY
		# 2- Clave_secreta
	def initialize()
		FlickRaw.api_key =  "b907fe707248d846c970de37fdf212e0"
		FlickRaw.shared_secret = "d6300bd479506d23"
	end
	
	
	#Metodo de obtener las fotos más recientes
	#No recive argumentos
	def obtener_recientes(numero)
		$Fotos = flickr.photos.getRecent(:per_page => numero, :page => 1)
	end
	
	#Metodo de obtener las fotos
	#No recive argumentos
	def obtener_fotos(filtro, numero)
		$Fotos = flickr.photos.search(:tags => filtro, :per_page => numero, :page => 1)
	end
	
	#Metodo que obtiene la información de cada foto
	#No recive argumentos
	def obtener_info()
		$Siguiente	= 0
		$Albun = []
		for foto in $Fotos do
			info = flickr.photos.getInfo(:photo_id => foto.id)
			$Fotografia.push(info.title)
			$Fotografia.push(FlickRaw.url_n(info))
			$Albun.push($Fotografia)
			$Fotografia = []
		end
		$Largo = $Albun.length
		$Total = $Largo
	end
	
	
	#Metodo de mostrar información
	#No recive argumentos
	def presentar_info()
		for foto in $Albun do
			puts "Foto numero " + $Contador.to_s
			$Contador = $Contador + 1
			puts "Titulo de la foto: " + foto[0]
			puts "Url de la foto: " + foto[1]
			puts "---------------------------------------------------"
		end
	end
	
	#Metodo para enviar la información
	#Envia la informacion a la aplicacion
	#No recive argumentos
	def asigna_imagen_s()
		if $Siguiente < $Largo
			$Titulo = $Albun[$Siguiente][0]
			$Foto	= $Albun[$Siguiente][1]
			$Siguiente = $Siguiente + 1
			$Actual = $Siguente
		else puts "Hemos llegado al final del archivo"
		end
	end
	
end

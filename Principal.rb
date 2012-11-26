#Programa de control principal
#Gemas
	# rubygems
	# sinatra
	# erb
#Modulos de carga hecho por desarrollo propio
	#Flickr.rb --- alias Flickr
#Versión de Ruby 1.8

#Importar las bibliotecas y el archivo Flickr.rb
require 'rubygems'
require 'erb'
require 'sinatra';
require 'Flickr';
require 'Twitter';

#Variables globales del sistema
$descrip	#Variable que tiene el paramtro de busqueda
$numero		#Variable que tiene el numero de imagenes a mostrar

#Parametros axiliares en caso de faltar un valor de busqueda
$param_busqueda	= "house"
$param_numero	=  10

$Flickr = Flickr.new() 		#Instancia a la clase Flickr
$Twitter = Twitter.new()	#Instancia a la clase Flickr

#Metodo de carga de la pagina principal
#Esta pagina contiene la conexion con Twitter
get '/' do
	erb:Ventana_Conexion
end

#Metodo que enia al usuario a la ventana de busqueda
post '/continuar' do
	redirect '/ventana_busqueda'
end

#Metodo que llama al sistema de conexión de twitter
post '/loguear' do
	if($Twitter.conexion_twitter) == true
		redirect '/ventana_busqueda'
	else
		redirect '/ventana_conexion_fallida'
	end
end

#Metodo que llama a la ventana de conxión si ha fallado
get '/ventana_conexion_fallida' do
	erb :Ventana_Conexion_Fallida
end

#Ventana de busqueda
#Es la que contiene los elemntos para realizar la busqueda
get '/ventana_busqueda' do
	erb :Ventana_Busqueda
end

#Metodo que solcita buscar la información
#Esto, basado en los parametros de entrada
#El limite de fotos a buscar es 30.
post '/buscar_fotos' do
	
	$descrip	= params[:campo1].to_s
	$numero		= params[:campo2].to_i
	if($descrip == "") and ($numero == 0 or $numero == "")
		$Flickr.obtener_recientes($param_numero)
		$Flickr.obtener_info()
		$Flickr.presentar_info()
		$Flickr.asigna_imagen_s()
		redirect  '/ventana_foto'
	elsif($descrip == "")
		$Flickr.obtener_recientes($param_numero)
		$Flickr.obtener_info()
		$Flickr.presentar_info()
		$Flickr.asigna_imagen_s()
		redirect  '/ventana_foto'
	elsif($numero == 0 or $numero == "")
		$numero = $param_numero
	elsif($numero >= 30)
		$numero = 30
	else
		$Flickr.obtener_fotos($descrip, $numero)
		$Flickr.obtener_info()
		$Flickr.presentar_info()
		$Flickr.asigna_imagen_s()
		redirect  '/ventana_foto'
	end
end

#Metodo para solicitar cargar la siguiente imagen
post '/siguiente_foto' do
	$Flickr.asigna_imagen_s()
	redirect  '/ventana_foto'
end

#Metodo que llama al metodo para generar el tweet
post '/twitteo' do
	if($Twitter.twittear($Titulo, $Foto)) == true
		puts "Tweet generado"
		redirect '/ventana_foto'
	else
		redirect '/tweet_error'
	end
end

#Metodo que muesta la imagen si fallo el tweet
get '/tweet_error' do
	erb :Ventana_Tweet_Fallido
end

#Metodo que llama a la pagina de resultado de la aplicacion	
get '/ventana_foto' do
	erb :Ventana_Foto
end

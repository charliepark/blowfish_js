require 'rubygems'
require 'sinatra'
require 'test/unit'
require 'rack/test'
require 'dm-core'
require 'dm-migrations'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/encrypted.db")

class User
  include DataMapper::Resource

  property  :id,          Serial
  property  :email,       String
  property  :created_on,  Date

  has n, :notes
end

class Note
  include DataMapper::Resource

  property  :id,          Serial
  property  :user_id,     Integer
  property  :title,       String
  property  :body,        Text
  property  :created_on,  Date
  
  belongs_to :user
end

DataMapper.finalize
DataMapper.auto_upgrade!

get '/' do
  @notes = Note.all
  erb :index
end

get '/new' do
  erb :new
end

post '/note' do
  Note.create(:title => params[:note]['title'], :body => params[:note]['body'])
  redirect '/'
end

get '/signup' do
  erb :signup
end

post '/user' do
  @email = params[:user]['email']
  User.create(:email => @email, :created_on => Date.today) unless @email.empty?
  redirect '/'
end

enable :inline_templates

__END__

@@ layout
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<title>Encrypted Notes</title>
	<style type="text/css">
	/* from Eric Meyer: v1.0 | 20080212 */
	html, body, div, span, applet, object, iframe, h1, h2, h3, h4, h5, h6, p, blockquote, pre, a, abbr, acronym, address, big, cite, code, del, dfn, em, font, img, ins, kbd, q, s, samp, small, strike, strong, sub, sup, tt, var, b, u, i, center, dl, dt, dd, ol, ul, li, fieldset, form, label, legend, table, caption, tbody, tfoot, thead, tr, th, td{background:transparent;border:0;font-size:100%;font-weight:inherit;margin:0;outline:0;padding:0;text-decoration:none;vertical-align:baseline}
	body{line-height:1}
	ol, ul{list-style:none}
	blockquote, q{quotes:none}
	blockquote:before,blockquote:after,q:before,q:after{content:'';content:none}
	/* remember to define focus styles! */
	:focus{outline:0}
	/* remember to highlight inserts somehow! */
	ins{text-decoration:none}
	del{text-decoration:line-through}
	table{border-collapse:collapse;border-spacing:0}
	/* end of Eric Meyer's CSS Reset */

  a{color:#fff}
  ul#nav a{padding:0 10px;}


	body, button, input, select, textarea{font-family:'helvetica neue',helvetica,arial,sans-serif;font-size:13px;line-height:20px}
	
	body{padding:10px;margin:0 auto;text-align:left;width:300px;}
	button{font-size:inherit;line-height:1;text-align:left;}
  form{display:inline-block}
	h1{font-size:50px;font-weight:bold;line-height:60px;}
	h3{font-weight:bold;font-size:2em;line-height:1;}
	html{background:#0A323A;color:#fff;text-align:center;}
  input{background:rgba(255,255,255,0.8);border:none;font-size:20px;line-height:24px;margin:5px 0;-moz-border-radius:3px;border-radius: 3px;width:100%;}
  p{padding: 0 0 0 20px;text-indent:-20px;}

  ul#nav{background:#444;background:rgba(0,0,0,0.5);display:block;height:30px;}

  ul#nav li{display:inline-block;font-size:14px;line-height:30px;}

	</style>
</head>
<body>
nav
<%= yield %>

<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js"></script>
<script type="text/javascript" src="blowfish.js" language="javascript"></script>
<script type="text/javascript">
$(function(){
  // things to do on startup
});

$('#body_raw').keyup(function(){
  var value = $('#body_raw').val();
  var encrypted_value = $().encrypt(value);
  $('#body').val(encrypted_value);  
});

jQuery.fn.encrypt = function(value){
  // Note: This obviously doesn't encrypt anything.
  return value + value
}
</script>

</body>
</html>

@@ signup
<form action="user" method="post">
  <input name="user[email]" class="text" value="" />
  <button class="awesome">submit</button>
</form>

@@ index
<% @notes.each do |note| %>
  <h3><%= note.title %></h3>
  <p><%= note.body %></p>
<% end %>


@@ new
<form id="new_note" action="note" method="post">
  <input id="title" name="note[title]" class="text" value="" />
  <textarea id="body_raw" name="note[body_raw]" class="text"></textarea>
  <textarea id="body" name="note[body]" class="text" style="display:no ne"></textarea>
  <button class="awesome">submit</button>
</form>

